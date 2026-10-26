# AGENTS.md — HistoLyon

App Flutter qui fait explorer Lyon à travers les époques : carte avec un slider d'époques, pins historiques, parcours, vue 3D. Contenu éditorial en YAML, backend Supabase (second semestre). Projet de fin d'études : le MVP est attendu le 07/02/2027.

Ce fichier est **la source unique des instructions pour tout agent IA**. `CLAUDE.md` l'importe ; Cursor et Copilot le lisent directement. Pour une zone précise, lis aussi son `AGENTS.md` local : [apps/mobile](apps/mobile/AGENTS.md), [apps/admin](apps/admin/AGENTS.md), [supabase](supabase/AGENTS.md).

## Ta mission type : réaliser un ticket

On te donne un ticket (issue GitHub), par exemple « réalise le ticket #12 ».

1. **Lis le ticket** en entier, commentaires compris. Il donne l'apport attendu, la capacité visée (`CAP-…`), la zone à modifier, les tests et la condition « terminé quand ».
2. **Charge ton contexte avec `ctx`, et rien d'autre** : `dart run tools/ctx.dart pack CAP-D1.2` donne la fiche, ses écrans, flux, entités et composants. Pour une question précise : `dart run tools/ctx.dart chercher "slider"`, `ctx lire ECR-CARTE-PRINCIPALE`, `ctx refs COMP-PIN`. Ne lis jamais `conception/` (archive gelée) ni tout `produit/`. Lis ensuite le `AGENTS.md` de la zone modifiée.
3. **Crée la branche** `<n°ticket>-<slug-court>` depuis `main` à jour.
4. **Tests d'abord** pour la logique : le premier commit contient les tests décrits par le ticket, rouges ; le code vient ensuite. Les critères de fin (`CF…`) de la capacité sont les tests d'acceptation.
5. **Reste dans la zone du ticket.** Un fichier hors zone (schéma SQL, autre feature, `app/router.dart`…) : arrête-toi et signale-le.
6. **Vérifie** : `dart run melos run analyze`, `dart run melos run test`, `dart run melos run format`. Si tu as touché `supabase/` : `supabase db reset && supabase test db`. Si tu as touché `produit/` : `dart run tools/ctx.dart check`.
7. **Ouvre la PR** avec le modèle (`Closes #12`, déclaration de l'assistance IA). Une autre personne la relit avant la fusion (squash).

**Ticket flou, contradictoire ou trop gros** : n'invente pas. Écris un commentaire avec ta question précise, puis arrête-toi. Une règle métier ou un détail de design inventé est un bug. Si une règle manque ou se contredit dans `produit/`, signale-le : on corrige la fiche d'abord, puis le code.

## Où est quoi

| Chemin | Contenu |
| --- | --- |
| `produit/` | **Le produit, en lecture courante** : capacités, écrans, composants, flux, entités, design, règles d'écriture, décisions. Point d'entrée : `produit/README.md`. |
| `apps/mobile/` | L'app Flutter. `lib/app/` (démarrage, routeur, coquille à 3 onglets), `lib/core/` (partagé), `lib/features/<slug>/` (une feature = `presentation → domain → data`). |
| `apps/admin/` | Back-office web : gabarit vide, second semestre. |
| `packages/design_tokens` | Couleurs, typos, espacements, rayons, ombres. Référence des valeurs visuelles. |
| `packages/api_types` | Types Dart **générés** depuis le schéma SQL. |
| `supabase/` | Base de données : schéma, règles d'accès (RLS), tests SQL. Second semestre pour l'app. |
| `content/` | Contenu éditorial YAML (époques, catégories, sources, pins, parcours). |
| `tools/` | Scripts maison (voir `tools/README.md`). |
| `conception/` | **Archive gelée** de l'ancienne spécification. Ne pas lire, ne pas modifier. |
| `docs/` | Journal des décisions, règles d'architecture, façon de travailler, recettes. Point d'entrée : `docs/README.md`. `docs/archive/` : historique, ne jamais s'en servir. |

## Commandes

- `dart run melos run analyze` : analyse Dart, lint de direction des imports, vérification des tokens. `... run test` : tests de tous les packages. `... run format` : vérifie le formatage (`dart format .` le corrige). `... run gen` : `build_runner` (Riverpod, Drift) après un `@riverpod` ou un `schema.drift`.
- App : depuis `apps/mobile/`, `flutter run --dart-define-from-file=../../env/local.json` (téléphone Android branché en USB, ou `-d chrome`).
- Base locale (seulement si tu touches `supabase/` ou `content/`) : `dart run melos run local` (Supabase, migrations, contenu, pins publiés). Exige Docker.
- `dart run tools/ctx.dart …` : lire et chercher dans `produit/` (`lire`, `pack`, `chercher`, `refs`, `liste`, `chemin`, `check`).
- `dart run tools/seed.dart` charge `content/` en base locale ; `dart run tools/gen_types.dart` régénère `packages/api_types` après une migration.

## Règles

- **Architecture (AD-5, vérifiée par la CI)** : une feature n'importe jamais une autre feature ; `core/` et `packages/` n'importent jamais une feature. Dans une feature : `presentation` → `domain` → `data`. Entre features : `context.goNamed(RouteNames.x)` (onglet) ou `context.pushNamed(RouteNames.x)` (plein écran).
- **Données** : `data/` est la seule couche qui lit les données (contenu embarqué du MVP, Drift, plus tard Supabase). Elle renvoie un `Result<T>` (`core/models/failure.dart`), jamais une exception brute.
- **État** : Riverpod `@riverpod`. `setState` seulement pour l'UI locale éphémère. L'état transverse est dans `core/session` (liste fermée).
- **Cycles de vie** : une colonne `statut` ne se modifie jamais par `UPDATE` ; chaque transition est une RPC SQL qui écrit sa trace (`docs/guides/ecrire-une-migration.md`).
- **Visuel** : aucune couleur ni taille en dur dans une feature. Tout vient de `packages/design_tokens`. Pas de thème sombre.
- **Données personnelles** : jamais d'identité civile, seulement un pseudonyme. Le profil anonyme reste local (Drift). Pas de SDK d'analytics, pas d'identifiant utilisateur dans les logs.
- **Nommage** : identifiants en français sans accent (`pin`, `epoque`, `parcours`, `etape`) ; `snake_case` en SQL et pour les fichiers, `lowerCamelCase` en Dart. Slugs de feature fixes : `carte`, `pins`, `parcours`, `proximite`, `onboarding`, `profil`, `audio`, `immersion`, `communaute`, `partage`.
- **Géo et dates** : positions en `geography(Point, 4326)`, dates en `timestamptz` UTC. Attribution OpenStreetMap/Protomaps toujours visible sur la carte.
- **Langue** : app en français uniquement.
- **Commits** : `type(scope): sujet`, `scope` = slug de feature, `supabase`, `content`, `produit`, `admin` ou `docs`. Le corps cite `#<ticket>`.
- **Multiplateforme** : pas d'API réservée à Android sans équivalent iOS ; sinon un commentaire `// DETTE-IOS: <raison>`.

## Jamais

- Pousser sur `main` : toujours une PR liée à un ticket.
- Un secret ou une URL en dur : la config passe par `--dart-define-from-file=env/<env>.json`. Aucune clé `sb_secret_*` dans une app.
- Éditer à la main un fichier généré : `packages/api_types`, `content/schema/`, `*.g.dart`. En cas de conflit Git, on le régénère.
- Éditer `conception/` (archive gelée) ou réécrire `docs/DECISIONS.md` (il se complète seulement).
- Committer un média de contenu (audio, photo de pin, modèle `.glb`) : ils vivent hors git. Seules les images de référence du design vont dans `produit/` (DEC-10).
- Changer une règle du produit dans le code sans mettre à jour sa fiche dans `produit/` d'abord.
