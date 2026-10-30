// Composition root : thème issu des tokens Figma (AD-10), français seul
// (convention Langue), configuration Supabase vérifiée au démarrage.

import 'package:design_tokens/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/bootstrap.dart';

void main() {
  testWidgets('le thème vient de design_tokens', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HistoLyonApp()));
    await tester.pumpAndSettle();

    final theme = Theme.of(tester.element(find.byType(NavigationBar)));
    expect(theme.colorScheme.primary, TOK_COLOR_PRIMARY);
    expect(theme.scaffoldBackgroundColor, TOK_COLOR_FOND_PRINCIPAL);
    expect(theme.brightness, Brightness.light);
  });

  testWidgets("l'app est en français uniquement", (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HistoLyonApp()));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.supportedLocales, [const Locale('fr')]);
    expect(
      Localizations.localeOf(tester.element(find.byType(NavigationBar))),
      const Locale('fr'),
    );
  });

  group('Supabase optionnel (DEC-04)', () {
    test('sans configuration, Supabase n\'est pas initialisé', () async {
      var appels = 0;
      final actif = await initialiserSupabaseSiConfigure(
        url: '',
        cle: '',
        initialiser: (url, cle) async => appels++,
      );
      expect(actif, isFalse);
      expect(appels, 0);
    });

    test('une configuration partielle est ignorée', () async {
      var appels = 0;
      Future<void> init(String u, String c) async => appels++;
      expect(
        await initialiserSupabaseSiConfigure(
          url: 'http://x',
          cle: '',
          initialiser: init,
        ),
        isFalse,
      );
      expect(appels, 0);
    });

    test('avec configuration complète, Supabase est initialisé', () async {
      String? recu;
      final actif = await initialiserSupabaseSiConfigure(
        url: 'http://x',
        cle: 'y',
        initialiser: (url, cle) async => recu = '$url|$cle',
      );
      expect(actif, isTrue);
      expect(recu, 'http://x|y');
    });
  });
}
