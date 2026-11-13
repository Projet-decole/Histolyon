import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/failure.dart';
import '../data/favoris_repository.dart';

export '../data/favoris_repository.dart' show FavoriProfil, TypeCible;

part 'favoris_provider.g.dart';

/// Liste des Favoris du Profil local (D6.2), les plus récents en tête.
@riverpod
class Favoris extends _$Favoris {
  @override
  Future<Result<List<FavoriProfil>>> build() =>
      ref.watch(favorisRepositoryProvider).lister();

  /// Retire le Favori `id`. La liste est mise à jour tout de suite (un
  /// élément glissé doit quitter l'arbre sans attendre la base) ; si la
  /// suppression échoue, elle est relue pour refléter l'état réel.
  Future<Result<void>> retirer(String id) async {
    if (state.value case Ok(:final value)) {
      state = AsyncData(Ok([...value.where((f) => f.id != id)]));
    }
    final resultat = await ref.read(favorisRepositoryProvider).retirer(id);
    if (resultat is Err) ref.invalidateSelf();
    return resultat;
  }
}
