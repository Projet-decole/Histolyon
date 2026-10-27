// Calculs du suivi hebdomadaire (ticket #125). Fonctions pures, sans accès
// réseau ni disque : elles reçoivent des données déjà lues (tickets, PR, runs
// de CI) et rendent des indicateurs. La lecture de GitHub est dans
// `tools/suivi.dart`. Les définitions sont celles de `docs/PROCESS.md`.

/// Un ticket (issue GitHub) réduit à ce que le suivi utilise.
class Ticket {
  const Ticket({
    required this.numero,
    required this.ouvert,
    required this.creeLe,
    this.fermeLe,
    this.majLe,
    this.charge,
    this.jalon,
    this.etiquettes = const {},
    this.assignes = const [],
  });

  final int numero;
  final bool ouvert;
  final DateTime creeLe;
  final DateTime? fermeLe;
  final DateTime? majLe;
  final int? charge;
  final String? jalon;
  final Set<String> etiquettes;
  final List<String> assignes;
}

class Revue {
  const Revue(this.auteur, this.le);

  final String auteur;
  final DateTime le;
}

/// Une pull request réduite à ce que le suivi utilise.
class PrData {
  const PrData({
    required this.numero,
    required this.auteur,
    required this.branche,
    required this.ouverte,
    required this.creeeLe,
    this.fusionneeLe,
    this.premierCommitLe,
    this.revues = const [],
  });

  final int numero;
  final String auteur;
  final String branche;
  final bool ouverte;
  final DateTime creeeLe;
  final DateTime? fusionneeLe;
  final DateTime? premierCommitLe;
  final List<Revue> revues;
}

class RunCi {
  const RunCi(this.reussi, this.le);

  final bool reussi;
  final DateTime le;
}

class ChargesJalon {
  const ChargesJalon({
    required this.total,
    required this.terminee,
    required this.ajoutee,
  });

  final int total;
  final int terminee;
  final int ajoutee;

  int get restante => total - terminee;
}

double _jours(Duration d) => d.inMinutes / (24 * 60);

/// Charges par jalon. `ouvertures` donne, pour chaque jalon, la date à partir
/// de laquelle un ticket créé compte comme un ajout de périmètre. Les tickets
/// sans charge ou sans jalon sont ignorés.
Map<String, ChargesJalon> chargesParJalon(
  List<Ticket> tickets,
  Map<String, DateTime> ouvertures,
) {
  final totaux = <String, int>{};
  final terminees = <String, int>{};
  final ajoutees = <String, int>{};
  for (final t in tickets) {
    final jalon = t.jalon;
    final charge = t.charge;
    if (jalon == null || charge == null) continue;
    totaux[jalon] = (totaux[jalon] ?? 0) + charge;
    if (!t.ouvert) terminees[jalon] = (terminees[jalon] ?? 0) + charge;
    final ouverture = ouvertures[jalon];
    if (ouverture != null && t.creeLe.isAfter(ouverture)) {
      ajoutees[jalon] = (ajoutees[jalon] ?? 0) + charge;
    }
  }
  return {
    for (final jalon in totaux.keys)
      jalon: ChargesJalon(
        total: totaux[jalon]!,
        terminee: terminees[jalon] ?? 0,
        ajoutee: ajoutees[jalon] ?? 0,
      ),
  };
}

/// Charge terminée par semaine, en moyenne sur les `semaines` dernières.
double debitParSemaine(
  List<Ticket> tickets,
  DateTime maintenant, {
  int semaines = 3,
}) {
  final debut = maintenant.subtract(Duration(days: 7 * semaines));
  var somme = 0;
  for (final t in tickets) {
    final fermeLe = t.fermeLe;
    if (t.ouvert || fermeLe == null || t.charge == null) continue;
    if (fermeLe.isAfter(debut)) somme += t.charge!;
  }
  return somme / semaines;
}

/// Date à laquelle la charge restante sera terminée au débit observé, ou
/// `null` si le débit est nul.
DateTime? datePrevue(int restante, double debit, DateTime maintenant) {
  if (restante <= 0) return maintenant;
  if (debit <= 0) return null;
  return maintenant.add(Duration(days: (restante / debit * 7).ceil()));
}

