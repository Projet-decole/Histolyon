// Concatène tous les fichiers AGENTS.md du dépôt (racine + locaux,
// découverts par glob, jamais une liste figée) en un contenu unique,
// préfixé d'un bandeau « généré », puis l'écrit dans les trois formats
// attendus par Claude Code, Cursor et GitHub Copilot : CLAUDE.md,
// .cursor/rules/histolyon.mdc et .github/copilot-instructions.md.
//
// Les liens Markdown relatifs présents dans un AGENTS.md source (ex.
// `[../../AGENTS.md](../../AGENTS.md)`) ne sont corrects que depuis
// l'emplacement de ce fichier source ; une fois concaténés dans les 3
// fichiers cibles (à des profondeurs différentes de la racine du dépôt),
// ils sont réécrits en texte de code inline exprimé relativement à la
// racine, jamais recopiés tels quels.
//
// Écrit sans dépendance pub tierce (dart:io seul), même convention que
// tools/check_import_direction.dart (Story 1.5) et tools/ctx.dart (Story
// 2.2) : erreur d'E/S -> message clair sur stderr + `exitCode = 1`, jamais
// une exception brute ni `exit()`.
//
// Ce script ne lit que des AGENTS.md et n'écrit jamais dedans : les trois
// fichiers cibles sont des sorties, jamais des sources. Il doit être lancé
// depuis la racine du workspace (présence de `pubspec.yaml` vérifiée avant
// toute écriture).
//
// Usage : dart run tools/sync_agents.dart

import 'dart:io';

const _generatedNotice =
    'Généré par `tools/sync_agents.dart` depuis les '
    '`AGENTS.md` — ne jamais éditer à la main.';

const _cursorFrontmatter =
    '---\n'
    'description: Instructions HistoLyon — $_generatedNotice\n'
    'alwaysApply: true\n'
    '---\n';

final _mdLinkPattern = RegExp(r'\[([^\]]*)\]\(([^)\s]+)(?:\s+"[^"]*")?\)');

/// Dossiers jamais descendus lors de la recherche des AGENTS.md.
///
/// Les dossiers cachés (`.git`, `.dart_tool`, `.fvm`, `.claude`, futurs
/// `.cursor`/`.github`) sont exclus à toute profondeur : ce sont des
/// artefacts d'outillage, jamais des sources, quel que soit l'endroit où ils
/// apparaissent dans l'arbre. `_bmad` et `build`, en revanche, ne sont exclus
/// qu'à la racine exacte du dépôt (premier segment du chemin relatif) : ce
/// sont des noms de dossier ordinaires ailleurs dans l'arbre, et les exclure
/// à toute profondeur écarterait à tort un dossier homonyme légitime.
bool _isExcludedDir(String name, String relPath) {
  if (name.startsWith('.')) return true;
  final isTopLevel = !relPath.contains('/');
  return isTopLevel && (name == '_bmad' || name == 'build');
}

/// Découvre tous les AGENTS.md sous [root], triés par profondeur de chemin
/// (nombre de segments) puis par chemin -- garantit que le fichier racine
/// est toujours premier, sans dépendre d'une coïncidence d'ordre ASCII entre
/// noms de dossiers.
List<String> _findAgentsFiles(Directory root) {
  final found = <String>[];

  void walk(Directory dir, String relDir) {
    for (final entity in dir.listSync(followLinks: false)) {
      final name = entity.uri.pathSegments.where((s) => s.isNotEmpty).last;
      final relPath = relDir.isEmpty ? name : '$relDir/$name';

      if (entity is Link) {
        stderr.writeln(
          'tools/sync_agents: lien symbolique ignoré (jamais suivi) : '
          '$relPath',
        );
        continue;
      }
      if (entity is Directory) {
        if (_isExcludedDir(name, relPath)) continue;
        walk(entity, relPath);
      } else if (entity is File && name == 'AGENTS.md') {
        found.add(relPath);
      }
    }
  }

  walk(root, '');
  found.sort((a, b) {
    final depthCompare = a.split('/').length.compareTo(b.split('/').length);
    if (depthCompare != 0) return depthCompare;
    return a.compareTo(b);
  });
  return found;
}

