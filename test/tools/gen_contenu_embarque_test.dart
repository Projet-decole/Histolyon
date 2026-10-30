import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../../tools/gen_contenu_embarque.dart';

void main() {
  late Directory racine;

  void ecrire(String chemin, String contenu) {
    final f = File('${racine.path}/$chemin');
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(contenu);
  }

  File sortie() =>
      File('${racine.path}/apps/mobile/assets/contenu/contenu.json');

  setUp(() {
    racine = Directory.systemTemp.createTempSync('gen_contenu_test_');
    ecrire('content/epoques/b.yaml', '''
id: e2
slug: b_epoque
libelle: Seconde
borne_debut: 1000
borne_fin: 1500
ordre: 2
''');
    ecrire('content/epoques/a.yaml', '''
id: e1
slug: a_epoque
libelle: Première
borne_debut: 0
borne_fin: 1000
ordre: 1
''');
    ecrire('content/categories/anecdote.yaml', '''
id: c1
slug: anecdote
libelle: Anecdote
ordre: 1
''');
    ecrire('content/sources/s.yaml', '''
id: s1
slug: source-fictive
type: page_web
reference: "Source fictive"
credit: "Crédit"
''');
    ecrire('content/pins/p.yaml', '''
id: p1
slug: pin-fictif
titre: Pin fictif
categorie: anecdote
epoques: [a_epoque]
sources: [source-fictive]
localisation: {lat: 45.76, lon: 4.83}
contenu_narratif:
  teaser: Un teaser.
  narration: |
    Une narration.
  post_narratif:
    - type: le_saviez_vous
      texte: Un encart.
''');
    // Le contenu de démonstration ne doit jamais être embarqué.
    ecrire('content/demo/pins/demo.yaml', 'id: d1\nslug: demo\n');
  });

  tearDown(() => racine.deleteSync(recursive: true));

  test('génère un JSON trié par ordre, sans le contenu de démo', () async {
    expect(await executer([], racine: racine), 0);
    final json = jsonDecode(sortie().readAsStringSync()) as Map;

    expect((json['epoques'] as List).map((e) => (e as Map)['slug']), [
      'a_epoque',
      'b_epoque',
    ]);
    expect((json['categories'] as List), hasLength(1));
    expect((json['sources'] as List), hasLength(1));
    final pins = json['pins'] as List;
    expect(pins, hasLength(1));
    final pin = pins.single as Map;
    expect(pin['slug'], 'pin-fictif');
    expect(pin['localisation'], {'lat': 45.76, 'lon': 4.83});
    expect((pin['contenu_narratif'] as Map)['post_narratif'], [
      {'type': 'le_saviez_vous', 'texte': 'Un encart.'},
    ]);
  });

  test('la génération est déterministe', () async {
    await executer([], racine: racine);
    final premier = sortie().readAsStringSync();
    await executer([], racine: racine);
    expect(sortie().readAsStringSync(), premier);
  });

  test('--verifier échoue si le fichier est absent', () async {
    expect(await executer(['--verifier'], racine: racine), 1);
  });

  test('--verifier réussit quand le fichier est à jour', () async {
    await executer([], racine: racine);
    expect(await executer(['--verifier'], racine: racine), 0);
  });

  test(
    '--verifier échoue quand content/ a changé depuis la génération',
    () async {
      await executer([], racine: racine);
      ecrire('content/categories/anecdote.yaml', '''
id: c1
slug: anecdote
libelle: Anecdote modifiée
ordre: 1
''');
      expect(await executer(['--verifier'], racine: racine), 1);
      expect(await executer([], racine: racine), 0);
      expect(await executer(['--verifier'], racine: racine), 0);
    },
  );
}
