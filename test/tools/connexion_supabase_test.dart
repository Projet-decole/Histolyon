import 'package:test/test.dart';

import '../../tools/src/connexion_supabase.dart';

void main() {
  test('lit API_URL et SERVICE_ROLE_KEY du JSON de supabase status', () {
    final r = lireStatutSupabase(
      'Stopped services: [x]\n{"API_URL": "http://127.0.0.1:54321", '
      '"SERVICE_ROLE_KEY": "cle"}',
    );
    expect(r?.url, 'http://127.0.0.1:54321');
    expect(r?.cle, 'cle');
  });

  test('renvoie null si la sortie ne contient pas les clés', () {
    expect(lireStatutSupabase('supabase start is not running.'), isNull);
    expect(lireStatutSupabase('{"API_URL": "x"}'), isNull);
  });

  test('JSON valide mais pas un objet -> null, sans exception', () {
    expect(lireStatutSupabase('[1, 2]'), isNull);
  });

  group('connexion depuis l environnement', () {
    test('les deux variables -> connexion distante', () {
      final c = connexionDepuisEnvironnement({
        'SUPABASE_URL': 'https://x.supabase.co',
        'SUPABASE_SERVICE_ROLE_KEY': 'cle',
      });
      expect(c, isA<ConnexionDistante>());
    });

    test('aucune variable -> base locale', () {
      expect(connexionDepuisEnvironnement({}), isA<ConnexionLocale>());
    });

    test(
      'une seule variable -> erreur, jamais un repli silencieux en local',
      () {
        expect(
          connexionDepuisEnvironnement({
            'SUPABASE_URL': 'https://x.supabase.co',
          }),
          isA<ConnexionIncomplete>(),
        );
        expect(
          connexionDepuisEnvironnement({'SUPABASE_SERVICE_ROLE_KEY': 'cle'}),
          isA<ConnexionIncomplete>(),
        );
      },
    );
  });
}
