// Story 5.1 (AD-7) : valide chaque fichier `content/<dossier>/*.yaml`
// contre le JSON Schema correspondant dans `content/schema/` (généré par
// tools/gen_types.dart, Story 4.2). Hook pre-commit de la Story 9.1.
//
// Usage : dart run tools/validate_content.dart
//
// `created_at`/`updated_at` sont exemptés du `required` du schéma : ce
// sont des colonnes gérées par la base (`default now()`), jamais saisies
// dans le YAML d'un contenu éditorial — seul `id` (uuid généré côté
// client, AD partagée sur tout le projet) reste exigé.

import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

const _champsExemptesDuRequired = {'created_at', 'updated_at'};

/// `content/<dossier>` -> `content/schema/<table>.schema.json`. Un dossier
/// de contenu peut ne pas exister encore (ex. `parcours`, Epic 5 pas
/// terminé) — ignoré silencieusement plutôt qu'une erreur.
const _dossiersDeContenu = {
  'epoques': 'epoque',
  'categories': 'categorie',
  'pins': 'pin',
  'parcours': 'parcours',
};

class Violation {
  Violation(this.fichier, this.message);
  final String fichier;
  final String message;

  @override
  String toString() => '$fichier: $message';
}

int evaluerValidationContent({
  required bool contentExiste,
  required bool schemaExiste,
}) {
  if (!contentExiste) {
    stdout.writeln('tools/validate_content: content/ absent — rien à valider.');
    return 0;
  }

  if (!schemaExiste) {
    stderr.writeln(
      'tools/validate_content: content/ existe mais content/schema/ est '
      'absent (Epic 4 non terminé) — refus par prudence plutôt que faux '
      'positif.',
    );
    return 1;
  }

  final violations = <Violation>[];
  for (final entry in _dossiersDeContenu.entries) {
    final dossierContenu = Directory('content/${entry.key}');
    if (!dossierContenu.existsSync()) continue;

    final fichierSchema = File('content/schema/${entry.value}.schema.json');
    if (!fichierSchema.existsSync()) {
      violations.add(
        Violation(
          dossierContenu.path,
          'content/schema/${entry.value}.schema.json introuvable — '
          'relancer `dart run tools/gen_types.dart`.',
        ),
      );
      continue;
    }

    final schema =
        jsonDecode(fichierSchema.readAsStringSync()) as Map<String, dynamic>;

    for (final fichier in dossierContenu.listSync()) {
      if (fichier is! File || !fichier.path.endsWith('.yaml')) continue;
      final document = loadYaml(fichier.readAsStringSync());
      violations.addAll(_validerContreSchema(fichier.path, document, schema));
    }
  }

  if (violations.isNotEmpty) {
    stderr.writeln(
      'tools/validate_content: ${violations.length} violation(s) :\n',
    );
    for (final v in violations) {
      stderr.writeln('  - $v');
    }
    return 1;
  }

  stdout.writeln('tools/validate_content: tous les fichiers valident.');
  return 0;
}

List<Violation> _validerContreSchema(
  String chemin,
  dynamic document,
  Map<String, dynamic> schema,
) {
  final violations = <Violation>[];
  if (document is! YamlMap) {
    return [Violation(chemin, 'le document racine doit être un objet.')];
  }

  final required = ((schema['required'] as List?) ?? []).cast<String>().where(
    (champ) => !_champsExemptesDuRequired.contains(champ),
  );
  for (final champ in required) {
    if (!document.containsKey(champ) || document[champ] == null) {
      violations.add(Violation(chemin, "champ requis manquant : '$champ'."));
    }
  }

  final properties = (schema['properties'] as Map?) ?? {};
  for (final cle in document.keys) {
    final nomChamp = cle.toString();
    final proprieteSchema = properties[nomChamp] as Map?;
    if (proprieteSchema == null) {
      violations.add(
        Violation(chemin, "champ inconnu du schéma : '$nomChamp'."),
      );
      continue;
    }
    final valeur = document[cle];
    if (valeur == null) continue;

    final typeAttendu = proprieteSchema['type'] as String?;
    if (typeAttendu != null && !_typeCorrespond(valeur, typeAttendu)) {
      violations.add(
        Violation(
          chemin,
          "'$nomChamp' devrait être de type $typeAttendu, "
          'trouvé ${valeur.runtimeType}.',
        ),
      );
    }

    final enumAttendu = (proprieteSchema['enum'] as List?)?.cast<String>();
    if (enumAttendu != null && !enumAttendu.contains(valeur.toString())) {
      violations.add(
        Violation(
          chemin,
          "'$nomChamp' = '$valeur' hors de l'enum $enumAttendu.",
        ),
      );
    }

    if (proprieteSchema['format'] == 'uuid' && !_estUuid(valeur.toString())) {
      violations.add(
        Violation(chemin, "'$nomChamp' = '$valeur' n'est pas un uuid."),
      );
    }
  }

  return violations;
}

bool _typeCorrespond(dynamic valeur, String typeAttendu) {
  return switch (typeAttendu) {
    'string' => valeur is String,
    'integer' => valeur is int,
    'number' => valeur is num,
    'boolean' => valeur is bool,
    'object' => valeur is Map,
    'array' => valeur is List,
    _ => true,
  };
}

final _regexUuid = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  caseSensitive: false,
);

bool _estUuid(String valeur) => _regexUuid.hasMatch(valeur);

void main() {
  exitCode = evaluerValidationContent(
    contentExiste: Directory('content').existsSync(),
    schemaExiste: Directory('content/schema').existsSync(),
  );
}
