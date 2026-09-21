import 'dart:io';

import 'package:test/test.dart';

import '../../tools/validate_content.dart';

void main() {
  test('content/ absent -> rien à valider (0)', () {
    expect(
      evaluerValidationContent(contentExiste: false, schemaExiste: false),
      0,
    );
  });

  test('content/ existe sans content/schema/ -> refus (1)', () {
    expect(
      evaluerValidationContent(contentExiste: true, schemaExiste: false),
      1,
    );
  });

  group('validation réelle contre le schéma (Story 5.1)', () {
    late Directory tempDir;
    late Directory cwdOrigine;

    setUp(() {
      cwdOrigine = Directory.current;
      tempDir = Directory.systemTemp.createTempSync('validate_content_test_');
      Directory('${tempDir.path}/content/categories')
          .createSync(recursive: true);
      Directory('${tempDir.path}/content/schema').createSync(recursive: true);
      File('${tempDir.path}/content/schema/categorie.schema.json')
          .writeAsStringSync('''
{
  "required": ["id", "slug", "libelle", "ordre", "created_at"],
  "properties": {
    "id": {"type": "string", "format": "uuid"},
    "slug": {"type": "string"},
    "libelle": {"type": "string"},
    "description": {"type": "string"},
    "ordre": {"type": "integer"}
  }
}
''');
      Directory.current = tempDir;
    });

    tearDown(() {
      Directory.current = cwdOrigine;
      tempDir.deleteSync(recursive: true);
    });

    test('un fichier conforme valide (0)', () {
      File('${tempDir.path}/content/categories/ok.yaml').writeAsStringSync('''
id: 9df72f8d-a04a-4dc6-a2e4-b32fbb935d5e
slug: classique
libelle: Classique
ordre: 1
''');
      expect(
        evaluerValidationContent(contentExiste: true, schemaExiste: true),
        0,
      );
    });

    test('champ requis manquant -> refus (1)', () {
      File('${tempDir.path}/content/categories/incomplet.yaml')
          .writeAsStringSync('''
id: 9df72f8d-a04a-4dc6-a2e4-b32fbb935d5e
slug: classique
''');
      expect(
        evaluerValidationContent(contentExiste: true, schemaExiste: true),
        1,
      );
    });

    test('id qui n\'est pas un uuid -> refus (1)', () {
      File('${tempDir.path}/content/categories/mauvais-id.yaml')
          .writeAsStringSync('''
id: pas-un-uuid
slug: classique
libelle: Classique
ordre: 1
''');
      expect(
        evaluerValidationContent(contentExiste: true, schemaExiste: true),
        1,
      );
    });

    test('champ inconnu du schéma -> refus (1)', () {
      File('${tempDir.path}/content/categories/champ-en-trop.yaml')
          .writeAsStringSync('''
id: 9df72f8d-a04a-4dc6-a2e4-b32fbb935d5e
slug: classique
libelle: Classique
ordre: 1
un_champ_qui_nexiste_pas: 42
''');
      expect(
        evaluerValidationContent(contentExiste: true, schemaExiste: true),
        1,
      );
    });

    test('created_at absent du YAML ne compte pas comme requis manquant', () {
      File('${tempDir.path}/content/categories/sans-created-at.yaml')
          .writeAsStringSync('''
id: 9df72f8d-a04a-4dc6-a2e4-b32fbb935d5e
slug: classique
libelle: Classique
ordre: 1
''');
      expect(
        evaluerValidationContent(contentExiste: true, schemaExiste: true),
        0,
      );
    });
  });

  group('pin : références par slug, jonctions, localisation, médias', () {
    late Directory tempDir;
    late Directory cwdOrigine;

    setUp(() {
      cwdOrigine = Directory.current;
      tempDir = Directory.systemTemp.createTempSync('validate_content_test_');
      Directory('${tempDir.path}/content/pins').createSync(recursive: true);
      Directory('${tempDir.path}/content/schema').createSync(recursive: true);
      File('${tempDir.path}/content/schema/pin.schema.json')
          .writeAsStringSync('''
{
  "required": ["id", "slug", "titre", "provenance", "categorie_id", "contenu_narratif", "statut", "created_at", "updated_at"],
  "properties": {
    "id": {"type": "string", "format": "uuid"},
    "slug": {"type": "string"},
    "titre": {"type": "string"},
    "provenance": {"type": "string", "enum": ["editorial", "communautaire"]},
    "categorie_id": {"type": "string", "format": "uuid"},
    "contenu_narratif": {"format": "jsonb"},
    "statut": {"type": "string", "enum": ["brouillon", "en_revue", "valide", "publie", "retire"]},
    "localisation": {"type": "string", "format": "public.geography(Point,4326)"},
    "created_at": {"type": "string"},
    "updated_at": {"type": "string"}
  }
}
''');
      Directory.current = tempDir;
    });

    tearDown(() {
      Directory.current = cwdOrigine;
      tempDir.deleteSync(recursive: true);
    });

    test(
      'pin complet (categorie/epoques/sources/localisation/medias) valide (0)',
      () {
        File('${tempDir.path}/content/pins/ok.yaml').writeAsStringSync('''
id: 969de5f0-ae71-4869-ac48-fbff8134d677
slug: demo
titre: Demo
categorie: anecdote
epoques: [moyen_age, aujourd_hui]
sources: [demo-archive-fictive]
localisation:
  lat: 45.76
  lon: 4.83
contenu_narratif:
  teaser: t
  narration: n
medias:
  - role: narration_audio
    media_slug: demo-narration
''');
        expect(
          evaluerValidationContent(contentExiste: true, schemaExiste: true),
          0,
        );
      },
    );

    test('categorie manquante -> refus (1)', () {
      File('${tempDir.path}/content/pins/sans-categorie.yaml')
          .writeAsStringSync('''
id: 969de5f0-ae71-4869-ac48-fbff8134d677
slug: demo
titre: Demo
contenu_narratif:
  teaser: t
''');
      expect(
        evaluerValidationContent(contentExiste: true, schemaExiste: true),
        1,
      );
    });

    test('localisation mal formée -> refus (1)', () {
      File('${tempDir.path}/content/pins/mauvaise-localisation.yaml')
          .writeAsStringSync('''
id: 969de5f0-ae71-4869-ac48-fbff8134d677
slug: demo
titre: Demo
categorie: anecdote
contenu_narratif:
  teaser: t
localisation: "45.76,4.83"
''');
      expect(
        evaluerValidationContent(contentExiste: true, schemaExiste: true),
        1,
      );
    });

    test('epoques qui ne sont pas une liste de slugs -> refus (1)', () {
      File('${tempDir.path}/content/pins/mauvaises-epoques.yaml')
          .writeAsStringSync('''
id: 969de5f0-ae71-4869-ac48-fbff8134d677
slug: demo
titre: Demo
categorie: anecdote
contenu_narratif:
  teaser: t
epoques: moyen_age
''');
      expect(
        evaluerValidationContent(contentExiste: true, schemaExiste: true),
        1,
      );
    });

    test('medias mal formés (media_slug manquant) -> refus (1)', () {
      File('${tempDir.path}/content/pins/mauvais-medias.yaml')
          .writeAsStringSync('''
id: 969de5f0-ae71-4869-ac48-fbff8134d677
slug: demo
titre: Demo
categorie: anecdote
contenu_narratif:
  teaser: t
medias:
  - role: narration_audio
''');
      expect(
        evaluerValidationContent(contentExiste: true, schemaExiste: true),
        1,
      );
    });

    test('medias avec une clé inconnue -> refus (1)', () {
      File('${tempDir.path}/content/pins/medias-cle-inconnue.yaml')
          .writeAsStringSync('''
id: 969de5f0-ae71-4869-ac48-fbff8134d677
slug: demo
titre: Demo
categorie: anecdote
contenu_narratif:
  teaser: t
medias:
  - role: narration_audio
    media_slug: demo-narration
    licence_bricolee_a_la_main: CC-BY
''');
      expect(
        evaluerValidationContent(contentExiste: true, schemaExiste: true),
        1,
      );
    });

    test('YAML invalide -> refus (1), sans planter le run', () {
      File('${tempDir.path}/content/pins/yaml-invalide.yaml')
          .writeAsStringSync('titre: ["liste ouverte jamais refermée');
      expect(
        evaluerValidationContent(contentExiste: true, schemaExiste: true),
        1,
      );
    });
  });
}
