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
}
