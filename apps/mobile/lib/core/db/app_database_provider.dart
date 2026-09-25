import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';

part 'app_database_provider.g.dart';

/// Base Drift unique du terminal, partagée par les couches `data/` des
/// features. En test : `appDatabaseProvider.overrideWithValue(
/// AppDatabase.pour(NativeDatabase.memory()))`.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
