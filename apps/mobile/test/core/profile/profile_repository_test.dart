import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/db/app_database.dart';
import 'package:mobile/core/db/app_database_provider.dart';
import 'package:mobile/core/models/failure.dart';
import 'package:mobile/core/profile/profile_repository.dart';

ProfilData _profil(Result<ProfilData> resultat) => switch (resultat) {
  Ok(:final value) => value,
  Err(:final failure) => fail('Err inattendu : $failure'),
};

void main() {
  late AppDatabase db;
  late ProfileRepository repository;

  setUp(() {
    db = AppDatabase.pour(NativeDatabase.memory());
    repository = ProfileRepository(db);
  });

  tearDown(() => db.close());

  test('crée un Profil local au premier lancement', () async {
    final profil = _profil(await repository.assurerProfilLocal());

    expect(profil.id, isNotEmpty);
    expect(profil.creeLe.isUtc, isTrue);
    expect(await db.select(db.profil).get(), hasLength(1));
  });

  test("un second lancement ne crée pas de second Profil", () async {
    final premier = _profil(await repository.assurerProfilLocal());
    final second = _profil(await repository.assurerProfilLocal());

    expect(second.id, premier.id);
    expect(await db.select(db.profil).get(), hasLength(1));
  });

  test("deux appels concurrents (ex. deux widgets au démarrage) ne créent qu'un seul Profil", () async {
    final resultats = await Future.wait([
      repository.assurerProfilLocal(),
      repository.assurerProfilLocal(),
    ]);

    expect(_profil(resultats[0]).id, _profil(resultats[1]).id);
    expect(await db.select(db.profil).get(), hasLength(1));
  });

  test('plusieurs Profils en base (état anormal) : pas de plantage', () async {
    for (final id in ['a', 'b']) {
      await db
          .into(db.profil)
          .insert(ProfilCompanion.insert(id: id, creeLe: DateTime.utc(2026)));
    }

    expect(await repository.assurerProfilLocal(), isA<Ok<ProfilData>>());
  });

  test(
    "une erreur de base devient un Err, jamais une exception brute",
    () async {
      await db.close();

      expect(await repository.assurerProfilLocal(), isA<Err<ProfilData>>());
    },
  );

  test('profilLocalProvider expose le Profil local', () async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final resultat = await container.read(profilLocalProvider.future);

    expect(_profil(resultat).id, isNotEmpty);
  });
}
