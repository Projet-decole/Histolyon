import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/app_database_provider.dart';
import '../../../core/log/app_logger.dart';
import '../../../core/models/failure.dart';

part 'favoris_repository.g.dart';

const _log = AppLogger('profil');

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

  final AppDatabase _db;

  /// Favoris du terminal, les plus récents en tête. `ajoute_le` est stocké à
  /// la seconde : à date égale, le dernier inséré (rowid) passe devant.
  Future<Result<List<FavoriProfil>>> lister() async {
    try {
      final requete = _db.select(_db.favori)
        ..orderBy([
          (f) => OrderingTerm.desc(f.ajouteLe),
          (f) => OrderingTerm.desc(f.rowId),
        ]);
      final lignes = await requete.get();
      return Ok([for (final l in lignes) _adapter(l)]);
    } catch (e, pile) {
      return _echec('lecture des favoris', e, pile);
    }
  }

  /// Supprime le Favori `id`. Un id inconnu n'est pas une erreur : le
  /// Favori est déjà absent.
  Future<Result<void>> retirer(String id) async {
    try {
      await (_db.delete(_db.favori)..where((f) => f.id.equals(id))).go();
      return const Ok(null);
    } catch (e, pile) {
      return _echec('retrait d\'un favori', e, pile);
    }
  }

  FavoriProfil _adapter(FavoriData l) => FavoriProfil(
    id: l.id,
    typeDeCible: TypeCible.values.byName(l.typeDeCible),
    cibleId: l.cibleId,
    ajouteLe: l.ajouteLe,
  );

  Result<T> _echec<T>(String operation, Object e, StackTrace pile) {
    _log.erreur(operation, e, pile);
    return const Err(InconnueFailure('Favoris indisponibles'));
  }
}

@riverpod
FavorisRepository favorisRepository(Ref ref) =>
    FavorisRepository(ref.watch(appDatabaseProvider));