double? mediane(List<double> valeurs) {
  if (valeurs.isEmpty) return null;
  final triees = [...valeurs]..sort();
  final milieu = triees.length ~/ 2;
  return triees.length.isOdd
      ? triees[milieu]
      : (triees[milieu - 1] + triees[milieu]) / 2;
}

/// Médiane, en jours, entre le premier commit (à défaut la création de la PR)
/// et la fusion, pour les PR fusionnées dans la fenêtre.
double? tempsCycleMedianJours(
  List<PrData> prs,
  DateTime maintenant, {
  int fenetreJours = 56,
}) {
  final debut = maintenant.subtract(Duration(days: fenetreJours));
  final durees = <double>[];
  for (final p in prs) {
    final fusionneeLe = p.fusionneeLe;
    if (fusionneeLe == null || !fusionneeLe.isAfter(debut)) continue;
    durees.add(_jours(fusionneeLe.difference(p.premierCommitLe ?? p.creeeLe)));
  }
  return mediane(durees);
}

/// Âge maximal (en jours) des tickets en cours, et nombre de tickets en cours
/// ou assignés sans mouvement depuis `seuilJours`. Un ticket est « en cours »
/// quand une PR ouverte a une branche `<numéro>-…`.
({double? ageMaxJours, int sansMouvement}) fluxEnCours(
  List<Ticket> tickets,
  List<PrData> prs,
  DateTime maintenant, {
  int seuilJours = 14,
}) {
  double? ageMax;
  var sansMouvement = 0;
  for (final t in tickets.where((t) => t.ouvert)) {
    final prsDuTicket = prs.where(
      (p) => p.ouverte && p.branche.startsWith('${t.numero}-'),
    );
    final enCours = prsDuTicket.isNotEmpty;
    for (final p in prsDuTicket) {
      final age = _jours(maintenant.difference(p.premierCommitLe ?? p.creeeLe));
      if (ageMax == null || age > ageMax) ageMax = age;
    }
    final majLe = t.majLe;
    if ((enCours || t.assignes.isNotEmpty) &&
        majLe != null &&
        maintenant.difference(majLe).inDays >= seuilJours) {
      sansMouvement++;
    }
  }
  return (ageMaxJours: ageMax, sansMouvement: sansMouvement);
}

Revue? _premiereRevueParAutre(PrData pr) {
  final revues = pr.revues.where((r) => r.auteur != pr.auteur).toList()
    ..sort((a, b) => a.le.compareTo(b.le));
  return revues.isEmpty ? null : revues.first;
}

/// Médiane, en jours, entre la création d'une PR et sa première relecture par
/// une autre personne que son auteur.
double? delaiPremiereRelectureMedianJours(List<PrData> prs) {
  final delais = <double>[];
  for (final p in prs) {
    final revue = _premiereRevueParAutre(p);
    if (revue != null) delais.add(_jours(revue.le.difference(p.creeeLe)));
  }
  return mediane(delais);
}

/// Pourcentage de PR fusionnées relues par une autre personne que l'auteur.
double? partRelueParAutre(List<PrData> prs) {
  final fusionnees = prs.where((p) => p.fusionneeLe != null).toList();
  if (fusionnees.isEmpty) return null;
  final relues = fusionnees.where((p) => _premiereRevueParAutre(p) != null);
  return relues.length / fusionnees.length * 100;
}

/// Pourcentage de runs de CI réussis sur les `jours` derniers jours.
double? partCiVerte(List<RunCi> runs, DateTime maintenant, {int jours = 28}) {
  final debut = maintenant.subtract(Duration(days: jours));
  final recents = runs.where((r) => r.le.isAfter(debut)).toList();
  if (recents.isEmpty) return null;
  return recents.where((r) => r.reussi).length / recents.length * 100;
}

/// Nombre de tickets de contenu par état (`contenu:redige|relu|publie`).
Map<String, int> pinsParEtat(List<Ticket> tickets) => {
  for (final etat in const ['redige', 'relu', 'publie'])
    etat: tickets.where((t) => t.etiquettes.contains('contenu:$etat')).length,
};

