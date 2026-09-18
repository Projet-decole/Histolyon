---
title: 'Initialiser le dépôt et protéger main'
type: 'chore'
created: '2026-09-17'
status: 'done'
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
- [x] `.gitignore` -- créer à la racine, excluant `_bmad/`, `.claude/` et les artefacts locaux habituels -- borner ce qui entre dans le premier commit
- [x] Premier commit -- `git add docs/ conception/ .gitignore` puis commit -- constitue le point de départ versionné du dépôt
- [x] `git push origin main` (ou `HEAD:main`) -- pousser directement le premier commit -- seul moyen de créer `main` côté remote
- [x] Protection de branche `main` -- configurée manuellement par l'humain via l'interface web GitHub (PR obligatoire sans approbation requise, branche à jour requise, aucun check nommé, "Do not allow bypassing" coché) + squash-only dans Settings → General
- [x] Vérification -- tentative de push direct sur `main` après configuration -- refusée par GitHub

**Acceptance Criteria:**
- Given un dépôt vide sans commit, when `git init` est exécuté et le premier commit est poussé vers `origin main`, then la branche `main` est protégée sur GitHub (PR obligatoire, statut CI requis, branche à jour requise, squash uniquement) — satisfait
- Given la protection configurée, when un push direct sur `main` est tenté, then GitHub le refuse — satisfait (voir Implementation Notes)

### Review Findings

- [x] [Review][Decision] `docs/epics.md` Story 2.1 AC ("conception/ committée en un seul commit dédié, sans mélange") était déjà irréalisable telle quelle — résolu : AC reformulée dans `docs/epics.md:230` pour vérifier l'état réel (conception/ committée avec `docs/`/`.gitignore` dans `335d33e`, sans code mélangé) plutôt que d'exiger un commit dédié. [`docs/epics.md:230`, `spec-1-1-initialiser-le-dépôt-et-protéger-main.md:31`]
- [x] [Review][Decision] Convention de nommage de branche divergente (`story/socle-NN-<slug>` vs AD-12 `story/<ID>-<slug>`) — résolu : `docs/epics.md:37` et `docs/stories/epic-1-context.md:27` mis à jour pour revenir à `story/<ID>-<slug>` (AD-12) dès la prochaine story ; la branche déjà utilisée pour Story 1.1 (`story/socle-01-cloture-doc`) est documentée comme exception non renommée rétroactivement. [`docs/epics.md:37`, `docs/stories/epic-1-context.md:27`]
- [x] [Review][Patch] Désaccord de statut entre `sprint-status.yaml` et la story elle-même — résolu : `sprint-status.yaml` mis à jour à `done`. [`docs/stories/sprint-status.yaml:39`]
- [x] [Review][Patch] `sprint-status.yaml` sans clé `action_items` — résolu : `action_items: []` ajouté. [`docs/stories/sprint-status.yaml`]
- [x] [Review][Defer] `.gitignore` ne couvre pas `env/demo.json`, le seul fichier que NFR8 nomme explicitement comme ne devant jamais être versionné — deferred: `env/` n'existe pas encore (Epic 10) ; Story 10.1 porte déjà sa propre AC couvrant `env/demo.json` ; hors du périmètre mono-zone (AD-12) de cette story. [`.gitignore:24-28`]
- [x] [Review][Defer] `.gitignore` ne couvre pas encore les artefacts Flutter/Dart spécifiques (`.flutter-plugins`, `.flutter-plugins-dependencies`, `*.iml`, `local.properties`) — deferred: `apps/mobile`/`apps/admin` n'existent pas encore (Story 1.4, backlog) ; `flutter create` gère typiquement ses propres entrées à ce moment. [`.gitignore:16-22`]

**Rejected**

