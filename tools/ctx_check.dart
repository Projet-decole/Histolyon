// `ctx check` : validation de `produit/` (identifiants, frontmatter, liens,
// budgets, motifs interdits, périmètre MVP, sources).

import 'dart:io';

import 'package:yaml/yaml.dart';

import 'ctx_corpus.dart';

const statutsValides = {'mvp', 's2', 'hors-perimetre'};
const clesLiens = {
  'ecrans': 'ECR',
  'flux': 'FLX',
  'entites': 'ENT',
  'invariants': 'INV',
  'composants': 'COMP',
  'decisions': 'DEC',
  'capacites': 'CAP',
  'questions': 'QO',
};

/// Plafond de `ctx pack` pour une capacité (tokens).
const plafondPack = 8000;

/// Motifs interdits dans `produit/` (hors `decisions/` et le rapport, qui
/// peuvent les citer pour expliquer leur retrait).
final motifsInterdits = <RegExp>[
  RegExp(r'design/conception'),
  RegExp(r'palier 16', caseSensitive: false),
  RegExp(r'persona_check'),
];

/// Calcule le coût d'un pack, injecté pour éviter une dépendance circulaire.
typedef CoutPack = int Function(Corpus c, Unit cap);

class Rapport {
  final erreurs = <String>[];
  final avertissements = <String>[];
}

Rapport verifie(Corpus c, {required CoutPack coutPack}) {
  final r = Rapport();
  void err(Unit? u, String m) => r.erreurs.add(u == null ? m : '${u.rel}: $m');

  // Frontmatter et schéma ---------------------------------------------------
  for (final u in c.units) {
    if (u.parseError != null) {
      err(u, u.parseError!);
      continue;
    }
    final f = u.front;
    for (final k in ['id', 'type', 'titre', 'statut', 'derniere_verif']) {
      if (f[k] == null || '${f[k]}'.trim().isEmpty)
        err(u, 'clé "$k" manquante');
    }
    if (u.id.isNotEmpty && !idPattern.hasMatch(u.id)) {
      err(u, 'identifiant "${u.id}" invalide (PREFIXE-MAJUSCULES)');
    }
    if (u.statut.isNotEmpty && !statutsValides.contains(u.statut)) {
      err(u, 'statut "${u.statut}" invalide');
    }
    final prefixe = u.id.split('-').first;
    final attendu = typeParPrefixe[prefixe];
    if (attendu != null && u.type != attendu) {
      err(u, 'type "${u.type}" ≠ "$attendu" attendu pour $prefixe-');
    }
    if (attendu != null) {
      final nomFichier = u.rel.split('/').last;
      if (nomFichier != '${u.id}.md') err(u, 'nom de fichier ≠ ${u.id}.md');
    }
    for (final k in ['liens', 'anciens_ids', 'sources']) {
      if (attendu != null && !f.containsKey(k)) err(u, 'clé "$k" manquante');
    }
    if (f['liens'] != null && f['liens'] is! Map)
      err(u, '"liens" doit être une table');
    if (f['sources'] != null && f['sources'] is! List)
      err(u, '"sources" doit être une liste');
    if (f['anciens_ids'] != null && f['anciens_ids'] is! List) {
      err(u, '"anciens_ids" doit être une liste');
    }
    if (u.type == 'capacite') {
      for (final k in ['priorite', 'jalon', 'budget_tokens']) {
        if (f[k] == null) err(u, 'clé "$k" manquante (capacité)');
      }
    }
    if (attendu != null && u.statut == 'mvp' && u.listOf('sources').isEmpty) {
      err(u, 'unité mvp sans source');
    }
    for (final s in u.listOf('sources')) {
      _verifieSource(c, u, s, err);
    }
  }

  // Identifiants uniques ----------------------------------------------------
  c.registre.forEach((id, l) {
    if (l.length > 1) {
      err(
        null,
        'identifiant en double $id : ${l.map((e) => e.unit.rel).join(', ')}',
      );
    }
  });

  // Liens résolus -----------------------------------------------------------
  for (final u in c.units) {
    u.liens.forEach((cle, ids) {
      final pref = clesLiens[cle];
      if (pref == null) {
        err(u, 'clé de liens inconnue "$cle"');
        return;
      }
      for (final id in ids) {
        if (!id.startsWith('$pref-')) {
          err(u, 'lien "$id" dans "$cle" : préfixe $pref- attendu');
        } else if (c.resous(id) == null) {
          err(u, 'lien non résolu "$id" ($cle)');
        }
      }
    });
    // Références inline dans le corps : doivent exister.
    if (u.rel.startsWith('decisions/_')) continue;
    for (final id in idsCites(u.body)) {
      if (c.resous(id) == null)
        err(u, 'référence non résolue "$id" dans le corps');
    }
  }

  // Budgets -----------------------------------------------------------------
  for (final u in c.units) {
    final plafond = budgetParType[u.type];
    if (plafond == null) continue;
    if (u.tokens > plafond) {
      err(u, 'budget dépassé : ${u.tokens} > $plafond tokens');
    }
    final decl = u.front['budget_tokens'];
    if (decl is int && decl > plafond) {
      err(u, 'budget_tokens déclaré $decl > plafond $plafond');
    }
    if (decl is int && u.tokens > decl) {
      err(u, 'budget_tokens déclaré $decl < mesure ${u.tokens}');
    }
  }
  for (final u in c.units.where(
    (u) => u.type == 'capacite' && u.statut == 'mvp',
  )) {
    final cout = coutPack(c, u);
    if (cout > plafondPack) err(u, 'ctx pack ≈ $cout tokens > $plafondPack');
  }

  // Motifs interdits --------------------------------------------------------
  final fichiers = <String, String>{for (final u in c.units) u.rel: u.raw};
  final csv = File('${c.produitDir.path}/_correspondance.csv');
  fichiers.forEach((rel, txt) {
    if (rel.startsWith('decisions/') || rel.startsWith('RAPPORT')) return;
    for (final m in motifsInterdits) {
      if (m.hasMatch(txt)) r.erreurs.add('$rel: motif interdit "${m.pattern}"');
    }
  });

  // Correspondance ----------------------------------------------------------
  if (csv.existsSync()) {
    final lignes = csv.readAsLinesSync();
    for (var i = 1; i < lignes.length; i++) {
      final cols = _csvCols(lignes[i]);
      if (cols.length < 3) {
        err(null, '_correspondance.csv:${i + 1} : moins de 3 colonnes');
        continue;
      }
      final nouveau = cols[1];
      if (nouveau.isNotEmpty && nouveau != '—' && c.resous(nouveau) == null) {
        // Les cibles non encore écrites sont tolérées seulement si la note le dit.
        final note = cols.length > 3 ? cols[3] : '';
        if (!note.startsWith('non-repris') && !note.startsWith('a-ecrire')) {
          err(
            null,
            '_correspondance.csv:${i + 1} : cible "$nouveau" introuvable',
          );
        }
      }
    }
  } else {
    r.avertissements.add('_correspondance.csv absent');
  }

  // Périmètre MVP -----------------------------------------------------------
  final per = File('${c.produitDir.path}/_perimetre-mvp.yaml');
  if (!per.existsSync()) {
    r.avertissements.add('_perimetre-mvp.yaml absent : périmètre non vérifié');
  } else {
    final y = loadYaml(per.readAsStringSync());
    if (y is YamlMap) {
      y.forEach((cle, val) {
        if (cle == 'cap_adressables') {
          final n = c.units.where((u) => u.type == 'capacite').length;
          if (n != val) err(null, 'capacités adressables : $n ≠ $val attendu');
          return;
        }
        if (val is! YamlList) return;
        for (final id in val) {
          final e = c.resous('$id');
          if (e == null) {
            err(null, 'périmètre MVP : "$id" absent');
          } else if (cle == 'capacites' && e.unit.statut != 'mvp') {
            err(null, 'périmètre MVP : "$id" devrait être statut mvp');
          }
        }
      });
    }
  }
  return r;
}

