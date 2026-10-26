import 'dart:convert';
import 'dart:io';

/// URL et clé service de la base Supabase visée par un outil de `tools/`.
///
/// Priorité à `SUPABASE_URL` / `SUPABASE_SERVICE_ROLE_KEY` (CI, projet
/// hébergé). À défaut, lit la base locale via `supabase status -o json` :
/// en développement, aucune variable à exporter à la main.
Future<({String url, String cle})?> connexionSupabase(String outil) async {
  switch (connexionDepuisEnvironnement(Platform.environment)) {
    case ConnexionDistante(:final url, :final cle):
      return (url: url, cle: cle);
    case ConnexionIncomplete():
      stderr.writeln(
        'tools/$outil : SUPABASE_URL et SUPABASE_SERVICE_ROLE_KEY vont '
        'ensemble — une seule est définie. Refus plutôt que de viser la base '
        'locale par erreur.',
      );
      return null;
    case ConnexionLocale():
      break;
  }

  try {
    final statut = await Process.run('supabase', ['status', '-o', 'json']);
    if (statut.exitCode == 0) {
      final local = lireStatutSupabase(statut.stdout as String);
      if (local != null) return local;
    }
  } on ProcessException {
    // CLI absente : message ci-dessous.
  }
  stderr.writeln(
    'tools/$outil : base Supabase introuvable. En local, lance '
    '`supabase start` ; sinon renseigne SUPABASE_URL et '
    'SUPABASE_SERVICE_ROLE_KEY (jamais commitées).',
  );
  return null;
}

/// Base visée d'après l'environnement.
sealed class ChoixConnexion {
  const ChoixConnexion();
}

/// Les deux variables sont définies (CI, projet hébergé).
final class ConnexionDistante extends ChoixConnexion {
  const ConnexionDistante(this.url, this.cle);
  final String url;
  final String cle;
}

/// Aucune variable : base locale de `supabase start`.
final class ConnexionLocale extends ChoixConnexion {
  const ConnexionLocale();
}

/// Une seule des deux variables : erreur de configuration.
final class ConnexionIncomplete extends ChoixConnexion {
  const ConnexionIncomplete();
}

ChoixConnexion connexionDepuisEnvironnement(Map<String, String> env) {
  final url = env['SUPABASE_URL'];
  final cle = env['SUPABASE_SERVICE_ROLE_KEY'];
  if (url != null && cle != null) return ConnexionDistante(url, cle);
  if (url == null && cle == null) return const ConnexionLocale();
  return const ConnexionIncomplete();
}

/// Extrait URL et clé service de la sortie JSON de `supabase status`.
/// Tolère du texte parasite avant le JSON (avertissements de la CLI).
({String url, String cle})? lireStatutSupabase(String sortie) {
  final debut = sortie.indexOf('{');
  if (debut < 0) return null;
  try {
    final json = jsonDecode(sortie.substring(debut));
    if (json is! Map<String, dynamic>) return null;
    final url = json['API_URL'] as String?;
    final cle = json['SERVICE_ROLE_KEY'] as String?;
    if (url == null || cle == null) return null;
    return (url: url, cle: cle);
  } on FormatException {
    return null;
  }
}
