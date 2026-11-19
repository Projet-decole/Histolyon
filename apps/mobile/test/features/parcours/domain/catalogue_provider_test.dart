import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/models/failure.dart';
import 'package:mobile/features/parcours/data/parcours_repository.dart';
import 'package:mobile/features/parcours/domain/catalogue_provider.dart';

import '../fixtures.dart';

class _RepositoryFactice implements ParcoursRepository {
  _RepositoryFactice(this.resultat);

  final Result<List<ParcoursCatalogue>> resultat;

  @override
  Future<Result<List<ParcoursCatalogue>>> catalogue() async => resultat;
}

Future<Result<List<ParcoursCatalogue>>> _lire(
  Result<List<ParcoursCatalogue>> depuisRepository,
) {
  final container = ProviderContainer(
    overrides: [
      parcoursRepositoryProvider.overrideWithValue(
        _RepositoryFactice(depuisRepository),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container.read(catalogueProvider.future);
}

void main() {
  test('le catalogue renvoie les parcours du repository', () async {
    final parcours = [
      parcoursFactice(slug: 'canuts', titre: 'Lyon insolite des canuts'),
      parcoursFactice(slug: 'vieux-lyon', titre: 'Le Vieux Lyon'),
    ];

    final resultat = await _lire(Ok(parcours));

    expect(resultat, isA<Ok<List<ParcoursCatalogue>>>());
    expect(
      (resultat as Ok<List<ParcoursCatalogue>>).value.map(
        (p) => p.parcours.slug,
      ),
      ['canuts', 'vieux-lyon'],
    );
  });

  test("le catalogue transmet l'erreur du repository", () async {
    final resultat = await _lire(const Err(ServeurFailure('hors service')));

    expect(resultat, isA<Err<List<ParcoursCatalogue>>>());
    expect(
      (resultat as Err<List<ParcoursCatalogue>>).failure,
      isA<ServeurFailure>(),
    );
  });
}
