# AGENTS.md — HistoLyon

App Flutter qui fait explorer Lyon à travers les époques : carte avec un slider d'époques, pins historiques, parcours et un peu de 3D/AR. Le backend est sur Supabase et le contenu éditorial est en YAML.

Ce fichier est **le point d'entrée de tout agent IA**. Il est chargé automatiquement : `CLAUDE.md`, `.cursor/rules/` et `.github/copilot-instructions.md` en sont générés. Pour en savoir plus sur une zone, lis le `AGENTS.md` local : [apps/mobile/AGENTS.md](apps/mobile/AGENTS.md), [apps/admin/AGENTS.md](apps/admin/AGENTS.md) ou [supabase/AGENTS.md](supabase/AGENTS.md).

## Ta mission type : implémenter une issue GitHub

On te donne un numéro d'issue, par exemple « implémente l'issue #12 ». Voici ce qu'il faut faire, dans l'ordre :

1. **Lis l'issue** en entier, commentaires compris (`gh issue view 12 --comments` ou l'outil GitHub disponible). Elle contient tout : l'objectif, ce qu'il faut lire, la zone à modifier, les tests attendus et la condition « terminé quand ».
2. **Lis ce qu'elle cite, et seulement ça.** La doc de conception est dans `conception/`. Ne la lis jamais en entier : passe par l'ID que donne l'issue, par exemple `dart run tools/ctx.dart D1.2` ou `dart run tools/ctx.dart I3`. Lis ensuite le `AGENTS.md` de la zone que tu modifies.
3. **Crée la branche** `<n°issue>-<slug-court>` depuis `main` à jour, par exemple `12-slider-epoques`.
4. **Tests d'abord.** Ton premier commit ne contient que les tests décrits par l'issue, et ils doivent être rouges. Le code vient ensuite, jusqu'à ce qu'ils passent.
5. **Reste dans la zone indiquée par l'issue.** Si tu dois modifier un fichier hors zone (le schéma SQL, une autre feature, `app/router.dart`…), **arrête-toi et signale-le** au lieu de le faire.
6. **Vérifie** : `melos run analyze`, `melos run test` et `melos run format` doivent être verts. Si tu as touché `supabase/`, lance aussi `supabase db reset && supabase test db`.
7. **Ouvre la PR** avec le template (`Closes #12`, déclaration de l'assistance IA). Un autre membre la relit avant la fusion (squash merge).

**Si l'issue est floue, contradictoire ou trop grosse pour une demi-journée**, n'invente pas. Écris un commentaire sur l'issue avec ta question précise, puis arrête-toi. Un détail de design ou une règle métier inventés sont des bugs.

## Où est quoi (état réel)

| Chemin | Contenu |
| --- | --- |
| `apps/mobile/lib/app/` | Composition root : bootstrap, routeur, coquille à 3 onglets (Carte, Parcours, Profil). |
| `apps/mobile/lib/features/<slug>/` | Une feature = `presentation/ → domain/ → data/`. Squelettes existants : `carte`, `parcours`, `profil`, `pins`, `immersion`. |
| `apps/mobile/lib/core/` | Partagé entre features : `router/route_names.dart`, `session/` (état transverse), `db/` (Drift local), `supabase/` (client), `models/failure.dart`, `log/`. |
| `apps/admin/` | Back-office Flutter Web, encore un squelette. |
| `packages/api_types` | Types Dart **générés** depuis le schéma SQL. Ne jamais les éditer à la main. |
| `packages/design_tokens` | Couleurs, typos, espacements, rayons, ombres de la maquette Figma. |
| `supabase/migrations/` | **Schéma complet** : pins, parcours, étapes, médias, modèles 3D, comptes, commentaires, signalements, avec la RLS. |
| `content/` | Contenu éditorial YAML (époques, catégories, sources, pins), chargé par `dart run tools/seed.dart`. |
| `conception/` | Le « quoi » du produit : fonctionnalités D1–D11, données, écrans, invariants I1–I10. Lecture par ID via `tools/ctx.dart`. Maquette Figma : `conception/15-maquette.md`. |
| `docs/guides/` | Recettes : ajouter une feature, écrire une migration ou une RPC, écrire un test de widget. |
| `docs/` (reste) | Pour les humains et le jury : `ARCHITECTURE-SPINE.md` (règles AD-n), `DECISIONS.md` (journal des décisions), `ORGANISATION.md`. `docs/archive/` contient l'historique du bootstrap : ne pas s'en servir comme référence. |

## Commandes

- `melos run analyze` : `dart analyze`, plus le lint de direction des imports et la vérification des tokens.
- `melos run test` : tests de tous les packages. `melos run format` vérifie le formatage (`dart format .` le corrige).
- `melos run gen` : `build_runner` (Riverpod, Drift) après avoir modifié un `@riverpod` ou `schema.drift`.
- `supabase start`, puis `supabase db reset` (rejoue les migrations) et `supabase test db` (pgTAP).
- `dart run tools/seed.dart` : charge `content/` en base locale. `dart run tools/gen_types.dart` : régénère `packages/api_types` après une migration. Les deux demandent `SUPABASE_URL` et `SUPABASE_SERVICE_ROLE_KEY`, à lire dans `supabase status`.
- `dart run tools/ctx.dart <ID>` : extrait de conception (`D1.2`, `I6`, `15-maquette`…).
- `flutter run --dart-define-from-file=env/local.json` (depuis `apps/mobile/`) : lance l'app sur la base locale.
- `dart run tools/sync_agents.dart` : régénère `CLAUDE.md` et les autres fichiers dérivés. À lancer après toute modification d'un `AGENTS.md`.

## Règles (la CI en vérifie une partie)

- **Architecture (AD-5, vérifiée par la CI)** : une feature n'importe jamais une autre feature, et `core/` ou `packages/` n'importent jamais une feature. Dans une feature, les imports vont de `presentation` vers `domain`, puis de `domain` vers `data`. Pour passer d'une feature à l'autre : `context.goNamed(RouteNames.x)`.
- **Données** : `data/` est la seule couche qui parle à Supabase ou Drift. Elle renvoie un `Result<T>` (`Ok`/`Err(Failure)`, dans `core/models/failure.dart`) et n'expose jamais d'exception brute.
- **État** : Riverpod `@riverpod`. `setState` est réservé à l'UI locale éphémère. L'état transverse (époque sélectionnée, parcours actif…) est dans `core/session`, une liste fermée de providers.
- **Cycles de vie** : une colonne `statut` ne se modifie jamais par un `UPDATE` (un trigger le bloque). Chaque transition est une RPC SQL qui écrit sa trace (voir `docs/guides/ecrire-une-migration.md`).
- **Visuel** : aucune couleur ni taille en dur dans une feature. Tout vient de `packages/design_tokens` (identifiants Figma). Pas de thème sombre.
- **Données personnelles** : jamais d'identité civile (I1), seulement un pseudonyme. Le Profil anonyme reste local, dans Drift (I6). Pas de SDK d'analytics. Pas d'identifiant utilisateur dans les logs.
- **Nommage** : identifiants en français du glossaire, sans accent (`pin`, `epoque`, `parcours`, `etape`). `snake_case` en SQL et pour les fichiers, `lowerCamelCase` en Dart. Les slugs de feature sont fixes : `carte`, `pins`, `parcours`, `proximite`, `onboarding`, `profil`, `audio`, `immersion`, `communaute`, `partage`.
- **Géo et dates** : positions en `geography(Point, 4326)`, dates en `timestamptz` UTC. Attribution OpenStreetMap/Protomaps toujours visible sur la carte.
- **Langue** : app en français uniquement.
- **Commits** : `type(scope): sujet`, avec pour `scope` le slug de la feature, `supabase`, `content`, `admin` ou `docs`. Le corps cite `#<issue>`.
- **Code multiplateforme** : pas d'API réservée à Android sans équivalent iOS. Sinon, ajouter un commentaire `// DETTE-IOS: <raison>`.

## Jamais

- Pousser sur `main` : toujours passer par une PR liée à une issue.
- Un secret ou une URL en dur : la config passe par `--dart-define-from-file=env/<env>.json`, et `env/demo.json` ne va jamais dans le dépôt. Aucune clé `sb_secret_*` dans une app.
- Éditer à la main un fichier généré : `packages/api_types`, `content/schema/`, `*.g.dart`, `CLAUDE.md`, `.cursor/rules/*`, `.github/copilot-instructions.md`, `conception/INDEX.md`. En cas de conflit Git sur l'un d'eux, on le régénère.
- Éditer `conception/`, qui est importée telle quelle. `docs/DECISIONS.md` se complète, il ne se réécrit jamais.
- Committer un média (image, audio, `.glb`) : ils vont dans Supabase Storage, et `content/` ne référence que leurs chemins.
