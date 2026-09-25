// Story 9.5 : parcours démo nightly — vide au début (aucun scénario réel
// n'existe encore), mais doit s'exécuter et se terminer sans erreur sur un
// vrai appareil/émulateur, contrairement à test/widget_test.dart qui
// tourne dans le harnais de test Flutter.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile/app/bootstrap.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("l'app démarre sur la coquille à trois onglets", (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HistoLyonApp()));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
