// Vérifie AD-5 (ARCHITECTURE-SPINE.md) : une feature n'importe jamais une
// autre feature ; core/ n'importe jamais une feature.
//
// Écrit sans dépendance pub tierce (dart:io seul) pour éviter le conflit de
// versions cli_util entre `custom_lint` et `melos` dans un workspace Pub
// unifié — voir docs/archive/stories/spec-1-5-lint-d-imports-et-lints-de-base.md.
//
// Usage : dart run tools/check_import_direction.dart
// Sortie non vide + exit 1 si une violation est trouvée.

import 'dart:io';

final _importPattern = RegExp(
  r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
  multiLine: true,
);

class Violation {
  Violation(this.file, this.line, this.import, this.reason);
  final String file;
  final int line;
  final String import;
  final String reason;

  @override
  String toString() => '$file:$line: $reason\n  import \'$import\';';
}

/// Segment de chemin après `lib/`, ex. `features/carte/domain/foo.dart`.
String? _libRelativePath(String absoluteOrRelativePath) {
  final normalized = absoluteOrRelativePath.replaceAll('\\', '/');
  final marker = '/lib/';
  final idx = normalized.indexOf(marker);
  if (idx == -1) return null;
  return normalized.substring(idx + marker.length);
}

/// Slug de feature si le chemin lib-relatif commence par `features/<slug>/`.
String? _featureSlug(String libRelativePath) {
  final parts = libRelativePath.split('/');
  if (parts.length >= 2 && parts[0] == 'features') return parts[1];
  return null;
}

bool _isCore(String libRelativePath) => libRelativePath.startsWith('core/');

void main() {
  final appsDir = Directory('apps');
  if (!appsDir.existsSync()) {
    // apps/ existe en permanence depuis la Story 1.4 : son absence signale
    // presque sûrement un lancement depuis le mauvais répertoire (le script
    // doit être exécuté depuis la racine du workspace, ce que garantit
    // `melos run`) plutôt qu'un état légitime — échouer bruyamment plutôt
    // que de désactiver silencieusement la règle AD-5.
    stderr.writeln(
      "tools/check_import_direction: apps/ introuvable depuis "
      '${Directory.current.path} — ce script doit être lancé depuis la '
      'racine du workspace (via `melos run analyze`).',
    );
    exitCode = 1;
    return;
  }

  final violations = <Violation>[];

  for (final appEntry in appsDir.listSync()) {
    if (appEntry is! Directory) continue;
    final pubspecFile = File('${appEntry.path}/pubspec.yaml');
    if (!pubspecFile.existsSync()) continue;

    final packageName = _packageName(pubspecFile.readAsStringSync());
    if (packageName == null) continue;

    final libDir = Directory('${appEntry.path}/lib');
    if (!libDir.existsSync()) continue;

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;

      final ownLibPath = _libRelativePath(entity.path);
      if (ownLibPath == null) continue;
      final ownFeatureSlug = _featureSlug(ownLibPath);
      final ownIsCore = _isCore(ownLibPath);
      if (ownFeatureSlug == null && !ownIsCore) continue;

      final content = entity.readAsStringSync();

      for (final match in _importPattern.allMatches(content)) {
        final importUri = match.group(1)!;
        final lineNumber = content.substring(0, match.start).split('\n').length;

        String? targetLibPath;
        if (importUri.startsWith('package:$packageName/')) {
          targetLibPath = importUri.substring('package:$packageName/'.length);
        } else if (!importUri.startsWith('package:') &&
            !importUri.startsWith('dart:')) {
          // Import relatif : résoudre par rapport au dossier du fichier source.
          final ownDir = Directory(entity.path).parent.path
              .replaceAll('\\', '/');
          final resolved = Uri.directory(ownDir)
              .resolve(importUri)
              .toFilePath();
          targetLibPath = _libRelativePath(resolved);
        }
        if (targetLibPath == null) continue;

        final targetFeatureSlug = _featureSlug(targetLibPath);
        if (targetFeatureSlug == null) continue; // cible pas dans features/

        if (ownIsCore) {
          violations.add(
            Violation(
              entity.path,
              lineNumber,
              importUri,
              'core/ ne doit jamais importer une feature (AD-5) — cible : features/$targetFeatureSlug',
            ),
          );
        } else if (ownFeatureSlug != null &&
            ownFeatureSlug != targetFeatureSlug) {
          violations.add(
            Violation(
              entity.path,
              lineNumber,
              importUri,
              "la feature '$ownFeatureSlug' ne doit jamais importer la feature "
              "'$targetFeatureSlug' (AD-5) — passer par core/session ou une navigation nommée",
            ),
          );
        }
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('tools/check_import_direction: aucune violation.');
    return;
  }

  stderr.writeln(
    'tools/check_import_direction: ${violations.length} violation(s) :\n',
  );
  for (final v in violations) {
    stderr.writeln(v);
    stderr.writeln();
  }
  exitCode = 1;
}

String? _packageName(String pubspecContent) {
  final match = RegExp(
    r'''^name:\s*['"]?([\w.-]+)['"]?''',
    multiLine: true,
  ).firstMatch(pubspecContent);
  return match?.group(1);
}
