// AppLogger enveloppe dart:developer.log : on vérifie seulement l'absence
// d'exception pour chaque niveau, dart:developer n'exposant pas de moyen
// d'inspecter les messages émis.

import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/log/app_logger.dart';

void main() {
  test("chaque niveau de log s'exécute sans exception", () {
    const logger = AppLogger('test');

    expect(() => logger.debug('debug'), returnsNormally);
    expect(() => logger.info('info'), returnsNormally);
    expect(() => logger.avertissement('avertissement'), returnsNormally);
    expect(
      () => logger.erreur('erreur', Exception('boom'), StackTrace.current),
      returnsNormally,
    );
  });
}
