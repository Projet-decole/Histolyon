# HistoLyon

Application Android (et, sans licence développeur Apple payante, code partagé prêt pour iOS) qui fait explorer Lyon à travers les époques : carte, slider temporel, pins historiques, parcours. Backend Supabase, contenu éditorial en YAML, monorepo Dart/Flutter.

Ce dépôt est encore au stade **bootstrap** : l'outillage, le process et la base sont en place, mais aucune fonctionnalité produit n'est encore visible (l'app démarre sur un écran vide). Le détail de ce qui est fait et de ce qui reste : [`docs/stories/sprint-status.yaml`](docs/stories/sprint-status.yaml), lisible via `dart run tools/report.dart`.

## Trois questions, trois portes

Tout le reste de la documentation répond à l'une de ces trois questions. Commence par celle qui t'intéresse — chacune se lit indépendamment des deux autres.

| Question | Réponse | Temps de lecture |
| --- | --- | --- |
| **Comment est structuré le projet ?** — dossiers, couches, qui importe quoi | [`AGENTS.md`](AGENTS.md) (commandes, où chercher, en une page) puis [`docs/ARCHITECTURE-SPINE.md`](docs/ARCHITECTURE-SPINE.md) (les 20 règles `AD-n`, l'arbre de dossiers de référence) | 5 min + référence |
| **Comment fonctionne l'organisation ?** — pourquoi des stories, des casquettes, ce process | [`docs/ORGANISATION.md`](docs/ORGANISATION.md) — guide d'équipe complet, se lit une fois dans l'ordre | 25 min |
| **Comment je me mets à développer ?** — installer son poste, prendre une story, livrer | § *Démarrer à coder* ci-dessous, puis `docs/ORGANISATION.md` § 8 (« ta première story », pas à pas) | 10 min |

Pour le « pourquoi » de chaque décision (pourquoi Supabase, pourquoi pas de dark mode, pourquoi BMAD puis plus BMAD…) : [`docs/DECISIONS.md`](docs/DECISIONS.md), journal chronologique jamais réécrit. Pour comment le socle lui-même a été construit, étape par étape : [`docs/BOOTSTRAP.md`](docs/BOOTSTRAP.md).

## Démarrer à coder

**Option la plus simple : le devcontainer.** Ouvre le dépôt dans VS Code avec l'extension *Dev Containers*, ou GitHub Codespaces — Flutter, Android SDK, Supabase CLI, melos et lefthook sont préinstallés et à la bonne version. Détail : [`.devcontainer/`](.devcontainer/).

**En natif**, installer d'abord : Flutter 3.47.4 (via [fvm](https://fvm.app/), voir `.fvmrc`), Docker, Supabase CLI 2.117, lefthook 2.1, Android SDK (API 21+, JDK 21) — détail et pourquoi chaque outil : `docs/BOOTSTRAP.md` Annexe A. Puis :

```bash
git clone <url-du-depot> && cd Histolyon
flutter pub get
lefthook install
supabase start
supabase db reset
melos run test
```

Tout doit être vert. Sinon, ouvre une issue `socle` avec ce qui a cassé — c'est déjà une contribution utile.

## Où trouver quoi, au-delà des trois portes

| Besoin | Réponse |
| --- | --- |
| Prendre et livrer une story, pas à pas | `docs/ORGANISATION.md` § 8, ou `prompts/dev-story.md` (à coller dans un assistant IA) |
| Le « quoi » du projet (fonctionnalités, données, écrans, invariants) | `conception/`, jamais lu en entier — `dart run tools/ctx.dart <ID>` (ex. `D1.2`, `I6`) |
| La maquette Figma (accès, tokens, composants, écrans) | `conception/15-maquette.md` |
| Une convention de code (nommage, erreurs, dates, commits…) | `docs/conventions/` — un fichier par sujet |
| Une recette (ajouter une feature, écrire une migration, un test de widget) | `docs/guides/` |
| L'état d'avancement, pour un compte rendu | `dart run tools/report.dart` → `docs/sprint/reports/<date>.md`, collé tel quel, jamais rédigé à la main |
| Qui tient quelle casquette (Pilote, Découpeur, Intégrateur…) | `docs/team/ROLES.md` |
| Le schéma de base, les RPC, les tests SQL | `supabase/` (détail : `supabase/AGENTS.md`) |

## Licences et données

Contenu sous licences documentées par source (`content/medias.yaml`, `content/sources/`) ; fond de carte OpenStreetMap (ODbL) et Protomaps, attribution visible en permanence dans l'app. Aucun secret, aucune clé, aucun média n'est versionné dans ce dépôt.
