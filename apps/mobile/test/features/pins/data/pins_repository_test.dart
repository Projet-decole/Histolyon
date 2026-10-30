import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/contenu/chargeur_contenu.dart';
import 'package:mobile/core/models/failure.dart';
import 'package:mobile/features/pins/data/pins_repository.dart';

class _ChargeurFactice implements ChargeurContenu {
  _ChargeurFactice(this._contenu);
  final ContenuEmbarque? _contenu;

  @override
  Future<ContenuEmbarque> charger() async {
    final c = _contenu;
    if (c == null) throw const ContenuIndisponible('illisible');
    return c;
  }
}

PinContenu _pin(
  String slug, {
  String categorie = 'anecdote',
  List<String> epoques = const ['a_epoque'],
  List<String> sources = const ['source-fictive'],
  PointContenu? lieu = const PointContenu(lat: 45.76, lon: 4.83),
}) => PinContenu(
  id: slug,
  slug: slug,
  titre: 'Titre $slug',
  categorie: categorie,
  epoques: epoques,
  sources: sources,
  localisation: lieu,
  teaser: 'teaser',
  narration: 'narration',
  postNarratif: const [],
);

ContenuEmbarque _contenu() => ContenuEmbarque(
  epoques: const [
    EpoqueContenu(
      id: 'e1',
      slug: 'a_epoque',
      libelle: 'Première',
      borneDebut: 0,
      borneFin: 1000,
      ordre: 1,
    ),
  ],
  categories: const [
    CategorieContenu(id: 'c1', slug: 'anecdote', libelle: 'Anecdote', ordre: 1),
  ],
  sources: const [
    SourceContenu(
      id: 's1',
      slug: 'source-fictive',
      type: 'page_web',
      reference: 'Source fictive',
      credit: 'Crédit',
    ),
  ],
  pins: [
    _pin('pin-a'),
    _pin('pin-b', epoques: ['b_epoque']),
    _pin('pin-sans-lieu', lieu: null),
    _pin('pin-categorie-inconnue', categorie: 'inconnue'),
  ],
);

void main() {
  test('pinsParEpoque ne renvoie que les pins de l\'époque', () async {
    final repo = PinsRepository(_ChargeurFactice(_contenu()));
    final res = await repo.pinsParEpoque('a_epoque');

    expect(res, isA<Ok<List<Pin>>>());
    final slugs = (res as Ok<List<Pin>>).value.map((p) => p.slug);
    expect(slugs, containsAll(['pin-a', 'pin-sans-lieu']));
    expect(slugs, isNot(contains('pin-b')));
  });

  test('pinsParEpoque écarte un pin à catégorie inconnue (R1)', () async {
    final repo = PinsRepository(_ChargeurFactice(_contenu()));
    final res = await repo.pinsParEpoque('a_epoque') as Ok<List<Pin>>;
    expect(
      res.value.map((p) => p.slug),
      isNot(contains('pin-categorie-inconnue')),
    );
  });

  test(
    'un pin porte le libellé de sa catégorie, ses sources et son lieu',
    () async {
      final repo = PinsRepository(_ChargeurFactice(_contenu()));
      final res = await repo.pinParSlug('pin-a') as Ok<Pin>;
      expect(res.value.categorie, 'Anecdote');
      expect(res.value.sources.single.credit, 'Crédit');
      expect(res.value.localisation?.lat, 45.76);
    },
  );

  test('pinParSlug inconnu -> Err(ValidationFailure)', () async {
    final repo = PinsRepository(_ChargeurFactice(_contenu()));
    final res = await repo.pinParSlug('nope');
    expect(res, isA<Err<Pin>>());
    expect((res as Err<Pin>).failure, isA<ValidationFailure>());
  });

  test('contenu illisible -> Err, jamais d\'exception brute', () async {
    final repo = PinsRepository(_ChargeurFactice(null));
    final res = await repo.pinsParEpoque('a_epoque');
    expect(res, isA<Err<List<Pin>>>());
    expect((res as Err<List<Pin>>).failure, isA<InconnueFailure>());
  });
}
