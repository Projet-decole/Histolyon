---
title: "Lint d'imports et lints de base"
type: 'chore'
created: '2026-09-18'
status: 'done'
route: 'dispatch'
review_loop_iteration: 0
context:
  - '{project-root}/docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md'
  - '{project-root}/docs/architecture/architecture-HistoLyon-2026-09-17/BOOTSTRAP.md'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** `flutter_lints` 6 est déjà actif par défaut (Story 1.4, `flutter create`), mais rien n'empêche une feature d'en importer une autre, ni `core/` d'importer une feature — violation silencieuse d'AD-5, découverte seulement en relecture humaine.

**Approach:** Ajouter une règle qui fait échouer `melos run analyze` sur un import fautif (`features/x → features/y`, `core/* → features/*`). `riverpod_lint` (demandé par `epics.md`/BOOTSTRAP.md) est **différé à l'Epic 6** : `custom_lint` (dont il dépend) exige `cli_util ^0.4.2` quelle que soit sa version — incompatible avec `melos` (`cli_util >=0.5.0 <0.7.0`) dans la résolution unifiée d'un workspace Pub natif, conflit vérifié empiriquement (le solveur pub échoue pour toute version de `custom_lint`). Décision humaine (2026-09-18) : différer `riverpod_lint`, implémenter la règle d'imports sans dépendance tierce. `BOOTSTRAP.md`, `epics.md` (AC Story 1.5) et `epic-1-context.md` amendés en conséquence.

</frozen-after-approval>

## Boundaries & Constraints

**Always:**
- La règle d'imports doit faire échouer `melos run analyze` sur un import fautif réel (vérifié par un fixture temporaire, pas seulement en lecture de code).
- Aucune dépendance pub tierce pour la règle d'imports (raison du conflit ci-dessus) : `dart:io` seul.
- `flutter_lints` 6 reste actif (déjà le cas via `flutter create`, Story 1.4) — ne pas le retirer.

**Never:**
- Ne pas ajouter `custom_lint`/`riverpod_lint` au workspace tant que `melos` y est une dépendance (cli_util incompatible, prouvé).
- Ne pas laisser de fixture de test (dossiers `features/x`, `features/y` factices) dans l'arbre final.

## Code Map

