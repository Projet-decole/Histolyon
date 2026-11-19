import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/models/failure.dart';

import 'package:mobile/features/parcours/data/parcours_repository.dart';

import '../fixtures.dart';

void main() {
  test(
    'une ligne Supabase donne le parcours, ses époques triées et ses étapes',
    () {
      final p = ParcoursCatalogue.depuisLigne(
        ligneParcours(
          slug: 'canuts',
          titre: 'Lyon insolite des canuts',
          provenance: 'communautaire',
          etapes: 3,
          epoques: [
            ('xxe-siecle', 'XXe siècle', 9),
            ('xixe-siecle', 'XIXe siècle', 7),
          ],
        ),
      );

      expect(p.parcours.titre, 'Lyon insolite des canuts');
      expect(p.estCommunautaire, isTrue);
      expect(p.nombreEtapes, 3);
      expect(p.epoques.map((e) => e.libelle), ['XIXe siècle', 'XXe siècle']);
    },
  );

  test('sans étape ni époque : zéro étape, aucune époque', () {
    final ligne = ligneParcours(slug: 'vide', titre: 'Vide', epoques: [])
      ..['etape'] = <Map<String, dynamic>>[];

    final p = ParcoursCatalogue.depuisLigne(ligne);

    expect(p.nombreEtapes, 0);
    expect(p.epoques, isEmpty);
    expect(p.estCommunautaire, isFalse);
  });

  test(
    'sans Supabase configuré, catalogue() renvoie un Err, sans exception',
    () async {
      final repository = ParcoursRepository(
        () => throw StateError('Supabase non initialisé'),
      );

      expect(await repository.catalogue(), isA<Err<List<ParcoursCatalogue>>>());
    },
  );
}
