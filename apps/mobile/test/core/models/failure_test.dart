import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/models/failure.dart';

void main() {
  test('ReseauFailure a un message par défaut', () {
    expect(const ReseauFailure().message, 'Connexion réseau indisponible');
  });

  test('les sous-types de Failure exposent leur message', () {
    expect(const ServeurFailure('500').message, '500');
    expect(const ValidationFailure('champ requis').message, 'champ requis');
    expect(const InconnueFailure('?').message, '?');
  });

  test('Ok porte une valeur, Err porte une Failure', () {
    const Result<int> ok = Ok(42);
    const Result<int> err = Err(ValidationFailure('invalide'));

    expect(switch (ok) {
      Ok(:final value) => value,
      Err() => null,
    }, 42);
    expect(switch (err) {
      Ok() => null,
      Err(:final failure) => failure.message,
    }, 'invalide');
  });
}
