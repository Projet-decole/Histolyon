import 'package:test/test.dart';

import '../../tools/projet_sync.dart';

ElementProjet element({
  int numero = 1,
  bool ouvert = true,
  String statut = 'Backlog',
  List<String> etiquettes = const [],
  List<String> assignes = const [],
  String? jalon = 'J2 · Follow-up 3 (18/12)',
  num? charge,
  String? priorite,
  String? nature,
  String? semaine,
  DateTime? misAJour,
}) => ElementProjet(
  numero: numero,
  titre: 'Ticket $numero',
  ouvert: ouvert,
  statut: statut,
  etiquettes: etiquettes,
  assignes: assignes,
  jalon: jalon,
  charge: charge,
  priorite: priorite,
  nature: nature,
  semaine: semaine,
  misAJour: misAJour ?? DateTime.utc(2026, 10, 30),
);

final maintenant = DateTime.utc(2026, 10, 30);

List<int> numeros(List<Anomalie> a, TypeAnomalie t) => [
  for (final x in a)
    if (x.type == t) x.numero,
];

void main() {
  group('chargeDepuisEtiquettes', () {
    test('lit le nombre de l\'étiquette charge:N', () {
      expect(chargeDepuisEtiquettes(['mobile', 'charge:3']), 3);
    });

    test('renvoie null sans étiquette de charge', () {
      expect(chargeDepuisEtiquettes(['mobile']), isNull);
    });

    test('ignore une étiquette de charge illisible', () {
      expect(chargeDepuisEtiquettes(['charge:beaucoup']), isNull);
    });
  });

  group('analyser', () {
    test('signale une charge absente ou différente de l\'étiquette', () {
      final a = analyser([
        element(numero: 1, etiquettes: ['charge:3'], charge: null),
        element(numero: 2, etiquettes: ['charge:3'], charge: 2),
        element(numero: 3, etiquettes: ['charge:3'], charge: 3),
      ], maintenant);
      expect(numeros(a, TypeAnomalie.chargeIncoherente), [1, 2]);
    });

    test('signale un ticket ouvert sans priorité, pas un ticket fermé', () {
      final a = analyser([
        element(numero: 1),
        element(numero: 2, ouvert: false, statut: 'Done'),
        element(numero: 3, priorite: '1 · Chemin critique'),
      ], maintenant);
      expect(numeros(a, TypeAnomalie.prioriteManquante), [1]);
    });

    test('signale un ticket sans nature', () {
      final a = analyser([
        element(numero: 1),
        element(numero: 2, nature: 'Tâche'),
      ], maintenant);
      expect(numeros(a, TypeAnomalie.natureManquante), [1]);
    });

    test('signale un ticket prêt ou en cours sans assigné', () {
      final a = analyser([
        element(numero: 1, statut: 'Ready'),
        element(numero: 2, statut: 'In progress', assignes: ['lunoshist']),
        element(numero: 3, statut: 'Backlog'),
        element(numero: 4, statut: 'In review'),
      ], maintenant);
      expect(numeros(a, TypeAnomalie.sansAssigne), [1, 4]);
    });

    test('signale un statut incohérent avec l\'état du ticket', () {
      final a = analyser([
        element(numero: 1, ouvert: false, statut: 'In progress'),
        element(numero: 2, ouvert: true, statut: 'Done'),
        element(numero: 3, ouvert: false, statut: 'Done'),
      ], maintenant);
      expect(numeros(a, TypeAnomalie.statutIncoherent), [1, 2]);
    });

    test('signale un ticket en cours sans mouvement depuis 14 jours', () {
      final a = analyser([
        element(
          numero: 1,
          statut: 'In progress',
          assignes: ['a'],
          misAJour: DateTime.utc(2026, 10, 10),
        ),
        element(
          numero: 2,
          statut: 'In progress',
          assignes: ['a'],
          misAJour: DateTime.utc(2026, 10, 25),
        ),
        element(
          numero: 3,
          statut: 'Backlog',
          misAJour: DateTime.utc(2026, 1, 1),
        ),
      ], maintenant);
      expect(numeros(a, TypeAnomalie.sansMouvement), [1]);
    });

    test('signale un ticket prêt ou en cours sans semaine planifiée', () {
      final a = analyser([
        element(numero: 1, statut: 'Ready', assignes: ['a']),
        element(numero: 2, statut: 'Ready', assignes: ['a'], semaine: 'S45'),
        element(numero: 3, statut: 'Backlog'),
      ], maintenant);
      expect(numeros(a, TypeAnomalie.sansSemaine), [1]);
    });

    test('renvoie une liste vide quand tout est cohérent', () {
      final a = analyser([
        element(
          numero: 1,
          statut: 'In progress',
          assignes: ['a'],
          etiquettes: ['charge:2'],
          charge: 2,
          priorite: '2 · Important',
          nature: 'Technique',
          semaine: 'S45',
        ),
      ], maintenant);
      expect(a, isEmpty);
    });
  });

  group('charge à corriger', () {
    test('ne propose que les écarts avec une étiquette', () {
      final c = chargesACorriger([
        element(numero: 1, etiquettes: ['charge:3'], charge: null),
        element(numero: 2, etiquettes: ['charge:3'], charge: 2),
        element(numero: 3, etiquettes: ['charge:3'], charge: 3),
        element(numero: 4, charge: 5),
      ]);
      expect(c, {1: 3, 2: 3});
    });
  });

  group('formaterRapport', () {
    test('liste chaque type avec ses tickets, ou dit que tout est bon', () {
      expect(formaterRapport([]), contains('Tout est cohérent'));
      final texte = formaterRapport([
        const Anomalie(TypeAnomalie.sansAssigne, 7, 'Slider'),
      ]);
      expect(texte, contains('#7'));
      expect(texte, contains('assigné'));
    });
  });
}
