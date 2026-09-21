---
title: 'tools/sync-agents'
type: 'feature'
created: '2026-09-18'
status: 'done'
baseline_revision: '3a4c7e88b2840a57c96b4a7a3236502a468f4856'
review_loop_iteration: 0
followup_review_recommended: false
context: []
warnings: []
deferred:
  - summary: >-
      Aucune vérification CI n'échoue quand `AGENTS.md` change sans que `tools/sync_agents.dart`
      ait été rejoué (péremption silencieuse de `CLAUDE.md`/`.cursor/rules/histolyon.mdc`/
      `.github/copilot-instructions.md`).
    evidence: |-
      `docs/architecture/architecture-HistoLyon-2026-09-17/BOOTSTRAP.md` : « vérifié en CI (un
      diff après régénération fait échouer le job) ... d'ici là, ils s'exécutent en local » —
      ce câblage CI est explicitement prévu pour l'Epic 9 (`docs/epics.md` NFR1), pas l'Epic 2.
      Un test local (`test/tools/sync_agents_test.dart`) couvre déjà la découverte/l'idempotence
      en attendant.
    location: >-
      tools/sync_agents.dart, CLAUDE.md, .cursor/rules/histolyon.mdc, .github/copilot-instructions.md
    severity: low
  - summary: >-
      `.cursor/rules/histolyon.mdc` porte `alwaysApply: true` sur tout le contenu concaténé,
      injectant les conventions spécifiques à `apps/mobile` ou `supabase` dans tout contexte
      d'édition Cursor, même hors de ces dossiers.
    evidence: |-
      L'AC nomme un unique fichier `.cursor/rules/histolyon.mdc` ; des règles Cursor scopées par
      `globs:` (un fichier par domaine) résoudraient le problème mais contrediraient ce nombre de
      fichiers explicitement demandé. À reconsidérer si un vrai conflit de pertinence se manifeste
      en usage réel.
    location: >-
      .cursor/rules/histolyon.mdc
    severity: low
---

<intent-contract>

## Intent

**Problem:** Les instructions de la maison vivent dans les `AGENTS.md` (Story 2.3), mais Claude Code, Cursor et GitHub Copilot cherchent chacun un fichier différent à un emplacement différent (`CLAUDE.md`, `.cursor/rules/*.mdc`, `.github/copilot-instructions.md`) — sans script, ces trois fichiers seraient maintenus (et dériveraient) séparément des `AGENTS.md`.

**Approach:** Un script Dart `tools/sync_agents.dart` (convention déjà établie par `tools/check_import_direction.dart`/`tools/ctx.dart`, invoqué via `dart run tools/sync_agents.dart`) qui concatène tous les fichiers `AGENTS.md` du dépôt (racine + locaux, découverts par glob — pas une liste figée à 2 fichiers, pour rester valable quand d'autres `AGENTS.md` locaux apparaîtront) en un contenu unique, préfixé d'un bandeau « généré, ne pas éditer », puis l'écrit dans les trois formats cibles.

## Boundaries & Constraints

**Always:** les trois fichiers générés portent un bandeau explicite (« Généré par `tools/sync_agents.dart` depuis les `AGENTS.md` — ne jamais éditer à la main ») ; le script est idempotent (relancer sans changer un `AGENTS.md` ne produit aucun diff) ; les trois fichiers cibles sont entièrement réécrits à chaque exécution ; `.cursor/rules/histolyon.mdc` porte le frontmatter minimal attendu par Cursor pour une règle toujours active (`alwaysApply: true`).

**Never:** ne jamais lire ni écrire un fichier généré comme source (le script ne lit que des fichiers `AGENTS.md`) ; ne jamais modifier un `AGENTS.md` existant ; ne pas coder en dur la liste des deux `AGENTS.md` locaux connus aujourd'hui (`apps/mobile`, `supabase`) — les découvrir par glob pour rester correct quand d'autres apparaîtront.

</intent-contract>

## Code Map

- `AGENTS.md` (racine), `apps/mobile/AGENTS.md`, `supabase/AGENTS.md` -- les 3 fichiers source existants aujourd'hui (Story 2.3, PR #53 non encore fusionnée mais présente sur cette branche puisqu'elle en dérive). Le script doit les découvrir par glob (`**/AGENTS.md` à la racine du dépôt, hors `_bmad/`, `.claude/`, `build/` etc. déjà couverts par `.gitignore`), pas une liste figée.
- `tools/ctx.dart` -- référence de convention existante (Story 2.2) : script Dart autonome (`dart:io` seul, pas de dépendance pub), écriture de fichier idempotente avec message de confirmation sur stdout. `tools/sync_agents.dart` suit la même convention.
- `docs/stories/sprint-status.yaml` action_items -- l'item `github-dir-not-created-story-1-3` suppose que Story 2.6 ou 9.1+ créeront `.github/` en premier ; cette story le crée en réalité la première (pour `copilot-instructions.md`) -- l'action item doit être mis à jour pour refléter ça, pas laissé tel quel.
- `.gitignore` -- ne couvre pas encore `.cursor/` ni `.github/` : aucun ajout nécessaire, ces dossiers doivent être committés (contenu généré, pas local).
- Format Cursor `.mdc` : frontmatter YAML minimal `description`, `alwaysApply: true` (règle de projet toujours active), suivi du contenu Markdown.