/// Dossier contenant [relPath] (chemin relatif à la racine du dépôt), ou
/// `''` si [relPath] est déjà à la racine.
String _dirOf(String relPath) {
  final idx = relPath.lastIndexOf('/');
  return idx == -1 ? '' : relPath.substring(0, idx);
}

/// Vrai si [target] est un lien externe (URL avec schéma, ex. `https:`,
/// `mailto:`) ou une simple ancre de page (`#section`) -- ni l'un ni l'autre
/// ne pose de problème de profondeur et ne doit être réécrit.
bool _isExternalOrAnchor(String target) =>
    target.startsWith('#') ||
    target.startsWith('//') ||
    RegExp(r'^[a-zA-Z][a-zA-Z0-9+.\-]*:').hasMatch(target);

/// Résout [target] (chemin relatif Markdown, avec fragment `#...` optionnel)
/// trouvé dans un fichier situé sous [sourceRelDir], en un chemin exprimé
/// relativement à la racine du dépôt.
String _resolveRelativeToRoot(String sourceRelDir, String target) {
  final hashIdx = target.indexOf('#');
  final pathPart = hashIdx == -1 ? target : target.substring(0, hashIdx);
  final fragment = hashIdx == -1 ? '' : target.substring(hashIdx);
  if (pathPart.isEmpty) return target;

  final baseSegments = sourceRelDir.isEmpty
      ? <String>[]
      : sourceRelDir.split('/');
  final targetSegments = pathPart.startsWith('/')
      ? pathPart.substring(1).split('/')
      : [...baseSegments, ...pathPart.split('/')];

  final resolved = <String>[];
  for (final seg in targetSegments) {
    if (seg.isEmpty || seg == '.') continue;
    if (seg == '..') {
      if (resolved.isNotEmpty) resolved.removeLast();
      continue;
    }
    resolved.add(seg);
  }

  final resolvedPath = resolved.join('/');
  return fragment.isEmpty ? resolvedPath : '$resolvedPath$fragment';
}

/// Réécrit chaque lien Markdown `[texte](chemin)` relatif de [content] (issu
/// du fichier source [sourceRelPath]) en texte de code inline exprimé
/// relativement à la racine du dépôt -- plus de lien cliquable, mais correct
/// quelle que soit la profondeur du fichier généré qui l'embarque. Les liens
/// externes, les ancres pures et les liens d'image (`![...]()`) sont laissés
/// tels quels.
String _rewriteRelativeLinks(String content, String sourceRelPath) {
  final sourceRelDir = _dirOf(sourceRelPath);
  final buffer = StringBuffer();
  var lastEnd = 0;

  for (final match in _mdLinkPattern.allMatches(content)) {
    final isImage = match.start > 0 && content[match.start - 1] == '!';
    buffer.write(content.substring(lastEnd, match.start));

    final target = match.group(2)!;
    if (isImage || _isExternalOrAnchor(target)) {
      buffer.write(match.group(0));
    } else {
      buffer.write('`${_resolveRelativeToRoot(sourceRelDir, target)}`');
    }
    lastEnd = match.end;
  }
  buffer.write(content.substring(lastEnd));
  return buffer.toString();
}

/// Concatène le contenu des AGENTS.md trouvés (liens relatifs réécrits), un
/// titre `## <chemin>` par fichier source, dans l'ordre de [relPaths].
String _buildBody(Directory root, List<String> relPaths) {
  final buffer = StringBuffer();
  for (final relPath in relPaths) {
    final content = File('${root.path}/$relPath').readAsStringSync();
    buffer.writeln('## $relPath');
    buffer.writeln();
    buffer.writeln(_rewriteRelativeLinks(content, relPath).trimRight());
    buffer.writeln();
  }
  return buffer.toString().trimRight();
}

