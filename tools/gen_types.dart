import 'dart:convert';
import 'dart:io';

// Story 4.2 (AD-3) : régénère packages/api_types (Dart, via supadart) et
// content/schema/ (JSON Schema) depuis le schéma Supabase local — jamais
// de modèle écrit à la main.
//
// Usage : dart run tools/gen_types.dart
// Lit SUPABASE_URL et SUPABASE_SERVICE_ROLE_KEY dans l'environnement
// (jamais commitées — voir `supabase status` en local).
//
// Deux limites de supadart 1.9.3 contournées ici plutôt que dans le
// fichier généré (cf. spike Story 4.1, .memlog.md de la spine) :
//
// 1. Il ne génère PAS les déclarations `enum Xxx { ... }` depuis le schéma
//    tout seul — il faut les lister dans `enums:` de sa config. Ce script
//    les déduit lui-même du JSON Schema PostgREST et les injecte dans une
//    copie temporaire de `packages/api_types/supadart.yaml`.
// 2. `postgis`/`pgtap` vivent dans le schéma `public` (pas `extensions`,
//    contrairement aux extensions par défaut de Supabase — écart de la
//    migration 0001_socle.sql, non corrigé ici pour ne pas risquer de
//    casser une migration déjà mergée) : PostgREST expose donc leurs
//    tables/vues internes (`spatial_ref_sys`, `tap_funky`, `pg_all_foreign_keys`...)
//    et supadart ne sait pas générer certaines de leurs colonnes (`oid`),
//    ce qui casse la compilation. Ce script fait tourner supadart contre
//    un proxy HTTP local qui ne laisse passer que les tables réellement
//    créées par `supabase/migrations/*.sql` — jamais d'édition du fichier
//    généré, juste une entrée filtrée.

const _tablesContenu = ['pin', 'parcours', 'epoque', 'categorie'];
const _configStatique = 'packages/api_types/supadart.yaml';
const _sortieApiTypes = 'packages/api_types/lib/';
const _dossierSchema = 'content/schema';
const _dossierMigrations = 'supabase/migrations';

Future<void> main() async {
  final url = Platform.environment['SUPABASE_URL'];
  final key = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'];
  if (url == null || key == null) {
    stderr.writeln(
      'tools/gen-types : SUPABASE_URL et SUPABASE_SERVICE_ROLE_KEY doivent '
      "être renseignées dans l'environnement (jamais commitées) — "
      'voir `supabase status` en local pour les récupérer.',
    );
    exitCode = 1;
    return;
  }

  final Map<String, dynamic> swaggerComplet;
  try {
    swaggerComplet = await _recupererSwagger(url, key);
  } catch (e) {
    stderr.writeln('tools/gen-types : impossible de joindre $url — $e');
    exitCode = 1;
    return;
  }
  final definitionsCompletes = (swaggerComplet['definitions'] as Map)
      .cast<String, dynamic>();

  final tablesDuSchema = _tablesDuSchema();
  final definitions = Map<String, dynamic>.fromEntries(
    definitionsCompletes.entries.where((e) => tablesDuSchema.contains(e.key)),
  );

  final enums = _extraireEnums(definitions);
  final violation = _premierEnumNullable(definitions);
  if (violation != null) {
    stderr.writeln(
      'tools/gen-types : colonne enum NULLABLE détectée ($violation) — '
      'supadart 1.9.3 traite mal ce cas (un null lu en base devient '
      "silencieusement la première valeur de l'enum au lieu de null, "
      'cf. spike Story 4.1 dans .memlog.md de la spine). Refus de générer '
      'tant que cette colonne reste nullable : soit la rendre NOT NULL, '
      'soit adapter ce garde-fou en connaissance de cause.',
    );
    exitCode = 1;
    return;
  }

  await _genererApiTypes(
    url: url,
    key: key,
    enums: enums,
    definitions: definitions,
  );
  await _genererJsonSchema(definitions);

  stdout.writeln('tools/gen-types : terminé.');
}

Future<Map<String, dynamic>> _recupererSwagger(String url, String key) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse('$url/rest/v1/'));
    request.headers.set('apikey', key);
    request.headers.set('Authorization', 'Bearer $key');
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      throw 'HTTP ${response.statusCode} : $body';
    }
    return jsonDecode(body) as Map<String, dynamic>;
  } finally {
    client.close();
  }
}

/// Noms de table créés par `create table [if not exists] [public.]<nom>`
/// dans les migrations — l'allowlist de ce qui est vraiment NOTRE schéma,
/// par opposition aux tables/vues internes que `public.postgis`/`pgtap`
/// exposent (cf. commentaire d'en-tête).
Set<String> _tablesDuSchema() {
  final regex = RegExp(
    r'create\s+table\s+(?:if\s+not\s+exists\s+)?(?:public\.)?"?([a-z_][a-z0-9_]*)"?',
    caseSensitive: false,
  );
  final noms = <String>{};
  for (final entite in Directory(_dossierMigrations).listSync()) {
    if (entite is! File || !entite.path.endsWith('.sql')) continue;
    for (final m in regex.allMatches(entite.readAsStringSync())) {
      noms.add(m.group(1)!.toLowerCase());
    }
  }
  return noms;
}

