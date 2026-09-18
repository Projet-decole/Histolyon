# Travail différé

## Deferred from: code review of spec-1-1-initialiser-le-dépôt-et-protéger-main (2026-09-18)

- `.gitignore` ne couvre pas `env/demo.json`, le seul fichier que NFR8 nomme explicitement comme ne devant jamais être versionné. `env/` n'existe pas encore (Epic 10) ; Story 10.1 porte déjà sa propre AC couvrant `env/demo.json` ; hors du périmètre mono-zone (AD-12) de cette story. [`.gitignore:24-28`]
- `.gitignore` ne couvre pas encore les artefacts Flutter/Dart spécifiques (`.flutter-plugins`, `.flutter-plugins-dependencies`, `*.iml`, `local.properties`). `apps/mobile`/`apps/admin` n'existent pas encore (Story 1.4, backlog) ; `flutter create` gère typiquement ses propres entrées à ce moment. [`.gitignore:16-22`]

## Deferred from: build of spec-1-3-arbre-de-dossiers-de-la-spine (2026-09-18)

- source_spec: `docs/stories/spec-1-3-arbre-de-dossiers-de-la-spine.md`
  summary: Le premier paragraphe du bloc `<frozen-after-approval>` (Intent) énumère 6 dossiers créés (`apps/`, `packages/`, `supabase/`, `prompts/`, `tools/`, `env/`) en omettant `content/`, qui n'apparaît que dans une phrase séparée deux lignes plus loin — un lecteur qui ne lit que la première liste croit que `content/` n'a pas été créé.
  evidence: Trouvé par revue blind-hunter ; réel (confirmé par lecture directe du fichier) mais non corrigible ici — le texte fautif est à l'intérieur du bloc gelé, que cette session ne peut pas éditer sans renégociation humaine.

## Deferred from: build of spec-1-5-lint-d-imports-et-lints-de-base (2026-09-18)

- source_spec: `docs/stories/spec-1-5-lint-d-imports-et-lints-de-base.md`
  summary: `tools/check_import_direction.dart` n'a aucun test de régression automatisé — sa vérification (fixtures créées puis supprimées manuellement) ne survit pas dans le dépôt, un futur changement de la regex/résolution de chemin pourrait casser silencieusement la règle AD-5.
  evidence: Réel (trouvé par revue blind-hunter) ; corrigible seulement en donnant à `tools/` sa propre structure de package testable (pubspec.yaml + dev_dependency `test`), une décision structurelle qui dépasse le périmètre mécanique de cette story — à reconsidérer avec l'outillage `tools/` plus large (Epic 9 ou quand un autre script `tools/` sera ajouté).
