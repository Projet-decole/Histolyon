import 'package:uuid/uuid.dart';

import '../db/app_database.dart';

/// Garantit l'existence d'un Profil local sans Compte dès le premier
/// lancement (AD-4, Story 6.3). `id` généré côté client (uuid v4).
class ProfileRepository {
  ProfileRepository(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  /// Le select-puis-insert est englobé dans une transaction Drift : deux
  /// appels concurrents (ex. deux widgets qui attendent le provider de
  /// profil au démarrage) sont sérialisés par la connexion SQLite unique,
  /// donc un seul insère effectivement le Profil local.
  Future<ProfilData> assurerProfilLocal() async {
    return _db.transaction(() async {
      final existant = await _db.select(_db.profil).getSingleOrNull();
      if (existant != null) return existant;

      final nouveauProfil = ProfilCompanion.insert(
        id: _uuid.v4(),
        creeLe: DateTime.now(),
      );
      await _db.into(_db.profil).insert(nouveauProfil);
      return _db.select(_db.profil).getSingle();
    });
  }
}