/// Crée [fullPath] (et ses parents) s'il n'existe pas, en vérifiant à chaque
/// segment qu'aucun n'existe déjà comme fichier simple -- `createSync` lèverait
/// sinon une exception brute au lieu d'un message clair.
bool _ensureDirectory(String fullPath) {
  final parts = fullPath.split('/').where((s) => s.isNotEmpty);
  var current = '';
  for (final part in parts) {
    current = '$current/$part';
    final type = FileSystemEntity.typeSync(current, followLinks: false);
    if (type == FileSystemEntityType.notFound) {
      try {
        Directory(current).createSync();
      } on FileSystemException catch (e) {
        stderr.writeln(
          "tools/sync_agents: impossible de créer '$current' -- "
          '${e.message}.',
        );
        return false;
      }
    } else if (type != FileSystemEntityType.directory) {
      stderr.writeln(
        "tools/sync_agents: '$current' existe déjà et n'est pas un "
        "dossier -- impossible d'y écrire les fichiers générés.",
      );
      return false;
    }
  }
  return true;
}

/// Écrit [content] dans [file] ; en cas d'échec, rapporte précisément quel
/// fichier a échoué et lesquels, parmi les 3 fichiers générés, ont déjà été
/// écrits avec succès avant cet échec (pour ne pas laisser croire à une
/// génération complète et cohérente).
bool _writeGenerated(
  File file,
  String content,
  String label,
  List<String> writtenSoFar,
) {
  try {
    file.writeAsStringSync(content);
  } on FileSystemException catch (e) {
    stderr.writeln(
      "tools/sync_agents: échec d'écriture de $label (${file.path}) -- "
      '${e.message}.',
    );
    if (writtenSoFar.isNotEmpty) {
      stderr.writeln(
        'tools/sync_agents: déjà écrits avant cet échec, potentiellement '
        "incohérents avec $label tant que le script n'aura pas été rejoué "
        'avec succès : ${writtenSoFar.join(', ')}.',
      );
    }
    return false;
  }
  writtenSoFar.add(label);
  return true;
}

void main() {
  final root = Directory.current;

  if (!File('${root.path}/pubspec.yaml').existsSync()) {
    stderr.writeln(
      "tools/sync_agents: pubspec.yaml introuvable depuis ${root.path} -- "
      'ce script doit être lancé depuis la racine du workspace (dart run '
      'tools/sync_agents.dart).',
    );
    exitCode = 1;
    return;
  }

  List<String> relPaths;
  try {
    relPaths = _findAgentsFiles(root);
  } on FileSystemException catch (e) {
    stderr.writeln(
      'tools/sync_agents: erreur d\'accès disque pendant la recherche des '
      'AGENTS.md${e.path != null ? " (${e.path})" : ""} -- ${e.message}.',
    );
    exitCode = 1;
    return;
  }

  if (relPaths.isEmpty) {
    stderr.writeln(
      'tools/sync_agents: aucun AGENTS.md trouvé sous ${root.path}.',
    );
    exitCode = 1;
    return;
  }

  String body;
  try {
    body = _buildBody(root, relPaths);
  } on FileSystemException catch (e) {
    stderr.writeln(
      'tools/sync_agents: lecture impossible${e.path != null ? " de ${e.path}" : ""} '
      '-- ${e.message}.',
    );
    exitCode = 1;
    return;
  }

  final commonContent = '> $_generatedNotice\n\n$body\n';

  if (!_ensureDirectory('${root.path}/.cursor/rules') ||
      !_ensureDirectory('${root.path}/.github')) {
    exitCode = 1;
    return;
  }

  final writtenSoFar = <String>[];
  final okClaude = _writeGenerated(
    File('${root.path}/CLAUDE.md'),
    commonContent,
    'CLAUDE.md',
    writtenSoFar,
  );
  final okCursor =
      okClaude &&
      _writeGenerated(
        File('${root.path}/.cursor/rules/histolyon.mdc'),
        '$_cursorFrontmatter\n$commonContent',
        '.cursor/rules/histolyon.mdc',
        writtenSoFar,
      );
  final okCopilot =
      okCursor &&
      _writeGenerated(
        File('${root.path}/.github/copilot-instructions.md'),
        commonContent,
        '.github/copilot-instructions.md',
        writtenSoFar,
      );

  if (!okClaude || !okCursor || !okCopilot) {
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'tools/sync_agents: ${relPaths.length} AGENTS.md synchronisés vers '
    'CLAUDE.md, .cursor/rules/histolyon.mdc, .github/copilot-instructions.md :',
  );
  for (final relPath in relPaths) {
    stdout.writeln('  - $relPath');
  }
}
