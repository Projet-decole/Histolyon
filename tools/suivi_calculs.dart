// Calculs du suivi hebdomadaire (ticket #125). Fonctions pures, sans accès
// réseau ni disque : elles reçoivent des données déjà lues (tickets, PR, runs
// de CI) et rendent des indicateurs. La lecture de GitHub est dans
// `tools/suivi.dart`.

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

Map<String, ChargesJalon> chargesParJalon(
  List<Ticket> tickets,
  Map<String, DateTime> ouvertures,
) => throw UnimplementedError();

double debitParSemaine(
  List<Ticket> tickets,
  DateTime maintenant, {
  int semaines = 3,
}) => throw UnimplementedError();

DateTime? datePrevue(int restante, double debit, DateTime maintenant) =>
    throw UnimplementedError();

double? mediane(List<double> valeurs) => throw UnimplementedError();

double? tempsCycleMedianJours(
  List<PrData> prs,
  DateTime maintenant, {
  int fenetreJours = 56,
}) => throw UnimplementedError();

({double? ageMaxJours, int sansMouvement}) fluxEnCours(
  List<Ticket> tickets,
  List<PrData> prs,
  DateTime maintenant, {
  int seuilJours = 14,
}) => throw UnimplementedError();

double? delaiPremiereRelectureMedianJours(List<PrData> prs) =>
    throw UnimplementedError();

double? partRelueParAutre(List<PrData> prs) => throw UnimplementedError();

double? partCiVerte(List<RunCi> runs, DateTime maintenant, {int jours = 28}) =>
    throw UnimplementedError();

Map<String, int> pinsParEtat(List<Ticket> tickets) =>
    throw UnimplementedError();

String etat3d(List<Ticket> tickets) => throw UnimplementedError();

Map<String, int> compterTests(Map<String, String> contenus) =>
    throw UnimplementedError();

double? partPremierContributeur(Map<String, int> contributions) =>
    throw UnimplementedError();

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
}) => throw UnimplementedError();

Map<String, Object?> instantaneInterne({
  required DateTime date,
  required Map<String, int> contributions,
}) => throw UnimplementedError();
