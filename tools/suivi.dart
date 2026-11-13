// Suivi hebdomadaire (ticket #125) : calcule un instantané des indicateurs de
// `docs/PROCESS.md` depuis GitHub (tickets, PR, CI, contributions par login)
// et le dépôt local (tests, couverture), sans aucune saisie. La date prévue
// d'un jalon cumule le reste des jalons d'échéance antérieure.
//
// Usage : dart run tools/suivi.dart [--depot Projet-decole/Histolyon]
//                                   [--sortie build/suivi]
//
// Écrit deux fichiers dans le dossier de sortie :
// - `instantane-AAAA-MM-JJ.json` : vue publique (client), sans aucun détail
//   par personne ;
// - `interne-AAAA-MM-JJ.json` : vue interne (contributions par personne).
// Le dossier par défaut (`build/`) est ignoré par git : la vue interne ne doit
// jamais être publiée, le dépôt est public.
//
// Prérequis : l'outil `gh` connecté à GitHub.

import 'dart:convert';
import 'dart:io';

import 'suivi_calculs.dart';
import 'suivi_donnees.dart';

Future<Object?> _gh(List<String> args) async {
  final r = await Process.run('gh', args);
  if (r.exitCode != 0) {
    throw StateError('gh ${args.join(' ')} : ${r.stderr}');
  }
  return jsonDecode(r.stdout as String);
}

String _option(List<String> args, String nom, String defaut) {
  final i = args.indexOf(nom);
  return i >= 0 && i + 1 < args.length ? args[i + 1] : defaut;
}

/// Lit le contenu des fichiers de tests du dépôt (clé = chemin relatif).
Map<String, String> _fichiersDeTests() {
  final contenus = <String, String>{};
  bool estTest(String chemin) =>
      (chemin.contains('/test/') || chemin.contains('/integration_test/')) &&
          chemin.endsWith('.dart') ||
      chemin.startsWith('test/tools/') && chemin.endsWith('_test.dart') ||
      chemin.startsWith('supabase/tests/database/') && chemin.endsWith('.sql');
  for (final racine in ['apps', 'packages', 'test', 'supabase']) {
    final dossier = Directory(racine);
    if (!dossier.existsSync()) continue;
    for (final f in dossier.listSync(recursive: true).whereType<File>()) {
      final chemin = f.path.replaceAll('\\', '/');
      if (chemin.contains('/.dart_tool/') || chemin.contains('/build/')) {
        continue;
      }
      if (estTest(chemin)) contenus[chemin] = f.readAsStringSync();
    }
  }
  return contenus;
}

/// Contributions des quatre dernières semaines sur la branche par défaut,
/// par login GitHub (voir `contributionsDepuisCommits`).
Future<Map<String, int>> _contributions(
  String depot,
  DateTime maintenant,
) async {
  final depuis = maintenant
      .subtract(const Duration(days: 28))
      .toIso8601String();
  // Pages lues une à une : `gh api --paginate --slurp` n'existe pas dans
  // toutes les versions de `gh`.
  final commits = <dynamic>[];
  for (var page = 1; ; page++) {
    final lot = await _gh([
      'api',
      'repos/$depot/commits?since=$depuis&per_page=100&page=$page',
    ]) as List;
    commits.addAll(lot);
    if (lot.length < 100) break;
  }
  return contributionsDepuisCommits(commits);
}

Future<void> main(List<String> args) async {
  final depot = _option(args, '--depot', 'Projet-decole/Histolyon');
  final sortie = Directory(_option(args, '--sortie', 'build/suivi'));
  final maintenant = DateTime.now().toUtc();

  final tickets = [
    for (final j in await _gh([
      'issue',
      'list',
      '--repo',
      depot,
      '--state',
      'all',
      '--limit',
      '1000',
      '--json',
      'number,state,createdAt,closedAt,updatedAt,labels,milestone,assignees',
    ]) as List)
      ticketDepuisJson(j as Map<String, dynamic>),
  ];
  final prs = [
    for (final j in await _gh([
      'pr',
      'list',
      '--repo',
      depot,
      '--state',
      'all',
      '--limit',
      // 40 PR récentes : au-delà, la requête GraphQL (commits et auteurs de
      // chaque PR) dépasse la limite de 500 000 nœuds de GitHub. Les fenêtres
      // du suivi (8 semaines) en contiennent bien moins.
      '40',
      '--json',
      'number,author,headRefName,state,createdAt,mergedAt,commits,reviews',
    ]) as List)
      prDepuisJson(j as Map<String, dynamic>),
  ];
  final runs = [
    for (final j in await _gh([
      'run',
      'list',
      '--repo',
      depot,
      '--limit',
      '500',
      '--json',
      'conclusion,createdAt,status,event',
    ]) as List)
      if ((j as Map)['status'] == 'completed' && j['event'] == 'pull_request')
        RunCi(
          j['conclusion'] == 'success',
          DateTime.parse(j['createdAt'] as String).toUtc(),
        ),
  ];
  final jalons = await _gh([
    'api',
    'repos/$depot/milestones?state=all&per_page=100',
  ]) as List;

  final charges = chargesParJalon(tickets, ouverturesJalons(jalons));
  final debit = debitParSemaine(tickets, maintenant);
  final flux = fluxEnCours(tickets, prs, maintenant);

  final lcov = File('apps/mobile/coverage/lcov.info');
  final contributions = await _contributions(depot, maintenant);
  final datesPrevues = datesPrevuesCumulees(
    charges: charges,
    echeances: echeancesJalons(jalons),
    debit: debit,
    maintenant: maintenant,
  );

  final publique = instantane(
    date: maintenant,
    charges: charges,
    debit: debit,
    datePrevueJalon: datesPrevues,
    tempsCycleJours: tempsCycleMedianJours(prs, maintenant),
    ageMaxEnCoursJours: flux.ageMaxJours,
    sansMouvement: flux.sansMouvement,
    delaiRelectureJours: delaiPremiereRelectureMedianJours(prs),
    partRelueParAutrePct: partRelueParAutre(prs),
    tests: compterTests(_fichiersDeTests()),
    couverturePct: lcov.existsSync()
        ? couvertureLcov(lcov.readAsStringSync())
        : null,
    ciVertePct: partCiVerte(runs, maintenant),
    pins: pinsParEtat(tickets),
    modele3d: etat3d(tickets),
  );
  final interne = instantaneInterne(
    date: maintenant,
    contributions: contributions,
  );

  sortie.createSync(recursive: true);
  final jour = publique['date'];
  const encodeur = JsonEncoder.withIndent('  ');
  File('${sortie.path}/instantane-$jour.json')
      .writeAsStringSync('${encodeur.convert(publique)}\n');
  File('${sortie.path}/interne-$jour.json')
      .writeAsStringSync('${encodeur.convert(interne)}\n');

  stdout.writeln(
    'Suivi du $jour (débit : ${debit.toStringAsFixed(1)} par semaine)',
  );
  for (final e in datesPrevues.entries) {
    final c = charges[e.key]!;
    final pct = c.total == 0 ? 0 : (c.terminee / c.total * 100).round();
    final prevue = e.value;
    stdout.writeln(
      '  ${e.key} : ${c.terminee}/${c.total} (${pct} %), reste ${c.restante}, '
      'ajouté ${c.ajoutee}, fin prévue (cumulée) '
      '${prevue == null ? 'inconnue (débit nul)' : prevue.toIso8601String().substring(0, 10)}',
    );
  }
  stdout.writeln('Fichiers écrits dans ${sortie.path}/');
}
