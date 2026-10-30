// Lecture des données du suivi hebdomadaire (ticket #125) : conversion du JSON
// de `gh` vers les types de `tools/suivi_calculs.dart`, et lecture d'un rapport
// de couverture lcov. Fonctions pures : l'appel de `gh` est dans
// `tools/suivi.dart`.

import 'suivi_calculs.dart';

DateTime? _date(Object? valeur) =>
    valeur is String ? DateTime.parse(valeur).toUtc() : null;

Ticket ticketDepuisJson(Map<String, dynamic> json) {
  final etiquettes = {
    for (final l in (json['labels'] as List? ?? const []))
      (l as Map)['name'] as String,
  };
  final charge = etiquettes
      .where((e) => e.startsWith('charge:'))
      .map((e) => int.tryParse(e.substring('charge:'.length)))
      .whereType<int>()
      .firstOrNull;
  return Ticket(
    numero: json['number'] as int,
    ouvert: json['state'] == 'OPEN',
    creeLe: _date(json['createdAt'])!,
    fermeLe: _date(json['closedAt']),
    majLe: _date(json['updatedAt']),
    charge: charge,
    jalon: (json['milestone'] as Map?)?['title'] as String?,
    etiquettes: etiquettes,
    assignes: [
      for (final a in (json['assignees'] as List? ?? const []))
        (a as Map)['login'] as String,
    ],
  );
}

PrData prDepuisJson(Map<String, dynamic> json) {
  final commits = [
    for (final c in (json['commits'] as List? ?? const []))
      ?_date((c as Map)['authoredDate'] ?? c['committedDate']),
  ]..sort();
  return PrData(
    numero: json['number'] as int,
    auteur: ((json['author'] as Map?)?['login'] as String?) ?? '',
    branche: json['headRefName'] as String? ?? '',
    ouverte: json['state'] == 'OPEN',
    creeeLe: _date(json['createdAt'])!,
    fusionneeLe: _date(json['mergedAt']),
    premierCommitLe: commits.isEmpty ? null : commits.first,
    revues: [
      for (final r in (json['reviews'] as List? ?? const []))
        if (_date((r as Map)['submittedAt']) != null)
          Revue(
            ((r['author'] as Map?)?['login'] as String?) ?? '',
            _date(r['submittedAt'])!,
          ),
    ],
  );
}

/// Date d'ouverture de chaque jalon (clé = titre) : sa création plus une
/// tolérance, au-delà de laquelle un ticket créé compte comme un ajout.
Map<String, DateTime> ouverturesJalons(
  List<dynamic> jalons, {
  int toleranceJours = 2,
}) => {
  for (final j in jalons)
    (j as Map)['title'] as String: _date(j['created_at'])!
        .add(Duration(days: toleranceJours)),
};

/// Pourcentage de lignes couvertes par les tests, pour les fichiers de `lib/`
/// hors code généré (`*.g.dart`), ou `null` s'il n'y en a aucun.
double? couvertureLcov(String lcov) {
  var trouvees = 0, couvertes = 0;
  var compte = false;
  for (final ligne in lcov.split('\n')) {
    if (ligne.startsWith('SF:')) {
      final chemin = ligne.substring(3);
      compte = chemin.startsWith('lib/') && !chemin.endsWith('.g.dart');
    } else if (compte && ligne.startsWith('LF:')) {
      trouvees += int.parse(ligne.substring(3));
    } else if (compte && ligne.startsWith('LH:')) {
      couvertes += int.parse(ligne.substring(3));
    }
  }
  return trouvees == 0 ? null : couvertes / trouvees * 100;
}
