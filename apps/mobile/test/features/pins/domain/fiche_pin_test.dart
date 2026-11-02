import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/models/failure.dart';
import 'package:mobile/features/pins/data/pins_repository.dart';
import 'package:mobile/features/pins/domain/fiche_pin.dart';

import '../pins_factices.dart';

ProviderContainer _conteneur(Result<Pin> resultat) {
  final c = ProviderContainer(
    overrides: [
      pinsRepositoryProvider.overrideWithValue(RepositoryFactice(resultat)),
    ],
  );
  addTearDown(c.dispose);
  // Garde les fiches en vie : un provider auto-dispose lu sans écouteur est
  // libéré avant d'avoir répondu.
  c.listen(fichePinProvider('pin-a'), (_, _) {});
  c.listen(fichePinProvider('nope'), (_, _) {});
  return c;
}

void main() {
  test('le repository réussit -> la fiche du pin', () async {
    final c = _conteneur(Ok(pinFactice()));
    final etat = await c.read(fichePinProvider('pin-a').future);

    expect(etat, isA<FicheDisponible>());
    expect((etat as FicheDisponible).pin.titre, 'La Cour des Voraces');
  });

  test('pin introuvable -> fiche retirée (R9)', () async {
    final c = _conteneur(const Err(ValidationFailure('introuvable')));
    final etat = await c.read(fichePinProvider('nope').future);

    expect(etat, isA<FicheRetiree>());
  });

  test('autre échec -> erreur de chargement', () async {
    final c = _conteneur(const Err(InconnueFailure('illisible')));

    await expectLater(
      c.read(fichePinProvider('pin-a').future),
      throwsA(isA<InconnueFailure>()),
    );
  });

  test(
    '« Le saviez-vous » sans son ouverture répétée, citation non affichée',
    () async {
      final c = _conteneur(
        Ok(
          pinFactice(
            postNarratif: const [
              EncartContenu(
                type: 'le_saviez_vous',
                texte:
                    'Le saviez-vous. Lyon compte des centaines de traboules.',
              ),
              EncartContenu(type: 'citation_historique', texte: '« Vivre »'),
            ],
          ),
        ),
      );
      final etat =
          await c.read(fichePinProvider('pin-a').future) as FicheDisponible;

      expect(etat.leSaviezVous, ['Lyon compte des centaines de traboules.']);
    },
  );
}
