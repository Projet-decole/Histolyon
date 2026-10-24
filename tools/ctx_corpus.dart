// Corpus `produit/` pour `tools/ctx.dart` v2 : chargement des unités
// (Markdown + frontmatter YAML), registre d'identifiants, estimation de coût
// en tokens et normalisation de texte pour la recherche.
//
// `produit/` est relu à chaque appel (aucun cache). `conception/` n'est jamais
// écrit : il sert seulement à vérifier les `sources` (fichier:ligne).

import 'dart:io';

import 'package:yaml/yaml.dart';

/// Préfixes d'identifiants typés autorisés (DOC- : documents transversaux).
const idPrefixes = <String>{
  'CAP',
  'ECR',
  'COMP',
  'FLX',
  'ENT',
  'INV',
  'TOK',
  'ICN',
  'EPQ',
  'MOD',
  'SRF',
  'DEC',
  'QO',
  'JAL',
  'DOC',
};

/// Type de frontmatter attendu pour un préfixe d'identifiant d'unité.
const typeParPrefixe = <String, String>{
  'CAP': 'capacite',
  'ECR': 'ecran',
  'COMP': 'composant',
  'FLX': 'flux',
  'ENT': 'entite',
  'DEC': 'decision',
};

/// Budget maximal (tokens) par type d'unité.
const budgetParType = <String, int>{
  'capacite': 2500,
  'ecran': 2000,
  'composant': 800,
  'flux': 500,
  'entite': 1500,
};

final idPattern = RegExp(r'^(' + idPrefixes.join('|') + r')-[A-Z0-9][A-Z0-9._-]*$');
final _idInText = RegExp(
  r'\b(' + idPrefixes.join('|') + r')-[A-Z0-9][A-Z0-9._-]*[A-Z0-9]\b',
);
final _headingId = RegExp(
  r'^(#{2,4})\s+((?:' + idPrefixes.join('|') + r')-[A-Z0-9][A-Z0-9._-]*)\b\s*[—:-]*\s*(.*)$',
);

/// Estimation du coût en tokens : caractères ÷ 3,5.
int estimeTokens(String text) => (text.runes.length / 3.5).ceil();

const _accents = {
  'à': 'a', 'â': 'a', 'ä': 'a', 'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
  'î': 'i', 'ï': 'i', 'ô': 'o', 'ö': 'o', 'ù': 'u', 'û': 'u', 'ü': 'u',
  'ç': 'c', 'œ': 'oe', 'æ': 'ae', '’': "'",
};

/// Minuscules, sans accents.
String normalise(String s) {
  final b = StringBuffer();
  for (final r in s.toLowerCase().runes) {
    final c = String.fromCharCode(r);
    b.write(_accents[c] ?? c);
  }
  return b.toString();
}

/// Section adressable (titre de niveau 2 à 4 débutant par un identifiant).
class Section {
  Section(this.id, this.titre, this.ligne, this.niveau, this.texte);
  final String id;
  final String titre;
  final int ligne; // 1-indexée dans le fichier
  final int niveau;
  final String texte; // titre inclus, jusqu'au prochain titre de niveau ≤
}

/// Une unité de `produit/` (un fichier Markdown).
class Unit {
  Unit({
    required this.path,
    required this.rel,
    required this.raw,
    required this.front,
    required this.body,
    required this.bodyStartLine,
    required this.parseError,
  });

  final String path;
  final String rel; // relatif à produit/, séparateurs `/`
  final String raw;
  final Map<String, dynamic> front;
  final String body;
  final int bodyStartLine;
  final String? parseError;

  String get id => '${front['id'] ?? ''}';
  String get type => '${front['type'] ?? ''}';
  String get titre => '${front['titre'] ?? ''}';
  String get statut => '${front['statut'] ?? ''}';
  int get tokens => estimeTokens(raw);

  List<String> listOf(String key) {
    final v = front[key];
    if (v is List) return v.map((e) => '$e').toList();
    return const [];
  }

  /// Liens typés : clé (ecrans, flux…) -> identifiants.
  Map<String, List<String>> get liens {
    final v = front['liens'];
    final out = <String, List<String>>{};
    if (v is Map) {
      v.forEach((k, val) {
        out['$k'] = val is List ? val.map((e) => '$e').toList() : <String>[];
      });
    }
    return out;
  }

  Iterable<String> get tousLiens => liens.values.expand((l) => l);

