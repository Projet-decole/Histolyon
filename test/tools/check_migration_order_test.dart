import 'package:test/test.dart';

import '../../tools/check_migration_order.dart';

void main() {
  test('aucune nouvelle migration -> rien à signaler', () {
    expect(migrationsInvalides(['0001_socle.sql'], ['0001_socle.sql']), []);
  });

  test('nouvelle migration postérieure -> acceptée', () {
    expect(
      migrationsInvalides(
        ['0001_socle.sql'],
        ['0001_socle.sql', '20260921120000_ajout.sql'],
      ),
      [],
    );
  });

  test('nouvelle migration antérieure -> refusée', () {
    expect(
      migrationsInvalides(
        ['0002_socle.sql'],
        ['0002_socle.sql', '0001_avant.sql'],
      ),
      ['0001_avant.sql'],
    );
  });

  test('même horodatage, suffixe alphabétiquement postérieur -> acceptée '
      '(comparaison sur le nom de fichier complet, pas juste le préfixe)', () {
    expect(
      migrationsInvalides(
        ['20260921120000_a.sql'],
        ['20260921120000_a.sql', '20260921120000_b.sql'],
      ),
      [],
    );
  });

  test('plusieurs nouvelles migrations, une seule invalide', () {
    expect(
      migrationsInvalides(
        ['0001_socle.sql'],
        ['0001_socle.sql', '20260921120000_bonne.sql', '0000_mauvaise.sql'],
      ),
      ['0000_mauvaise.sql'],
    );
  });
}
