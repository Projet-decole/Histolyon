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

  testWidgets('une erreur affiche un message, sans planter', (tester) async {
    await _afficher(tester, () async => const Err(ReseauFailure()));

    expect(find.textContaining('n’a pas pu être chargé'), findsOneWidget);
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
}