  List<Section> get sections {
    final lines = raw.split('\n');
    final res = <Section>[];
    for (var i = 0; i < lines.length; i++) {
      final m = _headingId.firstMatch(lines[i]);
      if (m == null) continue;
      final niveau = m.group(1)!.length;
      var j = i + 1;
      while (j < lines.length) {
        final h = RegExp(r'^(#{1,6})\s').firstMatch(lines[j]);
        if (h != null && h.group(1)!.length <= niveau) break;
        j++;
      }
      res.add(
        Section(
          m.group(2)!,
          m.group(3)!.trim(),
          i + 1,
          niveau,
          lines.sublist(i, j).join('\n').trimRight(),
        ),
      );
    }
    return res;
  }
}

dynamic _plain(dynamic v) {
  if (v is YamlMap) {
    return {for (final e in v.entries) '${e.key}': _plain(e.value)};
  }
  if (v is YamlList) return v.map(_plain).toList();
  return v;
}

/// Découpe `---\n…\n---\n corps`. Retourne (front|null, corps, ligne du corps).
({String? front, String body, int bodyLine}) splitFrontmatter(String raw) {
  final lines = raw.split('\n');
  if (lines.isEmpty || lines.first.trim() != '---') {
    return (front: null, body: raw, bodyLine: 1);
  }
  for (var i = 1; i < lines.length; i++) {
    if (lines[i].trim() == '---') {
      return (
        front: lines.sublist(1, i).join('\n'),
        body: lines.sublist(i + 1).join('\n'),
        bodyLine: i + 2,
      );
    }
  }
  return (front: null, body: raw, bodyLine: 1);
}

/// Un identifiant résolu : unité (fichier) ou section d'un fichier.
class Entree {
  Entree(this.id, this.unit, this.section);
  final String id;
  final Unit unit;
  final Section? section;
  String get titre => section?.titre.isNotEmpty == true ? section!.titre : unit.titre;
  String get typeAffiche =>
      section == null ? unit.type : id.split('-').first.toLowerCase();
  String get statut => unit.statut;
  int get ligne => section?.ligne ?? 1;
}

class Corpus {
  Corpus(this.produitDir, this.units);

  final Directory produitDir;
  final List<Unit> units;

  Directory get racine => produitDir.parent;

  /// Registre id -> entrées (plusieurs en cas de doublon, détecté par `check`).
  late final Map<String, List<Entree>> registre = _construireRegistre();

  Map<String, List<Entree>> _construireRegistre() {
    final m = <String, List<Entree>>{};
    for (final u in units) {
      if (u.id.isNotEmpty) m.putIfAbsent(u.id, () => []).add(Entree(u.id, u, null));
      for (final s in u.sections) {
        if (s.id == u.id) continue;
        m.putIfAbsent(s.id, () => []).add(Entree(s.id, u, s));
      }
    }
    return m;
  }

  Entree? resous(String id) {
    final l = registre[id];
    return l == null || l.isEmpty ? null : l.first;
  }

  /// Texte d'une entrée (fichier entier ou section).
  String texte(Entree e) => e.section?.texte ?? e.unit.raw.trimRight();

  Unit? parChemin(String arg) {
    var a = arg.replaceAll('\\', '/');
    if (a.startsWith('produit/')) a = a.substring(8);
    final sansExt = a.endsWith('.md') ? a.substring(0, a.length - 3) : a;
    for (final u in units) {
      final r = u.rel.substring(0, u.rel.length - 3);
      if (r == sansExt) return u;
    }
    for (final u in units) {
      final r = u.rel.substring(0, u.rel.length - 3);
      if (r.endsWith('/$sansExt')) return u;
    }
    return null;
  }

  static Corpus charge(Directory produitDir) {
    final units = <Unit>[];
    final files = produitDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.md'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));
    final base = produitDir.path.replaceAll('\\', '/');
    for (final f in files) {
      var rel = f.path.replaceAll('\\', '/').substring(base.length);
      if (rel.startsWith('/')) rel = rel.substring(1);
      if (rel.startsWith('_modeles/') || rel.startsWith('_import-figma/')) continue;
      final raw = f.readAsStringSync();
      final sp = splitFrontmatter(raw);
      var front = <String, dynamic>{};
      String? err;
      if (sp.front == null) {
        err = 'frontmatter absent';
      } else {
        try {
          final y = loadYaml(sp.front!);
          if (y is YamlMap) {
            front = Map<String, dynamic>.from(_plain(y) as Map);
          } else {
            err = 'frontmatter non mappable';
          }
        } on YamlException catch (e) {
          err = 'YAML invalide : ${e.message}';
        }
      }
      units.add(
        Unit(
          path: f.path,
          rel: rel,
          raw: raw,
          front: front,
          body: sp.body,
          bodyStartLine: sp.bodyLine,
          parseError: err,
        ),
      );
    }
    return Corpus(produitDir, units);
  }
}

/// Identifiants cités dans un texte.
Set<String> idsCites(String text) =>
    _idInText.allMatches(text).map((m) => m.group(0)!).toSet();