- `false` — Story 11.4 (`sprint-status.yaml` initialisé en fin de socle) ne contredit pas sa création dès la Story 1.1 : sa précondition d'AC est « ce document d'épics et de stories approuvé », pas « épics 1 à 10 terminés » — cette précondition était déjà vraie avant même la Story 1.1.
- `false`/rejeté — AC de `spec-1-1` (« when `git init` est exécuté ») ne correspond pas au Code Map (dépôt déjà initialisé) ni aux Tasks (aucune tâche `git init`) : correction rejetée, le correctif éditerait la spec sous revue elle-même.
- rejeté — Section Verification (`curl` avec PAT) décrite comme périmée par les Implementation Notes (automatisation abandonnée) : correction rejetée, le correctif éditerait la spec sous revue elle-même (section Verification).
- rejeté — Bloc gelé (« Always » : API classique + PAT/curl) non amendé après le passage à la configuration manuelle : correction rejetée, le correctif éditerait la spec sous revue elle-même (bloc gelé) ; les Implementation Notes documentent déjà la dérogation autorisée par l'humain.
- rejeté — La commande `curl` de Verification est annoncée comme retournant aussi le statut squash-only, que cet endpoint ne renvoie pas : correction rejetée, le correctif éditerait la spec sous revue elle-même (champs attendus de Verification).
- `low` — Format de date incohérent (`sprint-status.yaml` en `MM-DD-YYYY HH:MM` vs ISO 8601 ailleurs) : champs de métadonnée interne, jamais lus au quotidien dans ce diff, probablement le format par défaut de l'outillage BMAD plutôt qu'une erreur de saisie.
- `false` — Prérequis NFR9 (org Supabase, dossier médias, Figma) absents de `epic-1-context.md` : omission volontaire, ce contexte ne porte que ce dont l'Epic 1 a réellement besoin (AD-15) ; ces prérequis sont couverts par les Epics 3/5/6.
- `false` — Story 3.2 (la plus grosse du socle) sans relecture renforcée : le risque est explicitement reconnu et accepté par `epics.md` lui-même (« c'est voulu par la contrainte, pas un défaut de découpe »), pas un angle mort.
- `low` — Saut volontaire de la revue automatisée non capturé dans un champ structuré : déjà documenté en clair dans les Implementation Notes de cette story, exactement où un relecteur le cherche ; structurer ce champ demanderait d'inventer un nouveau schéma `sprint-status.yaml`, plus qu'une correction directe.

## Implementation Notes

- Sous-agent d'implémentation : `.gitignore` créé, premier commit `335d33e` (`docs/` + `conception/` + `.gitignore`, 144 fichiers, ni `_bmad/` ni `.claude/`), poussé directement sur `origin main` (création de la branche distante). Vérifié : `git log`/`git ls-remote` cohérents, working tree propre.
- Protection de branche : l'automatisation via PAT + API REST a été interrompue à la demande de l'humain (complexité/coût jugés excessifs pour cette étape) ; configurée à la place manuellement via l'interface web GitHub, suivant les réglages du Boundaries & Constraints ci-dessus.
- Preuve de fonctionnement : un commit de test local (`348c9c2`, "test regle") a été poussé directement sur `main` par l'humain après configuration ; GitHub a refusé ce push (le commit n'existe que localement, absent de `origin/main`). Ce commit de test a ensuite été annulé localement (`git reset --hard 335d33e`), aucune trace côté remote.
- Réglage squash-only (`Settings → General → Pull Requests`) non re-vérifiable par API sans jeton (accès non authentifié renvoie ces champs à `null`) ; confirmé visuellement par l'humain dans l'UI GitHub.
- Revue automatisée (step-04, 3 sous-agents reviewers) volontairement non lancée pour cette story : le diff de code est un `.gitignore` de 29 lignes (le reste — 144 fichiers `docs/`/`conception/` — est du contenu de planification préexistant simplement versionné, non produit par cette story), et l'humain a explicitement signalé un coût en tokens déjà trop élevé pour ce workflow. Revue manuelle du `.gitignore` faite directement par l'agent orchestrateur : aucun problème trouvé (aucun conflit avec `env/dev.json`, qui doit rester versionné).

## Verification

**Commands:**
- `git log --oneline -1` -- expected: un commit existe, HEAD de `main`
- `git ls-remote origin` -- expected: `refs/heads/main` présent, correspond au commit local
- `curl` GET sur `repos/Projet-decole/Histolyon/branches/main/protection` (avec le PAT) -- expected: réponse 200 avec `required_pull_request_reviews` présent, `required_status_checks.contexts` vide, squash-only et `enforce_admins.enabled: true`
- Tentative de push direct sur `main` après configuration -- expected: rejet par GitHub (branche protégée)

**Manual checks (if no CLI):**
- GitHub → Settings → Branches → règle sur `main` : PR obligatoire, squash uniquement, branche à jour requise, « Include administrators » coché.
