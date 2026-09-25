# Erreurs

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Erreurs ». AD liée : AD-5 (direction des dépendances `presentation → domain → data` dans une app).

## Convention

La couche `data` ne laisse jamais fuiter une exception brute : elle renvoie un `Result<T, Failure>`, où `Failure` est un type scellé (`sealed class`) défini dans `core/models`. La couche `presentation` n'attrape **jamais** directement une exception Supabase ou Drift — elle ne connaît que `Result`/`Failure`.

## Pourquoi

AD-5 impose que `presentation` ne connaisse que ce que `domain` lui expose, et que `data` soit la seule couche à parler à Supabase/Drift. Si `presentation` devait attraper des exceptions Supabase, elle serait couplée à l'infrastructure d'accès aux données — exactement l'inversion qu'AD-5 interdit (« une UI qui appelle Supabase »). `Result<T, Failure>` fait de l'échec une valeur de retour typée et exhaustive (via `sealed class`), traitable par un `switch` dans `domain`/`presentation` sans `try/catch` sur du code tiers.

## Exemple

```dart
// data/pin_repository.dart
Future<Result<Pin, Failure>> fetchPin(String id) async {
  try {
    final row = await supabase.from('pin').select().eq('id', id).single();
    return Ok(Pin.fromJson(row));
  } on PostgrestException catch (e) {
    return Err(Failure.serveur(e.message));
  } catch (e) {
    // Toute autre exception (désérialisation JSON, timeout, etc.) reste dans `data` :
    // `presentation` ne doit jamais recevoir autre chose qu'un Result<T, Failure>.
    return Err(Failure.inconnue(e.toString()));
  }
}
```

`presentation` ne voit jamais `PostgrestException` : elle reçoit un `Result<Pin, Failure>` et fait un `switch` sur `Failure` (`serveur`, `reseau`, `inconnue`, …) pour choisir l'affichage.
