# AGENTS.md — apps/mobile

App Flutter (Android, avec du code partagé prêt pour iOS). Les règles globales sont dans le `AGENTS.md` racine.

## Structure réelle

```
lib/
  main.dart                 → app/bootstrap.dart (Supabase.initialize + ProviderScope)
  app/router.dart           assemble les routes exportées par chaque feature (seul endroit qui importe des features)
  app/coquille.dart         NavigationBar : Carte / Parcours / Profil
  core/router/route_names.dart   noms et chemins de toutes les routes
  core/session/             état transverse, liste FERMÉE : epoqueSelectionnee, parcoursActif, etapeCourante, pinCourant, modePresentation, lectureAudio
  core/supabase/            supabaseClientProvider (lu uniquement par les couches data/)
  core/db/                  base Drift locale (schema.drift : profil, preference, favori, historique_visite) + appDatabaseProvider
  core/models/failure.dart  Result<T> = Ok | Err(Failure)
  core/log/                 logger (jamais print)
  features/<slug>/
    presentation/<slug>_ecran.dart    écran(s)
    presentation/<slug>_routes.dart   List<RouteBase> <slug>Routes, assemblée par app/router.dart
    domain/                           logique + providers exposés à presentation
    data/                             repository : Supabase / Drift → Result<T>
```

Les features en squelette sont `carte`, `parcours` et `profil` (les onglets), plus `pins` (`/pin/:slug`) et `immersion` (`/modele-3d/:slug`), qui s'ouvrent en plein écran au-dessus des onglets.

## Recette : une tranche de feature

1. **data/** : `<slug>_repository.dart` lit `ref.watch(supabaseClientProvider)` ou `appDatabaseProvider`. Chaque méthode publique renvoie `Future<Result<T>>` et attrape les exceptions pour les convertir en `Failure`. Pour les types serveur, utilise `package:api_types`, sans jamais redéfinir une classe `Pin` à la main.
2. **domain/** : des providers `@riverpod` qui appellent le repository et exposent à l'écran ce dont il a besoin.
3. **presentation/** : widgets `ConsumerWidget` qui font `ref.watch` sur les providers de `domain/`. Ils gèrent les états chargement, erreur et vide.
4. **Nouvelle sous-route** : ajoute le nom et le chemin dans `core/router/route_names.dart`, puis la `GoRoute` dans `presentation/<slug>_routes.dart`. Ne touche pas à `app/router.dart`.
5. **Tests** (`test/features/<slug>/…`) : test unitaire du domain avec un repository factice, test de widget de l'écran avec `ProviderScope(overrides: [...])`. Pour Drift en test : `AppDatabase.pour(NativeDatabase.memory())`.
6. `melos run gen` après tout ajout de `@riverpod`, puis `melos run analyze` et `melos run test`.

Guide détaillé : `docs/guides/ajouter-une-feature.md`. Tests de widget : `docs/guides/ecrire-un-test-de-widget.md`.

## Commandes

- `melos run app` (depuis la racine) : app dans le navigateur, sur http://localhost:8080 (lancer `melos run local` avant). Sur un téléphone Android en ADB : `flutter run --dart-define-from-file=../../env/local.json`.
- `flutter test` et `flutter analyze` pour ce seul package.

## Jamais

- `presentation/` qui appelle Supabase ou Drift directement, ou qui attrape une exception Supabase/Drift. C'est le rôle de `data/`.
- Ajouter un 7e provider dans `core/session` : un besoin transverse devient un service dans `core/`.
- Modifier `schema.drift` ou `app/router.dart` sans que l'issue le demande : ce sont des fichiers partagés, donc sources de conflits.
