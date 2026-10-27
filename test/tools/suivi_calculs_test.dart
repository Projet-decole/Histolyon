import 'package:test/test.dart';

import '../../tools/suivi_calculs.dart';

final maintenant = DateTime.utc(2026, 11, 2, 12);
DateTime ilYa(int jours) => maintenant.subtract(Duration(days: jours));

Ticket ticket(
  int numero, {
  bool ouvert = true,
  int? charge,
  String? jalon,
  DateTime? creeLe,
  DateTime? fermeLe,
  DateTime? majLe,
  Set<String> etiquettes = const {},
  List<String> assignes = const [],
}) => Ticket(
  numero: numero,
  ouvert: ouvert,
  creeLe: creeLe ?? ilYa(40),
  fermeLe: fermeLe,
  majLe: majLe ?? ilYa(1),
  charge: charge,
  jalon: jalon,
  etiquettes: etiquettes,
  assignes: assignes,
);

PrData pr(
  int numero, {
  String auteur = 'a',
  String branche = 'x',
  bool ouverte = false,
  DateTime? creeeLe,
  DateTime? fusionneeLe,
  DateTime? premierCommitLe,
  List<Revue> revues = const [],
}) => PrData(
  numero: numero,
  auteur: auteur,
  branche: branche,
  ouverte: ouverte,
  creeeLe: creeeLe ?? ilYa(20),
  fusionneeLe: fusionneeLe,
  premierCommitLe: premierCommitLe,
  revues: revues,
);

