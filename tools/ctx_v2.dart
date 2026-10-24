// `ctx` v2 : lecture, recherche et validation du corpus `produit/`.
//
// Sous-commandes (appelées depuis tools/ctx.dart) :
//   lire <ID|chemin>            imprime l'unité (ou la section) demandée
//   pack <CAP-…> [--complet]    fiche + écrans + flux + entités + invariants
//                               + composants (résumés) + décisions, avec coût
//   chercher "<texte>"          plein texte, insensible aux accents
//   refs <ID>                   liens entrants déduits
//   liste [--type …] [--statut mvp|s2|hors-perimetre]
//   chemin <ID>                 fichier (et ligne) de l'identifiant
//   check                       validation, code retour ≠ 0 si erreur
//
// Option globale : `--produit <dossier>` (défaut `produit/`).

import 'dart:io';

import 'ctx_check.dart';
import 'ctx_corpus.dart';

const sousCommandes = {'lire', 'pack', 'chercher', 'refs', 'liste', 'chemin', 'check'};

const _stop = {
  'le', 'la', 'les', 'de', 'du', 'des', 'un', 'une', 'et', 'ou', 'que', 'qui',
  'quoi', 'ce', 'se', 'sur', 'si', 'on', 'est', 'a', 'en', 'pour', 'par',
  'dans', 'd', 'l', 'quel', 'quelle', 'quels', 'quelles', 'quand', 'comment',
  'au', 'aux', 'il', 'elle', 'qu', 'y', 'ne', 'pas', 'son', 'sa', 'ses',
  'tape', 'passe',
};

int runV2(List<String> argsBrut) {
  var args = [...argsBrut];
  var dossier = 'produit';
  final i = args.indexOf('--produit');
  if (i != -1 && i + 1 < args.length) {
    dossier = args[i + 1];
    args.removeRange(i, i + 2);
  }
  final cmd = args.first;
  final reste = args.sublist(1);
  final dir = Directory(dossier);
  if (!dir.existsSync()) {
    stderr.writeln("tools/ctx: dossier '$dossier/' introuvable depuis ${Directory.current.path}.");
    return 1;
  }
  final corpus = Corpus.charge(dir);
  switch (cmd) {
    case 'lire':
      return _lire(corpus, reste);
    case 'pack':
      return _pack(corpus, reste);
    case 'chercher':
      return _chercher(corpus, reste);
    case 'refs':
      return _refs(corpus, reste);
    case 'liste':
      return _liste(corpus, reste);
    case 'chemin':
      return _chemin(corpus, reste);
    case 'check':
      return _check(corpus);
  }
  return 1;
}

int _lire(Corpus c, List<String> a) {
  if (a.length != 1) {
    stderr.writeln('Usage: ctx lire <ID|chemin>');
    return 1;
  }
  final e = c.resous(a[0]);
  if (e != null) {
    stdout.writeln(c.texte(e));
    return 0;
  }
  final u = c.parChemin(a[0]);
  if (u != null) {
    stdout.write(u.raw);
    return 0;
  }
  stderr.writeln("tools/ctx: '${a[0]}' introuvable dans produit/.");
  return 1;
}

int _chemin(Corpus c, List<String> a) {
  if (a.length != 1) {
    stderr.writeln('Usage: ctx chemin <ID>');
    return 1;
  }
  final e = c.resous(a[0]);
  if (e == null) {
    stderr.writeln("tools/ctx: identifiant '${a[0]}' introuvable.");
    return 1;
  }
  stdout.writeln('produit/${e.unit.rel}:${e.ligne}');
  return 0;
}

int _liste(Corpus c, List<String> a) {
  String? type;
  String? statut;
  for (var i = 0; i < a.length; i++) {
    if (a[i] == '--type' && i + 1 < a.length) type = a[++i];
    if (a[i] == '--statut' && i + 1 < a.length) statut = a[++i];
  }
  final lignes = <String>[];
  var total = 0;
  for (final u in c.units) {
    if (u.id.isEmpty) continue;
    if (type != null && u.type != type && !u.id.startsWith('${type.toUpperCase()}-')) continue;
    if (statut != null && u.statut != statut) continue;
    lignes.add('${u.id}\t${u.statut}\t${u.tokens}\t${u.titre}');
    total += u.tokens;
  }
  lignes.forEach(stdout.writeln);
  stdout.writeln('-- ${lignes.length} unités, ≈ $total tokens');
  return 0;
}

