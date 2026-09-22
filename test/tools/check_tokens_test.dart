import 'package:test/test.dart';

import '../../tools/check_tokens.dart';

void main() {
  group('parseCouleurs', () {
    test('extrait id et hex ARGB', () {
      expect(
        parseCouleurs(
          "const Color TOK_COLOR_PRIMARY = Color(0xFFB85220);\n"
          "const Color TOK_COLOR_OVERLAY_SOMBRE = Color(0xA61C1108);\n",
        ),
        {
          'TOK_COLOR_PRIMARY': 'FFB85220',
          'TOK_COLOR_OVERLAY_SOMBRE': 'A61C1108',
        },
      );
    });
  });

  group('parseNombres', () {
    test('extrait id et valeur double, y compris entiers', () {
      expect(
        parseNombres(
          'const double TOK_SPACE_XS = 4;\nconst double TOK_RADIUS_PILL = 9999;\n',
        ),
        {'TOK_SPACE_XS': 4.0, 'TOK_RADIUS_PILL': 9999.0},
      );
    });
  });

  group('parseTypographie', () {
    test('extrait tous les champs d\'un TextStyle', () {
      final source = '''
const TextStyle TOK_TYPO_DISPLAY_XL = TextStyle(
  fontFamily: 'Playfair Display',
  fontWeight: FontWeight.w800,
  fontSize: 32,
  height: 1.2,
);
''';
      expect(parseTypographie(source), {
        'TOK_TYPO_DISPLAY_XL': {
          'fontFamily': 'Playfair Display',
          'fontWeight': 800,
          'fontSize': 32.0,
          'height': 1.2,
        },
      });
    });
  });

  group('parseOmbres', () {
    test('extrait couleur, offset et blurRadius', () {
      final source = '''
const BoxShadow TOK_SHADOW_SM = BoxShadow(
  color: Color(0x1F1C1108),
  offset: Offset(0, 1),
  blurRadius: 3,
);
''';
      expect(parseOmbres(source), {
        'TOK_SHADOW_SM': {
          'colorArgb': '1F1C1108',
          'offsetX': 0.0,
          'offsetY': 1.0,
          'blurRadius': 3.0,
        },
      });
    });
  });

  group('valeursEgales', () {
    test('nombres int vs double équivalents -> égaux', () {
      expect(valeursEgales(4, 4.0), isTrue);
    });

    test('maps profondément différentes -> inégales', () {
      expect(valeursEgales({'a': 1, 'b': 2}, {'a': 1, 'b': 3}), isFalse);
    });
  });

  group('comparerCategorie', () {
    test('rien à signaler quand attendu == réel', () {
      expect(
        comparerCategorie(
          categorie: 'colors',
          attendu: {'TOK_COLOR_PRIMARY': 'FFB85220'},
          reel: {'TOK_COLOR_PRIMARY': 'FFB85220'},
        ),
        isEmpty,
      );
    });

    test('id absent du package -> divergence (alias ou oubli)', () {
      final divergences = comparerCategorie(
        categorie: 'colors',
        attendu: {
          'TOK_COLOR_PRIMARY': 'FFB85220',
          'TOK_COLOR_PIN_EDITORIAL': 'FFB85220',
        },
        reel: {'TOK_COLOR_PRIMARY': 'FFB85220'},
      );
      expect(divergences, hasLength(1));
      expect(divergences.single.message, contains('TOK_COLOR_PIN_EDITORIAL'));
    });

    test(
      'id présent dans le package mais absent de l\'export -> divergence',
      () {
        final divergences = comparerCategorie(
          categorie: 'colors',
          attendu: {'TOK_COLOR_PRIMARY': 'FFB85220'},
          reel: {
            'TOK_COLOR_PRIMARY': 'FFB85220',
            'TOK_COLOR_INVENTE': 'FF000000',
          },
        );
        expect(divergences, hasLength(1));
        expect(divergences.single.message, contains('TOK_COLOR_INVENTE'));
      },
    );

    test('valeur divergente -> signalée avec attendu et réel', () {
      final divergences = comparerCategorie(
        categorie: 'colors',
        attendu: {'TOK_COLOR_PRIMARY': 'FFB85220'},
        reel: {'TOK_COLOR_PRIMARY': 'FF000000'},
      );
      expect(divergences, hasLength(1));
      expect(divergences.single.message, contains('valeur divergente'));
    });
  });
}
