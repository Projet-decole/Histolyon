// Historique du suivi (ticket #126) : reconstitue une série hebdomadaire des
// indicateurs depuis les tickets, PR et runs de CI déjà lus, et en déduit les
// alertes des seuils de `docs/PROCESS.md`. Fonctions pures, sans réseau.
//
// Limite : la série est recalculée avec l'état **actuel** des étiquettes
// (`charge:N`) et des jalons. Ils n'existent que depuis le 26/10/2026 ; avant
// cette date, un ticket compte avec la charge et le jalon qu'il porte
// aujourd'hui, et les tickets d'avant le recadrage (sans charge) sont ignorés.

import 'suivi_calculs.dart';

/// Un point de la série, à une date donnée.
class PointSuivi {
  const PointSuivi({
    required this.date,
    required this.perimetre,
    required this.terminee,
    required this.debit,
    required this.datePrevue,
    required this.prFusionnees,
    required this.chargeTermineeSemaine,
    this.ciVertePct,
  });

  final DateTime date;

  /// Charge des jalons du MVP (ceux qui ont une échéance) connue à la date.
  final int perimetre;

  /// Part de cette charge terminée à la date.
  final int terminee;

  /// Charge terminée par semaine, moyenne des trois semaines précédentes.
  final double debit;

  /// Fin prévue du MVP à ce débit, ou `null` (périmètre vide, débit nul).
  final DateTime? datePrevue;

  /// PR fusionnées pendant la semaine écoulée.
  final int prFusionnees;

  /// Charge terminée pendant la semaine écoulée.
  final int chargeTermineeSemaine;

  /// Part des runs de CI réussis pendant la semaine écoulée.
  final double? ciVertePct;

  int get restante => perimetre - terminee;

  Map<String, Object?> versJson() => {
    'date': jourIso(date),
    'perimetre': perimetre,
    'terminee': terminee,
    'restante': restante,
    'debit_3sem': debit,
    'date_prevue': datePrevue == null ? null : jourIso(datePrevue!),
    'pr_fusionnees_semaine': prFusionnees,
    'charge_terminee_semaine': chargeTermineeSemaine,
    'ci_verte_semaine_pct': ciVertePct,
  };
}

String jourIso(DateTime date) =>
    date.toUtc().toIso8601String().substring(0, 10);

/// Une date tous les sept jours depuis `debut`, puis `maintenant`.
List<DateTime> datesHebdomadaires(DateTime debut, DateTime maintenant) {
  final dates = <DateTime>[];
  for (
    var d = debut;
    d.isBefore(maintenant);
    d = d.add(const Duration(days: 7))
  ) {
    dates.add(d);
  }
  if (dates.isEmpty || dates.last != maintenant) dates.add(maintenant);
  return dates;
}

bool _dans(DateTime? le, DateTime debut, DateTime fin) =>
    le != null && le.isAfter(debut) && !le.isAfter(fin);

/// Série hebdomadaire. Seuls comptent les tickets des jalons qui ont une
/// échéance (le MVP) ; un ticket compte dans le périmètre dès sa création et
/// comme terminé dès sa fermeture.
List<PointSuivi> historique({
  required List<Ticket> tickets,
  required List<PrData> prs,
  required List<RunCi> runs,
  required Map<String, DateTime?> echeances,
  required List<DateTime> dates,
}) {
  final mvp = [
    for (final t in tickets)
      if (t.charge != null && t.jalon != null && echeances[t.jalon] != null) t,
  ];
  return [
    for (final d in dates)
      () {
        final semaine = d.subtract(const Duration(days: 7));
        final troisSemaines = d.subtract(const Duration(days: 21));
        var perimetre = 0, terminee = 0, semaineCharge = 0, recente = 0;
        for (final t in mvp) {
          if (t.creeLe.isAfter(d)) continue;
          perimetre += t.charge!;
          final fermeLe = t.ouvert ? null : t.fermeLe;
          if (fermeLe == null || fermeLe.isAfter(d)) continue;
          terminee += t.charge!;
          if (_dans(fermeLe, semaine, d)) semaineCharge += t.charge!;
          if (_dans(fermeLe, troisSemaines, d)) recente += t.charge!;
        }
        final debit = recente / 3;
        final ci = [
          for (final r in runs)
            if (_dans(r.le, semaine, d)) r,
        ];
        return PointSuivi(
          date: d,
          perimetre: perimetre,
          terminee: terminee,
          debit: debit,
          datePrevue: perimetre == 0
              ? null
              : datePrevue(perimetre - terminee, debit, d),
          prFusionnees: prs
              .where((p) => _dans(p.fusionneeLe, semaine, d))
              .length,
          chargeTermineeSemaine: semaineCharge,
          ciVertePct: ci.isEmpty
              ? null
              : ci.where((r) => r.reussi).length / ci.length * 100,
        );
      }(),
  ];
}

/// Échéance de fin du MVP : la plus tardive des échéances connues.
DateTime? echeanceFinMvp(Map<String, DateTime?> echeances) {
  DateTime? fin;
  for (final e in echeances.values) {
    if (e != null && (fin == null || e.isAfter(fin))) fin = e;
  }
  return fin;
}

/// Alertes des seuils de `docs/PROCESS.md` (§ Le suivi), d'après le dernier
/// point de la série, les charges des jalons et les tickets immobiles.
List<String> alertes({
  required List<PointSuivi> points,
  required DateTime? echeanceFin,
  required Map<String, ChargesJalon> charges,
  required int sansMouvement,
}) {
  final resultat = <String>[];
  if (points.isNotEmpty) {
    final dernier = points.last;
    final prevue = dernier.datePrevue;
    if (dernier.restante > 0 && prevue == null) {
      resultat.add(
        'Débit nul sur les trois dernières semaines : aucune date de fin '
        'calculable.',
      );
    } else if (prevue != null &&
        echeanceFin != null &&
        prevue.isAfter(echeanceFin)) {
      resultat.add(
        'La fin prévue du MVP (${jourIso(prevue)}) est après son échéance '
        '(${jourIso(echeanceFin)}).',
      );
    }
    if (points.length >= 3 && dernier.restante > 0) {
      final trois = points.sublist(points.length - 3);
      if (trois.every((p) => p.terminee == dernier.terminee)) {
        resultat.add('Plateau : aucune charge terminée depuis deux semaines.');
      }
    }
  }
  for (final e in charges.entries) {
    final c = e.value;
    if (c.total > 0 && c.ajoutee / c.total > 0.10) {
      final pct = (c.ajoutee / c.total * 100).round();
      resultat.add(
        '${e.key} : ${c.ajoutee} de charge ajoutée en cours de jalon '
        '($pct %, seuil 10 %).',
      );
    }
  }
  if (sansMouvement > 0) {
    resultat.add('$sansMouvement ticket(s) sans mouvement depuis 14 jours.');
  }
  return resultat;
}
