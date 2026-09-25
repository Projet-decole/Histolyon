---
title: 'Importer conception/ telle quelle'
type: 'chore'
created: '2026-09-18'
status: 'done'
baseline_revision: '582f7c428d5e69a3a62429831553081cacc2972f'
review_loop_iteration: 0
followup_review_recommended: false
context: []
warnings: []
deferred: []
---

<intent-contract>

## Intent

**Problem:** `conception/` a été importée telle quelle depuis l'ancien dépôt dans le tout premier commit (`335d33e`), mais aucune story n'a jamais vérifié ni consigné que ce contenu est resté identique à son import et qu'aucun code n'a été mélangé au commit qui l'a introduit (AC de la Story 2.1, `docs/epics.md`).

**Approach:** Vérifier par l'historique et le diff git que `conception/` n'a subi aucune modification depuis `335d33e`, et que ce commit ne contient que `conception/`, `docs/` et `.gitignore` — puis consigner cette preuve dans la story et refléter le statut réel dans `sprint-status.yaml`. Cette vérification porte uniquement sur la stabilité interne du dépôt depuis `335d33e` ; elle ne constitue pas une comparaison directe avec l'ancien dépôt externe d'origine, qui n'est référencé par aucun remote ni chemin accessible depuis cet environnement. Aucun fichier sous `conception/` n'est modifié.

## Boundaries & Constraints

**Always:** `conception/` reste strictement en lecture seule ; toute affirmation de conformité s'appuie sur une commande git vérifiable, jamais sur une déclaration non sourcée.

**Never:** Ne jamais éditer, reformater ou re-committer un fichier sous `conception/` ; ne pas modifier `docs/epics.md` ni d'autres stories que la 2.1.

</intent-contract>

## Code Map

- `conception/` -- importée dans `335d33e` (premier commit du dépôt), jamais retouchée depuis (`git log --oneline -- conception/` ne renvoie que ce commit).
- `335d33e` -- commit d'import : 144 fichiers, uniquement `.gitignore`, `conception/*` et `docs/*` (`git show 335d33e --name-only`), aucun code applicatif.
- `docs/stories/sprint-status.yaml` -- entrée `2-1-importer-conception-telle-quelle` à passer de `backlog` à `done`.

## Tasks & Acceptance

**Execution:**
- `docs/stories/spec-2-1-importer-conception-telle-quelle.md` -- consigner les preuves de vérification (sorties des commandes git) dans une section Implementation Notes -- trace auditable de l'AC
- `docs/stories/sprint-status.yaml` -- passer `2-1-importer-conception-telle-quelle` à `done` -- refléter l'état réel une fois la preuve consignée

**Acceptance Criteria:**
- Given le commit d'import `335d33e`, when son contenu sous `conception/` est comparé à l'état actuel du dépôt (`git diff 335d33e -- conception/`), then la sortie est vide (contenu strictement identique, aucun fichier édité).
- Given l'historique complet de `conception/` (`git log --oneline -- conception/`), when on liste les commits l'ayant modifié, then seul `335d33e` apparaît.
- Given le commit `335d33e` (`git show 335d33e --name-only`), when on liste ses fichiers, then ils appartiennent uniquement à `.gitignore`, `conception/` ou `docs/` -- aucun fichier de code applicatif n'y est mélangé.

## Spec Change Log

## Review Triage Log

