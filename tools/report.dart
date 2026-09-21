import 'dart:convert';
import 'dart:io';

// Story 11.2 (AD-17) : rapport d'avancement calculé depuis GitHub — stories
// `socle` fermées par domaine, délai médian story -> fusion, taux de CI
// verte. Écrit docs/sprint/reports/<date>.md.
//
// Usage : dart run tools/report.dart
// GITHUB_TOKEN optionnel (l'API GitHub publique fonctionne sans, mais avec
// une limite de débit basse — un token la relève nettement).

const _owner = 'Projet-decole';
const _repo = 'Histolyon';
const _domaines = [
  'D1',
  'D2',
  'D3',
  'D4',
  'D5',
  'D6',
  'D7',
  'D8',
  'D9',
  'D10',
  'D11',
];
const _dossierRapports = 'docs/sprint/reports';

Future<void> main() async {
  final gh = _GitHub(Platform.environment['GITHUB_TOKEN']);

  final List<_Issue> issues;
  try {
    issues = await gh.issuesFermees(label: 'socle');
  } catch (e) {
    stderr.writeln('tools/report : impossible de lire les issues — $e');
    exitCode = 1;
    return;
  }
  stdout.writeln('tools/report : ${issues.length} issue(s) socle fermée(s).');

  final lignes = <_LigneRapport>[];
  for (final issue in issues) {
    final pr = await gh.trouverPrFermante(issue);
    final delaiApproxime = pr?.mergedAt == null;
    final delaiJours = pr?.mergedAt != null
        ? pr!.mergedAt!.difference(issue.createdAt).inHours / 24
        : issue.closedAt.difference(issue.createdAt).inHours / 24;
    final ciVerte = pr != null ? await gh.ciVerte(pr.mergeCommitSha) : null;
    lignes.add(
      _LigneRapport(
        issue: issue,
        pr: pr,
        delaiJours: delaiJours,
        delaiApproxime: delaiApproxime,
        ciVerte: ciVerte,
      ),
    );
  }
  gh.close();

  final rapport = _genererMarkdown(lignes);
  final aujourdhui = DateTime.now().toUtc();
  final nomFichier =
      '${aujourdhui.year.toString().padLeft(4, '0')}-'
      '${aujourdhui.month.toString().padLeft(2, '0')}-'
      '${aujourdhui.day.toString().padLeft(2, '0')}';

  final dossier = Directory(_dossierRapports)..createSync(recursive: true);
  final fichier = File('${dossier.path}/$nomFichier.md');
  fichier.writeAsStringSync(rapport);
  stdout.writeln('tools/report : ${fichier.path} écrit.');
}

double _mediane(List<double> valeurs) {
  if (valeurs.isEmpty) return 0;
  final triees = [...valeurs]..sort();
  final n = triees.length;
  return n.isOdd ? triees[n ~/ 2] : (triees[n ~/ 2 - 1] + triees[n ~/ 2]) / 2;
}