void _verifieSource(
  Corpus c,
  Unit u,
  String s,
  void Function(Unit?, String) err,
) {
  final t = s.trim();
  if (t.startsWith('brief:') || t.startsWith('DEC-')) return;
  final m = RegExp(
    r'^((?:(?:conception|content|packages|produit|supabase|apps|docs)/[^:\s]+|AGENTS\.md))(?::(\d+)(?:-(\d+))?)?(?:\s.*)?$',
  ).firstMatch(t);
  if (m == null) {
    err(u, 'source illisible "$t" (attendu chemin:ligne)');
    return;
  }
  final f = File('${c.racine.path}/${m.group(1)}');
  if (!f.existsSync()) {
    err(u, 'source introuvable "${m.group(1)}"');
    return;
  }
  final ligne = m.group(2);
  if (ligne != null) {
    final n = f.readAsLinesSync().length;
    final hi = int.parse(m.group(3) ?? ligne);
    if (int.parse(ligne) < 1 || hi > n) {
      err(u, 'source "$t" : ligne hors fichier ($n lignes)');
    }
  }
}

List<String> _csvCols(String l) {
  final out = <String>[];
  final b = StringBuffer();
  var q = false;
  for (var i = 0; i < l.length; i++) {
    final ch = l[i];
    if (ch == '"') {
      if (q && i + 1 < l.length && l[i + 1] == '"') {
        b.write('"');
        i++;
      } else {
        q = !q;
      }
    } else if (ch == ',' && !q) {
      out.add(b.toString());
      b.clear();
    } else {
      b.write(ch);
    }
  }
  out.add(b.toString());
  return out;
}
