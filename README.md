# HistoLyon

Application Android (et, sans licence développeur payante, code partagé prêt pour iOS) qui fait explorer Lyon à travers les époques : carte, slider temporel, pins historiques, parcours. Backend Supabase, contenu éditorial en YAML, monorepo Dart/Flutter.

**Nouveau sur ce dépôt ? Commence ici, dans l'ordre :**

1. [`AGENTS.md`](AGENTS.md) — commandes, conventions, où chercher. Une page, à lire en entier.
2. [`docs/architecture/architecture-HistoLyon-2026-09-17/ORGANISATION.md`](docs/architecture/architecture-HistoLyon-2026-09-17/ORGANISATION.md) — pourquoi le dépôt est organisé ainsi (25 min de lecture, explique tout le reste).
3. [`docs/architecture/architecture-HistoLyon-2026-09-17/BOOTSTRAP.md`](docs/architecture/architecture-HistoLyon-2026-09-17/BOOTSTRAP.md) — comment le socle a été construit, étape par étape.

## Démarrer à coder

**Option la plus simple : le devcontainer.** Ouvre le dépôt dans VS Code avec l'extension *Dev Containers*, ou GitHub Codespaces — Flutter, Android SDK, Supabase CLI, melos et lefthook sont préinstallés et à la bonne version. Détail : [`.devcontainer/`](.devcontainer/).

**En natif**, installer d'abord : Flutter 3.47.4 (via [fvm](https://fvm.app/), voir `.fvmrc`), Docker, Supabase CLI 2.117, lefthook 2.1, Android SDK (API 21+, JDK 21). Puis :

```bash
git clone <url-du-depot> && cd Histolyon
flutter pub get
lefthook install
supabase start
supabase db reset
melos run test
```

Tout doit être vert. Sinon, ouvre une issue `socle` avec ce qui a cassé.

## Où trouver quoi

| Question | Réponse |
| --- | --- |
| Comment prendre et livrer une story ? | `ORGANISATION.md` § 8, ou `prompts/dev-story.md` |
| Le « quoi » du projet (fonctionnalités, données, écrans) ? | `conception/`, jamais lu en entier — `dart run tools/ctx.dart <ID>` |
| La maquette Figma ? | `conception/15-maquette.md` |
| Une règle d'architecture ? | `docs/ARCHITECTURE-SPINE.md` (règles `AD-n`) et `docs/conventions/` |
| L'état d'avancement, pour un compte rendu ? | `dart run tools/report.dart` → `docs/sprint/reports/<date>.md` (voir la question suivante) |
| Qui tient quelle casquette ? | `docs/team/ROLES.md` |

## Le rapport d'avancement automatique

`dart run tools/report.dart` interroge l'API GitHub (issues et PR fermées, étiquetées par domaine) et écrit un fichier dans `docs/sprint/reports/<date>.md` : délai médian entre la prise d'une story et sa fusion, taux de CI verte, liste des stories fermées par domaine. Ce fichier généré se colle tel quel dans le compte rendu de réunion — il ne se rédige jamais à la main. Le dernier en date : [`docs/sprint/reports/`](docs/sprint/reports/).

## Licences et données

Contenu sous licences documentées par source (`content/medias.yaml`, `content/sources/`) ; fond de carte OpenStreetMap (ODbL) et Protomaps, attribution visible en permanence dans l'app. Aucun secret, aucune clé, aucun média n'est versionné dans ce dépôt.
