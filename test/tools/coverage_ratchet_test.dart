import 'package:test/test.dart';

import '../../tools/coverage_ratchet.dart';

void main() {
  group('calculerCouverturePourcent', () {
    test('additionne LF/LH sur plusieurs enregistrements lcov', () {
      const lcov = '''
SF:lib/a.dart
LF:10
LH:8
end_of_record
SF:lib/b.dart
LF:10
LH:2
end_of_record
''';
      expect(calculerCouverturePourcent(lcov), 50.0);
    });

    test('renvoie 100 quand aucune ligne trouvée (rapport vide)', () {
      expect(calculerCouverturePourcent(''), 100.0);
    });
  });

  group('comparerAuCliquet', () {
    test('accepte une couverture égale', () {
      expect(comparerAuCliquet(actuelle: 80, reference: 80), 0);
    });

    test('accepte une couverture en hausse', () {
      expect(comparerAuCliquet(actuelle: 85, reference: 80), 0);
    });

    test('refuse une couverture en baisse', () {
      expect(comparerAuCliquet(actuelle: 70, reference: 80), 1);
    });

    test('tolère un écart de flottant négligeable', () {
      expect(comparerAuCliquet(actuelle: 79.999, reference: 80), 0);
    });
  });
}