## Tasks & Acceptance

**Execution:**
- `tools/sync_agents.dart` -- créer le script : découvre tous les `AGENTS.md` du dépôt par glob, les concatène (un titre `## <chemin>` par fichier source, dans l'ordre du chemin trié), génère le contenu commun préfixé du bandeau « généré », puis écrit `CLAUDE.md` (racine, tel quel), `.cursor/rules/histolyon.mdc` (avec frontmatter `description`/`alwaysApply: true`), `.github/copilot-instructions.md` (créant `.cursor/rules/` et `.github/` s'ils n'existent pas). -- cœur de l'AC
- `AGENTS.md` (racine) -- ajouter une ligne dans la section Commandes documentant `dart run tools/sync_agents.dart` -- cohérence du point d'entrée L0 avec l'outillage qu'il décrit
- `docs/stories/sprint-status.yaml` -- mettre à jour le résumé de l'action item `github-dir-not-created-story-1-3` : `.github/` est en réalité créé par cette story (2.4), pas par 2.6/9.1+ -- corriger une prévision devenue fausse
- `docs/stories/spec-2-4-tools-sync-agents.md` -- consigner en Implementation Notes la sortie réelle de `dart run tools/sync_agents.dart` et la preuve d'idempotence -- preuve auditable

**Acceptance Criteria:**
- Given les trois `AGENTS.md` existants (racine, `apps/mobile`, `supabase`), when `dart run tools/sync_agents.dart` est exécuté, then `CLAUDE.md`, `.cursor/rules/histolyon.mdc` et `.github/copilot-instructions.md` sont créés/mis à jour, chacun contenant le contenu des trois `AGENTS.md` sous un bandeau « généré ».
- Given les trois fichiers déjà générés sans changement d'aucun `AGENTS.md`, when `dart run tools/sync_agents.dart` est rejoué, then aucun des trois fichiers générés ne change (`git diff` vide).
- Given un `AGENTS.md` modifié, when `dart run tools/sync_agents.dart` est rejoué, then les trois fichiers générés reflètent le changement.

## Spec Change Log

## Review Triage Log

### 2026-09-18 — Review pass
- verdicts: 21 findings — high 0, medium 1, low 16, false 4, maybe-false 0
- findings:
  - `[medium]` `patch` (blind-hunter) les liens Markdown relatifs de chaque `AGENTS.md` source (ex. `[../../AGENTS.md](../../AGENTS.md)`, `[apps/mobile/AGENTS.md](apps/mobile/AGENTS.md)`) ne sont corrects que depuis l'emplacement du fichier source ; une fois concaténés dans les 3 fichiers générés à des profondeurs différentes (racine, `.cursor/rules/`, `.github/`), plusieurs liens pointent hors dépôt ou vers un chemin inexistant — vérifié par grep sur les fichiers réellement générés. Corrigé : les liens relatifs sont réécrits en chemins de code inline (non cliquables mais toujours corrects) pendant la concaténation.
  - `[low]` `patch` (blind-hunter) `AGENTS.md` liste toujours `sync-agents` parmi les outils « arrivent épic par épic — pas encore là », alors que cette story le livre — corrigé : `sync-agents` retiré de cette liste.
  - `[false]` reject (blind-hunter) dérive de nommage `tools/sync-agents` (prose/AC) vs `tools/sync_agents.dart` (fichier réel) — réfuté : même convention déjà acceptée pour `tools/ctx` → `tools/ctx.dart` (Story 2.2), non substantiel.
  - `[low]` `patch` (blind-hunter) aucun garde-fou si le script est lancé depuis un mauvais répertoire (ex. `apps/mobile/`) : il trouverait le seul `AGENTS.md` local et écrirait les 3 fichiers générés au mauvais endroit, sans avertissement. Corrigé : le script vérifie la présence de `pubspec.yaml` à la racine avant d'écrire.
  - `[low]` `defer` (blind-hunter) aucune vérification CI de péremption (diff après régénération = échec) — explicitement prévu pour l'Epic 9 (`BOOTSTRAP.md`, `docs/epics.md` NFR1). Différé.
  - `[low]` `patch` (blind-hunter) l'ordre de tri (racine avant les locaux) ne repose que sur une coïncidence ASCII (`'A' < 'a'`), non documentée comme garantie. Corrigé : tri explicite par profondeur puis chemin, indépendant de la casse.
  - `[low]` `patch` (blind-hunter) le texte du bandeau « généré, ne pas éditer » existe en double dans deux constantes distinctes (bandeau principal + frontmatter Cursor), pouvant diverger. Corrigé : une seule constante partagée.
  - `[false]` reject (blind-hunter) risque signalé par l'implémenteur (exclusion par nom de dossier trop permissive) mais non tracé (`followup_review_recommended: false`, Review Triage Log vide) — absorbé par le correctif de la 16e ligne ci-dessous (le risque est directement corrigé, pas seulement tracé).
  - `[low]` `patch` (blind-hunter) aucun test automatisé pour la logique de traversée/idempotence — corrigé : `test/tools/sync_agents_test.dart` ajouté, même convention que `tools/ctx.dart` (Story 2.2) et NFR6.
  - `[low]` `patch` (edge-case-hunter) un lien symbolique (dossier ou fichier `AGENTS.md`) est silencieusement ignoré sans avertissement.
  - `[low]` `patch` (edge-case-hunter) `dir.listSync()` sur un sous-dossier sans permission lève une exception non interceptée.
  - `[low]` `patch` (edge-case-hunter) lecture d'un `AGENTS.md` devenu illisible entre la découverte et la lecture (TOCTOU) : exception non interceptée.
  - `[low]` `patch` (edge-case-hunter) si `.cursor` ou `.github` existe déjà comme fichier simple (pas un dossier), `createSync(recursive: true)` lève une exception non interceptée.
  - `[low]` `patch` (edge-case-hunter) un échec d'écriture partiel (disque plein, permissions) après que `CLAUDE.md` a déjà été réécrit laisse les 3 fichiers générés mutuellement incohérents, sans rapport clair de ce qui a réussi.
  - `[low]` reject (edge-case-hunter) récursion non bornée dans la marche du dossier, risque de dépassement de pile sur un arbre anormalement profond — rejeté : improbable dans ce dépôt et le correctif (passer à une pile explicite) dépasse une correction directe.
  - `[low]` `patch` (edge-case-hunter) l'exclusion de dossiers (`_bmad`, `build`) matche sur le nom nu, pas sur le chemin complet : un dossier légitimement nommé ainsi ailleurs dans l'arbre serait exclu à tort. Corrigé : l'exclusion ne s'applique qu'au chemin racine exact (`_bmad/`, `build/` en tête de chemin relatif).
  - `[low]` `defer` (verification-gap) aucun test automatisé ne couvre la découverte/l'idempotence, et aucun job CI ne le fera avant l'Epic 9 — disposition motivée explicitement par `BOOTSTRAP.md` (« vérifié en CI ... d'ici là ils s'exécutent en local ») et le précédent `tools/check_import_direction.dart`. La partie « test local existe » est désormais couverte par le correctif de la 9e ligne ; seule la vérification CI reste différée.
  - `[false]` reject (verification-gap) `sprint-status.yaml` affiche toujours `2-4-tools-sync-agents: backlog` sur cette branche — attendu, mis à jour à la Finalisation de cette story, pas un défaut du diff.
  - `[false]` reject (intent-alignment) même dérive de nommage que la 3e ligne (`tools/sync-agents` vs `tools/sync_agents.dart`).
  - `[low]` `patch` (intent-alignment) la preuve d'idempotence ne vit que dans la prose des Implementation Notes (exécution manuelle, `md5sum`), pas dans un artefact re-vérifiable — résolu par le même correctif que la 9e ligne (test automatisé).
  - `[low]` `defer` (intent-alignment) `.cursor/rules/histolyon.mdc` porte `alwaysApply: true` sur tout le contenu concaténé (racine + mobile + supabase), donc les conventions spécifiques à `apps/mobile` ou `supabase` sont injectées dans tout contexte d'édition, même hors de ces dossiers — réel, mais généré un unique fichier `.mdc` nommé est une contrainte explicite de l'AC ; des règles Cursor scopées par `globs:` (un fichier par domaine) contrediraient ce nombre de fichiers. Différé : à reconsidérer si un vrai conflit de pertinence se manifeste.

## Verification

**Commands:**
- `dart run tools/sync_agents.dart` -- expected: les 3 fichiers créés/mis à jour, message de confirmation sur stdout
- `git diff --stat -- CLAUDE.md .cursor/rules/histolyon.mdc .github/copilot-instructions.md` (après un premier commit) puis rejouer la commande -- expected: sortie vide (idempotent)
- modifier temporairement une ligne d'un `AGENTS.md`, rejouer, vérifier que le changement apparaît dans les 3 fichiers générés, puis annuler la modification -- expected: propagation confirmée, `AGENTS.md` restauré ensuite
- `melos run analyze` -- expected: aucune régression

## Implementation Notes

**Environnement d'exécution :** `dart`/`melos` absents du `PATH` par défaut sur ce poste ; Flutter 3.47.4 est géré par `fvm` (`.fvmrc`) et résolu via `/home/lunos/fvm/versions/3.47.4/bin`. Toutes les commandes ci-dessous ont été exécutées avec ce répertoire préfixé au `PATH` (et `~/.pub-cache/bin` pour `melos`), depuis la racine du dépôt.

**Sortie réelle de `dart run tools/sync_agents.dart` (après les correctifs de la revue, 3 AGENTS.md présents) :**

```
tools/sync_agents: 3 AGENTS.md synchronisés vers CLAUDE.md, .cursor/rules/histolyon.mdc, .github/copilot-instructions.md :
  - AGENTS.md
  - supabase/AGENTS.md
  - apps/mobile/AGENTS.md
```

Ordre trié par profondeur de chemin puis par chemin (`AGENTS.md` = 1 segment, `supabase/AGENTS.md` = 2, `apps/mobile/AGENTS.md` = 3) -- garantit le fichier racine toujours premier, indépendamment de toute coïncidence de casse entre noms de dossiers (correctif de revue, voir Review Triage Log).

`CLAUDE.md`, `.cursor/rules/histolyon.mdc` (avec frontmatter `description`/`alwaysApply: true`) et `.github/copilot-instructions.md` ont été créés (dossiers `.cursor/rules/` et `.github/` inexistants avant la première exécution), chacun préfixé du bandeau `> Généré par \`tools/sync_agents.dart\` depuis les \`AGENTS.md\` — ne jamais éditer à la main.` puis les trois AGENTS.md concaténés sous un titre `## <chemin>`. Les liens Markdown relatifs des AGENTS.md sources (ex. `[../../AGENTS.md](../../AGENTS.md)` dans `apps/mobile/AGENTS.md`) sont réécrits pendant la concaténation en chemins de code inline exprimés relativement à la racine du dépôt (ex. `` `AGENTS.md` ``, `` `AGENTS.md#jamais` ``) -- plus de lien cliquable, mais correct quelle que soit la profondeur du fichier généré qui l'embarque (correctif de revue : les liens recopiés tels quels pointaient hors dépôt ou vers un chemin inexistant une fois concaténés dans `.cursor/rules/` ou `.github/`).

**Preuve d'idempotence :** `md5sum CLAUDE.md .cursor/rules/histolyon.mdc .github/copilot-instructions.md` capturé, script rejoué, `md5sum` recapturé -- `diff` des deux captures vide (aucun octet changé), reconfirmé après les correctifs de revue. Couvert aussi par `test/tools/sync_agents_test.dart` (section « idempotence », comparaison de contenu entre deux exécutions successives sur le dépôt réel).

**Preuve de propagation :** une ligne temporaire (`TEMP_TEST_LINE_2_4_V2`) ajoutée à `supabase/AGENTS.md`, script rejoué -- la ligne apparaît dans les 3 fichiers générés (`grep -c` = 1 dans chacun). `supabase/AGENTS.md` restauré depuis une copie de sauvegarde, script rejoué -- la ligne disparaît des 3 fichiers générés (`grep -c` = 0 dans chacun) et `git diff --stat -- supabase/AGENTS.md` confirme une restauration exacte (sortie vide). Couvert aussi par `test/tools/sync_agents_test.dart` (section « propagation », sur une fixture isolée dans un répertoire temporaire, pour ne pas dépendre des AGENTS.md réels).

**`melos run analyze` :** `dart analyze .` -- "No issues found!" ; `tools/check_import_direction.dart` -- "aucune violation." Aucune régression, reconfirmé après les correctifs de revue.

**`dart test/tools/sync_agents_test.dart` :** 26 assertions, toutes au vert (découverte des AGENTS.md réels + absence de lien brisé, idempotence, propagation sur fixture isolée, garde-fou de répertoire sur fixture sans `pubspec.yaml`).

## Auto Run Result

**Résumé :** `tools/sync_agents.dart` créé (script Dart autonome) : découvre tous les `AGENTS.md` du dépôt par glob (racine + locaux, sans liste figée), les concatène sous un bandeau « généré », et écrit `CLAUDE.md`, `.cursor/rules/histolyon.mdc` (frontmatter Cursor) et `.github/copilot-instructions.md` de façon idempotente. Suite de tests dédiée ajoutée.

**Fichiers modifiés :**
- `tools/sync_agents.dart` -- script (découverte, concaténation, réécriture de liens relatifs, garde-fous d'E/S et de répertoire).
- `CLAUDE.md`, `.cursor/rules/histolyon.mdc`, `.github/copilot-instructions.md` -- générés.
- `AGENTS.md` -- ligne de commande ajoutée, mention obsolète de `sync-agents` retirée.
- `test/tools/sync_agents_test.dart` -- 26 assertions (découverte, idempotence, propagation, garde-fou).
- `docs/stories/sprint-status.yaml` -- action item `github-dir-not-created-story-1-3` corrigé et clos.

**Revue :** 4 lentilles, 21 findings.
- Patchés : 10 entrées (1 `medium` -- liens Markdown relatifs cassés une fois concaténés à des profondeurs différentes ; 9 `low` -- mention obsolète dans `AGENTS.md`, absence de garde-fou de répertoire, tri fragile par coïncidence ASCII, bandeau dupliqué, absence de test automatisé, plusieurs E/S non protégées (symlink, `listSync`, lecture TOCTOU, `.cursor`/`.github` déjà fichier, écriture partielle), exclusion de dossiers par nom nu au lieu du chemin complet). Tous corrigés, revérifiés (26 tests + vérifications manuelles).
- Différés (2, `low`) : détection CI de péremption (Epic 9, NFR1) ; `.cursor/rules/histolyon.mdc` en `alwaysApply: true` injecte des conventions locales hors de leur dossier (contrainte de l'AC : un seul fichier nommé, à reconsidérer si un conflit réel apparaît).
- Rejetés (`false`, 4) : dérive de nommage `tools/sync-agents`/`tools/sync_agents.dart` (×2, convention déjà établie par `tools/ctx`), risque non tracé (absorbé par le correctif d'exclusion), `sprint-status.yaml` encore `backlog` sur cette branche (attendu, mis à jour ci-dessous).
- Aucun `intent_gap` ni `bad_spec`.

**Follow-up review recommended :** `false` -- une seule entrée `medium` patchée (sous le seuil de deux), aucune `high`.

**Vérification effectuée :** les commandes de la section `## Verification` rejouées après correctifs (toutes conformes), plus `dart test/tools/sync_agents_test.dart` (26/26) et `melos run analyze` (propre), plus une vérification indépendante de l'absence de lien `](../` dans les 3 fichiers générés.

**Risques résiduels :** voir les deux items différés ci-dessus.

**Correctifs appliqués suite à la revue du 2026-09-18** (détail complet dans Review Triage Log) : réécriture des liens Markdown relatifs en chemins racine ; retrait de `sync-agents` de la liste « pas encore là » de `AGENTS.md` ; garde-fou `pubspec.yaml` avant toute écriture ; tri par profondeur puis chemin ; bandeau « généré » unifié en une seule constante partagée (bandeau + frontmatter Cursor) ; E/S protégées (lien symbolique signalé sur stderr, erreur de listing/lecture rapportée via `FileSystemException` plutôt qu'une exception brute) ; garde-fou si `.cursor`/`.github` existe déjà comme fichier simple ; rapport précis en cas d'échec d'écriture partiel (fichier en cause + fichiers déjà écrits) ; exclusion de `_bmad`/`build` restreinte au premier segment du chemin (dossiers cachés toujours exclus à toute profondeur, eux) ; `test/tools/sync_agents_test.dart` ajouté (même convention boîte noire que `test/tools/ctx_test.dart`, Story 2.2).

**Rien de laissé incomplet.**
