# HistoLyon

Application mobile qui fait explorer Lyon à travers les époques : une carte avec un slider d'époques, des pins historiques sourcés, des parcours et une vue 3D. Projet de fin d'études (Epitech), en Flutter. Le contenu éditorial est en YAML.

**Où on en est.** Le MVP attendu le 07/02/2027 se construit : une carte avec slider d'époques, un parcours de 7 à 10 pins, dont un en 3D. Aujourd'hui l'app affiche cinq écrans provisoires ; la carte, les pins et le parcours arrivent jalon par jalon (follow-up 2 le 13/11, follow-up 3 le 18/12, gel le 21/01). Détail dans [`produit/FEUILLE-DE-ROUTE.md`](produit/FEUILLE-DE-ROUTE.md).

## Voir l'app

Il faut [Flutter 3.47.4](https://docs.flutter.dev/get-started/install) (la version exacte est dans `.fvmrc` ; avec [fvm](https://fvm.app/), `fvm install`). Pas besoin de Docker pour cela. Vérifie ton installation avec `flutter doctor`.

```bash
flutter pub get                       # une fois, à la racine
cd apps/mobile
flutter run --dart-define-from-file=../../env/local.json
```

- **Sur un téléphone Android** : branche-le en USB, active les *Options pour les développeurs* puis le *Débogage USB*. `flutter run` détecte le téléphone. Dans le terminal, `r` recharge l'app après une modification (rechargement à chaud).
- **Dans Chrome**, sans téléphone : ajoute `-d chrome`.
- Le fichier `env/local.json` contient seulement l'adresse de la base locale et une clé de démonstration. Tant qu'aucun écran ne lit la base, rien n'a besoin d'être démarré.

*D'après le code, l'app démarre sans base de données. Si ce n'est pas le cas chez toi, dis-le dans un ticket avec le message d'erreur : c'est une contribution utile.*

## Comprendre le dépôt

| Dossier | Ce que c'est |
| --- | --- |
| [`produit/`](produit/README.md) | **Le produit, en lecture courante** : ce qu'on construit (capacités, écrans, composants, flux, données), le design, les règles d'écriture, les décisions |
| `apps/mobile/` | L'app Flutter. `lib/app/` démarre l'app, `lib/core/` est partagé, `lib/features/<nom>/` contient une fonctionnalité (`presentation → domain → data`) |
| `apps/admin/` | Le futur back-office web : gabarit vide, second semestre |
| `packages/design_tokens/` | Couleurs, polices, espacements du design, en Dart |
| `packages/api_types/` | Types Dart générés depuis le schéma SQL (ne pas éditer) |
| `supabase/` | La base de données : schéma, règles d'accès, tests. Solide, mais l'app du MVP ne s'en sert pas (second semestre) |
| `content/` | Le contenu éditorial en YAML : époques, catégories, sources, pins, parcours |
| `tools/` | Les scripts maison, expliqués dans [`tools/README.md`](tools/README.md) |
| [`docs/`](docs/README.md) | Comment on travaille ([`PROCESS.md`](docs/PROCESS.md)), journal des décisions, règles d'architecture, recettes |
| `prompts/` | Textes à donner à un agent IA : écrire un ticket, réaliser un ticket, relire une PR |
| `conception/` | **Archive gelée** de l'ancienne spécification : ne pas la lire, tout est repris dans `produit/` |

À la racine, `AGENTS.md` donne les règles à tout agent IA (`CLAUDE.md` l'importe), et `pubspec.yaml` déclare les packages du dépôt et les raccourcis `melos`.

## Comprendre le produit

Tout ce qu'on construit est décrit dans `produit/`, en petites fiches à identifiant unique, lues avec un outil :

```bash
dart run tools/ctx.dart liste --statut mvp          # ce qui est dans le MVP
dart run tools/ctx.dart pack CAP-D1.2               # tout le contexte du slider d'époques
dart run tools/ctx.dart chercher "couleur d'un pin" # recherche dans les fiches
dart run tools/ctx.dart lire ECR-CARTE-PRINCIPALE   # une fiche
```

Une **capacité** (`CAP-…`) est une fonctionnalité du produit avec ses règles et ses critères de fin ; elle renvoie à ses écrans (`ECR-…`), ses composants (`COMP-…`), ses flux (`FLX-…`) et ses données (`ENT-…`). Les captures de la maquette sont dans `produit/ecrans/img/`.

## Développer une fonctionnalité

1. **Prends un ticket** du jalon en cours (issues GitHub, avec un jalon, une capacité et une charge). Chaque ticket décrit un apport qu'on peut montrer.
2. **Charge son contexte** : `dart run tools/ctx.dart pack CAP-…`, puis ouvre un agent IA dans le dépôt (Claude Code, Cursor, Copilot…) et dis-lui : « Réalise le ticket #N ». Il lit `AGENTS.md` tout seul.
3. **Teste, code, vérifie** : les tests d'abord pour la logique, puis le code. Regarde l'app tourner sur le téléphone.
4. **Ouvre une PR** (`Closes #N`) : une autre personne la relit, puis on fusionne.

**Active les hooks git** (recommandé, car on développe avec des agents IA) : installe [lefthook](https://lefthook.dev) puis `lefthook install`. Au commit, tes fichiers sont formatés et analysés ; au push, seuls les tests du package que tu as touché tournent. Un bug est ainsi repéré avant qu'une autre personne le voie.

Le détail (étiquettes, charge, relecture, rendez-vous, suivi) est dans [`docs/PROCESS.md`](docs/PROCESS.md). Les règles de code sont dans [`AGENTS.md`](AGENTS.md). Les recettes pas à pas sont dans [`docs/guides/`](docs/guides/).

## Sur une machine modeste

Certaines commandes sont lourdes (tests complets, génération de code, Docker). Évite d'en lancer plusieurs à la fois, ferme ce dont tu n'as pas besoin, et teste seulement ce que tu touches :

```bash
cd apps/mobile && flutter analyze && flutter test   # seulement l'app
dart run tools/ctx.dart check                       # seulement produit/
```

L'analyse et les tests complets (`dart run melos run analyze`, `... run test`) tournent aussi en CI sur chaque PR. La liste des commandes et leur poids est dans [`tools/README.md`](tools/README.md).

## Avancé : base de données locale et devcontainer

Seulement si tu touches `supabase/` ou `content/` (Docker requis, au moins 8 Go de mémoire alloués) :

```bash
dart run melos run local   # Supabase local : schéma, contenu chargé et publié
```

Un **devcontainer** (`.devcontainer/`, VS Code + Docker) fournit tous les outils aux bonnes versions : option pour une machine qui n'a pas Flutter, mais plus lourde que l'installation directe.

## Licences et données

Chaque média a sa licence et son crédit (`content/medias.yaml`) ; chaque source cite son auteur et, pour un texte réutilisé, sa licence (`content/sources/`). Le fond de carte OpenStreetMap (ODbL) et Protomaps impose une attribution visible en permanence. Les icônes viennent de Lucide (licence ISC), sauf deux dessinées pour le projet. Aucun secret, aucune clé et aucun média de contenu n'est versionné dans ce dépôt.
