// Tests boîte noire de `tools/ctx.dart` (AD-14/NFR6).
//
// `tools/ctx.dart` n'expose aucune API publique -- écrit volontairement
// sans dépendance pub externe (dart:io seul), comme
// `tools/check_import_direction.dart` -- donc la seule surface testable est
// son contrat CLI (stdout/stderr/exitCode). Ce fichier suit la même
// contrainte plutôt que d'ajouter `package:test` comme dépendance du
// workspace racine.
//
// Usage : dart test/tools/ctx_test.dart (depuis la racine du workspace ;
// c'est aussi le répertoire de travail utilisé par `dart test`).

import 'dart:io';

int _failures = 0;

void _check(String description, bool condition) {
  if (condition) {
    stdout.writeln('  OK   $description');
  } else {
    stdout.writeln('  FAIL $description');
    _failures++;
  }
}

ProcessResult _runCtx(String scriptPath, List<String> args, String cwd) {
  return Process.runSync('dart', [scriptPath, ...args], workingDirectory: cwd);
}

void main() {
  final repoRoot = Directory.current.path;
  final scriptPath = '$repoRoot/tools/ctx.dart';

  if (!File(scriptPath).existsSync()) {
    stderr.writeln(
      'test/tools/ctx_test.dart: tools/ctx.dart introuvable depuis '
      '$repoRoot -- exécuter depuis la racine du workspace '
      '(dart test/tools/ctx_test.dart).',
    );
    exitCode = 1;
    return;
  }

  stdout.writeln('-- lookup exact d\'un id unique --');
  {
    final result = _runCtx(scriptPath, ['D1.2'], repoRoot);
    final out = result.stdout as String;
    _check('exit code 0', result.exitCode == 0);
    _check(
      'en-tête du bloc de définition présent',
      out.contains(
        '# 03-fonctionnalites/01-carte-exploration-temporelle.yaml:153',
      ),
    );
    _check(
      'contenu du bloc présent',
      out.contains("nom: \"Slider d'époques\""),
    );
  }

  stdout.writeln('-- lookup d\'un id dupliqué --');
  {
    final result = _runCtx(scriptPath, ['comp-icone'], repoRoot);
    final out = result.stdout as String;
    final headers = out
        .split('\n')
        .where((l) => l.startsWith('# 10-composants/'))
        .toSet();
    _check('exit code 0', result.exitCode == 0);
    _check(
      'les 5 occurrences réelles sont toutes affichées',
      headers.length == 5,
    );
  }

  stdout.writeln('-- fallback par chemin --');
  {
    final result = _runCtx(scriptPath, ['07-ecrans/carte/01'], repoRoot);
    final expected = File(
      '$repoRoot/conception/07-ecrans/carte/01-principale.yaml',
    ).readAsStringSync();
    _check('exit code 0', result.exitCode == 0);
    _check('fichier entier retourné tel quel', result.stdout == expected);
  }

  stdout.writeln('-- id introuvable --');
  {
    final result = _runCtx(scriptPath, ['XYZ-INEXISTANT'], repoRoot);
    _check('exit code non nul', result.exitCode != 0);
    _check('rien sur stdout', (result.stdout as String).isEmpty);
    _check(
      'message clair sur stderr',
      (result.stderr as String).contains('XYZ-INEXISTANT'),
    );
  }

  stdout.writeln('-- idempotence de --index --');
  {
    final indexFile = File('$repoRoot/conception/INDEX.md');

    final first = _runCtx(scriptPath, ['--index'], repoRoot);
    _check('première génération : exit code 0', first.exitCode == 0);
    final firstContent = indexFile.readAsStringSync();

    final second = _runCtx(scriptPath, ['--index'], repoRoot);
    _check('régénération : exit code 0', second.exitCode == 0);
    final secondContent = indexFile.readAsStringSync();

    _check(
      'aucun diff entre les deux générations',
      firstContent == secondContent,
    );
  }

  stdout.writeln(
    '-- id avec commentaire inline / guillemets simples (fixture) --',
  );
  {
    final fixtureRoot = Directory.systemTemp.createTempSync('ctx_test_quotes_');
    try {
      final fixtureConception = Directory('${fixtureRoot.path}/conception')
        ..createSync();
      File('${fixtureConception.path}/sample.yaml').writeAsStringSync(
        'domain:\n'
        '  - id: D1.2  # commentaire à ignorer\n'
        '    nom: "Avec commentaire"\n'
        "  - id: 'D9.9'\n"
        '    nom: "Avec guillemets simples"\n',
      );

      final commentResult = _runCtx(scriptPath, ['D1.2'], fixtureRoot.path);
      _check(
        'id avec commentaire inline reconnu malgré le `#...`',
        (commentResult.stdout as String).contains('nom: "Avec commentaire"'),
      );

      final quoteResult = _runCtx(scriptPath, ['D9.9'], fixtureRoot.path);
      _check(
        'id entre guillemets simples reconnu et déguillemetté',
        (quoteResult.stdout as String).contains(
          'nom: "Avec guillemets simples"',
        ),
      );

      final indexResult = _runCtx(scriptPath, ['--index'], fixtureRoot.path);
      final indexContent = File('${fixtureConception.path}/INDEX.md')
          .readAsStringSync();
      _check('--index : exit code 0', indexResult.exitCode == 0);
      _check(
        'id commenté indexé sans le commentaire',
        indexContent.contains('| D1.2 | sample.yaml:2 |'),
      );
      _check(
        'id entre guillemets simples indexé sans les guillemets',
        indexContent.contains('| D9.9 | sample.yaml:4 |'),
      );
    } finally {
      fixtureRoot.deleteSync(recursive: true);
    }
  }

  stdout.writeln('-- argument vide/blanc rejeté --');
  {
    final result = _runCtx(scriptPath, [''], repoRoot);
    _check('exit code non nul', result.exitCode != 0);
    _check('rien sur stdout', (result.stdout as String).isEmpty);
  }

  stdout.writeln('-- résolution par chemin restreinte au dernier segment --');
  {
    final fixtureRoot = Directory.systemTemp.createTempSync('ctx_test_seg_');
    try {
      final fixtureConception = Directory('${fixtureRoot.path}/conception')
        ..createSync();
      Directory('${fixtureConception.path}/dirA').createSync();
      Directory('${fixtureConception.path}/01-dirprefixed').createSync();
      File('${fixtureConception.path}/dirA/01-file.yaml')
          .writeAsStringSync('- id: X1\n');
      File('${fixtureConception.path}/01-dirprefixed/other.yaml')
          .writeAsStringSync('- id: X2\n');

      final result = _runCtx(scriptPath, ['01'], fixtureRoot.path);
      final out = result.stdout as String;
      _check('exit code 0', result.exitCode == 0);
      _check(
        'ne matche que le fichier dont le nom commence par 01, pas le '
        'répertoire homonyme',
        out.contains('X1') && !out.contains('X2'),
      );
    } finally {
      fixtureRoot.deleteSync(recursive: true);
    }
  }

  stdout.writeln('-- argument surnuméraire rejeté (--index) --');
  {
    final result = _runCtx(scriptPath, ['--index', 'garbage'], repoRoot);
    _check('exit code non nul', result.exitCode != 0);
  }

  stdout.writeln();
  if (_failures == 0) {
    stdout.writeln('Tous les tests sont passés.');
  } else {
    stdout.writeln('$_failures test(s) en échec.');
    exitCode = 1;
  }
}
