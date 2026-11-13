import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/db/app_database.dart';
import 'package:mobile/core/models/failure.dart';
import 'package:mobile/features/profil/data/favoris_repository.dart';

List<FavoriProfil> _liste(Result<List<FavoriProfil>> resultat) =>
    switch (resultat) {
      Ok(:final value) => value,
      Err(:final failure) => fail('Err inattendu : $failure'),
    };

void main() {
  late AppDatabase db;
  late FavorisRepository repository;

  setUp(() async {
    db = AppDatabase.pour(NativeDatabase.memory());
    repository = FavorisRepository(db);
    await db
        .into(db.profil)
        .insert(ProfilCompanion.insert(id: 'p1', creeLe: DateTime.utc(2026)));
    // Inséré en premier mais plus ancien : l'ordre doit venir de ajoute_le.
    await db
        .into(db.favori)
        .insert(
          FavoriCompanion.insert(
            id: 'f-ancien',
            profilId: 'p1',
            typeDeCible: 'pin',
            cibleId: 'pin-1',
            ajouteLe: DateTime.utc(2026, 11, 1),
          ),
        );
    await db
        .into(db.favori)
        .insert(
          FavoriCompanion.insert(
            id: 'f-recent',
            profilId: 'p1',
            typeDeCible: 'parcours',
            cibleId: 'parcours-1',
            ajouteLe: DateTime.utc(2026, 11, 10),
          ),
        );
  });

  tearDown(() => db.close());

  test('lister renvoie les favoris, les plus récents en tête', () async {
    final favoris = _liste(await repository.lister());

    expect(favoris.map((f) => f.id), ['f-recent', 'f-ancien']);
    expect(favoris.first.typeDeCible, TypeCible.parcours);
    expect(favoris.first.cibleId, 'parcours-1');
    expect(favoris.last.typeDeCible, TypeCible.pin);
    expect(
      favoris.first.ajouteLe.isAtSameMomentAs(DateTime.utc(2026, 11, 10)),
      isTrue,
    );
  });

  test('retirer supprime le favori, les autres restent', () async {
    expect(await repository.retirer('f-recent'), isA<Ok<void>>());

    final favoris = _liste(await repository.lister());
    expect(favoris.map((f) => f.id), ['f-ancien']);
  });

  test('aucun favori : liste vide', () async {
    await db.delete(db.favori).go();

    expect(_liste(await repository.lister()), isEmpty);
  });

  test('une erreur de base devient un Err, jamais une exception', () async {
    await db.customStatement('DROP TABLE favori');

    expect(await repository.lister(), isA<Err<List<FavoriProfil>>>());
    expect(await repository.retirer('f-recent'), isA<Err<void>>());
  });
}
