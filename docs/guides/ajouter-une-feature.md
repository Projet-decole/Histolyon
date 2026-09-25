# Guide — Implémenter une feature mobile

Ce guide suppose que le dossier de la feature existe déjà. Les squelettes sont posés pour `carte`, `parcours`, `profil`, `pins` et `immersion`. Pour une nouvelle feature (`proximite`, `onboarding`, `audio`, `communaute`, `partage`), voir la section 6.

Exemple de référence : `apps/mobile/lib/features/carte/`.

## 1. data/ : parler à Supabase ou à Drift

```dart
// features/pins/data/pins_repository.dart
import 'package:api_types/generated_classes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/failure.dart';
import '../../../core/supabase/supabase_provider.dart';

part 'pins_repository.g.dart';

class PinsRepository {
  PinsRepository(this._client);
  final SupabaseClient _client;

  Future<Result<List<Pin>>> pinsPublies() async {
    try {
      final rows = await _client.from('pin').select().eq('statut', 'publie');
      return Ok(rows.map(Pin.fromJson).toList());
    } on PostgrestException catch (e) {
      return Err(ServeurFailure(e.message));
    } catch (e) {
      return Err(InconnueFailure(e.toString()));
    }
  }
}

@riverpod
PinsRepository pinsRepository(Ref ref) =>
    PinsRepository(ref.watch(supabaseClientProvider));
```

- Les types serveur viennent de `package:api_types` (générés). On n'écrit jamais de classe miroir à la main.
- Pour les données locales (favoris, historique), on passe par `ref.watch(appDatabaseProvider)`.
- Une écriture qui change un `statut` passe par `_client.rpc('pin_publier', params: {...})`, jamais par `update`.

## 2. domain/ : ce dont l'écran a besoin

Écris des providers `@riverpod` qui appellent le repository et transforment le résultat, par exemple en filtrant les pins par époque sélectionnée (`ref.watch(epoqueSelectionneeProvider)`). C'est ici qu'un `Failure` devient une décision : réessayer, afficher un message ou montrer un état vide.

## 3. presentation/ : l'écran

Des `ConsumerWidget` qui font `ref.watch` sur les providers de `domain/`, sans import de `data/`. Couleurs, typos et espacements viennent de `package:design_tokens`, jamais de valeurs en dur. Textes en français.

## 4. Routes

- Une nouvelle sous-route se déclare dans `core/router/route_names.dart` (nom + chemin), puis la `GoRoute` va dans `presentation/<slug>_routes.dart`.
- Pour aller vers une autre feature, on utilise `context.goNamed(RouteNames.pin, pathParameters: {'slug': s})`, jamais un import de l'autre feature.

## 5. Tests puis vérification

- `test/features/<slug>/domain/…_test.dart` : logique avec un repository factice.
- `test/features/<slug>/presentation/…_test.dart` : écran sous `ProviderScope(overrides: [...])`. Voir `ecrire-un-test-de-widget.md`.
- Ensuite : `melos run gen`, `melos run analyze`, `melos run test`.

## 6. Créer une feature qui n'existe pas encore

1. Copie `features/carte/` sous le nouveau slug (fixé dans `AGENTS.md`, jamais inventé).
2. Ajoute le nom et le chemin de route dans `core/router/route_names.dart`.
3. Branche `<slug>Routes` dans `app/router.dart`, soit dans une branche d'onglet, soit en plein écran. C'est la **seule** modification autorisée dans `app/`, et l'issue doit la mentionner.

La CI (`tools/check_import_direction.dart`) refuse tout import d'une feature vers une autre, et tout import d'une feature depuis `core/`.
