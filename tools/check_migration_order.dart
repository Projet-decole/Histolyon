import 'dart:io';

// Story 9.3 (AD-16) : refuse toute migration dont l'horodatage n'est pas
// postérieur à la dernière migration déjà présente sur `main` — l'ordre de
// rejeu ne doit jamais dépendre de l'ordre de fusion des PR.
//
// Usage : dart run tools/check_migration_order.dart [ref-de-base]
// ref-de-base par défaut : origin/main.

void main(List<String> args) {
  final refBase = args.isNotEmpty ? args[0] : 'origin/main';

  final migrationsBase = _migrationsSurRef(refBase);
  if (migrationsBase.isEmpty) {
    stdout.writeln(
      'tools/check_migration_order : aucune migration trouvée sur '
      "'$refBase' — rien à comparer.",
    );
    return;
  }

  final migrationsActuelles = _migrationsSurDisque();
  final invalides = migrationsInvalides(migrationsBase, migrationsActuelles);

  if (invalides.isNotEmpty) {
    for (final nom in invalides) {
      stderr.writeln(
        "tools/check_migration_order : '$nom' n'est pas postérieure à la "
        "dernière migration de '$refBase' (${migrationsBase.last}) — AD-16 "
        '(horodatage doit toujours être postérieur au dernier de main).',
      );
    }
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'tools/check_migration_order : migrations correctement ordonnées vs '
    "'$refBase'.",
  );
}

/// Parmi les migrations sur disque absentes de `migrationsBase`, celles
/// dont le nom (donc l'horodatage, préfixe lexicographique) ne trie pas
/// après la dernière migration de `migrationsBase`.
List<String> migrationsInvalides(
  List<String> migrationsBase,
  List<String> migrationsActuelles,
) {
  final derniereBase = (([...migrationsBase]..sort())).last;
  final nouvelles = migrationsActuelles.where(
    (nom) => !migrationsBase.contains(nom),
  );
  return nouvelles.where((nom) => nom.compareTo(derniereBase) <= 0).toList();
}

List<String> _migrationsSurRef(String ref) {
  final resultat = Process.runSync('git', [
    'ls-tree',
    '--name-only',
    ref,
    '--',
    'supabase/migrations/',
  ]);
  if (resultat.exitCode != 0) return [];
  return (resultat.stdout as String)
      .split('\n')
      .map((ligne) => ligne.trim())
      .where((ligne) => ligne.endsWith('.sql'))
      .map((chemin) => chemin.split('/').last)
      .toList();
}

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
