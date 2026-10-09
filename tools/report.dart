import 'dart:convert';
import 'dart:io';

// Rapport d'avancement calculé depuis GitHub (AD-17) : issues livrées par
// zone, travail en cours et prêt à prendre, délai médian issue -> fusion,
// taux de CI verte. Écrit docs/sprint/reports/<date>.md.
//
// Compte toutes les issues fermées comme « terminées » (pas les
// « not planned » ni les doublons), sauf le label `organisation`.
//
// Usage : dart run tools/report.dart
// GITHUB_TOKEN optionnel (l'API GitHub publique fonctionne sans, mais avec
// une limite de débit basse — un token la relève nettement).

const _owner = 'Projet-decole';
const _repo = 'Histolyon';

/// Labels de zone, dans l'ordre d'affichage (une issue = une zone).
const _zones = ['mobile', 'admin', 'supabase', 'content', '3d', 'socle'];
const _labelExclu = 'organisation';
const _dossierRapports = 'docs/sprint/reports';

Future<void> main() async {
  final gh = _GitHub(Platform.environment['GITHUB_TOKEN']);

  final List<_Issue> issues;
  final List<_Issue> ouvertes;
  try {
    issues = (await gh.issues(etat: 'closed'))
        .where((i) => i.stateReason == 'completed')
        .toList();
    ouvertes = await gh.issues(etat: 'open');
  } catch (e) {
    stderr.writeln('tools/report : impossible de lire les issues — $e');
    exitCode = 1;
    return;
  }
  stdout.writeln('tools/report : ${issues.length} issue(s) livrée(s).');

  final lignes = <_LigneRapport>[];
  for (final issue in issues) {
    final pr = await gh.trouverPrFermante(issue);
    final delaiApproxime = pr?.mergedAt == null;
    final delaiJours = pr?.mergedAt != null
        ? pr!.mergedAt!.difference(issue.createdAt).inHours / 24
        : issue.closedAt.difference(issue.createdAt).inHours / 24;
    final ciVerte = pr != null ? await gh.ciVerte(pr.headSha) : null;
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

  final rapport = _genererMarkdown(lignes, ouvertes);
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

String _zoneDe(_Issue issue) =>
    _zones.firstWhere(issue.labels.contains, orElse: () => 'autre');

String _genererMarkdown(List<_LigneRapport> lignes, List<_Issue> ouvertes) {
  final parDomaine = <String, List<_LigneRapport>>{};
  for (final ligne in lignes) {
    parDomaine.putIfAbsent(_zoneDe(ligne.issue), () => []).add(ligne);
  }
  final enCours = ouvertes.where((i) => i.assignees.isNotEmpty).toList();
  final pretes = ouvertes
      .where((i) => i.assignees.isEmpty && i.labels.contains('prête'))
      .toList();

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
    'Calculé depuis GitHub : ${lignes.length} issue(s) livrée(s), '
    '${enCours.length} en cours, ${pretes.length} prête(s) à prendre. '
    'Généré par `dart run tools/report.dart` — ne pas éditer à la main, '
    'régénérer.',
  );
  buffer.writeln();
  buffer.writeln('## Indicateurs');
  buffer.writeln();
  buffer.write('- **Délai médian issue → fusion** : ');
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
      '(sur ${avecDonneesCi.length}/${lignes.length} issues avec au moins '
      'un run CI enregistré).',
    );
  } else {
    buffer.writeln(
      '- **Taux de CI verte** : N/A — aucun run CI enregistré sur les '
      'issues livrées à ce jour.',
    );
  }
  buffer.writeln();

  buffer.writeln('## En cours');
  buffer.writeln();
  if (enCours.isEmpty) buffer.writeln('- (aucune)');
  for (final i in enCours) {
    buffer.writeln(
      '- #${i.number} ${i.title} — ${_zoneDe(i)}, '
      '@${i.assignees.join(', @')}',
    );
  }
  buffer.writeln();
  buffer.writeln('## Prêtes à prendre');
  buffer.writeln();
  if (pretes.isEmpty) buffer.writeln('- (aucune)');
  for (final i in pretes) {
    buffer.writeln('- #${i.number} ${i.title} — ${_zoneDe(i)}');
  }
  buffer.writeln();
  buffer.writeln('## Livré, par zone');
  buffer.writeln();
  final ordre = [..._zones, 'autre'];
  for (final domaine in ordre.where(parDomaine.containsKey)) {
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

  buffer.writeln('## Limites connues de ce rapport');
  buffer.writeln();
  buffer.writeln(
    '- Une issue sans label de zone est classée « autre » ; '
    '`organisation` et les issues fermées sans suite ne sont pas comptées.',
  );
  buffer.writeln(
    '- Le taux de CI verte ne compte que les issues dont la PR de fusion '
    'a déclenché au moins un run CI enregistré par GitHub.',
  );
  if (approximees > 0) {
    buffer.writeln(
      '- $approximees issue(s) sans PR de fusion identifiée '
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
    required this.assignees,
    required this.stateReason,
    required this.createdAt,
    required this.closedAt,
  });

  final int number;
  final String title;
  final List<String> labels;
  final List<String> assignees;
  final String? stateReason;
  final DateTime createdAt;
  final DateTime closedAt;
}

class _PullRequest {
  _PullRequest({
    required this.number,
    required this.mergedAt,
    required this.headSha,
  });

  final int number;
  final DateTime? mergedAt;

  /// Dernier commit de la branche de la PR : c'est lui qui porte les
  /// check-runs (la CI ne tourne que sur `pull_request`, et le commit de
  /// squash sur main n'en a jamais).
  final String? headSha;
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

  Future<List<_Issue>> issues({required String etat}) async {
    final resultat = <_Issue>[];
    var page = 1;
    while (true) {
      final data = await _get(
        '/repos/$_owner/$_repo/issues',
        query: {'state': etat, 'per_page': '100', 'page': '$page'},
      ) as List;
      if (data.isEmpty) break;
      for (final item in data) {
        if (item['pull_request'] != null) continue; // exclut les PR
        final labels = (item['labels'] as List)
            .map((l) => l['name'] as String)
            .toList();
        if (labels.contains(_labelExclu)) continue;
        resultat.add(
          _Issue(
            number: item['number'] as int,
            title: item['title'] as String,
            labels: labels,
            assignees: (item['assignees'] as List)
                .map((a) => a['login'] as String)
                .toList(),
            stateReason: item['state_reason'] as String?,
            createdAt: DateTime.parse(item['created_at'] as String),
            closedAt: item['closed_at'] == null
                ? DateTime.now().toUtc()
                : DateTime.parse(item['closed_at'] as String),
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
        headSha: (data['head'] as Map<String, dynamic>?)?['sha'] as String?,
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
      final runs = <dynamic>[];
      var page = 1;
      while (true) {
        final data = await _get(
          '/repos/$_owner/$_repo/commits/$sha/check-runs',
          query: {'per_page': '100', 'page': '$page'},
        );
        final lot = data['check_runs'] as List;
        runs.addAll(lot);
        if (lot.length < 100) break;
        page++;
      }
      if (runs.isEmpty) return null;
      // Un job sauté (filtre de chemins) ou neutre n'est pas un échec.
      const verts = {'success', 'skipped', 'neutral'};
      return runs.every((r) => verts.contains(r['conclusion']));
    } catch (_) {
      return null;
    }
  }

  void close() => _client.close();
}
