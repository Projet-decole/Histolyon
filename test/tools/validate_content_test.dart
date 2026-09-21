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
}
