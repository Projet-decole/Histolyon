// Story 6.4 (AD-10) : vérifie que `packages/design_tokens` reflète
// exactement `packages/design_tokens/figma_export.json` — aucune valeur
// visuelle ne doit être inventée ni divergente par rapport à la maquette
// Figma, et aucun alias ne doit fusionner deux tokens différents (un id
// manquant côté package est déjà détecté comme divergence, qu'il ait été
// oublié ou fusionné dans une autre constante).
//
// Usage : dart run tools/check_tokens.dart
// Sortie non vide + exit 1 si une divergence est trouvée.

import 'dart:convert';
import 'dart:io';

class Divergence {
  Divergence(this.categorie, this.message);
  final String categorie;
  final String message;

  @override
  String toString() => '[$categorie] $message';
}

/// Compare récursivement deux valeurs déjà décodées (JSON ou parsées depuis
/// le source Dart) en tolérant int vs double pour les nombres.
bool valeursEgales(Object? attendu, Object? reel) {
  if (attendu is num && reel is num) {
    return attendu.toDouble() == reel.toDouble();
  }
  if (attendu is Map && reel is Map) {
    if (attendu.length != reel.length) return false;
    for (final cle in attendu.keys) {
      if (!reel.containsKey(cle)) return false;
      if (!valeursEgales(attendu[cle], reel[cle])) return false;
    }
    return true;
  }
  return attendu == reel;
}

/// Compare une catégorie de tokens (`attendu` = export Figma, `reel` =
/// constantes parsées depuis `packages/design_tokens`). Un id absent de
/// `reel` (manquant ou fusionné en alias sous un autre nom) et un id
/// présent dans `reel` mais absent de `attendu` (valeur inventée, AD-10)
/// sont tous les deux des divergences.
List<Divergence> comparerCategorie({
  required String categorie,
  required Map<String, Object?> attendu,
  required Map<String, Object?> reel,
}) {
  final divergences = <Divergence>[];

  for (final id in attendu.keys) {
    if (!reel.containsKey(id)) {
      divergences.add(
        Divergence(categorie, '$id absent de packages/design_tokens'),
      );
      continue;
    }
    if (!valeursEgales(attendu[id], reel[id])) {
      divergences.add(
        Divergence(
          categorie,
          '$id : valeur divergente (export=${attendu[id]}, package=${reel[id]})',
        ),
      );
    }
  }

  for (final id in reel.keys) {
    if (!attendu.containsKey(id)) {
      divergences.add(
        Divergence(
          categorie,
          '$id présent dans packages/design_tokens mais absent de '
          'figma_export.json (valeur inventée ?)',
        ),
      );
    }
  }

  return divergences;
}

Map<String, String> parseCouleurs(String source) {
  final motif = RegExp(
    r'''const Color (TOK_COLOR_\w+) = Color\(0x([0-9A-Fa-f]{8})\);''',
  );
  return {
    for (final m in motif.allMatches(source))
      m.group(1)!: m.group(2)!.toUpperCase(),
  };
}

Map<String, double> parseNombres(String source) {
  final motif = RegExp(r'''const double (TOK_\w+) = ([0-9]+(?:\.[0-9]+)?);''');
  return {
    for (final m in motif.allMatches(source))
      m.group(1)!: double.parse(m.group(2)!),
  };
}

Map<String, Map<String, Object>> parseTypographie(String source) {
  final motif = RegExp(
    r'''const TextStyle (TOK_TYPO_\w+) = TextStyle\(\s*'''
    r'''fontFamily: '([^']+)',\s*'''
    r'''fontWeight: FontWeight\.w(\d+),\s*'''
    r'''fontSize: ([0-9]+(?:\.[0-9]+)?),\s*'''
    r'''height: ([0-9]+(?:\.[0-9]+)?),\s*\);''',
  );
  return {
    for (final m in motif.allMatches(source))
      m.group(1)!: {
        'fontFamily': m.group(2)!,
        'fontWeight': int.parse(m.group(3)!),
        'fontSize': double.parse(m.group(4)!),
        'height': double.parse(m.group(5)!),
      },
  };
}

Map<String, Map<String, Object>> parseOmbres(String source) {
  final motif = RegExp(
    r'''const BoxShadow (TOK_SHADOW_\w+) = BoxShadow\(\s*'''
    r'''color: Color\(0x([0-9A-Fa-f]{8})\),\s*'''
    r'''offset: Offset\(([0-9]+(?:\.[0-9]+)?), ([0-9]+(?:\.[0-9]+)?)\),\s*'''
    r'''blurRadius: ([0-9]+(?:\.[0-9]+)?),\s*\);''',
  );
  return {
    for (final m in motif.allMatches(source))
      m.group(1)!: {
        'colorArgb': m.group(2)!.toUpperCase(),
        'offsetX': double.parse(m.group(3)!),
        'offsetY': double.parse(m.group(4)!),
        'blurRadius': double.parse(m.group(5)!),
      },
  };
}

void main() {
  final racinePackage = Directory('packages/design_tokens');
  if (!racinePackage.existsSync()) {
    stderr.writeln(
      'tools/check_tokens: packages/design_tokens introuvable depuis '
      '${Directory.current.path} — ce script doit être lancé depuis la '
      'racine du workspace (via `melos run analyze`).',
    );
    exitCode = 1;
    return;
  }

  final export = jsonDecode(
    File('packages/design_tokens/figma_export.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  final couleurs = parseCouleurs(
    File('packages/design_tokens/lib/src/colors.dart').readAsStringSync(),
  );
  final espacement = parseNombres(
    File('packages/design_tokens/lib/src/spacing.dart').readAsStringSync(),
  );
  final rayons = parseNombres(
    File('packages/design_tokens/lib/src/radius.dart').readAsStringSync(),
  );
  final opacites = parseNombres(
    File('packages/design_tokens/lib/src/opacity.dart').readAsStringSync(),
  );
  final typographie = parseTypographie(
    File('packages/design_tokens/lib/src/typography.dart').readAsStringSync(),
  );
  final ombres = parseOmbres(
    File('packages/design_tokens/lib/src/shadows.dart').readAsStringSync(),
  );

  final divergences = [
    ...comparerCategorie(
      categorie: 'colors',
      attendu: Map<String, Object?>.from(export['colors'] as Map),
      reel: couleurs,
    ),
    ...comparerCategorie(
      categorie: 'spacing',
      attendu: Map<String, Object?>.from(export['spacing'] as Map),
      reel: espacement,
    ),
    ...comparerCategorie(
      categorie: 'radius',
      attendu: Map<String, Object?>.from(export['radius'] as Map),
      reel: rayons,
    ),
    ...comparerCategorie(
      categorie: 'opacity',
      attendu: Map<String, Object?>.from(export['opacity'] as Map),
      reel: opacites,
    ),
    ...comparerCategorie(
      categorie: 'typography',
      attendu: Map<String, Object?>.from(export['typography'] as Map),
      reel: typographie,
    ),
    ...comparerCategorie(
      categorie: 'shadows',
      attendu: Map<String, Object?>.from(export['shadows'] as Map),
      reel: ombres,
    ),
  ];

  if (divergences.isEmpty) {
    stdout.writeln(
      'tools/check_tokens: aucune divergence (${couleurs.length + espacement.length + rayons.length + opacites.length + typographie.length + ombres.length} tokens vérifiés).',
    );
    return;
  }

  stderr.writeln('tools/check_tokens: ${divergences.length} divergence(s) :\n');
  for (final d in divergences) {
    stderr.writeln(d);
  }
  exitCode = 1;
}
