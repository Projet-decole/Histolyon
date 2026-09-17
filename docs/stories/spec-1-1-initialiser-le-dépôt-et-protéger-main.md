---
title: 'Initialiser le dépôt et protéger main'
type: 'chore'
created: '2026-09-17'
status: 'in-progress'
route: 'dispatch'
review_loop_iteration: 0
baseline_commit: '4b825dc642cb6eb9a060e54bf8d69288fbee4904'
context:
  - '{project-root}/docs/architecture/architecture-HistoLyon-2026-09-17/BOOTSTRAP.md'
  - '{project-root}/docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Le dépôt Git local n'a encore aucun commit et le remote `origin` (`git@github.com:Projet-decole/Histolyon.git`) est vide : rien n'empêche aujourd'hui un push direct sur `main`, ce qui casserait le process trunk-based imposé par AD-13 dès la première contribution.

**Approach:** Committer et pousser directement le premier commit sur `origin main` (seul moyen possible tant que `main` n'existe pas côté remote), puis configurer immédiatement après la protection de branche GitHub sur `main` (PR obligatoire, branche à jour requise, squash uniquement, statut CI requis activé sans check nommé) pour que tout push direct ultérieur soit refusé.

## Boundaries & Constraints

**Always:**
- Le tout premier commit est poussé directement sur `origin main` ; la protection est configurée immédiatement après, jamais avant (impossible : `main` n'existe pas encore côté remote).
- La protection active : PR obligatoire, branche à jour avant fusion, squash uniquement, et le toggle « statut CI requis » sans check nommé sélectionné (aucun workflow CI n'existe avant l'épic 9 — BOOTSTRAP.md §Chemin ; les checks tournent en local jusque-là).
- `enforce_admins` (« Include administrators ») est activé sur la règle, sinon l'AC « un push direct sur `main` est refusé » ne sera pas vérifiable pour la personne (probablement admin/owner du dépôt) qui teste.
- L'approbation de review obligatoire reste désactivée pour l'instant (activée seulement après la relecture groupée de fin de socle — BOOTSTRAP.md socle-01).
- Utiliser l'API de protection de branche classique GitHub (`PUT /repos/{owner}/{repo}/branches/main/protection`), pas les Rulesets — plus simple, suffisant ici, et le choix est invisible pour l'utilisateur final.
- Authentification GitHub : un Personal Access Token (scope `repo`) fourni par l'humain, utilisé via `curl` contre l'API REST. Le token vit uniquement dans un fichier local hors dépôt (jamais collé dans la conversation, jamais committé, jamais loggé en clair) ; le fichier est supprimé une fois la configuration terminée.
- Périmètre du premier commit : `docs/` et `conception/` sont committés ; un `.gitignore` racine généraliste exclut `_bmad/`, `.claude/` et les artefacts locaux habituels (OS, IDE, build) — pas seulement les deux dossiers identifiés en investigation.

**Never:**
- Ne pas activer l'approbation de review obligatoire maintenant.
- Ne pas sélectionner de check de statut nommé (aucune CI ne les rapporte encore).
- Ne jamais committer ni logger un secret/token GitHub utilisé pour authentifier la configuration de la protection.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Premier push | Dépôt local avec commit, remote sans `main` | Push direct réussit, `origin/main` créée | N/A |
| Push direct après protection | Tentative de push direct sur `main` une fois la règle active | GitHub refuse (branche protégée) | Confirmer le message d'erreur, ne jamais contourner (pas de `--force`, pas de désactivation temporaire) |
| PR sans review pendant l'épic 1 | PR ouverte contre `main` | Fusion possible sans approbation (review non encore obligatoire) | N/A |

</frozen-after-approval>

## Code Map

- `.git/` -- dépôt déjà initialisé, remote `origin` déjà configuré, aucun commit ; `git ls-remote origin` confirme un remote vide (aucune ref).
- `_bmad/` (permissions `700`) et `.claude/` -- outillage local (cache de rendu BMAD, config Claude Code) ; exclus du premier commit via `.gitignore`.
- `docs/`, `conception/` -- livrables déjà présents en working tree, non trackés ; candidats naturels au premier commit.
- `docs/architecture/architecture-HistoLyon-2026-09-17/BOOTSTRAP.md` §1 et `ARCHITECTURE-SPINE.md` AD-13 -- règles exactes de protection à appliquer.
- Environnement : `gh` absent (candidat apt `2.45.0-1ubuntu0.3`, non installé) ; ni `GITHUB_TOKEN` ni `GH_TOKEN` dans l'environnement ; accès réseau sortant vers `api.github.com` opérationnel ; auth SSH vers `origin` déjà fonctionnelle (`git ls-remote` réussit sans erreur).

## Tasks & Acceptance

**Execution:**
- [ ] `.gitignore` -- créer à la racine, excluant `_bmad/`, `.claude/` et les artefacts locaux habituels -- borner ce qui entre dans le premier commit
- [ ] Premier commit -- `git add docs/ conception/ .gitignore` puis commit -- constitue le point de départ versionné du dépôt
- [ ] `git push origin main` (ou `HEAD:main`) -- pousser directement le premier commit -- seul moyen de créer `main` côté remote
- [ ] Protection de branche `main` -- `curl` authentifié avec le PAT fourni par l'humain contre l'API REST GitHub -- PR obligatoire, branche à jour requise, squash uniquement, statut CI requis (sans check nommé), `enforce_admins` activé
- [ ] Vérification -- tenter un push direct sur `main` après configuration -- confirmer le refus par GitHub

**Acceptance Criteria:**
- Given un dépôt vide sans commit, when `git init` est exécuté et le premier commit est poussé vers `origin main`, then la branche `main` est protégée sur GitHub (PR obligatoire, statut CI requis, branche à jour requise, squash uniquement)
- Given la protection configurée, when un push direct sur `main` est tenté, then GitHub le refuse

## Implementation Notes

## Verification

**Commands:**
- `git log --oneline -1` -- expected: un commit existe, HEAD de `main`
- `git ls-remote origin` -- expected: `refs/heads/main` présent, correspond au commit local
- `curl` GET sur `repos/Projet-decole/Histolyon/branches/main/protection` (avec le PAT) -- expected: réponse 200 avec `required_pull_request_reviews` présent, `required_status_checks.contexts` vide, squash-only et `enforce_admins.enabled: true`
- Tentative de push direct sur `main` après configuration -- expected: rejet par GitHub (branche protégée)

**Manual checks (if no CLI):**
- GitHub → Settings → Branches → règle sur `main` : PR obligatoire, squash uniquement, branche à jour requise, « Include administrators » coché.