- `pubspec.yaml` (racine) — `melos.scripts.analyze` : chaîner la nouvelle règle après `dart analyze .`.
- `tools/` (Story 1.3, vide jusqu'ici) — nouveau script `check_import_direction.dart`.
- `apps/mobile/lib/`, `apps/admin/lib/` — pas de `features/`/`core/` réels pour l'instant (Epic 6+) ; la règle doit être un no-op silencieux sur l'arbre actuel, pas une erreur.

## Tasks & Acceptance

**Execution:**
- [x] `tools/check_import_direction.dart` — scanne `apps/*/lib/{features,core}` (imports `package:` et relatifs), détecte `features/x → features/y` et `core/* → features/*` — implémente la règle sans dépendance tierce
- [x] `pubspec.yaml` — `melos.scripts.analyze` chaîne `dart analyze . && dart run tools/check_import_direction.dart`
- [x] Vérification par fixture temporaire (créée puis supprimée) : import fautif détecté, imports valides (intra-feature, feature→core) non signalés
- [x] `BOOTSTRAP.md`, `docs/epics.md`, `docs/stories/epic-1-context.md` amendés pour documenter le report de `riverpod_lint`

**Acceptance Criteria:**
- Given les apps du workspace créées (Story 1.4), when `flutter_lints` 6 et la règle d'imports sont configurés, then `melos run analyze` passe sur les squelettes vides sans avertissement — satisfait
- Given un import volontairement fautif (`features/x` important `features/y`), when `melos run analyze` est lancé, then il échoue — satisfait (vérifié par fixture, voir Implementation Notes)
- Given l'Epic 1 terminé, when `melos run analyze` et `melos run test` sont lancés à la racine, then les deux passent sur les squelettes vides et un push direct sur `main` reste refusé — satisfait

## Implementation Notes

- `tools/check_import_direction.dart` écrit (regex sur `import '...'`, résolution des imports relatifs et `package:<app>/...`, comparaison du slug de feature source/cible). Testé avec un fixture temporaire (`apps/mobile/lib/features/{alpha,beta}`, `core/services/bad_core_service.dart`) : les 2 violations attendues détectées (`alpha→beta`, `core→alpha`), aucun faux positif sur les imports valides (`alpha/presentation→alpha/domain`, `alpha→core`). Un premier essai de fixture avait un chemin relatif erroné (`../..` au lieu de `../../..`) faussement détecté comme violation — bug de fixture, pas du script ; corrigé et revérifié. Fixtures supprimées après vérification.
- `melos.scripts.analyze` : `dart analyze . && dart run tools/check_import_direction.dart`. Vérifié : `melos run analyze` passe sur l'arbre réel (aucune feature/core encore réelle) ; échoue correctement avec un import fautif temporaire (`features/x→features/y`), confirmé en exécution réelle via `melos run analyze` (pas seulement le script seul).
- **Conflit `melos`/`custom_lint` découvert et résolu** (voir bloc gelé) : `riverpod_lint` différé à l'Epic 6. `BOOTSTRAP.md` §1, `docs/epics.md` (AC Story 1.5) et `docs/stories/epic-1-context.md` amendés avec la raison technique.
- Les 4 scripts melos revérifiés après coup : `analyze`, `test` (vrais tests Flutter des 2 apps, `flutter test`), `format`, `gen` — tous passent.
- `riverpod_lint`/`custom_lint` non ajoutés du tout (ni en dev_dependency directe ni transitivement) — action item de suivi ajouté à `sprint-status.yaml` pour l'Epic 6.

## Review Triage Log

- `medium`, patché — les directives `export` n'étaient pas scannées (seulement `import`) : un barrel `features/x` réexportant `features/y` contournait la règle AD-5 sans être détecté — regex étendue, vérifié par fixture (`export` fautif désormais détecté).
- `low`, patché — `_packageName` capturerait les guillemets si `pubspec.yaml` écrivait `name: "mobile"` (aucune app actuelle ne le fait, mais latent) — regex corrigée pour les tolérer.
- `low`, patché — absence silencieuse de `apps/` traitée comme "rien à vérifier" (exit 0) plutôt que comme un signal probable de mauvais répertoire de lancement — désormais un échec bruyant (stderr + exit 1), cohérent avec le principe « échouer fermé » d'une règle d'architecture.
- `low`, patché — `docs/epics.md` Story 1.5 : la ligne « Je veux » mentionnait encore `riverpod_lint` sans amendement, contredisant l'AC juste en dessous — reformulée.
- `medium`, différé — `tools/check_import_direction.dart` n'a aucun test de régression automatisé — corrigible seulement en dotant `tools/` d'une structure de package testable, décision structurelle hors périmètre mécanique de cette story ; entrée ajoutée à `deferred-work.md`.
- `false` — imports conditionnels (`if (dart.library.io) ...`) partiellement ignorés : réel mais rejeté (correction non triviale, improbable dans du code applicatif Flutter — pattern surtout utilisé dans des packages multi-plateformes).
- `false` — commentaire entre `import` et l'URI casse la regex : réel mais rejeté (style de code jamais rencontré dans ce projet, correction non triviale).
- `false` — pas de gestion d'erreur I/O (symlinks, fichiers non-UTF8) : aucun scénario démontré comme atteignable dans l'arbre réel de ce dépôt (uniquement des fichiers `.dart` texte) ; un futur crash resterait de toute façon visible (échec bruyant, pas silencieux).
- `false` — comparaison de casse des slugs non documentée pour un FS insensible à la casse : environnement de dev Linux uniquement (prérequis NFR9), convention de nommage des features déjà tout-minuscule (`epics.md`).
- `false` — `sprint-status.yaml` à `in-progress` alors que la spec est entièrement cochée : ordre normal du workflow (Finalize Spec pas encore exécuté à ce stade de la revue), pas une incohérence.
