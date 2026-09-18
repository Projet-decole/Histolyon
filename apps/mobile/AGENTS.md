# AGENTS.md — apps/mobile

App Flutter Android (terrain). Racine du dépôt : [../../AGENTS.md](../../AGENTS.md) — commandes workspace, workflow story/PR et interdits globaux valables ici aussi, non répétés ci-dessous.

État réel aujourd'hui : squelette `flutter create` (`lib/main.dart`), aucune couche en place. Les conventions ci-dessous (couches, composition root, Riverpod) sont la convention **cible** à partir de l'Epic 6, pas l'état actuel.

## Commandes

- `flutter run` (depuis `apps/mobile/`) — lance l'app sur un device ou émulateur connecté.
- `flutter test` (ou `melos run test` depuis la racine, qui couvre tout le workspace) — tests de ce package.
- `flutter analyze` — analyse statique de ce seul package (`melos run analyze`, à la racine, couvre tout le workspace plus le lint d'imports).

## Conventions de nommage

- Couches strictes par feature : `presentation → domain → data`, jamais d'inversion (AD-5) ; `domain/` importe `data/`.
- `app/` est l'**unique** composition root : il assemble le routeur (`app/router.dart`), le bootstrap et le `ProviderScope`.
- État : Riverpod avec `@riverpod` (`riverpod_generator`) ; chaque couche expose ses providers, la couche du dessus les lit.
- Navigation : `go_router`, noms et chemins de routes dans `core/router` (assemblage des `GoRoute` fait par `app/`).
- Erreurs : `data` renvoie `Result<T, Failure>` (`Failure` scellé dans `core/models`).
- Dossiers de feature = slugs de la table de conventions (D1…D11) : `carte`, `pins`, `parcours`, `proximite`, `onboarding`, `profil`, `audio`, `immersion`, `communaute`, `partage`.

## Où chercher

- `lib/main.dart` — état réel actuel : squelette `flutter create`, aucune couche encore en place.
- `lib/{app,core,features}` — convention **cible** à partir de l'Epic 6 (`socle-06`), pas l'état actuel du dépôt.

## Jamais

- `setState` au-delà du widget local — passer par un provider Riverpod.
- Attraper une exception Supabase ou Drift dans `presentation` — c'est le rôle de `data`, qui la convertit en `Failure`.
- Voir aussi les interdits transverses du [racine](../../AGENTS.md#jamais) (import d'une feature par une autre, secrets en dur, fichiers générés édités à la main) : ils s'appliquent ici aussi et ne sont pas répétés.
