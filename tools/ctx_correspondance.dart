// Génère `produit/_correspondance.csv` (ancien id -> nouvel id -> source) pour
// TOUS les identifiants de `conception/`, et `produit/decisions/_collisions.md`
// (identifiants utilisés plusieurs fois).
//
// Usage (depuis la racine) :
//   dart run tools/ctx_correspondance.dart            -- cibles proposées
//                                                        (note `a-ecrire`
//                                                        quand la cible n'existe pas)
//   dart run tools/ctx_correspondance.dart --final    -- cibles absentes :
//                                                        `non-repris`
//
// Une cible « repris » est une unité existante de `produit/` ; l'ancien id
// d'une unité (`anciens_ids`) sert de repli quand la règle par dossier ne
// propose rien.

import 'dart:io';

import 'ctx_corpus.dart';

final _idLine = RegExp(
  r'''^(\s*)(?:-\s*)?id:\s*["']?([^\s"'#]+)["']?\s*(?:#.*)?$''',
);

/// Cible proposée pour `id` défini dans `rel` (chemin sous `conception/`).
String? propose(String rel, String id) {
  final dossier = rel.contains('/') ? rel.split('/').first : rel;
  String maj(String s) => s.toUpperCase().replaceAll('_', '-');
  switch (dossier) {
    case '03-fonctionnalites':
      return RegExp(r'^D\d+\.\d+$').hasMatch(id) ? 'CAP-$id' : null;
    case '04-donnees':
      final inv = RegExp(r'^I(\d+)$').firstMatch(id);
      if (inv != null) return 'INV-${inv.group(1)!.padLeft(2, '0')}';
      if (RegExp(r'^[CD]\d+$').hasMatch(id)) return null;
      if (RegExp(r'^[a-z_0-9]+$').hasMatch(id)) return 'ENT-${maj(id)}';
      return null;
    case '05-architecture-info.yaml':
      if (RegExp(r'^M\d$').hasMatch(id)) return 'MOD-$id';
      if (RegExp(r'^[SP]\d$').hasMatch(id)) return 'SRF-$id';
      return null;
    case '06-flows':
      return RegExp(r'^[A-H]\d+$').hasMatch(id) ? 'FLX-$id' : null;
    case '07-ecrans':
      return id.startsWith('E-') ? 'ECR-${id.substring(2)}' : null;
    case '10-composants':
      return id.startsWith('comp-') ? 'COMP-${maj(id.substring(5))}' : null;
    case '11-reponse-parametrique':
    case '12-tokens':
      if (id.startsWith('TOK-')) return id;
      if (RegExp(r'^(DUR|CRV|HAP|CHO|MAP|TMP)-').hasMatch(id)) return 'TOK-$id';
      return null;
    case '13-icones':
      return id.startsWith('ICON-') ? 'ICN-${id.substring(5)}' : null;
    case '08-contenu':
      return id.startsWith('E-') ? 'ECR-${id.substring(2)}' : null;
  }
  return null;
}

/// Rôle de l'identifiant selon son dossier (pour le rapport de collisions).
String role(String rel, String id) {
  final dossier = rel.contains('/') ? rel.split('/').first : rel;
  if (RegExp(r'^\d+$').hasMatch(id)) return 'numéro de section';
  switch (dossier) {
    case '01-essence.yaml':
      return 'principe d’essence';
    case '02-personas.yaml':
      return 'persona ou règle de lecture';
    case '03-fonctionnalites':
      return id.contains('.') ? 'capacité' : 'domaine fonctionnel';
    case '04-donnees':
      if (RegExp(r'^I\d+$').hasMatch(id)) return 'invariant';
      if (RegExp(r'^C\d+$').hasMatch(id)) return 'cluster de données';
      if (RegExp(r'^D\d+$').hasMatch(id)) return 'décision locale';
      return 'entité';
    case '05-architecture-info.yaml':
      return RegExp(r'^[MSP]\d$').hasMatch(id)
          ? 'mode/surface'
          : 'élément d’architecture';
    case '06-flows':
      return RegExp(r'^[A-H]\d+$').hasMatch(id) ? 'flux' : 'autre';
    case '07-ecrans':
      return 'écran';
    case '08-contenu':
      return 'principe ou bloc de contenu';
    case '09-cartographie':
      return 'ancre ou décision de cartographie';
    case '10-composants':
      return id.startsWith('comp-')
          ? 'composant (définition ou usage)'
          : 'état, interaction ou décision';
    case '11-reponse-parametrique':
      return 'durée, courbe, chorégraphie, mapping ou décision';
    case '12-tokens':
      return id.startsWith('TOK-') ? 'token' : 'décision de tokens';
    case '13-icones':
      return id.startsWith('ICON-') ? 'icône' : 'décision d’icônes';
    case '14-surfaces-hors-app':
      return 'surface hors app ou décision';
  }
  return 'autre';
}

class Occ {
  Occ(this.id, this.rel, this.ligne);
  final String id;
  final String rel;
  final int ligne;
}

String _csv(String s) =>
    s.contains(',') || s.contains('"') ? '"${s.replaceAll('"', '""')}"' : s;

