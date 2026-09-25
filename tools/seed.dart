import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

// Story 5.4 (AD-7) : charge content/{categories,epoques,sources,pins}/*.yaml
// en base Supabase locale — upsert idempotent par slug, ne touche jamais
// `statut` (AD-6 : transitions de cycle de vie par RPC uniquement), force
// toujours `provenance: editorial` (seul contenu géré par ce script).
//
// Usage : dart run tools/seed.dart (après `supabase db reset`)
// Lit SUPABASE_URL et SUPABASE_SERVICE_ROLE_KEY dans l'environnement
// (jamais commitées — voir `supabase status` en local).

Future<void> main() async {
  final url = Platform.environment['SUPABASE_URL'];
  final key = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'];
  if (url == null || key == null) {
    stderr.writeln(
      'tools/seed : SUPABASE_URL et SUPABASE_SERVICE_ROLE_KEY doivent être '
      "renseignées dans l'environnement (jamais commitées) — voir "
      '`supabase status` en local.',
    );
    exitCode = 1;
    return;
  }

  final validation = await Process.run('dart', [
    'run',
    'tools/validate_content.dart',
  ]);
  stdout.write(validation.stdout);
  stderr.write(validation.stderr);
  if (validation.exitCode != 0) {
    stderr.writeln('tools/seed : contenu invalide (voir ci-dessus) — annulé.');
    exitCode = 1;
    return;
  }

  final db = _Postgrest(url, key);

  final categories = _chargerParSlug('content/categories');
  final epoques = _chargerParSlug('content/epoques');
  final sources = _chargerParSlug('content/sources');
  final pins = _chargerParSlug('content/pins');

  for (final categorie in categories.values) {
    await _essayer(
      "categorie '${categorie['slug']}'",
      () => db.upsert('categorie', {
        'id': categorie['id'],
        'slug': categorie['slug'],
        'libelle': categorie['libelle'],
        if (categorie['description'] != null)
          'description': categorie['description'],
        'ordre': categorie['ordre'],
      }, onConflict: 'slug'),
    );
  }
  stdout.writeln('tools/seed : ${categories.length} catégorie(s).');

  for (final epoque in epoques.values) {
    await _essayer(
      "epoque '${epoque['slug']}'",
      () => db.upsert('epoque', {
        'id': epoque['id'],
        'slug': epoque['slug'],
        'libelle': epoque['libelle'],
        'borne_debut': epoque['borne_debut'],
        'borne_fin': epoque['borne_fin'],
        'ordre': epoque['ordre'],
      }, onConflict: 'slug'),
    );
  }
  stdout.writeln('tools/seed : ${epoques.length} époque(s).');

  for (final source in sources.values) {
    await _essayer(
      "source '${source['slug']}'",
      () => db.upsert('source_documentaire', {
        'id': source['id'],
        'slug': source['slug'],
        'type': source['type'],
        'reference': source['reference'],
        'credit': source['credit'],
        if (source['lien'] != null) 'lien': source['lien'],
        if (source['description'] != null) 'description': source['description'],
      }, onConflict: 'slug'),
    );
  }
  stdout.writeln('tools/seed : ${sources.length} source(s).');

  for (final pin in pins.values) {
    final slugCategorie = pin['categorie'] as String;
    final categorieId = categories[slugCategorie]?['id'];
    if (categorieId == null) {
      stderr.writeln(
        "tools/seed : pin '${pin['slug']}' référence la catégorie inconnue "
        "'$slugCategorie'.",
      );
      exitCode = 1;
      continue;
    }

    final payload = <String, dynamic>{
      'id': pin['id'],
      'slug': pin['slug'],
      'titre': pin['titre'],
      'provenance': 'editorial',
      'categorie_id': categorieId,
      'contenu_narratif': pin['contenu_narratif'],
    };
    final localisation = pin['localisation'] as Map?;
    if (localisation != null) {
      payload['localisation'] =
          'POINT(${localisation['lon']} ${localisation['lat']})';
    }
    final pinOk = await _essayer(
      "pin '${pin['slug']}'",
      () => db.upsert('pin', payload, onConflict: 'slug'),
    );
    if (!pinOk) continue;

    final pinId = pin['id'] as String;

    if (await _essayer(
      "purge pin_epoque de '${pin['slug']}'",
      () => db.delete('pin_epoque', 'pin_id=eq.$pinId'),
    )) {
      for (final slugEpoque in (pin['epoques'] as List? ?? const [])) {
        final epoqueId = epoques[slugEpoque]?['id'];
        if (epoqueId == null) {
          stderr.writeln(
            "tools/seed : pin '${pin['slug']}' référence l'époque inconnue "
            "'$slugEpoque'.",
          );
          exitCode = 1;
          continue;
        }
        await _essayer(
          "pin_epoque '${pin['slug']}' -> '$slugEpoque'",
          () => db.upsert('pin_epoque', {
            'pin_id': pinId,
            'epoque_id': epoqueId,
          }, onConflict: 'pin_id,epoque_id'),
        );
      }
    }

    if (await _essayer(
      "purge pin_source de '${pin['slug']}'",
      () => db.delete('pin_source', 'pin_id=eq.$pinId'),
    )) {
      for (final slugSource in (pin['sources'] as List? ?? const [])) {
        final sourceId = sources[slugSource]?['id'];
        if (sourceId == null) {
          stderr.writeln(
            "tools/seed : pin '${pin['slug']}' référence la source inconnue "
            "'$slugSource'.",
          );
          exitCode = 1;
          continue;
        }
        await _essayer(
          "pin_source '${pin['slug']}' -> '$slugSource'",
          () => db.upsert('pin_source', {
            'pin_id': pinId,
            'source_id': sourceId,
          }, onConflict: 'pin_id,source_id'),
        );
      }
    }
  }
  stdout.writeln('tools/seed : ${pins.length} pin(s).');

  db.close();
  if (exitCode == 0) stdout.writeln('tools/seed : terminé.');
}

