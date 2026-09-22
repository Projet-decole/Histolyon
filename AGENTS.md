# AGENTS.md — HistoLyon

Point d'entrée pour tout agent humain ou IA qui travaille dans ce dépôt. 
`tools/sync-agents` dérivera `CLAUDE.md`, `.cursor/rules/*` et `.github/copilot-instructions.md` de ce fichier — ne jamais éditer ces fichiers générés à la main. 
Détail par domaine : [apps/mobile/AGENTS.md](apps/mobile/AGENTS.md), [supabase/AGENTS.md](supabase/AGENTS.md).

## Contexte donné aux IA

Ce qui est écrit ici s'applique donc partout, sans action de ta part. **Rien d'autre n'est chargé automatiquement** : `conception/`, `docs/`, une story précise ne sont lus que si le prompt/l'issue les cite par ID (`tools/ctx <ID>`). Une IA qui invente un détail de design ou de règle métier n'a probablement pas reçu le bon pointeur — corrige le prompt ou l'issue, pas seulement la réponse.

## Commandes

- `melos run analyze` — `dart analyze .` puis les lints maison (`tools/check_import_direction.dart` AD-5, `tools/check_tokens.dart` AD-10).
- `melos run test` — tests de chaque package du workspace qui a un dossier `test/`.
- `melos run format` — vérifie le formatage de tout le workspace (ne corrige pas).
- `melos run gen` — génération de code (`build_runner`) pour les packages qui en dépendent.
- Livré par la Story 2.2, indisponible tant qu'elle n'est pas fusionnée : `dart run tools/ctx.dart <ID>` — imprime l'extrait `conception/` correspondant à un ID (ex. `D1.2`, `I6`) ; `dart run tools/ctx.dart --index` régénère `conception/INDEX.md` (AD-15).
- `dart run tools/sync_agents.dart` — régénère `CLAUDE.md`, `.cursor/rules/histolyon.mdc` et `.github/copilot-instructions.md` depuis tous les `AGENTS.md` du dépôt (racine + locaux, découverts par glob) ; à rejouer après toute modification d'un `AGENTS.md`.

## Où chercher

- `apps/mobile/` — app Flutter Android (terrain). Détail : [apps/mobile/AGENTS.md](apps/mobile/AGENTS.md).
- `apps/admin/` — app Flutter Web (back-office), squelette `flutter create` pour l'instant.
- `packages/` — code partagé du workspace Pub (`design_tokens`, `ui_kit`, `api_types` généré, `map_styles`), peuplé au fil des Epics 4/6/7.
- `supabase/` — schéma SQL, RPC de transition, tests pgTAP. Détail : [supabase/AGENTS.md](supabase/AGENTS.md).
- `conception/` — L2, importée telle quelle, jamais lue en entier : adresser par ID via `tools/ctx`.
- `conception/15-maquette.md` — référence Figma (accès au fichier, tokens, icônes, 118 composants, 41 écrans indexés) : à lire en premier pour toute tâche de design/UI/tokens, avant tout appel MCP Figma (`dart run tools/ctx.dart 15-maquette`).
- `docs/` — L1, porte d'entrée après `AGENTS.md` : [`docs/ORGANISATION.md`](docs/ORGANISATION.md) (comment et pourquoi le dépôt est organisé ainsi — à lire en premier), [`docs/BOOTSTRAP.md`](docs/BOOTSTRAP.md) (comment le socle a été construit), [`docs/ARCHITECTURE-SPINE.md`](docs/ARCHITECTURE-SPINE.md) (les 20 règles `AD-n`), [`docs/DECISIONS.md`](docs/DECISIONS.md) (pourquoi chaque règle existe, journal chronologique), `conventions/` et `guides/` (un sujet par fichier), `docs/specs/` et `docs/stories/` (historique du bootstrap, voir `docs/stories/README.md`).
- `tools/` — scripts d'outillage. Existent aujourd'hui : `check_import_direction.dart`, `sync_agents.dart`, `ctx.dart`, `gen_types.dart`, `seed.dart`, `media_push.dart`, `report.dart`, `validate_content.dart`, `check_migration_order.dart`, `check_tokens.dart` (AD-10, compare `packages/design_tokens` à `packages/design_tokens/figma_export.json`). Le reste (`tiles`) arrive épic par épic — ne pas le traiter comme déjà là avant sa story.
- `content/` — contenu éditorial YAML (pins, parcours, époques, catégories) et manifeste de médias, peuplé à partir des Epics 4/5.
- `prompts/` — prompts portables d'équipe (dev-story, review, découpe) et checklist « sans IA ».
- `env/` — fichiers pour `--dart-define-from-file` (`local.json`, `dev.json` committés ; `demo.json` jamais).

## Conventions de nommage

- Un seul langage applicatif : Dart/Flutter pour mobile et back-office (AD-1) — aucune stack non-Dart sans amendement de cette AD.
- Langue des identifiants : français du glossaire, sans accent — `snake_case` en SQL/fichiers, `lowerCamelCase` en Dart (`pin`, `epoque`, `parcours`, `etape`, `profil`, `compte`).
- Identifiants : PK `id uuid` partout, généré côté client ; les entités éditoriales ajoutent un `slug text unique` (clé de seed et d'URL).
- Commits : Conventional Commits `type(scope): sujet`, `scope` = slug de feature ou `supabase`/`content`/`docs` ; le corps cite `#<issue>`.
- Workflow : une story = une issue GitHub = une branche `story/<ID>-<slug>` = une PR (AD-12) ; `main` protégé, trunk-based, PR à jour avec `main` + CI verte + relecture par un autre membre avant fusion, squash merge (AD-13).

## Jamais

- Aucun secret ni URL en dur dans le code — `--dart-define-from-file=env/<env>.json` ; `env/demo.json` n'entre jamais dans le dépôt.
- Éditer à la main un fichier généré (`packages/api_types`, `content/schema/`, `CLAUDE.md`, `.cursor/rules/*`, `.github/copilot-instructions.md`, `conception/INDEX.md`) — un conflit Git dessus se résout en régénérant.
- Éditer `conception/` (L2, importée telle quelle) pour documenter quoi que ce soit — la prose neuve vit dans les `AGENTS.md` et `docs/conventions|guides/`. `docs/DECISIONS.md` se complète, ne se réécrit jamais.
- Committer un média (`content/` ne référence que des chemins Storage) ou `env/demo.json`.
- Pousser directement sur `main` — toujours par PR liée à une issue.
- Une feature qui importe une autre feature, ou un `core/` qui importe une feature (AD-5) — détail par app dans les `AGENTS.md` locaux.
