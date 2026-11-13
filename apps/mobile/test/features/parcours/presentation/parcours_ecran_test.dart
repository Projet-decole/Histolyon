import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/models/failure.dart';
import 'package:mobile/features/parcours/domain/catalogue_provider.dart';
import 'package:mobile/features/parcours/presentation/parcours_ecran.dart';

import '../fixtures.dart';

Future<void> _afficher(
  WidgetTester tester,
  Future<Result<List<ParcoursCatalogue>>> Function() catalogue,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [catalogueProvider.overrideWith((ref) => catalogue())],
      child: const MaterialApp(home: ParcoursEcran()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('deux parcours s’affichent avec leur titre et leur durée', (
    tester,
  ) async {
    await _afficher(
      tester,
      () async => Ok([
        parcoursFactice(
          slug: 'canuts',
          titre: 'Lyon insolite des canuts',
          dureeMinutes: 90,
        ),
        parcoursFactice(
          slug: 'vieux-lyon',
          titre: 'Le Vieux Lyon',
          dureeMinutes: 45,
        ),
      ]),
    );

    expect(find.text('Lyon insolite des canuts'), findsOneWidget);
    expect(find.text('Le Vieux Lyon'), findsOneWidget);
    expect(find.text('1 h 30'), findsOneWidget);
    expect(find.text('45 min'), findsOneWidget);
    expect(find.text('2,4 km'), findsNWidgets(2));
    expect(find.text('5 ét.'), findsNWidgets(2));
    expect(find.text('XIXe siècle'), findsNWidgets(2));
  });

  testWidgets('un parcours communautaire porte son marquage', (tester) async {
    await _afficher(
      tester,
      () async => Ok([
        parcoursFactice(slug: 'canuts', titre: 'Lyon insolite des canuts'),
        parcoursFactice(
          slug: 'traboules',
          titre: 'Mes traboules',
          provenance: 'communautaire',
        ),
      ]),
    );

    expect(find.text('Communautaire'), findsOneWidget);
    expect(find.text('Éditorial'), findsOneWidget);
  });

  testWidgets('une liste vide affiche l’état vide', (tester) async {
    await _afficher(tester, () async => const Ok([]));

    expect(find.textContaining('Aucun parcours'), findsOneWidget);
  });

  testWidgets('une erreur affiche un message et « Réessayer » relance', (
    tester,
  ) async {
    var appels = 0;
    await _afficher(tester, () async {
      appels++;
      return appels == 1
          ? const Err(ReseauFailure())
          : Ok([parcoursFactice(slug: 'canuts', titre: 'Les canuts')]);
    });

    expect(find.textContaining('n’a pas pu être chargé'), findsOneWidget);

    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(appels, 2);
    expect(find.text('Les canuts'), findsOneWidget);
    expect(find.textContaining('n’a pas pu être chargé'), findsNothing);
  });

  testWidgets('chaque carte a son bouton « Découvrir »', (tester) async {
    await _afficher(
      tester,
      () async => Ok([
        parcoursFactice(slug: 'canuts', titre: 'Les canuts'),
        parcoursFactice(slug: 'vieux-lyon', titre: 'Le Vieux Lyon'),
      ]),
    );

    expect(find.text('Découvrir'), findsNWidgets(2));
    await tester.tap(find.text('Découvrir').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('sans durée ni distance, la carte affiche le reste', (
    tester,
  ) async {
    await _afficher(
      tester,
      () async => Ok([
        parcoursFactice(
          slug: 'court',
          titre: 'Court',
          dureeMinutes: null,
          distanceMetres: null,
          etapes: 2,
        ),
      ]),
    );

    expect(find.text('Court'), findsOneWidget);
    expect(find.text('2 ét.'), findsOneWidget);
    expect(find.textContaining('km'), findsNothing);
    expect(find.textContaining('min'), findsNothing);
  });

  testWidgets('pendant le chargement, un indicateur s’affiche', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogueProvider.overrideWith(
            (ref) => Future.delayed(
              const Duration(seconds: 1),
              () => const Ok(<ParcoursCatalogue>[]),
            ),
          ),
        ],
        child: const MaterialApp(home: ParcoursEcran()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('petit écran et texte à 200 % : aucun débordement', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogueProvider.overrideWith(
            (ref) async => Ok([
              parcoursFactice(
                slug: 'long',
                titre: 'Un parcours au titre particulièrement long',
              ),
            ]),
          ),
        ],
        child: const MediaQuery(
          data: MediaQueryData(
            size: Size(320, 640),
            textScaler: TextScaler.linear(2),
          ),
          child: MaterialApp(home: ParcoursEcran()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
