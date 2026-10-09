// Story 5.1 (AD-7) : valide chaque fichier `content/<dossier>/*.yaml`
// contre le JSON Schema correspondant dans `content/schema/` (généré par
// tools/gen_types.dart, Story 4.2). Hook pre-commit de la Story 9.1.
//
// Usage : dart run tools/validate_content.dart
//
// Champs exemptés du `required` du schéma — jamais saisis dans le YAML
// d'un contenu éditorial, seul `id` (uuid généré côté client) reste exigé :
// - `created_at`/`updated_at` : colonnes gérées par la base (`default now()`).
// - `statut` : jamais touché par le seed (AD-6 — transitions par RPC
//   uniquement, Story 5.4), reste à sa valeur par défaut ('brouillon').
// - `provenance` : fixé par le seed lui-même ('editorial' pour tout
//   contenu de content/, Story 5.4), pas par l'auteur du YAML.

import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

const _champsExemptesDuRequired = {
  'created_at',
  'updated_at',
  'statut',
  'provenance',
};

/// Colonne DB (clé étrangère directe) -> nom du champ tel qu'un auteur de
/// contenu l'écrit (slug, pas uuid) — `tools/seed` (Story 5.4) résoudra le
/// slug en uuid au moment du seed. Le champ DB réel n'apparaît alors jamais
/// dans le YAML, donc exempté du required lui aussi.
const _champsReferenceParSlug = {'categorie_id': 'categorie'};

/// Champs structurels de contenu qui n'existent pas comme colonnes du
/// schéma DB (jonctions many-to-many, résolues par `tools/seed`) — une
/// liste de slugs, jamais un uuid brut.
const _champsJonctionParSlugs = {'epoques', 'sources'};

/// `medias` : liste de références vers `content/medias.yaml` (manifeste
/// bucket/slug/fichier -> licence, Story 5.2/5.3), pas une colonne DB.
const _champMedias = 'medias';

/// `localisation` : la colonne DB est `geography` (WKB en base), mais un
/// auteur de contenu écrit des coordonnées lisibles — `tools/seed`
/// convertira. Validé structurellement (objet {lat, lon} numériques),
/// pas contre le `type: string` du schéma DB.
const _champLocalisation = 'localisation';

/// `content/<dossier>` -> `content/schema/<table>.schema.json`. Un dossier
/// de contenu peut ne pas exister encore (ex. `parcours`, Epic 5 pas
/// terminé) — ignoré silencieusement plutôt qu'une erreur.
const _dossiersDeContenu = {
  'epoques': 'epoque',
  'categories': 'categorie',
  'pins': 'pin',
  'parcours': 'parcours',
  'sources': 'source_documentaire',
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

    final Map<String, dynamic> schema;
    try {
      schema =
          jsonDecode(fichierSchema.readAsStringSync()) as Map<String, dynamic>;
    } catch (e) {
      violations.add(Violation(fichierSchema.path, 'JSON invalide : $e.'));
      continue;
    }

    for (final fichier in dossierContenu.listSync()) {
      if (fichier is! File || !fichier.path.endsWith('.yaml')) continue;
      final dynamic document;
      try {
        document = loadYaml(fichier.readAsStringSync());
      } catch (e) {
        violations.add(Violation(fichier.path, 'YAML invalide : $e.'));
        continue;
      }
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
    (champ) =>
        !_champsExemptesDuRequired.contains(champ) &&
        !_champsReferenceParSlug.containsKey(champ),
  );
  for (final champ in required) {
    if (!document.containsKey(champ) || document[champ] == null) {
      violations.add(Violation(chemin, "champ requis manquant : '$champ'."));
    }
  }
  for (final entry in _champsReferenceParSlug.entries) {
    if (!((schema['required'] as List?)?.contains(entry.key) ?? false)) {
      continue;
    }
    final valeur = document[entry.value];
    if (valeur is! String || valeur.isEmpty) {
      violations.add(
        Violation(chemin, "champ requis manquant : '${entry.value}' (slug)."),
      );
    }
  }

  final properties = (schema['properties'] as Map?) ?? {};
  for (final cle in document.keys) {
    final nomChamp = cle.toString();

    if (_champsJonctionParSlugs.contains(nomChamp)) {
      final valeur = document[cle];
      if (valeur is! YamlList || valeur.any((v) => v is! String || v.isEmpty)) {
        violations.add(
          Violation(chemin, "'$nomChamp' doit être une liste de slugs."),
        );
      }
      continue;
    }

    if (nomChamp == _champMedias) {
      final valeur = document[cle];
      final valide =
          valeur is YamlList &&
          valeur.every(
            (v) =>
                v is YamlMap &&
                v.keys.every((k) => k == 'role' || k == 'media_slug') &&
                v['role'] is String &&
                (v['role'] as String).isNotEmpty &&
                v['media_slug'] is String &&
                (v['media_slug'] as String).isNotEmpty,
          );
      if (!valide) {
        violations.add(
          Violation(
            chemin,
            "'$_champMedias' doit être une liste de {role, media_slug}.",
          ),
        );
      }
      continue;
    }

    if (nomChamp == _champLocalisation) {
      final valeur = document[cle];
      if (valeur is! YamlMap ||
          valeur['lat'] is! num ||
          valeur['lon'] is! num) {
        violations.add(
          Violation(
            chemin,
            "'$_champLocalisation' doit être {lat: <num>, lon: <num>}.",
          ),
        );
      } else if ((valeur['lat'] as num).abs() > 90 ||
          (valeur['lon'] as num).abs() > 180) {
        violations.add(
          Violation(
            chemin,
            "'$_champLocalisation' hors bornes : lat dans [-90, 90], lon dans "
            '[-180, 180] (lat et lon inversées ?).',
          ),
        );
      }
      continue;
    }

    if (_champsReferenceParSlug.values.contains(nomChamp)) {
      final valeur = document[cle];
      if (valeur is! String || valeur.isEmpty) {
        violations.add(Violation(chemin, "'$nomChamp' doit être un slug."));
      }
      continue;
    }

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
