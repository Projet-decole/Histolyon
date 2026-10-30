import 'package:test/test.dart';

import '../../tools/suivi_donnees.dart';

void main() {
  group('ticketDepuisJson', () {
    test('un ticket ouvert avec charge, jalon, étiquettes et assignés', () {
      final t = ticketDepuisJson({
        'number': 5,
        'state': 'OPEN',
        'createdAt': '2026-10-26T10:00:00Z',
        'closedAt': null,
        'updatedAt': '2026-10-27T10:00:00Z',
        'labels': [
          {'name': 'charge:3'},
          {'name': 'mobile'},
        ],
        'milestone': {'title': 'J1 · Follow-up 2 (13/11)'},
        'assignees': [
          {'login': 'x'},
        ],
      });

      expect(t.numero, 5);
      expect(t.ouvert, isTrue);
      expect(t.charge, 3);
      expect(t.jalon, 'J1 · Follow-up 2 (13/11)');
      expect(t.etiquettes, containsAll(['charge:3', 'mobile']));
      expect(t.assignes, ['x']);
      expect(t.creeLe, DateTime.utc(2026, 10, 26, 10));
    });

    test('un ticket fermé, sans jalon ni charge', () {
      final t = ticketDepuisJson({
        'number': 6,
        'state': 'CLOSED',
        'createdAt': '2026-10-01T10:00:00Z',
        'closedAt': '2026-10-05T10:00:00Z',
        'updatedAt': '2026-10-05T10:00:00Z',
        'labels': <Object>[],
        'milestone': null,
        'assignees': <Object>[],
      });

      expect(t.ouvert, isFalse);
      expect(t.fermeLe, DateTime.utc(2026, 10, 5, 10));
      expect(t.charge, isNull);
      expect(t.jalon, isNull);
    });
  });

  group('prDepuisJson', () {
    test('premier commit, revues et état fusionné', () {
      final p = prDepuisJson({
        'number': 9,
        'author': {'login': 'a'},
        'headRefName': '9-slider',
        'state': 'MERGED',
        'createdAt': '2026-10-20T09:00:00Z',
        'mergedAt': '2026-10-25T09:00:00Z',
        'commits': [
          {'authoredDate': '2026-10-20T08:00:00Z'},
          {'authoredDate': '2026-10-19T08:00:00Z'},
        ],
        'reviews': [
          {
            'author': {'login': 'b'},
            'submittedAt': '2026-10-21T09:00:00Z',
          },
        ],
      });

      expect(p.numero, 9);
      expect(p.auteur, 'a');
      expect(p.branche, '9-slider');
      expect(p.ouverte, isFalse);
      expect(p.fusionneeLe, DateTime.utc(2026, 10, 25, 9));
      expect(p.premierCommitLe, DateTime.utc(2026, 10, 19, 8));
      expect(p.revues.single.auteur, 'b');
    });

    test('une PR ouverte sans revue ni commit', () {
      final p = prDepuisJson({
        'number': 10,
        'author': {'login': 'a'},
        'headRefName': '10-x',
        'state': 'OPEN',
        'createdAt': '2026-10-20T09:00:00Z',
        'mergedAt': null,
        'commits': <Object>[],
        'reviews': <Object>[],
      });

      expect(p.ouverte, isTrue);
      expect(p.fusionneeLe, isNull);
      expect(p.premierCommitLe, isNull);
      expect(p.revues, isEmpty);
    });
  });

  group('ouverturesJalons', () {
    test('la création du jalon plus deux jours de tolérance', () {
      final ouvertures = ouverturesJalons([
        {'title': 'J1', 'created_at': '2026-10-26T10:00:00Z'},
      ]);

      expect(ouvertures['J1'], DateTime.utc(2026, 10, 28, 10));
    });
  });

  group('couvertureLcov', () {
    test('compte seulement les fichiers de lib/, hors code généré', () {
      const lcov = '''
SF:lib/a.dart
LF:10
LH:5
end_of_record
SF:lib/a.g.dart
LF:100
LH:0
end_of_record
SF:test/x_test.dart
LF:20
LH:20
end_of_record
''';

      expect(couvertureLcov(lcov), 50);
      expect(couvertureLcov(''), isNull);
    });
  });
}
