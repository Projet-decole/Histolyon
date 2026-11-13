import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/failure.dart';
import '../data/favoris_repository.dart';

export '../data/favoris_repository.dart' show FavoriProfil, TypeCible;

part 'favoris_provider.g.dart';

/// Liste des Favoris du Profil local (D6.2), les plus récents en tête.
@riverpod
class Favoris extends _$Favoris {
  @override
  Future<Result<List<FavoriProfil>>> build() => throw UnimplementedError();

  /// Retire le Favori `id` et met la liste à jour.
  Future<Result<void>> retirer(String id) => throw UnimplementedError();
}
