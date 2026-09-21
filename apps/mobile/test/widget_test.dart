// Test de composition root (Story 6.1) : l'app démarre sur un écran vide.
// N'appelle pas `demarrer()` (Supabase.initialize nécessite un réseau/env
// réels) : on pompe directement HistoLyonApp sous son propre ProviderScope,
// comme le ferait bootstrap.dart après l'initialisation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/bootstrap.dart';

void main() {
  testWidgets('l\'app démarre sur un écran vide', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: HistoLyonApp()));
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