int _refs(Corpus c, List<String> a) {
  if (a.length != 1) {
    stderr.writeln('Usage: ctx refs <ID>');
    return 1;
  }
  final id = a[0];
  final cible = c.resous(id);
  if (cible == null) {
    stderr.writeln("tools/ctx: identifiant '$id' introuvable.");
    return 1;
  }
  var n = 0;
  for (final u in c.units) {
    final propre = u.id == id || (cible.unit == u);
    if (propre) continue;
    final viaLien = u.tousLiens.contains(id);
    final viaTexte = idsCites(u.body).contains(id);
    if (viaLien || viaTexte) {
      stdout.writeln('${u.id}\t${u.type}\t${viaLien ? 'lien' : 'texte'}\t${u.titre}');
      n++;
    }
  }
  stdout.writeln('-- $n référence(s) entrante(s)');
  return 0;
}

// ---------------------------------------------------------------------------
// pack
// ---------------------------------------------------------------------------

/// Résumé d'un composant : titre + 3 premières lignes utiles du corps.
String resumeComposant(Unit u) {
  final lignes = u.body
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty && !l.startsWith('#'))
      .take(3);
  return '- ${u.id} — ${u.titre}\n${lignes.map((l) => '  $l').join('\n')}';
}

/// Contenu du pack d'une capacité. `complet` : composants intégraux.
String construitPack(Corpus c, Unit cap, {bool complet = false}) {
  final b = StringBuffer();
  void section(String t) => b.writeln('\n==== $t ====\n');
  void unite(String id) {
    final e = c.resous(id);
    if (e == null) return;
    b.writeln(c.texte(e));
    b.writeln();
  }

  b.writeln(cap.raw.trimRight());
  final liens = cap.liens;
  final ecrans = liens['ecrans'] ?? [];
  if (ecrans.isNotEmpty) section('Écrans (images citées par chemin, non inlinées)');
  for (final id in ecrans) {
    unite(id);
  }
  final flux = liens['flux'] ?? [];
  if (flux.isNotEmpty) section('Flux');
  for (final id in flux) {
    unite(id);
  }
  final ent = liens['entites'] ?? [];
  final inv = liens['invariants'] ?? [];
  if (ent.isNotEmpty || inv.isNotEmpty) section('Entités et invariants');
  for (final id in [...ent, ...inv]) {
    unite(id);
  }
  // Composants : ceux de la fiche + ceux des écrans cités.
  final comps = <String>{...(liens['composants'] ?? [])};
  for (final id in ecrans) {
    final u = c.resous(id)?.unit;
    if (u != null) comps.addAll(u.liens['composants'] ?? []);
  }
  if (comps.isNotEmpty) section(complet ? 'Composants (complet)' : 'Composants (résumés)');
  for (final id in comps) {
    final u = c.resous(id)?.unit;
    if (u == null) continue;
    b.writeln(complet ? u.raw.trimRight() : resumeComposant(u));
    if (complet) b.writeln();
  }
  final dec = liens['decisions'] ?? [];
  if (dec.isNotEmpty) section('Décisions');
  for (final id in dec) {
    unite(id);
  }
  return b.toString();
}

int coutPackCap(Corpus c, Unit cap) => estimeTokens(construitPack(c, cap));

int _pack(Corpus c, List<String> a) {
  final complet = a.contains('--complet');
  final ids = a.where((x) => !x.startsWith('--')).toList();
  if (ids.length != 1) {
    stderr.writeln('Usage: ctx pack <CAP-…> [--complet]');
    return 1;
  }
  final e = c.resous(ids[0]);
  if (e == null || e.unit.type != 'capacite') {
    stderr.writeln("tools/ctx: '${ids[0]}' n'est pas une capacité.");
    return 1;
  }
  final txt = construitPack(c, e.unit, complet: complet);
  stdout.write(txt);
  final cout = estimeTokens(txt);
  stdout.writeln('\n-- coût du pack : ≈ $cout tokens${complet ? ' (complet)' : ''}');
  if (cout > plafondPack) {
    stdout.writeln('-- AVERTISSEMENT : au-delà de $plafondPack tokens');
  }
  return 0;
}

// ---------------------------------------------------------------------------
// chercher
// ---------------------------------------------------------------------------

