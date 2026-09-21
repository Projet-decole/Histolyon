// Adresse `conception/` par extrait, sans jamais y écrire (AD-15 : la
// conception n'est jamais lue en entier par convention -- ce script permet
// de la lire par fragments adressables).
//
// Usage :
//   dart run tools/ctx.dart <ID>       -- imprime le(s) extrait(s) YAML dont
//                                          la clé `- id:` vaut <ID> ; si aucun
//                                          ID ne correspond, tente une
//                                          résolution par chemin de fichier.
//   dart run tools/ctx.dart <chemin>   -- imprime le fichier entier dont le
//                                          chemin relatif à conception/, sans
//                                          extension, est égal ou commence
//                                          par <chemin> (ex. le nom de
//                                          fichier tronqué à son préfixe
//                                          numérique).
//   dart run tools/ctx.dart --index    -- régénère conception/INDEX.md.
//
// Écrit sans dépendance pub tierce (dart:io seul), même convention que
// tools/check_import_direction.dart -- voir
// docs/stories/spec-2-2-tools-ctx-et-conception-index-md.md.
//
// `conception/` reste strictement en lecture seule : ce script n'y écrit
// jamais rien d'autre que conception/INDEX.md, et uniquement en mode
// `--index`.

import 'dart:io';

const _conceptionDirName = 'conception';
const _indexFileName = 'INDEX.md';

void main(List<String> args) {
  final conceptionDir = Directory(_conceptionDirName);
  if (!conceptionDir.existsSync()) {
    stderr.writeln(
      "tools/ctx: répertoire '$_conceptionDirName/' introuvable depuis "
      '${Directory.current.path} -- ce script doit être lancé depuis la '
      'racine du workspace.',
    );
    exitCode = 1;
    return;
  }

  if (args.isEmpty) {
    stderr.writeln(
      'Usage: dart run tools/ctx.dart <ID|chemin>\n'
      '       dart run tools/ctx.dart --index',
    );
    exitCode = 1;
    return;
  }

  if (args.length > 1) {
    stderr.writeln('tools/ctx: un seul argument est attendu.');
    exitCode = 1;
    return;
  }

  // Toute lecture (`readAsLinesSync`/`readAsStringSync`) ou écriture
  // (`writeAsStringSync` de `conception/INDEX.md`) déclenchée par ces deux
  // modes est protégée ici plutôt qu'à chaque appel : une exception d'E/S
  // (fichier supprimé entre le listing et la lecture, disque plein,
  // permissions, encodage invalide...) doit produire le même contrat
  // stderr + exit non nul qu'un ID introuvable, jamais une trace brute.
  try {
    if (args[0] == '--index') {
      _generateIndex(conceptionDir);
      return;
    }

    _lookup(conceptionDir, args[0]);
  } on FileSystemException catch (e) {
    stderr.writeln(
      'tools/ctx: erreur d\'accès disque sous '
      '$_conceptionDirName/ -- ${e.message}'
      '${e.path != null ? ' (${e.path})' : ''}.',
    );
    exitCode = 1;
  }
}

// ---------------------------------------------------------------------------
// Parcours de fichiers
// ---------------------------------------------------------------------------

/// Fichiers `.yaml` sous `conception/`, triés par chemin relatif -- seuls
/// les fichiers YAML portent des clés `- id:` adressables.
List<File> _yamlFiles(Directory conceptionDir) {
  final files = conceptionDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.replaceAll('\\', '/').endsWith('.yaml'))
      .toList();
  files.sort((a, b) => a.path.compareTo(b.path));
  return files;
}

/// Tous les fichiers sous `conception/` (YAML et autres, ex. le Markdown de
/// `15-maquette.md`), triés par chemin relatif -- utilisé pour la résolution
/// par chemin et pour la table "Par fichier" de l'index. `conception/INDEX.md`
/// lui-même est exclu : c'est l'artefact généré, pas du contenu adressable.
List<File> _allFiles(Directory conceptionDir) {
  final files = conceptionDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => _relativePath(conceptionDir, f) != _indexFileName)
      .toList();
  files.sort((a, b) => a.path.compareTo(b.path));
  return files;
}

/// Chemin relatif à `conception/`, séparateurs `/` normalisés (ex.
/// `07-ecrans/carte/01-principale.yaml`).
String _relativePath(Directory conceptionDir, File file) {
  final base = conceptionDir.path.replaceAll('\\', '/');
  final full = file.path.replaceAll('\\', '/');
  var rel = full.substring(base.length);
  if (rel.startsWith('/')) rel = rel.substring(1);
  return rel;
}

