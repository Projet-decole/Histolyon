import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Base Drift unique du terminal (AD-4). Un seul fichier SQLite nommé
/// `histolyon` sur le système de fichiers de l'appareil.
@DriftDatabase(include: {'schema.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_ouvrirConnexion());

  AppDatabase.pour(super.connexion);

  @override
  int get schemaVersion => 1;

  /// SQLite n'applique les clés étrangères (et donc les `ON DELETE CASCADE`
  /// de schema.drift) que si on le lui demande, à chaque ouverture.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _ouvrirConnexion() {
    return driftDatabase(
      name: 'histolyon',
      // Cible web (développement dans le navigateur depuis le devcontainer) :
      // fichiers servis depuis web/, versions alignées sur pubspec.lock
      // (sqlite3 3.6.0, drift 2.35.0).
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