String _racine(String t) {
  var s = t;
  if (s.length > 3 && (s.endsWith('s') || s.endsWith('x'))) s = s.substring(0, s.length - 1);
  if (s.length >= 7) s = s.substring(0, s.length - 2);
  return s;
}

List<String> termesRequete(String q) {
  final mots = normalise(q)
      .split(RegExp(r"[^a-z0-9]+"))
      .where((m) => m.isNotEmpty && !_stop.contains(m) && (m.length > 1 || RegExp(r'\d').hasMatch(m)))
      .toList();
  return mots.map(_racine).toList();
}

class Resultat {
  Resultat(this.entree, this.score, this.extrait);
  final Entree entree;
  final double score;
  final String extrait;
}

List<Resultat> cherche(Corpus c, String requete, {int max = 10}) {
  final termes = termesRequete(requete);
  if (termes.isEmpty) return [];
  final phrase = normalise(requete).trim();
  final res = <Resultat>[];
  final vus = <Entree>[];
  for (final l in c.registre.values) {
    vus.addAll(l);
  }
  // Unités sans id (aucune ne devrait exister) ignorées.
  for (final e in vus) {
    final titre = normalise(e.titre);
    final id = normalise(e.id);
    final anciens = normalise(e.unit.listOf('anciens_ids').join(' '));
    final corps = normalise(
      e.section != null ? e.section!.texte : '${e.unit.titre}\n${e.unit.body}',
    );
    var score = 0.0;
    var trouves = 0;
    for (final t in termes) {
      var s = 0.0;
      if (titre.contains(t)) s += 10;
      if (id.contains(t)) s += 6;
      if (anciens.contains(t)) s += 4;
      final n = t.allMatches(corps).length;
      if (n > 0) s += 1 + (n > 4 ? 4 : n - 1) * 0.5;
      if (s > 0) trouves++;
      score += s;
    }
    if (trouves == 0) continue;
    score *= 0.5 + 0.5 * trouves / termes.length;
    if (trouves == termes.length && termes.length > 1) score += 5;
    if (phrase.length > 4 && titre.contains(phrase)) score += 8;
    if (phrase.length > 4 && corps.contains(phrase)) score += 4;
    // Une section précise l'emporte sur son fichier entier à score égal.
    if (e.section != null) score += 0.5;
    res.add(Resultat(e, score, _extrait(e, termes)));
  }
  res.sort((a, b) {
    final d = b.score.compareTo(a.score);
    return d != 0 ? d : a.entree.id.compareTo(b.entree.id);
  });
  return res.take(max).toList();
}

String _extrait(Entree e, List<String> termes) {
  final lignes = (e.section?.texte ?? e.unit.body).split('\n');
  var meilleure = '';
  var meilleurN = 0;
  for (final l in lignes) {
    final n = normalise(l);
    final k = termes.where(n.contains).length;
    if (k > meilleurN && l.trim().isNotEmpty) {
      meilleurN = k;
      meilleure = l.trim();
    }
  }
  if (meilleure.isEmpty) return '';
  return meilleure.length > 140 ? '${meilleure.substring(0, 140)}…' : meilleure;
}

int _chercher(Corpus c, List<String> a) {
  if (a.isEmpty) {
    stderr.writeln('Usage: ctx chercher "<texte>"');
    return 1;
  }
  final res = cherche(c, a.join(' '));
  if (res.isEmpty) {
    stdout.writeln('Aucun résultat.');
    return 0;
  }
  for (final r in res) {
    stdout.writeln('${r.entree.id}\t${r.entree.statut}\t${r.entree.titre}');
    if (r.extrait.isNotEmpty) stdout.writeln('    ${r.extrait}');
  }
  return 0;
}

// ---------------------------------------------------------------------------
// check
// ---------------------------------------------------------------------------

int _check(Corpus c) {
  final r = verifie(c, coutPack: coutPackCap);
  for (final w in r.avertissements) {
    stdout.writeln('AVERT  $w');
  }
  for (final e in r.erreurs) {
    stdout.writeln('ERREUR $e');
  }
  final mvp = c.units.where((u) => u.statut == 'mvp').length;
  stdout.writeln(
    '-- ${c.units.length} fichiers, $mvp unités mvp, '
    '${r.erreurs.length} erreur(s), ${r.avertissements.length} avertissement(s)',
  );
  return r.erreurs.isEmpty ? 0 : 1;
}
