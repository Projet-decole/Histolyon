// Tests boîte noire de `tools/sync_agents.dart` (AD-14/NFR6).
//
// Même contrainte et même approche que `test/tools/ctx_test.dart` (Story
// 2.2) : le script n'expose aucune API publique -- écrit volontairement sans
// dépendance pub externe (dart:io seul) -- donc la seule surface testable
// est son contrat CLI (stdout/stderr/exitCode/fichiers écrits). Ce fichier
// suit la même contrainte plutôt que d'ajouter `package:test` comme
// dépendance du workspace racine.
//
// Usage : dart test/tools/sync_agents_test.dart (depuis la racine du
// workspace ; c'est aussi le répertoire de travail utilisé par `dart test`).

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

ProcessResult _run(String scriptPath, String cwd) {
  return Process.runSync('dart', [scriptPath], workingDirectory: cwd);
}

void main() {
  final repoRoot = Directory.current.path;
  final scriptPath = '$repoRoot/tools/sync_agents.dart';

  if (!File(scriptPath).existsSync()) {
    stderr.writeln(
      'test/tools/sync_agents_test.dart: tools/sync_agents.dart introuvable '
      'depuis $repoRoot -- exécuter depuis la racine du workspace '
      '(dart test/tools/sync_agents_test.dart).',
    );
    exitCode = 1;
    return;
  }

  final claudeFile = File('$repoRoot/CLAUDE.md');
  final cursorFile = File('$repoRoot/.cursor/rules/histolyon.mdc');
  final copilotFile = File('$repoRoot/.github/copilot-instructions.md');

  stdout.writeln('-- découverte des AGENTS.md réels --');
  {
    final result = _run(scriptPath, repoRoot);
    final out = result.stdout as String;
    _check('exit code 0', result.exitCode == 0);
    _check('AGENTS.md (racine) listé', out.contains('- AGENTS.md'));
    _check(
      'apps/mobile/AGENTS.md listé',
      out.contains('- apps/mobile/AGENTS.md'),
    );
    _check('supabase/AGENTS.md listé', out.contains('- supabase/AGENTS.md'));
    _check('CLAUDE.md créé', claudeFile.existsSync());
    _check('.cursor/rules/histolyon.mdc créé', cursorFile.existsSync());
    _check('.github/copilot-instructions.md créé', copilotFile.existsSync());

    final claudeContent = claudeFile.readAsStringSync();
    _check(
      'bandeau généré présent',
      claudeContent.contains(
        'Généré par `tools/sync_agents.dart` depuis les `AGENTS.md`',
      ),
    );
    _check(
      'frontmatter Cursor alwaysApply: true présent',
      cursorFile.readAsStringSync().contains('alwaysApply: true'),
    );
    _check(
      'aucun lien Markdown relatif brisé (`](../`) dans le fichier généré '
      '-- les liens des AGENTS.md sources doivent être réécrits en chemin '
      'racine, pas recopiés tels quels',
      !claudeContent.contains('](../'),
    );
    _check(
      "lien réécrit en chemin inline racine (ex. `apps/mobile/AGENTS.md` "
      'depuis le lien relatif `../../AGENTS.md` de apps/mobile/AGENTS.md)',
      claudeContent.contains('`AGENTS.md#jamais`') ||
          claudeContent.contains('`AGENTS.md`'),
    );
  }

  stdout.writeln('-- idempotence --');
  {
    final first = _run(scriptPath, repoRoot);
    final firstClaude = claudeFile.readAsStringSync();
    final firstCursor = cursorFile.readAsStringSync();
    final firstCopilot = copilotFile.readAsStringSync();

    final second = _run(scriptPath, repoRoot);
    final secondClaude = claudeFile.readAsStringSync();
    final secondCursor = cursorFile.readAsStringSync();
    final secondCopilot = copilotFile.readAsStringSync();

    _check('première exécution : exit code 0', first.exitCode == 0);
    _check('seconde exécution : exit code 0', second.exitCode == 0);
    _check('CLAUDE.md inchangé', firstClaude == secondClaude);
    _check('.cursor/rules/histolyon.mdc inchangé', firstCursor == secondCursor);
    _check(
      '.github/copilot-instructions.md inchangé',
      firstCopilot == secondCopilot,
    );
  }

  stdout.writeln('-- propagation d\'un changement source (fixture isolée) --');
  {
    final fixtureRoot = Directory.systemTemp.createTempSync(
      'sync_agents_test_propagation_',
    );
    try {
      File('${fixtureRoot.path}/pubspec.yaml').writeAsStringSync(
        "name: fixture\nenvironment:\n  sdk: '>=3.0.0 <4.0.0'\n",
      );
      File('${fixtureRoot.path}/AGENTS.md')
          .writeAsStringSync('# AGENTS.md racine fixture\n\nLigne initiale.\n');
      Directory('${fixtureRoot.path}/apps/mobile').createSync(recursive: true);
      File('${fixtureRoot.path}/apps/mobile/AGENTS.md')
          .writeAsStringSync('# AGENTS.md mobile fixture\n\nAutre ligne.\n');

      final before = _run(scriptPath, fixtureRoot.path);
      final fixtureClaude = File('${fixtureRoot.path}/CLAUDE.md');
      _check('première génération fixture : exit code 0', before.exitCode == 0);
      _check(
        'contenu initial absent avant modification',
        !fixtureClaude.readAsStringSync().contains('LIGNE_AJOUTEE_TEST'),
      );

      final sourceAgents = File('${fixtureRoot.path}/apps/mobile/AGENTS.md');
      sourceAgents.writeAsStringSync(
        '${sourceAgents.readAsStringSync()}\nLIGNE_AJOUTEE_TEST\n',
      );

      final after = _run(scriptPath, fixtureRoot.path);
      _check('régénération fixture : exit code 0', after.exitCode == 0);
      final regenerated = fixtureClaude.readAsStringSync();
      final regeneratedCursor = File(
        '${fixtureRoot.path}/.cursor/rules/histolyon.mdc',
      ).readAsStringSync();
      final regeneratedCopilot = File(
        '${fixtureRoot.path}/.github/copilot-instructions.md',
      ).readAsStringSync();
      _check(
        'changement propagé dans CLAUDE.md',
        regenerated.contains('LIGNE_AJOUTEE_TEST'),
      );
      _check(
        'changement propagé dans .cursor/rules/histolyon.mdc',
        regeneratedCursor.contains('LIGNE_AJOUTEE_TEST'),
      );
      _check(
        'changement propagé dans .github/copilot-instructions.md',
        regeneratedCopilot.contains('LIGNE_AJOUTEE_TEST'),
      );
    } finally {
      fixtureRoot.deleteSync(recursive: true);
    }
  }

  stdout.writeln('-- garde-fou de répertoire (pubspec.yaml absent) --');
  {
    final fixtureRoot = Directory.systemTemp.createTempSync(
      'sync_agents_test_guard_',
    );
    try {
      // Un AGENTS.md local existe, mais aucun pubspec.yaml : ce n'est pas
      // la racine du workspace, le script doit refuser d'écrire quoi que ce
      // soit plutôt que d'écrire les 3 fichiers générés au mauvais endroit.
      File('${fixtureRoot.path}/AGENTS.md').writeAsStringSync('# fixture\n');

      final result = _run(scriptPath, fixtureRoot.path);
      _check('exit code non nul', result.exitCode != 0);
      _check(
        'message clair sur stderr',
        (result.stderr as String).contains('pubspec.yaml'),
      );
      _check(
        'CLAUDE.md non créé au mauvais endroit',
        !File('${fixtureRoot.path}/CLAUDE.md').existsSync(),
      );
      _check(
        '.cursor/ non créé au mauvais endroit',
        !Directory('${fixtureRoot.path}/.cursor').existsSync(),
      );
      _check(
        '.github/ non créé au mauvais endroit',
        !Directory('${fixtureRoot.path}/.github').existsSync(),
      );
    } finally {
      fixtureRoot.deleteSync(recursive: true);
    }
  }

  // Remet les 3 fichiers générés réels dans leur état stable (dernière
  // exécution sur repoRoot, sans la fixture) pour ne pas laisser de diff
  // parasite après ce test.
  _run(scriptPath, repoRoot);

  stdout.writeln();
  if (_failures == 0) {
    stdout.writeln('Tous les tests sont passés.');
  } else {
    stdout.writeln('$_failures test(s) en échec.');
    exitCode = 1;
  }
}
