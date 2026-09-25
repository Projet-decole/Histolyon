// Test de composition root : l'app démarre sur la coquille à trois onglets.
// N'appelle pas `demarrer()` (Supabase.initialize nécessite un réseau/env
// réels) : on pompe directement HistoLyonApp sous son propre ProviderScope,
// comme le ferait bootstrap.dart après l'initialisation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/app/bootstrap.dart';
import 'package:mobile/core/router/route_names.dart';

void main() {
  testWidgets("l'app démarre sur la Carte avec trois onglets", (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HistoLyonApp()));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(3));
    expect(find.text('Carte — à venir'), findsOneWidget);
  });

  testWidgets("toucher l'onglet Parcours affiche la surface Parcours", (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: HistoLyonApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Parcours'));
    await tester.pumpAndSettle();

    expect(find.text('Parcours — à venir'), findsOneWidget);
  });

  // Écrans plein écran : ouverts par pushNamed pour garder les onglets
  // dessous (bouton retour, geste retour Android).
  testWidgets(
    'la route nommée pin ouvre la fiche au-dessus des onglets, puis retour',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: HistoLyonApp()));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(NavigationBar));
      GoRouter.of(
        context,
      ).pushNamed(RouteNames.pin, pathParameters: {'slug': 'cour-des-voraces'});
      await tester.pumpAndSettle();

      expect(find.text('cour-des-voraces'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
    },
  );

  testWidgets(
    'la route nommée modele3d ouvre la vue 3D au-dessus des onglets',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: HistoLyonApp()));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(NavigationBar));
      GoRouter.of(
        context,
      ).pushNamed(RouteNames.modele3d, pathParameters: {'slug': 'basilique'});
      await tester.pumpAndSettle();

      expect(find.text('basilique'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    },
  );
}