/// État du modèle 3D : l'étape la plus avancée portée par une étiquette
/// `3d:…`, ou `inconnu`.
String etat3d(List<Ticket> tickets) {
  for (final etat in const ['integre', 'optimise', 'droits', 'trouve']) {
    if (tickets.any((t) => t.etiquettes.contains('3d:$etat'))) return etat;
  }
  return 'inconnu';
}

final _motifTest = RegExp(r'(?<![A-Za-z_])test\(');
final _motifTestWidgets = RegExp(r'testWidgets\(');
final _motifPlanSql = RegExp(r'plan\((\d+)\)');

/// Compte les tests par type d'après le contenu des fichiers (clé = chemin) :
/// `unite`, `widget`, `integration` (dossier `integration_test`) et `sql`
/// (somme des `plan(n)` de pgTAP).
Map<String, int> compterTests(Map<String, String> contenus) {
  var unite = 0, widget = 0, integration = 0, sql = 0;
  contenus.forEach((chemin, texte) {
    final tests =
        _motifTest.allMatches(texte).length +
        _motifTestWidgets.allMatches(texte).length;
    if (chemin.endsWith('.sql')) {
      sql += _motifPlanSql
          .allMatches(texte)
          .fold<int>(0, (s, m) => s + int.parse(m.group(1)!));
    } else if (chemin.contains('integration_test')) {
      integration += tests;
    } else {
      unite += _motifTest.allMatches(texte).length;
      widget += _motifTestWidgets.allMatches(texte).length;
    }
  });
  return {
    'unite': unite,
    'widget': widget,
    'integration': integration,
    'sql': sql,
  };
}

/// Part (en %) du premier contributeur, ou `null` sans contribution.
double? partPremierContributeur(Map<String, int> contributions) {
  final total = contributions.values.fold<int>(0, (s, v) => s + v);
  if (total == 0) return null;
  final max = contributions.values.reduce((a, b) => a > b ? a : b);
  return max / total * 100;
}

String _jour(DateTime date) => date.toUtc().toIso8601String().substring(0, 10);

/// Instantané **public** (vue client) : aucun détail par personne.
Map<String, Object?> instantane({
  required DateTime date,
  required Map<String, ChargesJalon> charges,
  required double debit,
  required Map<String, DateTime?> datePrevueJalon,
  required double? tempsCycleJours,
  required double? ageMaxEnCoursJours,
  required int sansMouvement,
  required double? delaiRelectureJours,
  required double? partRelueParAutrePct,
  required Map<String, int> tests,
  required double? couverturePct,
  required double? ciVertePct,
  required Map<String, int> pins,
  required String modele3d,
}) => {
  'date': _jour(date),
  'charge': {
    for (final e in charges.entries)
      e.key: {
        'total': e.value.total,
        'terminee': e.value.terminee,
        'restante': e.value.restante,
        'ajoutee': e.value.ajoutee,
      },
  },
  'debit_3sem': debit,
  'date_prevue': {
    for (final e in datePrevueJalon.entries)
      e.key: e.value == null ? null : _jour(e.value!),
  },
  'flux': {
    'cycle_median_j': tempsCycleJours,
    'age_max_en_cours_j': ageMaxEnCoursJours,
    'sans_mouvement_14j': sansMouvement,
    'delai_premiere_relecture_j': delaiRelectureJours,
    'pr_relues_par_autre_pct': partRelueParAutrePct,
  },
  'qualite': {
    'tests': tests,
    'couverture_lib_pct': couverturePct,
    'ci_verte_4sem_pct': ciVertePct,
  },
  'contenu': {'pins': pins, 'modele_3d': modele3d},
};

/// Instantané **interne** : détail par personne, jamais publié.
Map<String, Object?> instantaneInterne({
  required DateTime date,
  required Map<String, int> contributions,
}) => {
  'date': _jour(date),
  'contributions_4sem': contributions,
  'part_premier_contributeur_pct': partPremierContributeur(contributions),
};