void main() {
  group('chargesParJalon', () {
    test('total, terminée et ajoutée depuis l\'ouverture du jalon', () {
      final charges = chargesParJalon(
        [
          ticket(1, charge: 3, jalon: 'J1', ouvert: false, creeLe: ilYa(10)),
          ticket(2, charge: 2, jalon: 'J1', creeLe: ilYa(10)),
          ticket(3, charge: 1, jalon: 'J1', creeLe: ilYa(2)),
          ticket(4, charge: 5, jalon: 'J2', creeLe: ilYa(10)),
          ticket(5, jalon: 'J1'), // sans charge : ignoré
          ticket(6, charge: 4), // sans jalon : ignoré
        ],
        {'J1': ilYa(5), 'J2': ilYa(5)},
      );

      expect(charges['J1']!.total, 6);
      expect(charges['J1']!.terminee, 3);
      expect(charges['J1']!.ajoutee, 1);
      expect(charges['J2']!.total, 5);
      expect(charges.containsKey(null), isFalse);
    });
  });

  group('débit et date prévue', () {
    test(
      'le débit compte les charges fermées sur les trois dernières semaines',
      () {
        final debit = debitParSemaine([
          ticket(1, charge: 3, ouvert: false, fermeLe: ilYa(5)),
          ticket(2, charge: 2, ouvert: false, fermeLe: ilYa(10)),
          ticket(3, charge: 5, ouvert: false, fermeLe: ilYa(30)), // trop ancien
          ticket(4, charge: 4), // encore ouvert
        ], maintenant);

        expect(debit, closeTo(5 / 3, 1e-9));
      },
    );

    test('la date prévue divise la charge restante par le débit', () {
      expect(
        datePrevue(10, 2, maintenant),
        maintenant.add(const Duration(days: 35)),
      );
    });

    test('sans débit, pas de date ; sans reste, la date est aujourd\'hui', () {
      expect(datePrevue(10, 0, maintenant), isNull);
      expect(datePrevue(0, 0, maintenant), maintenant);
    });
  });

  group('médiane', () {
    test('liste impaire, paire et vide', () {
      expect(mediane([3, 1, 2]), 2);
      expect(mediane([1, 2, 3, 4]), 2.5);
      expect(mediane([]), isNull);
    });
  });

  group('temps de cycle', () {
    test('premier commit jusqu\'à la fusion, dans la fenêtre', () {
      final jours = tempsCycleMedianJours([
        pr(1, premierCommitLe: ilYa(20), fusionneeLe: ilYa(10)), // 10 jours
        pr(2, premierCommitLe: ilYa(8), fusionneeLe: ilYa(6)), // 2 jours
        pr(3, creeeLe: ilYa(9), fusionneeLe: ilYa(5)), // 4 jours, sans commit
        pr(4, premierCommitLe: ilYa(2)), // non fusionnée : ignorée
        pr(
          5,
          premierCommitLe: ilYa(100),
          fusionneeLe: ilYa(90),
        ), // hors fenêtre
      ], maintenant);

      expect(jours, 4);
    });
  });

  group('flux en cours', () {
    test('âge maximal des tickets en cours et tickets sans mouvement', () {
      final flux = fluxEnCours(
        [
          ticket(7, majLe: ilYa(1)),
          ticket(8, assignes: ['b'], majLe: ilYa(20)),
          ticket(9, majLe: ilYa(30)), // ni assigné ni en cours : ignoré
        ],
        [pr(70, branche: '7-slider', ouverte: true, premierCommitLe: ilYa(12))],
        maintenant,
      );

      expect(flux.ageMaxJours, 12);
      expect(flux.sansMouvement, 1);
    });

    test('aucun ticket en cours : pas d\'âge', () {
      final flux = fluxEnCours([ticket(1)], [], maintenant);
      expect(flux.ageMaxJours, isNull);
      expect(flux.sansMouvement, 0);
    });
  });

  group('relecture', () {
    test('délai avant la première relecture par une autre personne', () {
      final jours = delaiPremiereRelectureMedianJours([
        pr(
          1,
          auteur: 'a',
          creeeLe: ilYa(10),
          revues: [Revue('a', ilYa(9)), Revue('b', ilYa(7))], // 3 jours
        ),
        pr(2, auteur: 'a', creeeLe: ilYa(10)), // pas de relecture : ignorée
      ]);

      expect(jours, 3);
    });

    test('part des PR fusionnées relues par une autre personne', () {
      final part = partRelueParAutre([
        pr(1, fusionneeLe: ilYa(3), revues: [Revue('b', ilYa(4))]),
        pr(2, fusionneeLe: ilYa(3), revues: [Revue('a', ilYa(4))]), // auteur
        pr(3, fusionneeLe: ilYa(3)),
        pr(4, fusionneeLe: ilYa(3)),
        pr(5), // non fusionnée : ignorée
      ]);

      expect(part, 25);
      expect(partRelueParAutre([pr(1)]), isNull);
    });
  });

  group('CI', () {
    test('part de runs verts sur la fenêtre', () {
      final part = partCiVerte([
        RunCi(true, ilYa(1)),
        RunCi(true, ilYa(2)),
        RunCi(true, ilYa(3)),
        RunCi(false, ilYa(4)),
        RunCi(false, ilYa(60)), // hors fenêtre
      ], maintenant);

      expect(part, 75);
      expect(partCiVerte([], maintenant), isNull);
    });
  });

  group('contenu et 3D', () {
    test('pins par état d\'après les étiquettes', () {
      final etats = pinsParEtat([
        ticket(1, etiquettes: {'contenu:redige'}),
        ticket(2, etiquettes: {'contenu:redige'}),
        ticket(3, etiquettes: {'contenu:publie'}, ouvert: false),
        ticket(4, etiquettes: {'mobile'}),
      ]);

      expect(etats, {'redige': 2, 'relu': 0, 'publie': 1});
    });

    test('état du modèle 3D : l\'étape la plus avancée', () {
      expect(etat3d([ticket(1)]), 'inconnu');
      expect(
        etat3d([
          ticket(1, etiquettes: {'3d:trouve'}),
          ticket(2, etiquettes: {'3d:droits'}),
        ]),
        'droits',
      );
      expect(
        etat3d([
          ticket(1, etiquettes: {'3d:integre'}),
        ]),
        'integre',
      );
    });
  });

  group('tests et contributions', () {
    test('compte les tests par type d\'après le contenu des fichiers', () {
      final nombres = compterTests({
        'apps/mobile/test/a_test.dart':
            "test('un', () {}); testWidgets('deux', (t) async {});"
            "group('g', () { test('trois', () {}); });",
        'apps/mobile/integration_test/app_test.dart':
            "testWidgets('i', (t) async {});",
        'test/tools/b_test.dart': "test('x', () {}); test('y', () {});",
        'supabase/tests/database/c.sql': 'select plan(4); select plan(3);',
      });

      expect(nombres, {'unite': 4, 'widget': 1, 'integration': 1, 'sql': 7});
    });

    test('part du premier contributeur', () {
      expect(partPremierContributeur({'a': 8, 'b': 2}), 80);
      expect(partPremierContributeur({}), isNull);
    });
  });

  group('instantané', () {
    test('la vue publique ne contient aucun détail par personne', () {
      final publique = instantane(
        date: maintenant,
        charges: {'J1': const ChargesJalon(total: 6, terminee: 3, ajoutee: 1)},
        debit: 1.5,
        datePrevueJalon: {'J1': maintenant.add(const Duration(days: 14))},
        tempsCycleJours: 2,
        ageMaxEnCoursJours: 3,
        sansMouvement: 0,
        delaiRelectureJours: 1,
        partRelueParAutrePct: 40,
        tests: {'unite': 3},
        couverturePct: null,
        ciVertePct: 90,
        pins: {'redige': 1, 'relu': 0, 'publie': 0},
        modele3d: 'droits',
      );
      final texte = publique.toString();

      expect(publique['date'], '2026-11-02');
      expect(publique.containsKey('interne'), isFalse);
      expect(texte.contains('contributions'), isFalse);
      expect((publique['charge'] as Map)['J1'], containsPair('total', 6));
    });

    test('la vue interne porte les contributions par personne', () {
      final interne = instantaneInterne(
        date: maintenant,
        contributions: {'a': 8, 'b': 2},
      );

      expect(interne['date'], '2026-11-02');
      expect(interne['contributions_4sem'], {'a': 8, 'b': 2});
      expect(interne['part_premier_contributeur_pct'], 80);
    });
  });
}
