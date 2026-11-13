import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/parcours/presentation/parcours_ecran.dart';

void main() {
  test('durée', () {
    expect(formaterDuree(90), '1 h 30');
    expect(formaterDuree(125), '2 h 05');
    expect(formaterDuree(120), '2 h');
    expect(formaterDuree(45), '45 min');
  });

  test('distance', () {
    expect(formaterDistance(2400), '2,4 km');
    expect(formaterDistance(3000), '3 km');
    expect(formaterDistance(800), '800 m');
  });
}
