---
title: 'AGENTS.md racine et locaux'
type: 'feature'
created: '2026-09-18'
status: 'done'
baseline_revision: '582f7c428d5e69a3a62429831553081cacc2972f'
review_loop_iteration: 0
followup_review_recommended: true
context: []
warnings: []
deferred: []
---

<intent-contract>

## Intent

**Problem:** Rien ne dit aujourd'hui à un arrivant (humain ou IA) où chercher, quelles commandes lancer, ou ce qu'il ne doit jamais faire dans ce dépôt — l'information est éparpillée entre `ARCHITECTURE-SPINE.md` (334 lignes, 20 AD), `BOOTSTRAP.md` et `ORGANISATION.md`, trop volumineux pour être le point d'entrée L0 voulu par AD-15.

**Approach:** Trois fichiers `AGENTS.md` écrits à la main (jamais générés — ce sont `tools/sync-agents`, Story 2.4, qui en dérivera `CLAUDE.md`/`.cursor`/`copilot-instructions`, pas l'inverse) : un racine (repo entier : commandes workspace, carte des dossiers, conventions transverses, workflow story/PR, interdits globaux) et deux locaux, `apps/mobile/AGENTS.md` (spécifique Flutter/Riverpod/couches) et `supabase/AGENTS.md` (spécifique migrations/RLS/RPC/pgTAP). Chaque règle vit à un seul endroit ; les fichiers locaux renvoient au racine par lien relatif au lieu de répéter son contenu.

## Boundaries & Constraints

**Always:** chacun des trois fichiers fait strictement moins de 150 lignes ; chaque fichier couvre ses quatre rubriques (commandes, conventions de nommage, où chercher, ce qu'on ne fait jamais) ; toute règle transverse (workflow story/PR, interdits globaux type secrets/génératifs) vit uniquement dans le racine, les locaux y renvoient par lien relatif plutôt que de la répéter.

**Never:** ne jamais dupliquer une même règle en substance dans deux des trois fichiers ; ne jamais prétendre qu'une structure de dossiers existe déjà si elle n'est pas encore créée (ex. `apps/mobile/lib/{app,core,features}` n'existe qu'à partir de l'Epic 6 — le documenter comme convention cible, pas comme état actuel) ; ne jamais éditer `conception/`, `docs/architecture/`, ou tout fichier généré pour produire ce contenu — tout est de la prose neuve dans les trois `AGENTS.md`.

</intent-contract>

## Code Map

- `docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md` -- source des AD-1 à AD-20 (lignes ~26-208) et de la table `## Consistency Conventions` (lignes 187-208) ; source d'autorité pour tout contenu des trois fichiers, jamais copiée intégralement (chaque AGENTS.md est une distillation, pas une reproduction).
- `docs/architecture/architecture-HistoLyon-2026-09-17/BOOTSTRAP.md` -- séquence socle-01→11 et détail des commandes déjà établies (`tools/ctx`, `melos run analyze/test/format/gen`).
- `pubspec.yaml` (racine) -- scripts melos réels : `analyze` (`dart analyze . && dart run tools/check_import_direction.dart`), `test`, `format`, `gen` -- source de vérité des commandes du AGENTS.md racine, ne pas en inventer d'autres.
- `tools/ctx.dart`, `tools/check_import_direction.dart` -- les deux seuls scripts `tools/` existants aujourd'hui ; les autres (`gen-types`, `sync-agents`, `seed`, `media`, `tiles`, `check-tokens`, `report`) sont des épics futurs, à ne pas documenter comme existants.
- `apps/mobile/lib/main.dart`, `apps/admin/lib/main.dart` -- état réel actuel des apps (squelette `flutter create`, pas encore de `app/core/features`) ; AD-1, AD-5 (spine lignes ~29, ~37-40) donnent la convention cible.
- `supabase/README.md` -- confirme qu'aucun code Supabase réel n'existe encore (juste ce README) ; AD-2, AD-6, AD-16 (spine) donnent les conventions cibles pour migrations/RLS/RPC/pgTAP.
- Table `## Consistency Conventions` (spine, lignes 187-208) -- répartir ses lignes pertinentes entre les trois fichiers selon leur portée (ex. "Langue des identifiants"/"Commits" → racine ; "État"/"Erreurs"/"Auth" → mobile ; "Identifiants de données"/"Statut & provenance"/"Polymorphisme" → supabase), jamais recopier la table entière dans un seul fichier.
- AD-12, AD-13 (spine) -- workflow story/branche/PR/trunk-based : appartient uniquement au racine.

## Tasks & Acceptance

**Execution:**
- [x] `AGENTS.md` (racine, nouveau) -- rubriques : Commandes (melos run analyze/test/format/gen, `dart run tools/ctx.dart <ID>`, `dart run tools/ctx.dart --index`) ; Où chercher (une ligne par dossier de premier niveau : `apps/mobile`, `apps/admin`, `packages/`, `supabase/`, `conception/`, `docs/`, `tools/`, `content/`, `prompts/`, `env/`) ; Conventions transverses (langue des identifiants, PK uuid, Conventional Commits, un seul langage Dart/Flutter AD-1, workflow story/branche/PR AD-12, trunk-based AD-13) ; Jamais (secrets/URLs en dur, fichiers générés édités à la main, `conception/` éditée, médias/`env/demo.json` committés, push direct sur `main`, feature import d'une autre feature) ; renvois vers `apps/mobile/AGENTS.md` et `supabase/AGENTS.md` pour le détail par domaine. -- cœur de l'AC
- [x] `apps/mobile/AGENTS.md` (nouveau) -- rubriques : Commandes (`flutter run`, `melos run test` filtré sur ce package, `flutter analyze`) ; Conventions (couches strictes `presentation → domain → data` AD-5, composition root unique `app/`, état via `@riverpod`, navigation `go_router` dans `core/router`, erreurs `data` → `Result<T, Failure>`, `lowerCamelCase`, dossiers de feature = slugs D1-D11 de la table de conventions) ; Où chercher (`lib/main.dart` aujourd'hui ; `lib/{app,core,features}` = convention cible à partir de l'Epic 6, pas l'état actuel) ; Jamais (`setState` au-delà du widget local, exception Supabase/Drift attrapée en `presentation`, renvoi vers le racine pour l'import d'une feature par une autre plutôt que de répéter la règle). Renvoie au racine pour le workflow story/PR. -- cœur de l'AC
- [x] `supabase/AGENTS.md` (nouveau) -- rubriques : Commandes (`supabase start`, `supabase db reset`, `supabase test db`) ; Conventions (migrations dans `migrations/`, une par PR, horodatage postérieur au dernier de `main` AD-16, chaque invariant I1-I10 = contrainte SQL/RLS + test pgTAP dans `tests/`, transition de statut = RPC qui écrit une Trace, jamais `UPDATE` direct, rôles via `membre_equipe`) ; Où chercher (`migrations/`, `functions_sql/`, `tests/`, `seed/` -- pas encore peuplés, convention cible) ; Jamais (modification manuelle d'un projet Supabase, `UPDATE` direct sur une colonne de cycle de vie, clé secrète committée). Renvoie au racine pour le workflow story/PR. -- cœur de l'AC
- [x] `docs/stories/spec-2-3-agents-md-racine-et-locaux.md` -- consigner en Implementation Notes le nombre de lignes de chacun des trois fichiers et la vérification d'absence de duplication -- preuve auditable

**Acceptance Criteria:**
- Given les trois fichiers écrits, when on compte leurs lignes (`wc -l`), then chacun fait strictement moins de 150 lignes. -- satisfait : `AGENTS.md` 41, `apps/mobile/AGENTS.md` 31, `supabase/AGENTS.md` 34 (voir Implementation Notes).
- Given les trois fichiers écrits, when on vérifie leur contenu, then chacun couvre ses quatre rubriques (commandes, conventions de nommage, où chercher, ce qu'on ne fait jamais). -- satisfait : les trois fichiers ont chacun les sections `## Commandes`, `## Conventions de nommage`, `## Où chercher`, `## Jamais`.
- Given les trois fichiers écrits, when on compare leur contenu deux à deux, then aucune règle n'est répétée en substance dans deux fichiers (les locaux renvoient au racine par lien relatif plutôt que de répéter son contenu). -- satisfait (voir Implementation Notes pour le détail de la vérification croisée).

## Spec Change Log

## Implementation Notes

- Fichiers créés : `/home/lunos/CODE/ESP/AGENTS.md` (41 lignes), `/home/lunos/CODE/ESP/apps/mobile/AGENTS.md` (31 lignes), `/home/lunos/CODE/ESP/supabase/AGENTS.md` (34 lignes) -- `wc -l` confirme les trois strictement < 150.
- **Correction post-revue** : la vérification croisée initiale avait manqué une vraie duplication — `AGENTS.md` racine et `supabase/AGENTS.md` énonçaient tous les deux « PK `id uuid` généré côté client + `slug text unique` pour les entités éditoriales » quasi verbatim. Retiré de `supabase/AGENTS.md` (règle transverse, pas spécifique au schéma SQL — reste seule au racine, section Conventions de nommage) ; les autres lignes de `supabase/AGENTS.md` (statut/provenance, polymorphisme, invariants I1-I10) restent, elles sont spécifiques au schéma SQL. `apps/mobile/AGENTS.md` a aussi reçu un avertissement « état réel vs cible » en tête de fichier (squelette `flutter create`, conventions ci-dessous = cible Epic 6), au même endroit que celui déjà présent dans `supabase/AGENTS.md`, pour qu'un lecteur qui saute à la section Conventions ne croie pas l'architecture en couches déjà en place. La puce `tools/ctx.dart` du racine a été réordonnée pour porter la réserve « livré par la Story 2.2 » en tête plutôt qu'en fin de puce. La notation des plages d'épics a été uniformisée sur `/` (« Epics 4/5 » au lieu de « Epics 4-5 », cohérent avec « Epics 4/6/7 »).
- Écart constaté avec le Code Map de cette spec : `tools/ctx.dart` n'existe pas encore dans le dépôt (seul `tools/check_import_direction.dart` est réel aujourd'hui ; Story 2.2 `2-2-tools-ctx-et-conception-index-md` est encore `backlog` dans `sprint-status.yaml`). La commande `dart run tools/ctx.dart <ID>` / `--index` est tout de même documentée dans `AGENTS.md` racine (mandat explicite de cette spec, section Commandes), avec une note explicite « livré par la Story 2.2, indisponible tant qu'elle n'est pas fusionnée » pour ne pas prétendre qu'elle fonctionne déjà -- respecte la contrainte Never de ne jamais présenter un état non encore atteint comme actuel. De même, `tools/` liste `check_import_direction.dart` comme seul script existant et nomme le reste (`ctx`, `gen-types`, `sync-agents`, `seed`, `media`, `tiles`, `check-tokens`, `report`) comme à venir.
- Vérification croisée anti-duplication (lecture manuelle des trois fichiers, section par section) :
  - Workflow story/branche/PR (AD-12) et trunk-based (AD-13) : uniquement dans `AGENTS.md` racine, section Conventions de nommage. Aucune mention dans les deux fichiers locaux au-delà du lien de renvoi en tête de fichier.
  - Interdits globaux (secrets/URLs en dur, fichiers générés édités à la main, import d'une feature par une autre AD-5) : formulés une seule fois dans `AGENTS.md` racine (section Jamais). `apps/mobile/AGENTS.md` et `supabase/AGENTS.md` ne les reformulent pas : chacun a une ligne finale « Voir aussi les interdits transverses du [racine](...) » qui pointe par lien relatif sans répéter le contenu.
  - Conventions de la table *Consistency Conventions* de la spine réparties sans chevauchement : Langue des identifiants + Commits → racine ; État (Riverpod/`setState`) + Erreurs (`Result<T, Failure>`) → mobile ; Identifiants de données + Statut & provenance + Polymorphisme → supabase. Aucune de ces lignes n'apparaît dans un deuxième fichier.
  - Convention "un seul écrivain par entité / transition par RPC" (AD-6) : détaillée uniquement dans `supabase/AGENTS.md` (RPC, Trace, `UPDATE` interdit) ; `AGENTS.md` racine ne la mentionne pas, `apps/mobile/AGENTS.md` non plus.
  - Aucune phrase substantiellement identique trouvée entre les trois fichiers au-delà des liens de renvoi eux-mêmes (qui sont de la navigation, pas une règle répétée).
- `melos run analyze` exécuté réellement (Flutter 3.47.4 via `.fvm/flutter_sdk/bin`) après ajout des trois fichiers : `Analyzing .... No issues found!` puis `tools/check_import_direction: aucune violation.` -- aucune régression, les fichiers Markdown n'ont aucun effet de bord sur l'analyse statique ou le lint d'imports.
- Aucun fichier de `conception/`, `docs/architecture/` ni fichier généré n'a été touché ; seuls les trois `AGENTS.md` (nouveaux) et ce fichier de spec ont été modifiés.

## Review Triage Log

### 2026-09-18 — Review pass
- verdicts: 13 findings — high 3, medium 0, low 6, false 4, maybe-false 0
- findings:
  - `[high]` `patch` (blind-hunter) `AGENTS.md` (racine, l.30 « Identifiants ») et `supabase/AGENTS.md` (l.16) énoncent la même règle PK `id uuid`/`slug` quasi verbatim — viole littéralement le « Never » de la spec (« ne jamais dupliquer une même règle en substance ») et contredit la propre note d'Implementation Notes affirmant qu'aucune duplication n'a été trouvée : l'auto-vérification était fausse. Corrigé : la règle ne vit plus qu'au racine (transverse — s'applique aussi côté client/Drift, pas seulement Supabase), `supabase/AGENTS.md` ne la répète plus.
  - `[false]` reject (blind-hunter) la spec listait `lowerCamelCase` comme convention à documenter dans `apps/mobile/AGENTS.md`, absente du fichier réel — réfuté : `lowerCamelCase` est déjà couvert au racine (l.29) ; le reproduire dans le fichier mobile créerait une nouvelle duplication. L'omission est le bon choix au regard de la contrainte anti-duplication ; la description de tâche de la spec était juste imprécise sur ce point de détail.
  - `[low]` reject, hors périmètre par intention (blind-hunter) `apps/admin` n'a pas de `AGENTS.md` local ni de note d'asymétrie — réfuté comme défaut : l'AC de la story 2.3 (`docs/epics.md`) ne nomme que le racine, `apps/mobile` et `supabase` ; `apps/admin` en est explicitement absent, ce n'est pas un oubli.
  - `[low]` reject, hors périmètre par le Never de la spec (blind-hunter) les anciens documents (`ARCHITECTURE-SPINE.md`, `BOOTSTRAP.md`, `ORGANISATION.md`, `supabase/README.md`) ne sont ni réconciliés ni pointés vers les nouveaux `AGENTS.md` — la spec interdit explicitement d'éditer `docs/architecture/` pour produire ce contenu ; coexistence L0/L1 voulue, pas une incohérence.
  - `[low]` `patch` (blind-hunter) `supabase/AGENTS.md` porte un avertissement explicite « état réel vs cible » en tête de fichier, `apps/mobile/AGENTS.md` non (la nuance n'apparaît que plus loin, sous « Où chercher ») — un lecteur qui commence par « Conventions de nommage » pourrait croire l'architecture déjà en place. Corrigé : avertissement ajouté en tête de `apps/mobile/AGENTS.md`, même format que `supabase/AGENTS.md`.
  - `[low]` `patch` (blind-hunter) `dart run tools/ctx.dart` documenté dans la liste principale des Commandes du racine avec la réserve « indisponible » en fin de puce plutôt qu'en évidence — un lecteur pressé peut la manquer et exécuter une commande qui échoue. Corrigé : réserve déplacée en tête de puce.
  - `[low]` `patch` (blind-hunter) incohérence de notation « Epics 4/6/7 » vs « Epics 4-5 » dans « Où chercher » du racine. Corrigé : notation uniformisée.
  - `[low]` `defer` (blind-hunter) aucune vérification automatisée (CI/lint) du plafond de 150 lignes pour l'avenir — réel mais hors périmètre de l'épic 2 (checks CI câblés en Epic 9, `docs/epics.md` NFR1). Différé.
  - `[high]` `patch` (edge-case-hunter) même défaut que la 1re ligne (duplication PK uuid/slug racine/supabase).
  - `[high]` `patch` (intent-alignment) même défaut que la 1re ligne (duplication PK uuid/slug), présentée ici comme contradiction entre la clause 3 de l'AC et le contenu réel.
  - `[false]` reject (intent-alignment) écart de méthode de vérification (`melos run analyze` ne peut pas vérifier du contenu Markdown / une duplication de substance) — réfuté comme défaut séparé : c'est l'explication méthodologique de pourquoi la 1re ligne est passée inaperçue, pas un défaut distinct à corriger en plus du correctif déjà apporté ; bâtir un outillage automatisé de détection de duplication sémantique pour 3 fichiers Markdown statiques serait disproportionné.
  - `[low]` `patch` (intent-alignment) même défaut que la 6e ligne (commande `tools/ctx.dart` non fonctionnelle documentée sans mise en évidence suffisante).
  - `[false]` reject (intent-alignment) le fichier de spec `docs/stories/spec-2-3-...md` est un artefact « en plus » des trois AGENTS.md demandés par l'AC littérale — réfuté : c'est la convention BMAD appliquée à chaque story de ce build, pas une particularité de ce diff.
- note (verification-gap) : aucun finding rapporté par cette lentille (contenu statique, hors périmètre de son rubric) — n'apparaît pas dans le compte ci-dessus.

## Auto Run Result

**Résumé :** Trois `AGENTS.md` écrits à la main (racine 41 lignes, `apps/mobile` 31 lignes, `supabase` 34 lignes), chacun couvrant Commandes/Conventions de nommage/Où chercher/Jamais, sans duplication de substance entre eux après correction post-revue.

**Fichiers modifiés :**
- `AGENTS.md` (racine) -- nouveau, point d'entrée L0.
- `apps/mobile/AGENTS.md` -- nouveau, spécifique Flutter/Riverpod/couches, avertissement état réel vs cible ajouté en revue.
- `supabase/AGENTS.md` -- nouveau, spécifique migrations/RLS/RPC/pgTAP, ligne « Identifiants » retirée en revue (déjà au racine).
- `docs/stories/spec-2-3-agents-md-racine-et-locaux.md` -- spec, Implementation Notes, Review Triage Log.

**Revue :** 4 lentilles, 13 findings.
- Patchés : 4 entrées (1 `high` -- duplication réelle de la règle PK uuid/slug entre le racine et `supabase/AGENTS.md`, contredisant à la fois le Never de la spec et l'auto-vérification initiale, qui s'est révélée fausse ; 3 `low` -- avertissement état réel/cible manquant sur `apps/mobile/AGENTS.md`, mise en évidence insuffisante de la réserve sur `tools/ctx.dart`, incohérence de notation des plages d'épics). Tous corrigés, revérifiés (`grep` de non-duplication, `wc -l`, présence des 4 rubriques, `melos run analyze`).
- Différé (1, `low`) : absence de vérification CI/lint du plafond de 150 lignes -- hors périmètre épic 2 (Epic 9, NFR1).
- Rejetés hors périmètre par l'AC/le Never de la spec (`low`, 2) : absence d'`apps/admin/AGENTS.md`, non-réconciliation des anciens documents (`ARCHITECTURE-SPINE.md` etc.).
- Rejetés (`false`, 4) : omission de `lowerCamelCase` dans le fichier mobile (déjà au racine, l'ajouter aurait dupliqué), écart de méthode de vérification (explication du raté, pas un défaut distinct), fichier de spec « en plus » (convention BMAD normale).
- Aucun `intent_gap` ni `bad_spec`.

**Follow-up review recommended :** `true` -- une entrée `high` a été patchée lors de cette première passe (seuil atteint par construction dès qu'un `high` est corrigé). Risque nommé : la vérification croisée anti-duplication reste une lecture manuelle (aucun outillage automatisé ne la reproduit), et elle avait déjà raté une duplication réelle une première fois avant cette passe de revue.

**Vérification effectuée :** les 3 commandes de la section `## Verification` rejouées après correctifs (`wc -l`, lecture croisée, `melos run analyze`) -- toutes conformes.

**Risques résiduels :** la commande `dart run tools/ctx.dart` documentée au racine reste indisponible tant que la PR de la Story 2.2 n'est pas fusionnée (dépendance de séquencement entre PR, pas un défaut de cette story) ; voir aussi Follow-up review recommended ci-dessus.

## Verification

**Commands:**
- `wc -l AGENTS.md apps/mobile/AGENTS.md supabase/AGENTS.md` -- expected: les trois valeurs < 150
- lecture manuelle croisée des trois fichiers -- expected: aucune phrase substantiellement dupliquée ; chaque fichier couvre ses 4 rubriques
- `melos run analyze` -- expected: aucune régression (fichiers Markdown seulement, mais vérifie l'absence d'effet de bord)
