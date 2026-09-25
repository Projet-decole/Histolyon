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

  test('une configuration Supabase absente échoue tôt et clairement', () {
    expect(
      () => verifierConfigSupabase(url: '', cle: 'x'),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('dart-define-from-file'),
        ),
      ),
    );
    expect(
      () => verifierConfigSupabase(url: 'http://x', cle: ''),
      throwsStateError,
    );
    expect(
      () => verifierConfigSupabase(url: 'http://x', cle: 'y'),
      returnsNormally,
    );
  });
}