void main(List<String> args) {
  final finale = args.contains('--final');
  final conception = Directory('conception');
  final produit = Directory('produit');
  if (!conception.existsSync() || !produit.existsSync()) {
    stderr.writeln(
      'tools/ctx_correspondance: lancer depuis la racine du dépôt.',
    );
    exitCode = 1;
    return;
  }
  final corpus = Corpus.charge(produit);
  final parAncien = <String, Set<String>>{};
  for (final u in corpus.units) {
    for (final a in u.listOf('anciens_ids')) {
      parAncien.putIfAbsent(a, () => {}).add(u.id);
    }
  }

  final occs = <Occ>[];
  final fichiers =
      conception
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.yaml'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  for (final f in fichiers) {
    final rel = f.path.substring('conception/'.length);
    final lignes = f.readAsLinesSync();
    for (var i = 0; i < lignes.length; i++) {
      final m = _idLine.firstMatch(lignes[i]);
      if (m != null) occs.add(Occ(m.group(2)!, rel, i + 1));
    }
  }

  // Ancien id -> dossiers où il est défini (ambiguïté si plusieurs rôles).
  final roles = <String, Set<String>>{};
  for (final o in occs) {
    roles.putIfAbsent(o.id, () => {}).add(role(o.rel, o.id));
  }

  final csv = StringBuffer('ancien_id,nouvel_id,source,note\n');
  var repris = 0;
  var aEcrire = 0;
  var nonRepris = 0;
  for (final o in occs) {
    var cible = propose(o.rel, o.id);
    var note = '';
    if (cible != null && corpus.resous(cible) == null) {
      cible = null;
      note = 'cible-proposee-absente';
    }
    if (cible == null) {
      final alt = parAncien[o.id];
      if (alt != null && alt.length == 1 && roles[o.id]!.length == 1)
        cible = alt.first;
    }
    final prop = propose(o.rel, o.id);
    if (cible != null) {
      note = 'repris';
      repris++;
    } else if (!finale && prop != null) {
      cible = prop;
      note = 'a-ecrire';
      aEcrire++;
    } else {
      note = 'non-repris: ${role(o.rel, o.id)}';
      nonRepris++;
    }
    csv.writeln(
      '${_csv(o.id)},${_csv(cible ?? '')},conception/${o.rel}:${o.ligne},${_csv(note)}',
    );
  }
  File('produit/_correspondance.csv').writeAsStringSync(csv.toString());

  // Rapport de collisions ---------------------------------------------------
  final parId = <String, List<Occ>>{};
  for (final o in occs) {
    parId.putIfAbsent(o.id, () => []).add(o);
  }
  final b = StringBuffer()
    ..writeln('---')
    ..writeln('id: DOC-COLLISIONS')
    ..writeln('type: document')
    ..writeln('titre: "Collisions d’identifiants de conception/"')
    ..writeln('statut: mvp')
    ..writeln('sources: [brief:lot1]')
    ..writeln(
      'derniere_verif: ${DateTime.now().toIso8601String().substring(0, 10)}',
    )
    ..writeln('---')
    ..writeln()
    ..writeln('# Collisions d’identifiants de `conception/`')
    ..writeln()
    ..writeln(
      'Généré par `dart run tools/ctx_correspondance.dart`. Un identifiant est en '
      'collision quand le même texte désigne des objets différents (rôles '
      'distincts) ou est défini plusieurs fois. Dans `produit/`, chaque '
      'identifiant est typé (CAP-, ECR-, FLX-…) et unique ; l’ancien id est dans '
      '`anciens_ids` et dans `_correspondance.csv`.',
    )
    ..writeln();
  final collisions = parId.entries.where((e) => e.value.length > 1).toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  final reelles = collisions.where((e) => roles[e.key]!.length > 1).toList();
  final doublons = collisions.where((e) => roles[e.key]!.length == 1).toList();
  b
    ..writeln(
      'Total : ${occs.length} définitions, ${parId.length} identifiants distincts, '
      '${collisions.length} répétés (${reelles.length} avec plusieurs rôles, '
      '${doublons.length} définis plusieurs fois pour un même rôle).',
    )
    ..writeln()
    ..writeln('## Collisions de rôle')
    ..writeln()
    ..writeln('| ancien id | occurrences | rôles |')
    ..writeln('|---|---|---|');
  for (final e in reelles) {
    b.writeln(
      '| ${e.key} | ${e.value.length} | ${roles[e.key]!.join(' ; ')} |',
    );
  }
  b
    ..writeln()
    ..writeln('## Doublons de définition (même rôle)')
    ..writeln()
    ..writeln('| ancien id | rôle | sources |')
    ..writeln('|---|---|---|');
  for (final e in doublons) {
    b.writeln(
      '| ${e.key} | ${roles[e.key]!.first} | '
      '${e.value.map((o) => '${o.rel}:${o.ligne}').join(' ; ')} |',
    );
  }
  Directory('produit/decisions').createSync(recursive: true);
  File('produit/decisions/_collisions.md').writeAsStringSync(b.toString());

  stdout.writeln(
    'tools/ctx_correspondance: ${occs.length} lignes ($repris repris, '
    '$aEcrire à écrire, $nonRepris non repris) ; ${reelles.length} collisions de '
    'rôle, ${doublons.length} doublons.',
  );
}
