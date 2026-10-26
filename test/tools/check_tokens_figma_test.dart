import 'dart:io';

import 'package:test/test.dart';

import '../../tools/check_tokens.dart';

void main() {
  group('convertirVariablesFigma', () {
    test('convertit couleurs (ARGB), espacements, rayons et opacités', () {
      final categories = convertirVariablesFigma({
        'TOK-COLOR-PRIMARY': {
          r'$type': 'color',
          r'$value': {'alpha': 1, 'hex': '#B85220'},
        },
        'TOK-COLOR-OVERLAY-SOMBRE': {
          r'$type': 'color',
          r'$value': {'alpha': 0.65, 'hex': '#1C1108'},
        },
        'TOK-SPACE-XS': {r'$type': 'number', r'$value': 4},
        'TOK-RADIUS-PILL': {r'$type': 'number', r'$value': 9999},
        'TOK-OPACITY-BACKDROP-M6': {
          r'$type': 'number',
          r'$value': 0.4000000059604645,
        },
      });

      expect(categories['colors'], {
        'TOK_COLOR_PRIMARY': 'FFB85220',
        'TOK_COLOR_OVERLAY_SOMBRE': 'A61C1108',
      });
      expect(categories['spacing'], {'TOK_SPACE_XS': 4.0});
      expect(categories['radius'], {'TOK_RADIUS_PILL': 9999.0});
      expect(categories['opacity'], {'TOK_OPACITY_BACKDROP_M6': 0.4});
    });

    test(
      "ignore les métadonnées de l'export (clés commençant par un dollar)",
      () {
        final categories = convertirVariablesFigma({
          r'$extensions': {'com.figma.modeName': 'light'},
        });
        expect(categories.values.every((c) => c.isEmpty), isTrue);
      },
    );
  });

  test("le package est identique à l'export Figma versionné", () {
    final fichier = File(cheminVariablesFigma);
    if (!fichier.existsSync()) {
      markTestSkipped('$cheminVariablesFigma absent');
      return;
    }
    final resultat = Process.runSync('dart', [
      'run',
      'tools/check_tokens.dart',
    ]);
    expect(resultat.exitCode, 0, reason: '${resultat.stderr}');
    expect(resultat.stdout, contains('confirmés par l\'export Figma'));
  });
}
