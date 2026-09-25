// Base Drift locale (AD-4) : SQLite applique les clés étrangères, la
// suppression d'un Profil nettoie ses données, les valeurs fermées sont
// contrôlées.

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.pour(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> creerProfil(String id) => db
      .into(db.profil)
      .insert(ProfilCompanion.insert(id: id, creeLe: DateTime.utc(2026)));

  test('une préférence vers un Profil inexistant est refusée', () async {
    await expectLater(
      db
          .into(db.preference)
          .insert(
            PreferenceCompanion.insert(
              profilId: 'inconnu',
              cle: 'k',
              valeur: 'v',
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test('supprimer le Profil supprime ses données locales', () async {
    await creerProfil('p1');
    await db
        .into(db.preference)
        .insert(
          PreferenceCompanion.insert(profilId: 'p1', cle: 'k', valeur: 'v'),
        );
    await db
        .into(db.favori)
        .insert(
          FavoriCompanion.insert(
            id: 'f1',
            profilId: 'p1',
            typeDeCible: 'pin',
            cibleId: 'pin-1',
            ajouteLe: DateTime.utc(2026),
          ),
        );

    await db.delete(db.profil).go();

    expect(await db.select(db.preference).get(), isEmpty);
    expect(await db.select(db.favori).get(), isEmpty);
  });

  test("un type d'événement hors liste est refusé", () async {
    await creerProfil('p1');
    await expectLater(
      db
          .into(db.historiqueVisite)
          .insert(
            HistoriqueVisiteCompanion.insert(
              id: 'h1',
              profilId: 'p1',
              typeEvenement: 'inconnu',
              typeDeCible: 'pin',
              cibleId: 'pin-1',
              horodatage: DateTime.utc(2026),
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test("un type d'événement documenté est accepté", () async {
    await creerProfil('p1');
    await db
        .into(db.historiqueVisite)
        .insert(
          HistoriqueVisiteCompanion.insert(
            id: 'h1',
            profilId: 'p1',
            typeEvenement: 'consultation_pin',
            typeDeCible: 'pin',
            cibleId: 'pin-1',
            horodatage: DateTime.utc(2026),
          ),
        );
    expect(await db.select(db.historiqueVisite).get(), hasLength(1));
  });
}
