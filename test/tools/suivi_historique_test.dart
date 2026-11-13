import 'package:test/test.dart';

import '../../tools/suivi_calculs.dart';
import '../../tools/suivi_historique.dart';

final debut = DateTime.utc(2026, 10, 1);
DateTime jour(int n) => debut.add(Duration(days: n));

Ticket ticket(
  int numero, {
  required int charge,
  String jalon = 'J1',
  DateTime? creeLe,
  DateTime? fermeLe,
}) => Ticket(
  numero: numero,
  ouvert: fermeLe == null,
  creeLe: creeLe ?? jour(0),
  fermeLe: fermeLe,
  charge: charge,
  jalon: jalon,
);

PrData prFusionnee(int numero, DateTime le) => PrData(
  numero: numero,
  auteur: 'a',
  branche: '$numero-x',
  ouverte: false,
  creeeLe: le.subtract(const Duration(days: 1)),
  fusionneeLe: le,
);

final echeances = <String, DateTime?>{
  'J1': DateTime.utc(2026, 11, 13),
  'J2': DateTime.utc(2026, 12, 18),
  'S2': null,
};

void main() {
  group('datesHebdomadaires', () {
    test('une date tous les sept jours, la dernière est aujourd\'hui', () {
      final dates = datesHebdomadaires(debut, jour(17));
      expect(dates, [jour(0), jour(7), jour(14), jour(17)]);
    });

    test('pas de doublon quand aujourd\'hui tombe sur une semaine pleine', () {
      expect(datesHebdomadaires(debut, jour(14)), [jour(0), jour(7), jour(14)]);
    });
  });

  group('historique', () {
    final tickets = [
      ticket(1, charge: 3, creeLe: jour(0), fermeLe: jour(5)),
      ticket(2, charge: 2, creeLe: jour(3), fermeLe: jour(12)),
      ticket(3, charge: 5, jalon: 'J2', creeLe: jour(10)),
      ticket(4, charge: 8, jalon: 'S2', creeLe: jour(0)), // hors MVP
    ];
    final points = historique(
      tickets: tickets,
      prs: [prFusionnee(10, jour(5)), prFusionnee(11, jour(6))],
      runs: [
        RunCi(true, jour(4)),
        RunCi(false, jour(6)),
        RunCi(true, jour(13)),
      ],
      echeances: echeances,
      dates: [jour(0), jour(7), jour(14)],
    );

    test('périmètre et charge terminée des seuls jalons à échéance', () {
      expect([for (final p in points) p.perimetre], [3, 5, 10]);
      expect([for (final p in points) p.terminee], [0, 3, 5]);
      expect(points.last.restante, 5);
    });

    test('flux de la semaine écoulée : PR fusionnées, charge, CI', () {
      expect([for (final p in points) p.prFusionnees], [0, 2, 0]);
      expect([for (final p in points) p.chargeTermineeSemaine], [0, 3, 2]);
      expect(points[0].ciVertePct, isNull);
      expect(points[1].ciVertePct, 50);
      expect(points[2].ciVertePct, 100);
    });

    test('débit sur trois semaines et date prévue au moment du point', () {
      expect(points[2].debit, closeTo(5 / 3, 1e-9));
      // reste 5 au débit de 5/3 par semaine : 3 semaines.
      expect(points[2].datePrevue, jour(14 + 21));
      // aucun débit au premier point : pas de date.
      expect(points[0].datePrevue, isNull);
    });

    test('pas de date prévue tant que le périmètre est vide', () {
      final vide = historique(
        tickets: const [],
        prs: const [],
        runs: const [],
        echeances: echeances,
        dates: [jour(0)],
      );
      expect(vide.single.perimetre, 0);
      expect(vide.single.datePrevue, isNull);
    });

    test('se sérialise en JSON avec des dates au jour', () {
      final json = points[2].versJson();
      expect(json['date'], '2026-10-15');
      expect(json['date_prevue'], '2026-11-05');
      expect(json['perimetre'], 10);
    });
  });

  group('echeanceFinMvp', () {
    test('la plus tardive des échéances connues', () {
      expect(echeanceFinMvp(echeances), DateTime.utc(2026, 12, 18));
      expect(echeanceFinMvp({'S2': null}), isNull);
    });
  });

  group('alertes', () {
    PointSuivi point(
      int n, {
      int perimetre = 10,
      int terminee = 0,
      DateTime? datePrevue,
    }) => PointSuivi(
      date: jour(n),
      perimetre: perimetre,
      terminee: terminee,
      debit: 1,
      datePrevue: datePrevue,
      prFusionnees: 0,
      chargeTermineeSemaine: 0,
    );

    test('date prévue après l\'échéance de fin', () {
      final a = alertes(
        points: [point(0, datePrevue: DateTime.utc(2027, 3, 1))],
        echeanceFin: DateTime.utc(2027, 2, 7),
        charges: const {},
        sansMouvement: 0,
      );
      expect(a.single, contains('2027-03-01'));
      expect(a.single, contains('2027-02-07'));
    });

    test('plateau de deux semaines, ajout de périmètre, tickets immobiles', () {
      final a = alertes(
        points: [
          point(0, terminee: 4, datePrevue: jour(30)),
          point(7, terminee: 4, datePrevue: jour(30)),
          point(14, terminee: 4, datePrevue: jour(30)),
        ],
        echeanceFin: jour(60),
        charges: {
          'J1': const ChargesJalon(total: 20, terminee: 4, ajoutee: 6),
          'J2': const ChargesJalon(total: 40, terminee: 0, ajoutee: 2),
        },
        sansMouvement: 3,
      );
      expect(a.any((x) => x.contains('Plateau')), isTrue);
      expect(a.any((x) => x.contains('J1') && x.contains('30 %')), isTrue);
      expect(a.any((x) => x.contains('J2')), isFalse); // 5 % : sous le seuil
      expect(a.any((x) => x.contains('3 ticket')), isTrue);
    });

    test('débit nul avec du reste : aucune date calculable', () {
      final a = alertes(
        points: [point(0)],
        echeanceFin: jour(60),
        charges: const {},
        sansMouvement: 0,
      );
      expect(a.single, contains('Débit nul'));
    });

    test('rien à signaler', () {
      expect(
        alertes(
          points: [point(0, terminee: 2, datePrevue: jour(10))],
          echeanceFin: jour(60),
          charges: const {},
          sansMouvement: 0,
        ),
        isEmpty,
      );
    });
  });
}
