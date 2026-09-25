// Développement local uniquement : publie tous les pins et parcours de la
// base Supabase locale, pour que l'app (connectée en anonyme) les voie.
// Sans ça, `tools/seed.dart` laisse tout en brouillon (il ne touche jamais
// `statut`, AD-6) et la RLS masque les brouillons.
//
// Usage : dart run tools/publier_local.dart   (après seed.dart)
//
// Passe par `psql` dans le conteneur Docker de `supabase start`, en posant
// le drapeau de session que les triggers de statut exigent. Ne jamais
// utiliser contre un projet hébergé : aucune trace de validation n'est écrite.

import 'dart:io';

const _conteneur = 'supabase_db_histolyon';

const _sql = '''
begin;
select set_config('histolyon.transition_autorisee', 'on', true);
update pin set statut = 'publie' where statut <> 'publie';
update parcours set statut = 'publie' where statut <> 'publie';
select (select count(*) from pin where statut = 'publie') as pins_publies,
       (select count(*) from parcours where statut = 'publie') as parcours_publies;
commit;
''';

Future<void> main() async {
  final ProcessResult resultat;
  try {
    resultat = await Process.run('docker', [
      'exec',
      _conteneur,
      'psql',
      '-U',
      'postgres',
      '-v',
      'ON_ERROR_STOP=1',
      '-c',
      _sql,
    ]);
  } on ProcessException catch (e) {
    stderr.writeln('tools/publier_local : docker introuvable (${e.message}).');
    exitCode = 1;
    return;
  }
  if (resultat.exitCode != 0) {
    stderr.writeln(
      'tools/publier_local : échec — `supabase start` a-t-il tourné ?\n'
      '${resultat.stderr}',
    );
    exitCode = 1;
    return;
  }
  stdout.writeln(resultat.stdout);
}
