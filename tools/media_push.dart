import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

// Story 5.3 (AD-7, AD-19) : téléverse les binaires listés dans
// content/medias.yaml depuis un dossier partagé vers Supabase Storage, au
// chemin <bucket>/<slug>/<fichier> — les médias ne polluent jamais Git.
//
// Usage : dart run tools/media_push.dart
// Lit SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY et MEDIA_SOURCE_DIR (dossier
// partagé local, ex. un point de montage OneDrive/SharePoint synchronisé —
// chemin propre à chaque poste, jamais commité) dans l'environnement.

/// Extension -> (content-type, taille max en octets). Limites de la
/// convention Config & secrets / AD-19.
const _formatsAutorises = {
  '.webp': (contentType: 'image/webp', tailleMaxOctets: 500 * 1024),
  '.m4a': (contentType: 'audio/mp4', tailleMaxOctets: 5 * 1024 * 1024),
  '.glb': (contentType: 'model/gltf-binary', tailleMaxOctets: 20 * 1024 * 1024),
};

Future<void> main() async {
  final url = Platform.environment['SUPABASE_URL'];
  final key = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'];
  final dossierSource = Platform.environment['MEDIA_SOURCE_DIR'];
  if (url == null || key == null || dossierSource == null) {
    stderr.writeln(
      'tools/media_push : SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY et '
      'MEDIA_SOURCE_DIR doivent être renseignées dans l\'environnement — '
      'MEDIA_SOURCE_DIR pointe vers le dossier partagé local (jamais '
      'commité, propre à chaque poste).',
    );
    exitCode = 1;
    return;
  }

  final manifeste = File('content/medias.yaml');
  if (!manifeste.existsSync()) {
    stdout.writeln(
      'tools/media_push : content/medias.yaml absent — rien à téléverser.',
    );
    return;
  }

  final contenuManifeste = loadYaml(manifeste.readAsStringSync());
  if (contenuManifeste is! YamlList) {
    stderr.writeln(
      'tools/media_push : content/medias.yaml vide ou mal formé — attendu '
      'une liste au premier niveau.',
    );
    exitCode = 1;
    return;
  }
  final entrees = contenuManifeste;
  final client = HttpClient();
  var succes = 0;

  for (final entree in entrees) {
    final bucket = entree['bucket'];
    final slug = entree['slug'];
    final fichier = entree['fichier'];
    final mediaSlug = entree['media_slug'];
    if (bucket is! String ||
        slug is! String ||
        fichier is! String ||
        mediaSlug is! String) {
      stderr.writeln(
        'tools/media_push : entrée invalide dans content/medias.yaml — '
        "'bucket', 'slug', 'fichier' et 'media_slug' doivent tous être "
        'renseignés en chaîne ($entree).',
      );
      exitCode = 1;
      continue;
    }
    final cheminSource = '$dossierSource/$fichier';
    final sourceFile = File(cheminSource);

    if (!sourceFile.existsSync()) {
      stderr.writeln(
        "tools/media_push : '$mediaSlug' — fichier source introuvable "
        '($cheminSource) dans le dossier partagé.',
      );
      exitCode = 1;
      continue;
    }

    final extension = _extension(fichier);
    final format = _formatsAutorises[extension];
    if (format == null) {
      stderr.writeln(
        "tools/media_push : '$mediaSlug' — format '$extension' non "
        'autorisé (formats gérés : ${_formatsAutorises.keys.join(', ')}).',
      );
      exitCode = 1;
      continue;
    }

    final tailleOctets = sourceFile.lengthSync();
    if (tailleOctets > format.tailleMaxOctets) {
      stderr.writeln(
        "tools/media_push : '$mediaSlug' — ${tailleOctets ~/ 1024} Ko "
        'dépasse le budget $extension '
        '(${format.tailleMaxOctets ~/ 1024} Ko max).',
      );
      exitCode = 1;
      continue;
    }

    final cheminStorage = '$bucket/$slug/$fichier';
    try {
      await _televerser(
        client: client,
        url: url,
        key: key,
        cheminStorage: cheminStorage,
        contenu: sourceFile.readAsBytesSync(),
        contentType: format.contentType,
      );
      stdout.writeln(
        "tools/media_push : '$mediaSlug' -> $cheminStorage "
        '(${tailleOctets ~/ 1024} Ko).',
      );
      succes++;
    } catch (e) {
      stderr.writeln("tools/media_push : '$mediaSlug' — échec upload : $e");
      exitCode = 1;
    }
  }

  client.close();
  stdout.writeln(
    'tools/media_push : $succes/${entrees.length} média(s) téléversé(s).',
  );
}

String _extension(String fichier) {
  final point = fichier.lastIndexOf('.');
  return point == -1 ? '' : fichier.substring(point).toLowerCase();
}

Future<void> _televerser({
  required HttpClient client,
  required String url,
  required String key,
  required String cheminStorage,
  required List<int> contenu,
  required String contentType,
}) async {
  final uri = Uri.parse('$url/storage/v1/object/$cheminStorage');
  final request = await client.postUrl(uri);
  request.headers
    ..set('apikey', key)
    ..set('Authorization', 'Bearer $key')
    ..set('Content-Type', contentType)
    ..set('x-upsert', 'true')
    ..contentLength = contenu.length;
  request.add(contenu);
  final response = await request.close();
  if (response.statusCode >= 300) {
    final corps = await response.transform(utf8.decoder).join();
    throw 'HTTP ${response.statusCode} : $corps';
  }
  await response.drain<void>();
}
