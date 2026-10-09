// Tests boîte noire de `tools/check_import_direction.dart` (AD-5) : chaque
// cas monte un mini-workspace temporaire et vérifie le code de sortie et le
// message du lint.

import 'dart:io';

import 'package:test/test.dart';

final _script = '${Directory.current.path}/tools/check_import_direction.dart';

late Directory _racine;

void _fichier(String chemin, String contenu) {
  File('${_racine.path}/$chemin')
    ..createSync(recursive: true)
    ..writeAsStringSync(contenu);
}

ProcessResult _lancer() =>
    Process.runSync('dart', [_script], workingDirectory: _racine.path);

void main() {
  setUp(() {
    _racine = Directory.systemTemp.createTempSync('check_import_');
    _fichier('apps/app/pubspec.yaml', 'name: app\n');
    _fichier('packages/outils/pubspec.yaml', 'name: outils\n');
  });
  tearDown(() => _racine.deleteSync(recursive: true));

  test('un workspace conforme passe', () {
    _fichier(
      'apps/app/lib/features/a/presentation/ecran.dart',
      "import '../domain/logique.dart';\n"
          "import 'package:app/core/session/session.dart';\n",
    );
    _fichier(
      'apps/app/lib/features/a/domain/logique.dart',
      "import '../data/depot.dart';\n",
    );
    _fichier(
      'apps/app/lib/features/a/data/depot.dart',
      "import 'package:supabase_flutter/supabase_flutter.dart';\n",
    );
    _fichier('apps/app/lib/core/session/session.dart', '');
    final resultat = _lancer();
    expect(resultat.exitCode, 0, reason: '${resultat.stderr}');
  });

  test('une feature qui importe une autre feature est refusée', () {
    _fichier(
      'apps/app/lib/features/a/presentation/ecran.dart',
      "import 'package:app/features/b/presentation/autre.dart';\n",
    );
    final resultat = _lancer();
    expect(resultat.exitCode, 1);
    expect(resultat.stderr, contains("la feature 'a'"));
  });

  test('core/ qui importe une feature (import relatif) est refusé', () {
    _fichier(
      'apps/app/lib/core/router/routes.dart',
      "import '../../features/a/presentation/ecran.dart';\n",
    );
    final resultat = _lancer();
    expect(resultat.exitCode, 1);
    expect(resultat.stderr, contains('core/'));
  });

  test('domain/ qui importe presentation/ est refusé (sens des couches)', () {
    _fichier(
      'apps/app/lib/features/a/domain/logique.dart',
      "import '../presentation/ecran.dart';\n",
    );
    final resultat = _lancer();
    expect(resultat.exitCode, 1);
    expect(resultat.stderr, contains('domain'));
    expect(resultat.stderr, contains('presentation'));
  });

  test('data/ qui importe domain/ est refusé (sens des couches)', () {
    _fichier(
      'apps/app/lib/features/a/data/depot.dart',
      "import 'package:app/features/a/domain/logique.dart';\n",
    );
    expect(_lancer().exitCode, 1);
  });

  test('presentation/ qui importe Supabase ou Drift est refusé', () {
    _fichier(
      'apps/app/lib/features/a/presentation/ecran.dart',
      "import 'package:drift/drift.dart';\n",
    );
    final resultat = _lancer();
    expect(resultat.exitCode, 1);
    expect(resultat.stderr, contains('data/'));
  });

  test("packages/ qui importe une app est refusé", () {
    _fichier(
      'packages/outils/lib/outil.dart',
      "import 'package:app/features/a/domain/logique.dart';\n",
    );
    final resultat = _lancer();
    expect(resultat.exitCode, 1);
    expect(resultat.stderr, contains('packages/'));
  });

  test("la cible alternative d'un import conditionnel est vérifiée", () {
    _fichier(
      'apps/app/lib/core/plateforme.dart',
      "import 'stub.dart'\n"
          "    if (dart.library.io) 'package:app/features/b/data/io.dart';\n",
    );
    expect(_lancer().exitCode, 1);
  });
}
