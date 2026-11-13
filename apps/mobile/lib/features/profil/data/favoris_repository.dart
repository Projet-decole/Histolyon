import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/app_database_provider.dart';
import '../../../core/models/failure.dart';

part 'favoris_repository.g.dart';

/// Type de la cible d'un Favori (colonne `type_de_cible` de schema.drift).
enum TypeCible { pin, parcours }

/// Un Favori du Profil local tel que la feature le lit. Nommé
/// `FavoriProfil` car Drift génère déjà la classe de table `Favori`.
final class FavoriProfil {
  const FavoriProfil({
    required this.id,
    required this.typeDeCible,
    required this.cibleId,
    required this.ajouteLe,
  });

  final String id;
  final TypeCible typeDeCible;
  final String cibleId;
  final DateTime ajouteLe;
}

/// Lit et nettoie les Favoris stockés dans la base Drift locale (I6 : rien
/// ne quitte l'appareil).
class FavorisRepository {
  FavorisRepository(this._db);

  // ignore: unused_field
  final AppDatabase _db;

  /// Favoris du terminal, les plus récents en tête.
  Future<Result<List<FavoriProfil>>> lister() async =>
      throw UnimplementedError();

  /// Supprime le Favori `id`.
  Future<Result<void>> retirer(String id) async => throw UnimplementedError();
}

@riverpod
FavorisRepository favorisRepository(Ref ref) =>
    FavorisRepository(ref.watch(appDatabaseProvider));