String _withoutExtension(String path) {
  final dot = path.lastIndexOf('.');
  final slash = path.lastIndexOf('/');
  if (dot > slash) return path.substring(0, dot);
  return path;
}

/// Un `- id: <valeur>` reconnu sur une ligne, avec son indentation (en
/// nombre d'espaces de tête).
class _IdLineMatch {
  _IdLineMatch(this.indent, this.id);
  final int indent;
  final String id;
}

final _idLinePrefixPattern = RegExp(r'^(\s*)-\s*id:\s*(.*)$');

/// Reconnaît une ligne `- id: <valeur>`, en tolérant :
/// - un id entre guillemets doubles ou simples (`"D1.2"` / `'D1.2'`) ;
/// - un commentaire YAML final (`# ...`), quoté ou non (ex.
///   `- id: D1.2  # note` ou `- id: 'D1.2'  # note`).
///
/// Retourne `null` si la ligne ne correspond pas à ce format (y compris une
/// valeur non quottée contenant un espace, qui n'est pas un id simple).
_IdLineMatch? _matchIdLine(String line) {
  final prefix = _idLinePrefixPattern.firstMatch(line);
  if (prefix == null) return null;

  final indent = prefix.group(1)!.length;
  var value = prefix.group(2)!;

  final hashIndex = value.indexOf('#');
  if (hashIndex != -1) {
    value = value.substring(0, hashIndex);
  }
  value = value.trim();
  if (value.isEmpty) return null;

  final isDoubleQuoted =
      value.length >= 2 && value.startsWith('"') && value.endsWith('"');
  final isSingleQuoted =
      value.length >= 2 && value.startsWith("'") && value.endsWith("'");
  if (isDoubleQuoted || isSingleQuoted) {
    value = value.substring(1, value.length - 1);
  } else if (value.contains(RegExp(r'\s'))) {
    // Une valeur non quottée ne devrait contenir aucun espace -- sinon la
    // ligne n'est pas un simple `- id: <valeur>` (ex. reliquat non géré
    // après le commentaire) et on l'ignore plutôt que de mal la couper.
    return null;
  }

  if (value.isEmpty) return null;
  return _IdLineMatch(indent, value);
}

// ---------------------------------------------------------------------------
// Extraction de bloc
// ---------------------------------------------------------------------------

/// Extrait le bloc débutant à `lines[startIndex]` (indentation `indent`,
/// en nombre d'espaces de tête), jusqu'à la prochaine ligne non vide de
/// même indentation (ou moindre), ou fin de fichier. Les lignes vides
/// finales sont retirées du bloc retourné.
List<String> _extractBlock(List<String> lines, int startIndex, int indent) {
  final block = <String>[lines[startIndex]];
  var i = startIndex + 1;
  while (i < lines.length) {
    final line = lines[i];
    if (line.trim().isEmpty) {
      block.add(line);
      i++;
      continue;
    }
    final lineIndent = line.length - line.trimLeft().length;
    if (lineIndent <= indent) break;
    block.add(line);
    i++;
  }
  while (block.isNotEmpty && block.last.trim().isEmpty) {
    block.removeLast();
  }
  return block;
}

class _IdMatch {
  _IdMatch(this.relPath, this.lineNumber, this.block);
  final String relPath;
  final int lineNumber;
  final String block;
}

List<_IdMatch> _findIdMatches(Directory conceptionDir, String id) {
  final matches = <_IdMatch>[];
  for (final file in _yamlFiles(conceptionDir)) {
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final m = _matchIdLine(lines[i]);
      if (m == null || m.id != id) continue;
      final block = _extractBlock(lines, i, m.indent);
      matches.add(
        _IdMatch(_relativePath(conceptionDir, file), i + 1, block.join('\n')),
      );
    }
  }
  // Triés par chemin de fichier puis par ligne (cf. matrice I/O : un ID
  // dupliqué doit montrer toutes ses occurrences, jamais n'en garder qu'une).
  matches.sort((a, b) {
    final byPath = a.relPath.compareTo(b.relPath);
    if (byPath != 0) return byPath;
    return a.lineNumber.compareTo(b.lineNumber);
  });
  return matches;
}

// ---------------------------------------------------------------------------
// Mode lookup (ID ou chemin)
// ---------------------------------------------------------------------------

