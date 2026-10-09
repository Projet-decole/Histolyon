// Vérifie AD-5 (ARCHITECTURE-SPINE.md) :
// - une feature n'importe jamais une autre feature ;
// - core/ n'importe jamais une feature ;
// - dans une feature, les imports vont de presentation vers domain vers data,
//   jamais en sens inverse ;
// - seule data/ parle à Supabase ou Drift (pas presentation/ ni domain/) ;
// - packages/ n'importe jamais une app.
// Les deux cibles d'un import conditionnel (`import 'a' if (...) 'b'`) sont
// vérifiées.
//
// Écrit sans dépendance pub tierce (dart:io seul) pour éviter le conflit de
// versions cli_util entre `custom_lint` et `melos` dans un workspace Pub
// unifié.
//
// Usage : dart run tools/check_import_direction.dart (depuis la racine)
// Sortie non vide + exit 1 si une violation est trouvée.

import 'dart:io';

/// Une directive `import`/`export` complète, jusqu'au `;`.
final _directivePattern = RegExp(
  r'''^\s*(?:import|export)\s+[^;]+;''',
  multiLine: true,
);
final _uriPattern = RegExp(r'''['"]([^'"]+)['"]''');

/// Ordre des couches : un fichier n'importe que sa couche ou une suivante.
const _couches = ['presentation', 'domain', 'data'];

/// Paquets réservés à la couche data/ (AGENTS.md, Données).
const _paquetsData = [
  'package:supabase_flutter/',
  'package:supabase/',
  'package:drift/',
  'package:drift_flutter/',
];

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

/// Couche (`presentation`, `domain`, `data`) d'un fichier de feature.
String? _couche(String libRelativePath) {
  final parts = libRelativePath.split('/');
  if (parts.length >= 3 && parts[0] == 'features') {
    return _couches.contains(parts[2]) ? parts[2] : null;
  }
  return null;
}

bool _isCore(String libRelativePath) => libRelativePath.startsWith('core/');

/// Directives d'un fichier : (ligne, uri) pour chaque URI citée, y compris
/// les cibles alternatives des imports conditionnels.
Iterable<(int, String)> _imports(String content) sync* {
  for (final directive in _directivePattern.allMatches(content)) {
    final ligne = content.substring(0, directive.start).split('\n').length;
    for (final uri in _uriPattern.allMatches(directive.group(0)!)) {
      yield (ligne, uri.group(1)!);
    }
  }
}

/// Paquets (nom -> dossier) des sous-dossiers de [racine] ayant un pubspec.
Map<String, Directory> _paquets(Directory racine) {
  final paquets = <String, Directory>{};
  if (!racine.existsSync()) return paquets;
  for (final entree in racine.listSync()) {
    if (entree is! Directory) continue;
    final pubspec = File('${entree.path}/pubspec.yaml');
    if (!pubspec.existsSync()) continue;
    final nom = _packageName(pubspec.readAsStringSync());
    if (nom != null) paquets[nom] = entree;
  }
  return paquets;
}

Iterable<File> _fichiersDart(Directory paquet) {
  final lib = Directory('${paquet.path}/lib');
  if (!lib.existsSync()) return const [];
  return lib
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));
}

void main() {
  final appsDir = Directory('apps');
  if (!appsDir.existsSync()) {
    // Absence d'apps/ = presque sûrement lancé depuis le mauvais répertoire :
    // échouer bruyamment plutôt que de désactiver silencieusement AD-5.
    stderr.writeln(
      "tools/check_import_direction: apps/ introuvable depuis "
      '${Directory.current.path} — ce script doit être lancé depuis la '
      'racine du workspace (via `melos run analyze`).',
    );
    exitCode = 1;
    return;
  }

  final violations = <Violation>[];
  final apps = _paquets(appsDir);

  for (final MapEntry(key: packageName, value: app) in apps.entries) {
    for (final entity in _fichiersDart(app)) {
      final ownLibPath = _libRelativePath(entity.path);
      if (ownLibPath == null) continue;
      final ownFeatureSlug = _featureSlug(ownLibPath);
      final ownCouche = _couche(ownLibPath);
      final ownIsCore = _isCore(ownLibPath);
      if (ownFeatureSlug == null && !ownIsCore) continue;

      for (final (lineNumber, importUri) in _imports(
        entity.readAsStringSync(),
      )) {
        if (ownCouche != null &&
            ownCouche != 'data' &&
            _paquetsData.any(importUri.startsWith)) {
          violations.add(
            Violation(
              entity.path,
              lineNumber,
              importUri,
              '$ownCouche/ ne parle jamais à Supabase ou Drift : seule la '
              'couche data/ le fait (AD-5)',
            ),
          );
          continue;
        }

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
        } else if (ownFeatureSlug != targetFeatureSlug) {
          violations.add(
            Violation(
              entity.path,
              lineNumber,
              importUri,
              "la feature '$ownFeatureSlug' ne doit jamais importer la feature "
              "'$targetFeatureSlug' (AD-5) — passer par core/session ou une navigation nommée",
            ),
          );
        } else {
          final targetCouche = _couche(targetLibPath);
          if (ownCouche != null &&
              targetCouche != null &&
              _couches.indexOf(targetCouche) < _couches.indexOf(ownCouche)) {
            violations.add(
              Violation(
                entity.path,
                lineNumber,
                importUri,
                '$ownCouche/ ne doit pas importer $targetCouche/ : les imports '
                'vont de presentation vers domain vers data (AD-5)',
              ),
            );
          }
        }
      }
    }
  }

  // packages/ est partagé par les apps : il n'en importe jamais aucune.
  for (final paquet in _paquets(Directory('packages')).values) {
    for (final entity in _fichiersDart(paquet)) {
      for (final (lineNumber, importUri) in _imports(
        entity.readAsStringSync(),
      )) {
        final app = apps.keys.where(
          (nom) => importUri.startsWith('package:$nom/'),
        );
        if (app.isNotEmpty) {
          violations.add(
            Violation(
              entity.path,
              lineNumber,
              importUri,
              "packages/ n'importe jamais une app (AD-5) — cible : apps/${app.first}",
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
