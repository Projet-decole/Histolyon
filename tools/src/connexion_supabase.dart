import 'dart:convert';
import 'dart:io';

/// URL et clé service de la base Supabase visée par un outil de `tools/`.
///
/// Priorité à `SUPABASE_URL` / `SUPABASE_SERVICE_ROLE_KEY` (CI, projet
/// hébergé). À défaut, lit la base locale via `supabase status -o json` :
/// en développement, aucune variable à exporter à la main.
Future<({String url, String cle})?> connexionSupabase(String outil) async {
  final url = Platform.environment['SUPABASE_URL'];
  final cle = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'];
  if (url != null && cle != null) return (url: url, cle: cle);

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

/// Extrait URL et clé service de la sortie JSON de `supabase status`.
/// Tolère du texte parasite avant le JSON (avertissements de la CLI).
({String url, String cle})? lireStatutSupabase(String sortie) {
  final debut = sortie.indexOf('{');
  if (debut < 0) return null;
  try {
    final json = jsonDecode(sortie.substring(debut)) as Map<String, dynamic>;
    final url = json['API_URL'] as String?;
    final cle = json['SERVICE_ROLE_KEY'] as String?;
    if (url == null || cle == null) return null;
    return (url: url, cle: cle);
  } on FormatException {
    return null;
  }
}