void _lookup(Directory conceptionDir, String arg) {
  if (arg.trim().isEmpty) {
    stderr.writeln('tools/ctx: argument vide ou blanc invalide.');
    exitCode = 1;
    return;
  }

  final idMatches = _findIdMatches(conceptionDir, arg);
  if (idMatches.isNotEmpty) {
    final buffer = StringBuffer();
    for (final m in idMatches) {
      buffer.writeln('# ${m.relPath}:${m.lineNumber}');
      buffer.writeln(m.block);
      buffer.writeln();
    }
    stdout.write(buffer.toString());
    return;
  }

  // Repli : résolution par chemin -- fichier dont le chemin relatif sous
  // conception/, sans extension, est égal à l'argument ou l'a pour préfixe
  // (ex. `07-ecrans/carte/01` -> `07-ecrans/carte/01-principale.yaml`, le
  // préfixe numérique du nom de fichier sans son suffixe descriptif).
  // Un argument sans `/` ne désigne qu'un nom de fichier : il ne doit
  // matcher que sur le dernier segment du chemin, jamais sur l'ensemble
  // de la chaîne (sinon un court préfixe numérique comme `01` capte aussi
  // des répertoires sans rapport dont le nom commence pareil).
  final pathMatches = _allFiles(conceptionDir).where((file) {
    final relNoExt = _withoutExtension(_relativePath(conceptionDir, file));
    if (relNoExt == arg) return true;
    if (arg.contains('/')) return relNoExt.startsWith(arg);
    final lastSlash = relNoExt.lastIndexOf('/');
    final lastSegment = lastSlash == -1
        ? relNoExt
        : relNoExt.substring(lastSlash + 1);
    return lastSegment.startsWith(arg);
  }).toList();

  if (pathMatches.isEmpty) {
    stderr.writeln(
      "tools/ctx: aucun ID ni fichier correspondant à '$arg' sous "
      '$_conceptionDirName/.',
    );
    exitCode = 1;
    return;
  }

  if (pathMatches.length == 1) {
    stdout.write(pathMatches.first.readAsStringSync());
    return;
  }

  // Plusieurs fichiers partagent ce préfixe : même logique que pour les ID
  // dupliqués, on montre tout plutôt que de désambiguïser silencieusement.
  final buffer = StringBuffer();
  for (final file in pathMatches) {
    buffer.writeln('# ${_relativePath(conceptionDir, file)}');
    buffer.writeln(file.readAsStringSync());
    buffer.writeln();
  }
  stdout.write(buffer.toString());
}

// ---------------------------------------------------------------------------
// Mode --index
// ---------------------------------------------------------------------------

class _IdEntry {
  _IdEntry(this.id, this.relPath, this.lineNumber);
  final String id;
  final String relPath;
  final int lineNumber;
}

void _generateIndex(Directory conceptionDir) {
  final entries = <_IdEntry>[];
  for (final file in _yamlFiles(conceptionDir)) {
    final lines = file.readAsLinesSync();
    final relPath = _relativePath(conceptionDir, file);
    for (var i = 0; i < lines.length; i++) {
      final m = _matchIdLine(lines[i]);
      if (m == null) continue;
      entries.add(_IdEntry(m.id, relPath, i + 1));
    }
  }
  entries.sort((a, b) {
    final byId = a.id.compareTo(b.id);
    if (byId != 0) return byId;
    final byPath = a.relPath.compareTo(b.relPath);
    if (byPath != 0) return byPath;
    return a.lineNumber.compareTo(b.lineNumber);
  });

  final files = _allFiles(conceptionDir);

  final buffer = StringBuffer()
    ..writeln(
      '<!-- GÉNÉRÉ par `dart run tools/ctx.dart --index` -- '
      'ne pas éditer à la main. -->',
    )
    ..writeln()
    ..writeln('# Index de `conception/`')
    ..writeln()
    ..writeln(
      'Régénérer avec `dart run tools/ctx.dart --index` après toute '
      'modification de `conception/`.',
    )
    ..writeln()
    ..writeln('## Par ID')
    ..writeln()
    ..writeln('| id | fichier:ligne |')
    ..writeln('|---|---|');
  for (final e in entries) {
    buffer.writeln('| ${e.id} | ${e.relPath}:${e.lineNumber} |');
  }
  buffer
    ..writeln()
    ..writeln('## Par fichier')
    ..writeln()
    ..writeln('| chemin adressable | fichier réel |')
    ..writeln('|---|---|');
  for (final f in files) {
    final rel = _relativePath(conceptionDir, f);
    buffer.writeln('| ${_withoutExtension(rel)} | $rel |');
  }

  File('${conceptionDir.path}/$_indexFileName')
      .writeAsStringSync(buffer.toString());
  stdout.writeln(
    'tools/ctx: $_conceptionDirName/$_indexFileName régénéré '
    '(${entries.length} entrées "Par ID", ${files.length} fichiers '
    '"Par fichier").',
  );
}
