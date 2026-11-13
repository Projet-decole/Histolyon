import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/models/failure.dart';
import 'package:mobile/features/profil/data/favoris_repository.dart';
import 'package:mobile/features/profil/presentation/profil_ecran.dart';

/// Repository en mémoire : isole l'écran de Drift.
class _RepositoryFactice implements FavorisRepository {
  _RepositoryFactice(this.favoris);

  final List<FavoriProfil> favoris;

  @override
  Future<Result<List<FavoriProfil>>> lister() async => Ok([...favoris]);

  @override
  Future<Result<void>> retirer(String id) async {
    favoris.removeWhere((f) => f.id == id);
    return const Ok(null);
  }
}

class _RepositoryEnPanne implements FavorisRepository {
  @override
  Future<Result<List<FavoriProfil>>> lister() async =>
      const Err(InconnueFailure('base illisible'));

  @override
  Future<Result<void>> retirer(String id) async =>
      const Err(InconnueFailure('base illisible'));
}

List<FavoriProfil> _deuxFavoris() => [
  FavoriProfil(
    id: 'f-recent',
    typeDeCible: TypeCible.parcours,
    cibleId: 'parcours-canuts',
    ajouteLe: DateTime(2026, 11, 10),
  ),
  FavoriProfil(
    id: 'f-ancien',
    typeDeCible: TypeCible.pin,
    cibleId: 'cour-des-voraces',
    ajouteLe: DateTime(2026, 11, 1),
  ),
];

Future<void> _afficher(WidgetTester tester, FavorisRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [favorisRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: ProfilEcran()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('liste les favoris avec leur type et leur date d’ajout', (
    tester,
  ) async {
    await _afficher(tester, _RepositoryFactice(_deuxFavoris()));

    expect(find.text('2 favoris · les plus récents en tête'), findsOneWidget);
    expect(find.textContaining('parcours-canuts'), findsOneWidget);
    expect(find.textContaining('cour-des-voraces'), findsOneWidget);
    expect(find.text('Parcours'), findsOneWidget);
    expect(find.text('Pin'), findsOneWidget);
    expect(find.textContaining('10/11/2026'), findsOneWidget);

    // Les plus récents en tête.
    final yRecent = tester
        .getTopLeft(find.textContaining('parcours-canuts'))
        .dy;
    final yAncien = tester
        .getTopLeft(find.textContaining('cour-des-voraces'))
        .dy;
    expect(yRecent, lessThan(yAncien));
  });

  testWidgets('sans favori, un état vide invite à explorer la carte', (
    tester,
  ) async {
    await _afficher(tester, _RepositoryFactice([]));

    expect(find.textContaining('Aucun favori pour l’instant'), findsOneWidget);
    expect(find.text('Explorer la carte'), findsOneWidget);
  });

  testWidgets('toucher « retirer » supprime le favori de la liste', (
    tester,
  ) async {
    final repo = _RepositoryFactice(_deuxFavoris());
    await _afficher(tester, repo);

    await tester.tap(find.byTooltip('Retirer des favoris').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('parcours-canuts'), findsNothing);
    expect(find.textContaining('cour-des-voraces'), findsOneWidget);
    expect(find.text('1 favori · les plus récents en tête'), findsOneWidget);
    expect(repo.favoris.map((f) => f.id), ['f-ancien']);
  });

  testWidgets(
    'glisser un favori le retire ; le dernier retiré mène à l’état vide',
    (tester) async {
      final repo = _RepositoryFactice([_deuxFavoris().last]);
      await _afficher(tester, repo);

      await tester.drag(
        find.textContaining('cour-des-voraces'),
        const Offset(-600, 0),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('cour-des-voraces'), findsNothing);
      expect(find.text('Explorer la carte'), findsOneWidget);
      expect(repo.favoris, isEmpty);
    },
  );

  testWidgets('une lecture en échec affiche un message, sans planter', (
    tester,
  ) async {
    await _afficher(tester, _RepositoryEnPanne());

    expect(find.textContaining('n’ont pas pu être lus'), findsOneWidget);
  });
}