/// Exécute une écriture PostgREST en rapportant un échec (réseau, contrainte,
/// RLS) comme une ligne stderr + `exitCode = 1`, sans interrompre le reste du
/// seed — même politique de tolérance que les lookups de clé étrangère
/// ci-dessus plutôt qu'un crash qui abandonnerait tout le contenu restant.
Future<bool> _essayer(
  String description,
  Future<void> Function() action,
) async {
  try {
    await action();
    return true;
  } catch (e) {
    stderr.writeln('tools/seed : $description a échoué — $e');
    exitCode = 1;
    return false;
  }
}

/// Charge tous les `*.yaml` d'un dossier de contenu, indexés par leur
/// `slug` — conversion récursive YAML -> types Dart natifs (json-encodables).
Map<String, dynamic> _chargerParSlug(String dossier) {
  final resultat = <String, dynamic>{};
  final dir = Directory(dossier);
  if (!dir.existsSync()) return resultat;

  for (final fichier in dir.listSync()) {
    if (fichier is! File || !fichier.path.endsWith('.yaml')) continue;
    final document = _versDartPur(loadYaml(fichier.readAsStringSync()));
    resultat[document['slug'] as String] = document;
  }
  return resultat;
}

dynamic _versDartPur(dynamic node) {
  if (node is YamlMap) {
    return {
      for (final entry in node.entries)
        entry.key.toString(): _versDartPur(entry.value),
    };
  }
  if (node is YamlList) {
    return node.map(_versDartPur).toList();
  }
  return node;
}

/// Client HTTP minimal contre PostgREST — pas de dépendance pub tierce
/// (dart:io seul), même convention que tools/gen_types.dart et
/// tools/check_import_direction.dart.
class _Postgrest {
  _Postgrest(this._url, this._key) : _client = HttpClient();

  final String _url;
  final String _key;
  final HttpClient _client;

  Future<void> upsert(
    String table,
    Map<String, dynamic> ligne, {
    required String onConflict,
  }) async {
    final uri = Uri.parse('$_url/rest/v1/$table?on_conflict=$onConflict');
    final corpsOctets = utf8.encode(jsonEncode(ligne));
    final request = await _client.postUrl(uri);
    request.headers
      ..set('apikey', _key)
      ..set('Authorization', 'Bearer $_key')
      ..set('Content-Type', 'application/json')
      ..set('Prefer', 'resolution=merge-duplicates,return=minimal')
      ..contentLength = corpsOctets.length;
    request.add(corpsOctets);
    final response = await request.close();
    if (response.statusCode >= 300) {
      final corps = await response.transform(utf8.decoder).join();
      throw 'upsert $table a échoué (HTTP ${response.statusCode}) : $corps';
    }
    await response.drain<void>();
  }

  Future<void> delete(String table, String filtre) async {
    final uri = Uri.parse('$_url/rest/v1/$table?$filtre');
    final request = await _client.deleteUrl(uri);
    request.headers
      ..set('apikey', _key)
      ..set('Authorization', 'Bearer $_key');
    final response = await request.close();
    if (response.statusCode >= 300) {
      final corps = await response.transform(utf8.decoder).join();
      throw 'delete $table a échoué (HTTP ${response.statusCode}) : $corps';
    }
    await response.drain<void>();
  }

  void close() => _client.close();
}
