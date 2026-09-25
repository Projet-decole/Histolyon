import 'dart:io';

// AD-16 et supabase/AGENTS.md, vérifiés contre la branche de base :
// - toute nouvelle migration a un horodatage postérieur à la dernière
//   migration de la base (l'ordre de rejeu ne dépend jamais de l'ordre de
//   fusion des PR) ;
// - une migration déjà fusionnée n'est jamais modifiée ni supprimée ;
// - une seule nouvelle migration par PR.
// Une ref de base illisible fait échouer le contrôle : jamais un succès
// silencieux.
//
// Usage : dart run tools/check_migration_order.dart [ref-de-base]
// ref-de-base par défaut : origin/main.

void main(List<String> args) {
  final refBase = args.isNotEmpty ? args[0] : 'origin/main';

  final verification = Process.runSync('git', [
    'rev-parse',
    '--verify',
    '--quiet',
    '$refBase^{commit}',
  ]);
  if (verification.exitCode != 0) {
    stderr.writeln(
      "tools/check_migration_order : ref de base '$refBase' illisible "
      '(branche absente ou clone superficiel ?) — contrôle impossible.',
    );
    exitCode = 1;
    return;
  }

  final migrationsBase = _migrationsSurRef(refBase);
  final migrationsActuelles = _migrationsSurDisque();
  final erreurs = <String>[];

  for (final nom in migrationsFusionneesTouchees(
    base: migrationsBase,
    actuelles: migrationsActuelles,
    modifiees: _migrationsModifiees(refBase),
  )) {
    erreurs.add(
      "'$nom' est déjà sur '$refBase' : ne jamais la modifier ni la "
      'supprimer, écrire une nouvelle migration (supabase/AGENTS.md).',
    );
  }

  for (final nom in migrationsInvalides(migrationsBase, migrationsActuelles)) {
    erreurs.add(
      "'$nom' n'est pas postérieure à la dernière migration de '$refBase' "
      '(${([...migrationsBase]..sort()).last}) — AD-16.',
    );
  }

  final nouvelles = nouvellesMigrations(migrationsBase, migrationsActuelles);
  if (nouvelles.length > 1) {
    erreurs.add(
      'une seule nouvelle migration par PR (supabase/AGENTS.md) — trouvées : '
      '${nouvelles.join(', ')}.',
    );
  }

  if (erreurs.isNotEmpty) {
    for (final erreur in erreurs) {
      stderr.writeln('tools/check_migration_order : $erreur');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'tools/check_migration_order : migrations conformes vs '
    "'$refBase'.",
  );
}

/// Migrations sur disque absentes de `migrationsBase`.
List<String> nouvellesMigrations(
  List<String> migrationsBase,
  List<String> migrationsActuelles,
) =>
    ([...migrationsActuelles.where((nom) => !migrationsBase.contains(nom))]
      ..sort());

/// Parmi les nouvelles migrations, celles dont le nom (donc l'horodatage,
/// préfixe lexicographique) ne trie pas après la dernière de la base.
List<String> migrationsInvalides(
  List<String> migrationsBase,
  List<String> migrationsActuelles,
) {
  if (migrationsBase.isEmpty) return [];
  final derniereBase = ([...migrationsBase]..sort()).last;
  return nouvellesMigrations(
    migrationsBase,
    migrationsActuelles,
  ).where((nom) => nom.compareTo(derniereBase) <= 0).toList();
}

/// Migrations de la base supprimées du disque ou modifiées.
List<String> migrationsFusionneesTouchees({
  required List<String> base,
  required List<String> actuelles,
  required List<String> modifiees,
}) => ([
  ...base.where((nom) => !actuelles.contains(nom) || modifiees.contains(nom)),
]..sort());

List<String> _migrationsSurRef(String ref) {
  final resultat = Process.runSync('git', [
    'ls-tree',
    '--name-only',
    ref,
    '--',
    'supabase/migrations/',
  ]);
  if (resultat.exitCode != 0) {
    throw StateError('git ls-tree $ref a échoué : ${resultat.stderr}');
  }
  return _nomsSql(resultat.stdout as String);
}

/// Migrations dont le contenu diffère entre la ref et l'arbre de travail.
List<String> _migrationsModifiees(String ref) {
  final resultat = Process.runSync('git', [
    'diff',
    '--name-only',
    ref,
    '--',
    'supabase/migrations/',
  ]);
  if (resultat.exitCode != 0) {
    throw StateError('git diff $ref a échoué : ${resultat.stderr}');
  }
  return _nomsSql(resultat.stdout as String);
}

List<String> _nomsSql(String sortie) => sortie
    .split('\n')
    .map((ligne) => ligne.trim())
    .where((ligne) => ligne.endsWith('.sql'))
    .map((chemin) => chemin.split('/').last)
    .toList();

List<String> _migrationsSurDisque() {
  final dossier = Directory('supabase/migrations');
  if (!dossier.existsSync()) return [];
  return dossier
      .listSync()
      .whereType<File>()
      .map((f) => f.path.split('/').last)
      .where((nom) => nom.endsWith('.sql'))
      .toList();
}