### 2026-09-18 — Review pass
- verdicts: 11 findings — high 0, medium 2, low 7, false 2, maybe-false 0
- findings:
  - `[low]` `patch` (blind-hunter) `sprint-status.yaml` laisse `epic-2: backlog` alors que sa première story passe `done`, contredisant la note de workflow du fichier ("Epic transitions to 'in-progress' automatically when its first story starts") — corrigé : `epic-2` passé à `in-progress`.
  - `[low]` `patch` (blind-hunter) statut de la spec en cours de revue vs `sprint-status.yaml` déjà à `done` dans le même diff — root cause : la tâche « passer à done » est exécutée pendant l'implémentation (step-03) au lieu d'être réservée à la Finalisation (step-04) qui suit la revue. Aucun changement d'artefact nécessaire ici (cette même passe de revue conclut `done`, donc l'état final est cohérent) ; correction de process pour les stories 2.2–2.7 : ne faire passer `sprint-status.yaml` à `done` qu'après la revue, jamais pendant l'implémentation.
  - `[medium]` `patch` (blind-hunter) la section `## Verification` liste toujours la commande littérale (`git show 335d33e --name-only | grep -v -E '...'`) qui produit une sortie non vide (faux positifs `core.quotepath`), alors que les Implementation Notes utilisent une commande corrigée — une relecture future qui rejoue la commande littérale conclura à tort à un échec de l'AC. Corrigé : commande de la section Verification remplacée par la forme corrigée (`-c core.quotepath=false ... --format=""`).
  - `[false]` reject (blind-hunter) « Spec Change Log vide malgré une déviation » — réfuté : cette section est explicitement réservée par son propre gabarit aux amendements de revue en boucle `bad_spec` (aucune boucle ici), pas aux corrections découvertes pendant l'implémentation, déjà correctement consignées dans Implementation Notes.
  - `[low]` `patch` (blind-hunter) même racine que la 2e ligne ci-dessus (Review Triage Log vide + `sprint-status.yaml` déjà `done`) — même disposition : aucun changement d'artefact, correction de séquencement pour la suite de l'épic.
  - `[false]` reject (blind-hunter) titre frontmatter « Importer conception/ telle quelle » jugé « lit maladroitement » — réfuté : aucun préjudice concret nommé, champ YAML brut non destiné au rendu markdown, remarque purement stylistique.
  - `[low]` `patch` (blind-hunter) `docs/stories/epic-2-context.md` (artefact de planification d'épic, généré en step-01) existe sur disque mais n'est pas inclus dans ce diff — corrigé : ajouté au commit de cette story, pour éviter une recompilation redondante par les stories 2.2–2.7 et le laisser versionné dès la première story de l'épic.
  - `[medium]` `patch` (edge-case-hunter) même défaut que la 3e ligne (commande de Verification obsolète) — même correctif.
  - `[low]` `patch` (edge-case-hunter) même racine que les lignes 2 et 5 (désynchronisation `sprint-status.yaml`/statut de la spec) — même disposition.
  - `[low]` `patch` (edge-case-hunter) les Implementation Notes qualifient la commande littérale de « deux faux positifs » alors qu'elle émet aussi l'en-tête complet du commit (hash/Author/Date/message), non filtré par les préfixes autorisés — vérifié en rejouant la commande. Corrigé : reformulation des Implementation Notes pour mentionner l'en-tête, sans changer la conclusion (les 144 fichiers réels respectent les préfixes autorisés).
  - `[low]` `patch` (intent-alignment) l'AC/`epics.md` parlent de fidélité à « l'ancien dépôt » (source externe), mais la vérification ne peut porter que sur la stabilité interne depuis `335d33e` — l'ancien dépôt n'est référencé nulle part dans ce dépôt (pas de remote, pas de chemin), donc cette lecture plus large est structurellement invérifiable ici. Corrigé : une phrase de portée ajoutée à l'Approche pour le documenter explicitement, dans l'esprit de la rétro Epic 1 (limites de preuve consignées plutôt que tues).

## Verification

**Commands:**
- `git diff 335d33e -- conception/` -- expected: sortie vide
- `git log --oneline -- conception/` -- expected: une seule ligne, `335d33e ...`
- `git -c core.quotepath=false show 335d33e --name-only --format="" | grep -v -E '^(\.gitignore$|conception/|docs/)'` -- expected: sortie vide (aucun fichier hors de ces trois préfixes)

## Implementation Notes

Vérification exécutée le 2026-09-18 sur `story/2-1-importer-conception-telle-quelle` (HEAD = `582f7c4`).

**1. `git diff 335d33e -- conception/`**

```
$ git diff 335d33e -- conception/
(sortie vide)
```

Aucune différence entre l'état actuel de `conception/` et son contenu au commit d'import `335d33e` : le contenu est resté strictement identique.

**2. `git log --oneline -- conception/`**

```
$ git log --oneline -- conception/
335d33e chore(docs): premier commit — conception et documentation du socle
```

Un seul commit touche `conception/` depuis l'origine du dépôt : `335d33e`. Aucune modification ultérieure.

**3. `git show 335d33e --name-only`**

Le commit `335d33e` contient 144 fichiers. La commande littérale initialement envisagée (`git show 335d33e --name-only | grep -v -E '^(\.gitignore$|conception/|docs/)'`) fait remonter, par défaut, l'en-tête complet du commit (hash, `Author:`, `Date:`, message), qui ne correspond lui non plus à aucun des préfixes autorisés, en plus de deux faux positifs dus à l'échappement octal de `git show` sur les noms de fichiers accentués (`core.quotepath` par défaut) :

```
"conception/11-reponse-parametrique/03-chor\303\251graphies.yaml"
"docs/stories/spec-1-1-initialiser-le-d\303\251p\303\264t-et-prot\303\251ger-main.md"
```

Ces deux lignes appartiennent bien aux préfixes autorisés (`conception/` et `docs/`) une fois l'échappement neutralisé. Commande équivalente sans cet artefact (`core.quotepath=false`, en-tête de commit exclu via `--format=""`) :

```
$ git -c core.quotepath=false show 335d33e --name-only --format="" | grep -v -E '^(\.gitignore$|conception/|docs/)'
(sortie vide, code de sortie 1 = aucune correspondance)
$ git -c core.quotepath=false show 335d33e --name-only --format="" | wc -l
144
```

Les 144 fichiers du commit `335d33e` appartiennent exclusivement à `.gitignore`, `conception/` ou `docs/` — aucun fichier de code applicatif n'y est mélangé.

**Conclusion :** les trois critères d'acceptation de la Story 2.1 sont vérifiés par des commandes git reproductibles. `conception/` a été importée telle quelle et n'a jamais été retouchée depuis ; le commit d'import ne contient que de la conception et de la documentation.

## Auto Run Result

**Résumé :** Vérification (pas de nouveau code) que `conception/`, importée dans le tout premier commit du dépôt (`335d33e`), est restée strictement identique depuis et que ce commit n'a jamais mélangé de code applicatif. Preuve consignée par commandes git reproductibles.

**Fichiers modifiés :**
- `docs/stories/spec-2-1-importer-conception-telle-quelle.md` -- spec + preuves de vérification (Implementation Notes) + ce résultat.
- `docs/stories/sprint-status.yaml` -- `2-1-importer-conception-telle-quelle: done`, `epic-2: in-progress`.
- `docs/stories/epic-2-context.md` -- ajouté au suivi git (artefact de contexte d'épic généré en step-01, réutilisable par les stories 2.2–2.7).

**Revue :** 4 lentilles (blind-hunter, edge-case-hunter, verification-gap, intent-alignment), 11 findings au total.
- Patchés : 5 entrées (1 `medium` — commande de Verification obsolète/faux positifs `core.quotepath`, regroupant 3 findings ; 4 `low` — statut `epic-2` non transitionné, désynchronisation de séquencement `sprint-status.yaml`/revue, `epic-2-context.md` non suivi, portée de la vérification non précisée face à « l'ancien dépôt »). Tous corrigés par le sous-agent d'implémentation, revérifiés (AC toujours vertes).
- Rejetés (`false`, 2) : « Spec Change Log vide » (section réservée aux boucles `bad_spec`, non déclenchées ici) ; nitpick de formatage du titre frontmatter (aucun préjudice concret nommé).
- Aucun `intent_gap` ni `bad_spec`.

**Follow-up review recommended :** `false` (aucune entrée `high` patchée, un seul `medium`, sous le seuil de deux).

**Vérification effectuée :** les 3 commandes de la section `## Verification` (forme corrigée) rejouées après patch, toutes conformes à l'attendu.

**Risques résiduels :** l'AC au sens large (« identique à l'ancien dépôt externe ») reste structurellement invérifiable dans cet environnement (aucun accès à ce dépôt externe) ; seule la stabilité interne depuis `335d33e` est prouvée — limite désormais documentée explicitement dans l'Approche.
