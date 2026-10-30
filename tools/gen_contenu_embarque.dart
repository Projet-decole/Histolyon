// Génère l'instantané de contenu embarqué dans l'app (DEC-04) depuis
// `content/` : époques, catégories, sources et pins éditoriaux. `content/demo/`
// n'est jamais embarqué.
//
// Usage :
//   dart run tools/gen_contenu_embarque.dart             écrit le fichier
//   dart run tools/gen_contenu_embarque.dart --verifier  échoue (code 1) s'il
//                                                        n'est plus à jour (CI)
//
// Le contenu doit déjà être valide : `dart run tools/validate_content.dart`.

import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

const cheminSortie = 'apps/mobile/assets/contenu/contenu.json';

/// Dossiers de `content/` embarqués, dans l'ordre de leurs clés JSON.
const _dossiers = {
  'epoques': 'epoques',
  'categories': 'categories',
  'sources': 'sources',
  'pins': 'pins',
};

Future<void> main(List<String> args) async {
  exitCode = await executer(args);
}

/// Écrit le fichier embarqué, ou le vérifie avec `--verifier`.
/// `racine` : racine du dépôt (le répertoire courant par défaut).
Future<int> executer(List<String> args, {Directory? racine}) async {
  final base = racine?.path ?? Directory.current.path;
  final contenu = _genererJson(Directory('$base/content'));
  final fichier = File('$base/$cheminSortie');

  if (args.contains('--verifier')) {
    final aJour = fichier.existsSync() && fichier.readAsStringSync() == contenu;
    if (!aJour) {
      stderr.writeln(
        'tools/gen_contenu_embarque : $cheminSortie n\'est pas à jour — '
        'lancer dart run tools/gen_contenu_embarque.dart et committer le '
        'résultat.',
      );
      return 1;
    }
    stdout.writeln('tools/gen_contenu_embarque : $cheminSortie à jour.');
    return 0;
  }

  fichier.parent.createSync(recursive: true);
  fichier.writeAsStringSync(contenu);
  stdout.writeln('tools/gen_contenu_embarque : $cheminSortie écrit.');
  return 0;
}

String _genererJson(Directory content) {
  final sortie = <String, Object?>{
    '_genere': 'dart run tools/gen_contenu_embarque.dart — ne pas éditer',
  };
  for (final entree in _dossiers.entries) {
    sortie[entree.key] = _lireDossier(
      Directory('${content.path}/${entree.value}'),
    );
  }
  return '${const JsonEncoder.withIndent('  ').convert(sortie)}\n';
}

/// Les YAML d'un dossier, triés par `ordre` puis par `slug` (déterministe).
List<Map<String, Object?>> _lireDossier(Directory dossier) {
  if (!dossier.existsSync()) return const [];
  final elements = dossier
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.yaml'))
      .map((f) => _enDart(loadYaml(f.readAsStringSync())))
      .cast<Map<String, Object?>>()
      .toList();
  elements.sort((a, b) {
    final ordre = ((a['ordre'] as int?) ?? 0).compareTo(
      (b['ordre'] as int?) ?? 0,
    );
    return ordre != 0 ? ordre : '${a['slug']}'.compareTo('${b['slug']}');
  });
  return elements;
}

/// Convertit les `YamlMap`/`YamlList` en `Map`/`List` Dart ordinaires.
Object? _enDart(Object? v) => switch (v) {
  YamlMap() => {for (final e in v.entries) '${e.key}': _enDart(e.value)},
  YamlList() => [for (final e in v) _enDart(e)],
  _ => v,
};
