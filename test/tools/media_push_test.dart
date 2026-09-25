import 'package:test/test.dart';

import '../../tools/media_push.dart';

void main() {
  test('une entrée valide passe', () {
    expect(
      erreurEntreeMedia(bucket: 'images', slug: 'demo', fichier: 'facade.webp'),
      isNull,
    );
  });

  test('un bucket inconnu est refusé', () {
    expect(
      erreurEntreeMedia(bucket: 'photos', slug: 'demo', fichier: 'a.webp'),
      contains('bucket'),
    );
  });

  test('un fichier qui sort du dossier partagé est refusé', () {
    for (final fichier in ['../secret.webp', 'a/../../b.webp', '/etc/passwd']) {
      expect(
        erreurEntreeMedia(bucket: 'images', slug: 'demo', fichier: fichier),
        isNotNull,
        reason: fichier,
      );
    }
  });

  test('un slug avec un séparateur de chemin est refusé', () {
    expect(
      erreurEntreeMedia(bucket: 'images', slug: '../demo', fichier: 'a.webp'),
      isNotNull,
    );
  });
}
