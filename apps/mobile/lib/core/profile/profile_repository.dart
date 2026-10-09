import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../db/app_database.dart';
import '../db/app_database_provider.dart';
import '../models/failure.dart';

part 'profile_repository.g.dart';

/// Garantit l'existence d'un Profil local sans Compte dès le premier
/// lancement (AD-4, I6). `id` généré côté client (uuid v4).
class ProfileRepository {
  ProfileRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  /// Le select-puis-insert est englobé dans une transaction Drift : deux
  /// appels concurrents (ex. deux widgets qui attendent le provider de
  /// profil au démarrage) sont sérialisés par la connexion SQLite unique,
  /// donc un seul insère effectivement le Profil local.
  Future<Result<ProfilData>> assurerProfilLocal() async {
    try {
      final profil = await _db.transaction(() async {
        final requete = _db.select(_db.profil)
          ..orderBy([(p) => OrderingTerm.asc(p.creeLe)])
          ..limit(1);
        final existant = await requete.getSingleOrNull();
        if (existant != null) return existant;

        final nouveau = ProfilData(
          id: _uuid.v4(),
          creeLe: DateTime.now().toUtc(),
        );
        await _db.into(_db.profil).insert(nouveau);
        return nouveau;
      });
      return Ok(profil);
    } catch (e) {
      return Err(InconnueFailure('Profil local indisponible : $e'));
    }
  }
}

/// Identifiant du Profil local de l'appareil (créé au premier accès) : la clé
/// `profil_id` des préférences, favoris et historique. Expose l'id plutôt que
/// `ProfilData`, type généré par Drift que riverpod_generator ne peut pas
/// résoudre dans le même build.
@Riverpod(keepAlive: true)
Future<Result<String>> profilLocalId(Ref ref) async {
  final resultat = await ProfileRepository(ref.watch(appDatabaseProvider))
      .assurerProfilLocal();
  return switch (resultat) {
    Ok(:final value) => Ok(value.id),
    Err(:final failure) => Err(failure),
  };
}
