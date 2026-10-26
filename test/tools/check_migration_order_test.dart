import 'dart:io';

import 'package:test/test.dart';

import '../../tools/check_migration_order.dart';

void main() {
  test('aucune nouvelle migration -> rien à signaler', () {
    expect(migrationsInvalides(['0001_socle.sql'], ['0001_socle.sql']), []);
  });

  test('nouvelle migration postérieure -> acceptée', () {
    expect(
      migrationsInvalides(
        ['0001_socle.sql'],
        ['0001_socle.sql', '20260921120000_ajout.sql'],
      ),
      [],
    );
  });

  test('nouvelle migration antérieure -> refusée', () {
    expect(
      migrationsInvalides(
        ['0002_socle.sql'],
        ['0002_socle.sql', '0001_avant.sql'],
      ),
      ['0001_avant.sql'],
    );
  });

  test('même horodatage, suffixe alphabétiquement postérieur -> acceptée '
      '(comparaison sur le nom de fichier complet, pas juste le préfixe)', () {
    expect(
      migrationsInvalides(
        ['20260921120000_a.sql'],
        ['20260921120000_a.sql', '20260921120000_b.sql'],
      ),
      [],
    );
  });

  test('plusieurs nouvelles migrations, une seule invalide', () {
    expect(
      migrationsInvalides(
        ['0001_socle.sql'],
        ['0001_socle.sql', '20260921120000_bonne.sql', '0000_mauvaise.sql'],
      ),
      ['0000_mauvaise.sql'],
    );
  });

  test('base vide -> aucune migration refusée (pas de StateError)', () {
    expect(migrationsInvalides([], ['0001_socle.sql']), []);
  });

  test('migration fusionnée modifiée ou supprimée -> signalée', () {
    expect(
      migrationsFusionneesTouchees(
        base: ['0001_socle.sql', '0002_suite.sql'],
        actuelles: ['0001_socle.sql'],
        modifiees: ['0001_socle.sql'],
      ),
      ['0001_socle.sql', '0002_suite.sql'],
    );
  });

  test('nouvelles migrations comptées (une seule par PR)', () {
    expect(
      nouvellesMigrations(
        ['0001_socle.sql'],
        ['0001_socle.sql', '0002_a.sql', '0003_b.sql'],
      ),
      ['0002_a.sql', '0003_b.sql'],
    );
  });

  group('CLI sur un dépôt git temporaire', () {
    final script = '${Directory.current.path}/tools/check_migration_order.dart';
    late Directory depot;

    ProcessResult git(List<String> args) =>
        Process.runSync('git', args, workingDirectory: depot.path);

    ProcessResult lancer(String ref) =>
        Process.runSync('dart', [script, ref], workingDirectory: depot.path);

    void migration(String nom, String contenu) {
      File('${depot.path}/supabase/migrations/$nom')
        ..createSync(recursive: true)
        ..writeAsStringSync(contenu);
    }

    setUp(() {
      depot = Directory.systemTemp.createTempSync('check_migration_');
      git(['init', '-q', '-b', 'main']);
      git(['config', 'user.email', 'test@histolyon.local']);
      git(['config', 'user.name', 'test']);
      migration('0001_socle.sql', 'select 1;\n');
      git(['add', '.']);
      git(['commit', '-q', '-m', 'socle']);
    });
    tearDown(() => depot.deleteSync(recursive: true));

    test('ref de base illisible -> échec (jamais un succès silencieux)', () {
      expect(lancer('origin/inexistante').exitCode, 1);
    });

    test('une nouvelle migration postérieure -> succès', () {
      migration('0002_suite.sql', 'select 2;\n');
      expect(lancer('main').exitCode, 0);
    });

    test('migration déjà fusionnée modifiée -> échec', () {
      migration('0001_socle.sql', 'select 42;\n');
      final resultat = lancer('main');
      expect(resultat.exitCode, 1);
      expect(resultat.stderr, contains('0001_socle.sql'));
    });

    test('deux nouvelles migrations -> échec (une par PR)', () {
      migration('0002_a.sql', 'select 2;\n');
      migration('0003_b.sql', 'select 3;\n');
      expect(lancer('main').exitCode, 1);
    });
  });
}
