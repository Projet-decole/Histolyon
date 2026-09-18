# Travail différé

## Deferred from: code review of spec-1-1-initialiser-le-dépôt-et-protéger-main (2026-09-18)

- `.gitignore` ne couvre pas `env/demo.json`, le seul fichier que NFR8 nomme explicitement comme ne devant jamais être versionné. `env/` n'existe pas encore (Epic 10) ; Story 10.1 porte déjà sa propre AC couvrant `env/demo.json` ; hors du périmètre mono-zone (AD-12) de cette story. [`.gitignore:24-28`]
- `.gitignore` ne couvre pas encore les artefacts Flutter/Dart spécifiques (`.flutter-plugins`, `.flutter-plugins-dependencies`, `*.iml`, `local.properties`). `apps/mobile`/`apps/admin` n'existent pas encore (Story 1.4, backlog) ; `flutter create` gère typiquement ses propres entrées à ce moment. [`.gitignore:16-22`]
