import 'package:test/test.dart';

import '../../tools/suivi_historique.dart';
import '../../tools/suivi_page.dart';

PointSuivi point(
  int jourDuMois, {
  int perimetre = 10,
  int terminee = 0,
  DateTime? datePrevue,
  int prFusionnees = 0,
  int charge = 0,
  double? ci,
}) => PointSuivi(
  date: DateTime.utc(2026, 11, jourDuMois),
  perimetre: perimetre,
  terminee: terminee,
  debit: 2,
  datePrevue: datePrevue,
  prFusionnees: prFusionnees,
  chargeTermineeSemaine: charge,
  ciVertePct: ci,
);

final points = [
  point(1, perimetre: 0),
  point(8, perimetre: 20, terminee: 4, prFusionnees: 3, charge: 4, ci: 100),
  point(
    13,
    perimetre: 22,
    terminee: 8,
    datePrevue: DateTime.utc(2027, 3, 24),
    prFusionnees: 2,
    charge: 4,
    ci: 50,
  ),
];

final instantane = <String, Object?>{
  'date': '2026-11-13',
  'charge': {
    'J1 · Follow-up 2 (13/11)': {
      'total': 22,
      'terminee': 8,
      'restante': 14,
      'ajoutee': 8,
    },
  },
  'debit_3sem': 4.7,
  'date_prevue': {'J1 · Follow-up 2 (13/11)': '2026-12-04'},
  'flux': {
    'cycle_median_j': 0.15,
    'age_max_en_cours_j': 16.8,
    'sans_mouvement_14j': 8,
    'delai_premiere_relecture_j': null,
    'pr_relues_par_autre_pct': 0.0,
  },
  'qualite': {
    'tests': {'unite': 166, 'widget': 14, 'integration': 1, 'sql': 82},
    'couverture_lib_pct': 92.3,
    'ci_verte_4sem_pct': 100.0,
  },
  'contenu': {
    'pins': {'redige': 0, 'relu': 0, 'publie': 0},
    'modele_3d': 'trouve',
  },
};

void main() {
  group('graphiques SVG', () {
    for (final (nom, svg) in [
      ('burn-up', svgBurnUp(points)),
      ('date prévue', svgDatePrevue(points, DateTime.utc(2027, 2, 7))),
      ('flux', svgFlux(points)),
    ]) {
      test('$nom : un SVG autonome, sans valeur invalide', () {
        expect(svg, startsWith('<svg'));
        expect(svg, contains('xmlns="http://www.w3.org/2000/svg"'));
        expect(svg.trimRight(), endsWith('</svg>'));
        expect(svg, isNot(contains('NaN')));
        expect(svg, isNot(contains('Infinity')));
        expect(svg, isNot(contains('<script')));
      });
    }

    test('burn-up : une courbe pour le périmètre et une pour le terminé', () {
      final svg = svgBurnUp(points);
      expect('<polyline'.allMatches(svg).length, 2);
      expect(svg, contains('Périmètre'));
      expect(svg, contains('Terminé'));
    });

    test('date prévue : la ligne de l\'échéance est tracée', () {
      final svg = svgDatePrevue(points, DateTime.utc(2027, 2, 7));
      expect(svg, contains('Échéance'));
      expect(svg, contains('2027-02-07'));
    });

    test('flux : une barre par semaine et par série', () {
      final svg = svgFlux(points);
      expect('<rect class="barre"'.allMatches(svg).length, 6);
    });

    test('aucun point : un SVG qui le dit', () {
      expect(svgBurnUp(const []), contains('Pas encore de données'));
    });
  });

  group('page client', () {
    final page = pageClient(
      instantane: instantane,
      points: points,
      echeanceFin: DateTime.utc(2027, 2, 7),
      alertes: const ['Plateau : rien de terminé depuis deux semaines.'],
    );

    test('montre les graphiques par chemin relatif', () {
      expect(page, contains('![Burn-up](burnup.svg)'));
      expect(page, contains('(date-prevue.svg)'));
      expect(page, contains('(flux.svg)'));
    });

    test('reprend l\'instantané : jalons, qualité, contenu', () {
      expect(page, contains('J1 · Follow-up 2 (13/11)'));
      expect(page, contains('8 / 22'));
      expect(page, contains('2026-12-04'));
      expect(page, contains('166'));
      expect(page, contains('92 %'));
      expect(page, contains('trouve'));
    });

    test('liste les alertes et un tableau semaine par semaine', () {
      expect(page, contains('Plateau'));
      expect(page, contains('| 2026-11-08 |'));
      expect(page, contains('| 2026-11-13 |'));
    });

    test('dit la limite de la reconstitution avant le 26/10', () {
      expect(page, contains('26/10/2026'));
      expect(page, contains('étiquettes'));
    });

    test('ne contient aucun détail par personne', () {
      expect(page, isNot(contains('contributions')));
      expect(page, isNot(contains('premier_contributeur')));
    });
  });
}