String _genererMarkdown(List<_LigneRapport> lignes) {
  final parDomaine = <String, List<_LigneRapport>>{};
  for (final ligne in lignes) {
    final domaine = ligne.issue.labels.firstWhere(
      _domaines.contains,
      orElse: () => 'socle (bootstrap, sans domaine produit)',
    );
    parDomaine.putIfAbsent(domaine, () => []).add(ligne);
  }

  final delaiMedian = _mediane(lignes.map((l) => l.delaiJours).toList());
  final approximees = lignes.where((l) => l.delaiApproxime).length;

  final avecDonneesCi = lignes.where((l) => l.ciVerte != null).toList();
  final tauxCiVerte = avecDonneesCi.isEmpty
      ? null
      : avecDonneesCi.where((l) => l.ciVerte == true).length /
            avecDonneesCi.length;

  final buffer = StringBuffer();
  final date = DateTime.now().toUtc().toIso8601String().split('T').first;

  buffer.writeln('# Rapport d\'avancement — $date');
  buffer.writeln();
  buffer.writeln(
    'Calculé depuis GitHub (${lignes.length} stories `socle` fermées). '
    'Généré par `dart run tools/report.dart` — ne pas éditer à la main, '
    'régénérer.',
  );
  buffer.writeln();
  buffer.writeln('## Indicateurs');
  buffer.writeln();
  buffer.write('- **Délai médian story → fusion** : ');
  buffer.write('${delaiMedian.toStringAsFixed(1)} jour(s)');
  if (approximees > 0) {
    buffer.write(
      ' (⚠️ $approximees/${lignes.length} calculés depuis la date de '
      "fermeture de l'issue faute de PR identifiée — voir « Limites » ci-dessous)",
    );
  }
  buffer.writeln('.');
  if (tauxCiVerte != null) {
    buffer.writeln(
      '- **Taux de CI verte** : ${(tauxCiVerte * 100).toStringAsFixed(0)}% '
      '(sur ${avecDonneesCi.length}/${lignes.length} stories avec au moins '
      'un run CI enregistré).',
    );
  } else {
    buffer.writeln(
      '- **Taux de CI verte** : N/A — aucun run CI enregistré sur les '
      'stories fermées à ce jour (les workflows `ci-mobile`/`ci-admin`, '
      'Story 9.1/9.2, sont postérieurs à la plupart des fusions).',
    );
  }
  buffer.writeln();

  buffer.writeln('## Par domaine');
  buffer.writeln();
  for (final domaine in (parDomaine.keys.toList()..sort())) {
    final lignesDomaine = parDomaine[domaine]!;
    buffer.writeln('### $domaine (${lignesDomaine.length})');
    buffer.writeln();
    for (final ligne in lignesDomaine) {
      final ci = ligne.ciVerte == null ? '—' : (ligne.ciVerte! ? '✅' : '❌');
      final prTxt = ligne.pr != null
          ? '#${ligne.pr!.number}'
          : '(PR non identifiée)';
      buffer.writeln(
        '- #${ligne.issue.number} ${ligne.issue.title} — $prTxt, '
        '${ligne.delaiJours.toStringAsFixed(1)} j, CI $ci',
      );
    }
    buffer.writeln();
  }

  buffer.writeln('## Limites connues de ce rapport (v0)');
  buffer.writeln();
  buffer.writeln(
    '- Toutes les stories fermées à ce jour ne portent que le label '
    '`socle` (bootstrap) — aucune n\'a encore de label de domaine produit '
    '`D1`…`D11`, qui s\'appliqueront aux futures stories de feature '
    '(Epic 8 et au-delà).',
  );
  buffer.writeln(
    '- Le taux de CI verte ne compte que les stories dont la PR de fusion '
    'a déclenché au moins un run CI enregistré par GitHub.',
  );
  if (approximees > 0) {
    buffer.writeln(
      '- $approximees story(ies) sans PR de fusion identifiée '
      'automatiquement (recherche du texte « Closes #N » dans les PR '
      'mergées, puis repli sur un commentaire de rattrapage) : leur délai '
      "est calculé depuis la fermeture de l'issue, qui peut ne pas "
      'refléter la date réelle de fusion.',
    );
  }

  return buffer.toString();
}

class _Issue {
  _Issue({
    required this.number,
    required this.title,
    required this.labels,
    required this.createdAt,
    required this.closedAt,
  });

  final int number;
  final String title;
  final List<String> labels;
  final DateTime createdAt;
  final DateTime closedAt;
}

class _PullRequest {
  _PullRequest({
    required this.number,
    required this.mergedAt,
    required this.mergeCommitSha,
  });

  final int number;
  final DateTime? mergedAt;
  final String? mergeCommitSha;
}

class _LigneRapport {
  _LigneRapport({
    required this.issue,
    required this.pr,
    required this.delaiJours,
    required this.delaiApproxime,
    required this.ciVerte,
  });

  final _Issue issue;
  final _PullRequest? pr;
  final double delaiJours;
  final bool delaiApproxime;
  final bool? ciVerte;
}

/// Client HTTP minimal contre l'API REST GitHub — pas de dépendance pub
/// tierce, même convention que le reste de tools/.
class _GitHub {
  _GitHub(this._token) : _client = HttpClient();

  final String? _token;
  final HttpClient _client;

