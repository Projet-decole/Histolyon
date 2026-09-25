---
title: 'Apps Flutter du workspace'
type: 'chore'
created: '2026-09-18'
status: 'done'
route: 'oneshot'
review_loop_iteration: 0
context:
  - '{project-root}/docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** `apps/` n'a qu'un `README.md` (Story 1.3) : aucune app Flutter n'existe pour développer le mobile Android ni le back-office web, et le workspace Pub racine (Story 1.2) n'a aucun membre.

**Approach:** `flutter create --platforms=android` dans `apps/mobile`, `flutter create --platforms=web` dans `apps/admin` (org `com.histolyon` — non spécifié ailleurs dans la doc, choix par défaut documenté ici plutôt que laissé au hasard de `com.example`) ; ajouter `resolution: workspace` à l'`environment:` de chaque `pubspec.yaml` généré ; lister `apps/mobile` et `apps/admin` dans le `workspace:` du `pubspec.yaml` racine. Le contenu généré par `flutter create` (boilerplate `lib/main.dart`, `android/`, `web/`, `.gitignore` local, `analysis_options.yaml`, tests par défaut) n'est pas revu fichier par fichier — c'est de l'output d'outil déterministe, pas du code écrit à la main.

</frozen-after-approval>

## Implementation Notes

- `apps/mobile` : `flutter create --platforms=android --org com.histolyon --project-name mobile --description "Application mobile Android HistoLyon" apps/mobile` (35 fichiers écrits par `flutter create`, dont 26 réellement trackés par git — le reste, `.idea/`, `*.iml`, `gradlew`/`.jar`, `local.properties`, `.dart_tool/`, est exclu par le `.gitignore` que `flutter create` génère lui-même). `apps/admin` : même commande côté web (19 fichiers écrits, 14 trackés).
- `resolution: workspace` ajouté (clé sœur d'`environment:`, pas imbriquée dedans — le texte de l'Intent ci-dessus est imprécis sur ce point ; non corrigible, bloc gelé). `workspace:` racine mis à jour : `[apps/mobile, apps/admin]`.
- `flutter pub get` à la racine : résolution réussie, les deux apps rejoignent le workspace (`flutter_lints 6.0.0` déjà conforme à la spine ; `riverpod_lint` est le périmètre explicite de la Story 1.5, pas de celle-ci).
- Chaque app génère son propre `.gitignore` (`.dart_tool/`, `/build/`, `.flutter-plugins-dependencies`, `*.iml`, etc.) — résout de facto l'item différé de la Story 1.1 sur la couverture Flutter du `.gitignore` racine (`docs/stories/deferred-work.md` non modifié, conformément à la règle « ne pas éditer les entrées existantes »).
- **Correctif de fond découvert en revue** : les scripts `melos.scripts.test`/`gen` (Story 1.2) tournaient à la racine du workspace (`dart test`/`dart run build_runner` sans `melos exec`) — ils ne pouvaient donc jamais atteindre les packages membres. Corrigés en `dart run melos exec --dir-exists=test -- "flutter test || dart test"` et `dart run melos exec --depends-on=build_runner -- "..."` (le `dart run` explicite est nécessaire : `melos` n'est pas un binaire global sur ce poste, seulement une dev_dependency du workspace).
- AC + les 4 scripts vérifiés en exécution réelle : `analyze` → `No issues found!` ; `test` → `flutter test` exécute réellement les deux `widget_test.dart` générés, `All tests passed!` (2/2 packages) ; `format` → `Formatted 4 files (0 changed)` ; `gen` → `0 packages` concernés (attendu, aucun package ne dépend encore de `build_runner`).
- `flutter build web` réussi pour `apps/admin` (`✓ Built build/web`) — confirme que le toolchain web fonctionne réellement, pas seulement l'analyse statique. `flutter build apk` non tenté pour `apps/mobile` : `flutter doctor` signale le SDK Android présent mais `cmdline-tools` manquant (prérequis NFR9, hors périmètre de cette story) — build APK non vérifiable sur ce poste, tracé en action item.
- Titre de l'onglet/manifest web `apps/admin` corrigé (`admin` → `HistoLyon — Admin`), placeholder par défaut de `flutter create` sinon laissé tel quel.

## Review Triage Log

- `high`, patché — `melos.scripts.test`/`gen` (Story 1.2) ne s'exécutaient jamais dans les packages membres (pas de `melos exec`), donc les vrais tests Flutter de `apps/mobile`/`apps/admin` n'auraient jamais été lancés — corrigé, les 4 scripts vérifiés en exécution réelle.
- `low`, patché — `apps/README.md` gardait une formulation au futur (« peuplées par la Story 1.4 ») alors que les apps existent désormais — reformulé.
- `low`, patché — titre de page/manifest web `apps/admin` = placeholder `admin` par défaut — remplacé par « HistoLyon — Admin ».
- `low`, patché — Implementation Notes citaient les comptes de fichiers bruts de `flutter create` (35/19) sans préciser que `.gitignore` en exclut une partie du suivi git (26/14 trackés) — clarifié.
- `low`, différé — le texte du bloc gelé dit `resolution: workspace` imbriqué dans `environment:` ; en réalité clé sœur — non corrigible (bloc gelé), noté en Implementation Notes.
- `low`, patché — pas de build réel exercé (seulement analyse statique) — `flutter build web` tenté et réussi pour `apps/admin` ; `flutter build apk` non tenté (`cmdline-tools` Android absent), tracé en action item plutôt que silencieux.
- `false` — `riverpod_lint` non vérifié ici : périmètre explicite de la Story 1.5 (`epics.md`), pas de cette story.
- `false` — org `com.histolyon` mal justifiée (« non spécifié ailleurs ») car `ORGANISATION.md`/le remote GitHub utilisent « Projet-decole » : choix par produit (`histolyon`) plutôt que par organisation GitHub reste défendable ; texte d'Intent imprécis mais non corrigible (bloc gelé) et ne remet pas en cause la décision elle-même.
- `false` — `deferred-work.md` devrait annoter l'item Story 1.1 comme résolu par cette story : la règle du workflow interdit explicitement d'éditer les entrées existantes de ce fichier ; la résolution de facto est déjà notée en Implementation Notes.
