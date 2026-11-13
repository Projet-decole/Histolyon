import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/models/failure.dart';
import 'package:mobile/features/profil/data/favoris_repository.dart';
import 'package:mobile/features/profil/domain/favoris_provider.dart';

class _RepositoryFactice implements FavorisRepository {
  _RepositoryFactice(this.favoris, {this.retraitEchoue = false});

  final List<FavoriProfil> favoris;
  final bool retraitEchoue;
  var lectures = 0;

  @override
  Future<Result<List<FavoriProfil>>> lister() async {
    lectures++;
    return Ok([...favoris]);
  }

  @override
  Future<Result<void>> retirer(String id) async {
    if (retraitEchoue) return const Err(InconnueFailure('échec'));
    favoris.removeWhere((f) => f.id == id);
    return const Ok(null);
  }
}

FavoriProfil _favori(String id) => FavoriProfil(
  id: id,
  typeDeCible: TypeCible.pin,
  cibleId: 'cible-$id',
  ajouteLe: DateTime.utc(2026, 11, 1),
);

List<String> _ids(Result<List<FavoriProfil>>? r) => switch (r) {
  Ok(:final value) => [for (final f in value) f.id],
  _ => fail('Ok attendu, reçu $r'),
};

ProviderContainer _container(FavorisRepository repo) {
  final c = ProviderContainer(
    overrides: [favorisRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(c.dispose);
  // Garde le provider (autoDispose) vivant pendant le test.
  c.listen(favorisProvider, (_, _) {});
  return c;
}

void main() {
  test('expose la liste du repository', () async {
    final c = _container(_RepositoryFactice([_favori('a'), _favori('b')]));

    expect(_ids(await c.read(favorisProvider.future)), ['a', 'b']);
  });

  test('retirer enlève le favori de la liste sans relire la base', () async {
    final repo = _RepositoryFactice([_favori('a'), _favori('b')]);
    final c = _container(repo);
    await c.read(favorisProvider.future);

    final resultat = await c.read(favorisProvider.notifier).retirer('a');

    expect(resultat, isA<Ok<void>>());
    expect(_ids(c.read(favorisProvider).value), ['b']);
    expect(repo.lectures, 1);
  });

  test('un retrait en échec renvoie Err et relit la liste réelle', () async {
    final repo = _RepositoryFactice([
      _favori('a'),
      _favori('b'),
    ], retraitEchoue: true);
    final c = _container(repo);
    await c.read(favorisProvider.future);

    final resultat = await c.read(favorisProvider.notifier).retirer('a');

    expect(resultat, isA<Err<void>>());
    expect(_ids(await c.read(favorisProvider.future)), ['a', 'b']);
    expect(repo.lectures, 2);
  });
}