  Future<dynamic> _get(String path, {Map<String, String>? query}) async {
    final uri = Uri.https('api.github.com', path, query);
    final request = await _client.getUrl(uri);
    request.headers
      ..set('Accept', 'application/vnd.github+json')
      ..set('User-Agent', 'histolyon-tools-report')
      ..set('X-GitHub-Api-Version', '2022-11-28');
    if (_token != null) {
      request.headers.set('Authorization', 'Bearer $_token');
    }
    final response = await request.close();
    final corps = await response.transform(utf8.decoder).join();
    if (response.statusCode >= 300) {
      throw 'GET $path -> HTTP ${response.statusCode} : $corps';
    }
    return jsonDecode(corps);
  }

  Future<List<_Issue>> issuesFermees({required String label}) async {
    final resultat = <_Issue>[];
    var page = 1;
    while (true) {
      final data = await _get(
        '/repos/$_owner/$_repo/issues',
        query: {
          'labels': label,
          'state': 'closed',
          'per_page': '100',
          'page': '$page',
        },
      ) as List;
      if (data.isEmpty) break;
      for (final item in data) {
        if (item['pull_request'] != null) continue; // exclut les PR
        resultat.add(
          _Issue(
            number: item['number'] as int,
            title: item['title'] as String,
            labels: (item['labels'] as List)
                .map((l) => l['name'] as String)
                .toList(),
            createdAt: DateTime.parse(item['created_at'] as String),
            closedAt: DateTime.parse(item['closed_at'] as String),
          ),
        );
      }
      if (data.length < 100) break;
      page++;
    }
    return resultat;
  }

  /// Cherche la PR qui a fermé l'issue : d'abord la convention native
  /// (« Closes #N » dans le corps d'une PR mergée), puis en repli le
  /// commentaire de rattrapage (« mergée via #N ») posé lors du nettoyage
  /// de traçabilité du 2026-09-21 pour les stories mergées avant
  /// l'adoption de cette convention.
  Future<_PullRequest?> trouverPrFermante(_Issue issue) async {
    try {
      final recherche = await _get(
        '/search/issues',
        query: {'q': 'repo:$_owner/$_repo is:pr is:merged "#${issue.number}"'},
      );
      final regexCloses = RegExp(
        'clos(?:es|e|ing) #${issue.number}\\b',
        caseSensitive: false,
      );
      for (final item in (recherche['items'] as List)) {
        final corps = item['body'] as String? ?? '';
        if (regexCloses.hasMatch(corps)) {
          final pr = await _pr(item['number'] as int);
          if (pr != null) return pr;
        }
      }
    } catch (_) {
      // Recherche indisponible (rate limit, réseau) — repli ci-dessous.
    }

    try {
      final commentaires = await _get(
        '/repos/$_owner/$_repo/issues/${issue.number}/comments',
      ) as List;
      final regexVia = RegExp(r'via #(\d+)');
      for (final commentaire in commentaires) {
        final m = regexVia.firstMatch(commentaire['body'] as String? ?? '');
        if (m != null) {
          final pr = await _pr(int.parse(m.group(1)!));
          if (pr != null) return pr;
        }
      }
    } catch (_) {
      // Idem.
    }

    return null;
  }

  Future<_PullRequest?> _pr(int numero) async {
    try {
      final data = await _get('/repos/$_owner/$_repo/pulls/$numero');
      return _PullRequest(
        number: numero,
        mergedAt: data['merged_at'] != null
            ? DateTime.parse(data['merged_at'] as String)
            : null,
        mergeCommitSha: data['merge_commit_sha'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  /// `true`/`false` si des check-runs existent pour ce commit, `null` si
  /// aucun run n'a jamais été enregistré (CI trop récente, ou requête
  /// indisponible).
  Future<bool?> ciVerte(String? sha) async {
    if (sha == null) return null;
    try {
      final data = await _get('/repos/$_owner/$_repo/commits/$sha/check-runs');
      final runs = data['check_runs'] as List;
      if (runs.isEmpty) return null;
      return runs.every((r) => r['conclusion'] == 'success');
    } catch (_) {
      return null;
    }
  }

  void close() => _client.close();
}
