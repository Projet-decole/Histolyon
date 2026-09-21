import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/db/app_database.dart';
import 'package:mobile/core/profile/profile_repository.dart';

void main() {
  late AppDatabase db;
  late ProfileRepository repository;

  setUp(() {
    db = AppDatabase.pour(NativeDatabase.memory());
    repository = ProfileRepository(db);
  });

  tearDown(() => db.close());

  test('crée un Profil local au premier lancement', () async {
    final profil = await repository.assurerProfilLocal();

    expect(profil.id, isNotEmpty);
    expect(await db.select(db.profil).get(), hasLength(1));
  });

  test("un second lancement ne crée pas de second Profil", () async {
    final premier = await repository.assurerProfilLocal();
    final second = await repository.assurerProfilLocal();

    expect(second.id, premier.id);
    expect(await db.select(db.profil).get(), hasLength(1));
  });

  test(
    "deux appels concurrents (ex. deux widgets au démarrage) ne créent qu'un seul Profil",
    () async {
      final resultats = await Future.wait([
        repository.assurerProfilLocal(),
        repository.assurerProfilLocal(),
      ]);

      expect(resultats[0].id, resultats[1].id);
      expect(await db.select(db.profil).get(), hasLength(1));
    },
  );
}
