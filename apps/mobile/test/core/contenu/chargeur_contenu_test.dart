import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/contenu/chargeur_contenu.dart';
import 'package:mobile/core/models/failure.dart';

const _json = '''
{
  "epoques": [
    {"id": "e1", "slug": "a_epoque", "libelle": "Première",
     "borne_debut": 0, "borne_fin": 1000, "ordre": 1}
  ],
  "categories": [
    {"id": "c1", "slug": "anecdote", "libelle": "Anecdote", "ordre": 1}
  ],
  "sources": [
    {"id": "s1", "slug": "source-fictive", "type": "page_web",
     "reference": "Source fictive", "credit": "Crédit"}
  ],
  "pins": [
    {"id": "p1", "slug": "pin-fictif", "titre": "Pin fictif",
     "categorie": "anecdote", "epoques": ["a_epoque"],
     "sources": ["source-fictive"],
     "localisation": {"lat": 45.76, "lon": 4.83},
     "contenu_narratif": {
       "teaser": "Un teaser.", "narration": "Une narration.",
       "post_narratif": [{"type": "le_saviez_vous", "texte": "Un encart."}]}},
    {"id": "p2", "slug": "pin-sans-lieu", "titre": "Sans lieu",
     "categorie": "anecdote", "epoques": ["a_epoque"], "sources": [],
     "contenu_narratif": {"teaser": "t", "narration": "n"}}
  ]
}
''';

class _BundleFactice extends CachingAssetBundle {
  _BundleFactice(this.texte);
  final String? texte;

  @override
  Future<ByteData> load(String key) async {
    if (texte == null) throw FlutterError('asset introuvable : $key');
    final octets = utf8.encode(texte!);
    return ByteData.sublistView(Uint8List.fromList(octets));
  }
}

void main() {
  test('depuisJson lit époques, catégories, sources et pins', () {
    final contenu = ContenuEmbarque.depuisJson(_json);

    expect(contenu.epoques.single.slug, 'a_epoque');
    expect(contenu.epoques.single.borneFin, 1000);
    expect(contenu.categories.single.libelle, 'Anecdote');
    expect(contenu.sources.single.credit, 'Crédit');
    final pin = contenu.pins.first;
    expect(pin.titre, 'Pin fictif');
    expect(pin.localisation?.lat, 45.76);
    expect(pin.teaser, 'Un teaser.');
    expect(pin.postNarratif.single.texte, 'Un encart.');
    expect(contenu.pins.last.localisation, isNull);
    expect(contenu.pins.last.postNarratif, isEmpty);
  });

  test('charger lit le fichier via le bundle', () async {
    final chargeur = ChargeurContenu(bundle: _BundleFactice(_json));
    final contenu = await chargeur.charger();
    expect(contenu.pins, hasLength(2));
  });

  test('charger met le résultat en cache', () async {
    final chargeur = ChargeurContenu(bundle: _BundleFactice(_json));
    expect(await chargeur.charger(), same(await chargeur.charger()));
  });

  test('le vrai contenu embarqué se charge', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final contenu = await ChargeurContenu().charger();
    expect(contenu.pins.map((p) => p.slug), contains('cour-des-voraces'));
    expect(contenu.epoques, isNotEmpty);
  });

  test('un fichier absent ou illisible lève ContenuIndisponible', () async {
    await expectLater(
      ChargeurContenu(bundle: _BundleFactice(null)).charger(),
      throwsA(isA<ContenuIndisponible>()),
    );
    await expectLater(
      ChargeurContenu(bundle: _BundleFactice('{pas du json')).charger(),
      throwsA(isA<ContenuIndisponible>()),
    );
  });

  test('ContenuIndisponible reste un type distinct de Failure', () {
    expect(const ContenuIndisponible('x'), isNot(isA<Failure>()));
  });
}