/// `{nom_enum_postgres: [valeurs...]}` déduit des propriétés swagger dont
/// le `format` est `public.<nom>` et qui portent une clé `enum`.
Map<String, List<String>> _extraireEnums(Map<String, dynamic> definitions) {
  final enums = <String, List<String>>{};
  for (final table in definitions.values) {
    final properties = (table as Map)['properties'] as Map?;
    if (properties == null) continue;
    for (final colonne in properties.values) {
      final col = (colonne as Map);
      final valeurs = col['enum'];
      final format = col['format']?.toString() ?? '';
      if (valeurs is! List || !format.startsWith('public.')) continue;
      final nom = format.substring('public.'.length);
      enums[nom] = valeurs.cast<String>();
    }
  }
  return enums;
}

/// Renvoie `table.colonne` de la première colonne enum nullable trouvée,
/// ou `null` si aucune (cf. garde-fou du bug supadart, spike Story 4.1).
String? _premierEnumNullable(Map<String, dynamic> definitions) {
  for (final entry in definitions.entries) {
    final table = entry.value as Map;
    final properties = table['properties'] as Map?;
    if (properties == null) continue;
    final required = (table['required'] as List?)?.cast<String>() ?? [];
    for (final colEntry in properties.entries) {
      final col = colEntry.value as Map;
      final estEnum = col['enum'] is List;
      final estNullable = !required.contains(colEntry.key);
      if (estEnum && estNullable) {
        return '${entry.key}.${colEntry.key}';
      }
    }
  }
  return null;
}

Future<void> _genererApiTypes({
  required String url,
  required String key,
  required Map<String, List<String>> enums,
  required Map<String, dynamic> definitions,
}) async {
  final configStatique = File(_configStatique).readAsStringSync();
  final blocEnums = StringBuffer('enums:\n');
  enums.forEach((nom, valeurs) {
    blocEnums.writeln('  $nom: [${valeurs.join(', ')}]');
  });
  // Remplace la ligne `enums:` (seule, sans valeurs) du fichier statique par
  // le bloc introspecté — le fichier commité documente juste que ce bloc
  // est auto-rempli, il ne le porte jamais lui-même.
  final configComplete = configStatique.replaceFirst(
    RegExp(r'^enums:\s*$', multiLine: true),
    blocEnums.toString().trimRight(),
  );

  final configTemp = File(
    '${Directory.systemTemp.path}/supadart_${DateTime.now().microsecondsSinceEpoch}.yaml',
  );
  configTemp.writeAsStringSync(configComplete);

  final proxy = await _demarrerProxySwaggerFiltre(definitions);

  try {
    final resultat = await Process.run('dart', [
      'run',
      'supadart',
      '-c',
      configTemp.path,
      '-u',
      'http://127.0.0.1:${proxy.port}',
      '-k',
      key,
    ]);
    stdout.write(resultat.stdout);
    stderr.write(resultat.stderr);
    if (resultat.exitCode != 0) {
      throw 'supadart a échoué (exit ${resultat.exitCode})';
    }
  } finally {
    configTemp.deleteSync();
    await proxy.close(force: true);
  }
  stdout.writeln('tools/gen-types : $_sortieApiTypes régénéré.');
}

/// Sert `{"definitions": <definitionsFiltrees>}` sur `/rest/v1/` — supadart
/// n'utilise que ce champ de la réponse (cf. commentaire d'en-tête). Sert
/// aussi une liste de buckets vide sur `/storage/v1/bucket/` : supadart
/// traite un échec de cet appel comme fatal (`exit(1)`), et ce dépôt ne
/// déclare aucun bucket pour l'instant (Story 3.1).
Future<HttpServer> _demarrerProxySwaggerFiltre(
  Map<String, dynamic> definitionsFiltrees,
) async {
  final serveur = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  final corpsSwagger = utf8.encode(
    jsonEncode({'definitions': definitionsFiltrees}),
  );
  const corpsBuckets = '[]';
  serveur.listen((request) {
    request.response.headers.contentType = ContentType.json;
    if (request.uri.path.startsWith('/storage/')) {
      request.response.write(corpsBuckets);
    } else {
      request.response.add(corpsSwagger);
    }
    request.response.close();
  });
  return serveur;
}

/// Convertit chaque définition swagger (déjà quasi un JSON Schema) en
/// `content/schema/<table>.schema.json`, pour les tables de contenu
/// éditorial (AD-7). Une table listée mais absente du schéma (ex.
/// `parcours`, pas encore migré) est signalée et ignorée plutôt que de
/// produire un schéma inventé.
Future<void> _genererJsonSchema(Map<String, dynamic> definitions) async {
  final dossier = Directory(_dossierSchema)..createSync(recursive: true);
  const encoder = JsonEncoder.withIndent('  ');

  for (final table in _tablesContenu) {
    final definition = definitions[table];
    if (definition == null) {
      stdout.writeln(
        'tools/gen-types : table "$table" absente du schéma local — '
        "schéma non généré (normal tant que sa migration n'existe pas).",
      );
      continue;
    }

    final schema = {
      r'$schema': 'http://json-schema.org/draft-07/schema#',
      'title': table,
      ...Map<String, dynamic>.from(definition as Map),
    };

    final fichier = File('${dossier.path}/$table.schema.json');
    fichier.writeAsStringSync('${encoder.convert(schema)}\n');
  }
  stdout.writeln('tools/gen-types : $_dossierSchema régénéré.');
}
