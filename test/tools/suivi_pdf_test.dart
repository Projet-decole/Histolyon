import 'dart:io';

import 'package:test/test.dart';

import '../../tools/suivi_pdf.dart';

void main() {
  group('markdownVersHtml', () {
    test('titres, paragraphes et emphase', () {
      final html = markdownVersHtml(
        '# Titre\n\nUne **phrase**\nsur deux lignes avec `code`.\n\n## Sous-titre\n',
      );
      expect(html, contains('<h1>Titre</h1>'));
      expect(html, contains('<h2>Sous-titre</h2>'));
      expect(
        html,
        contains(
          '<p>Une <strong>phrase</strong> sur deux lignes avec <code>code</code>.</p>',
        ),
      );
    });

    test('listes à puces', () {
      final html = markdownVersHtml('- un\n- **deux**\n\nfin');
      expect(
        html,
        contains('<ul><li>un</li><li><strong>deux</strong></li></ul>'),
      );
      expect(html, contains('<p>fin</p>'));
    });

    test('tableaux avec ligne de séparation', () {
      final html = markdownVersHtml(
        '| Jalon | Reste |\n|---|---|\n| J1 | 14 |\n| J2 | 38 |\n',
      );
      expect(html, contains('<table>'));
      expect(html, contains('<th>Jalon</th><th>Reste</th>'));
      expect(html, contains('<td>J1</td><td>14</td>'));
      expect(html, contains('<td>J2</td><td>38</td>'));
      expect(html, isNot(contains('---')));
    });

    test('échappe le HTML du texte', () {
      final html = markdownVersHtml('a < b & c > d');
      expect(html, contains('a &lt; b &amp; c &gt; d'));
    });

    test('une image connue est remplacée par son SVG en ligne', () {
      const svg = '<svg xmlns="http://www.w3.org/2000/svg"><rect/></svg>';
      final html = markdownVersHtml(
        '![Burn-up](burnup.svg)',
        images: {'burnup.svg': svg},
      );
      expect(html, contains(svg));
      expect(html, isNot(contains('burnup.svg')));
    });

    test('une image inconnue garde son texte alternatif', () {
      final html = markdownVersHtml('![Graphique absent](x.svg)');
      expect(html, contains('Graphique absent'));
      expect(html, isNot(contains('<img')));
    });

    test('les accents passent tels quels', () {
      expect(markdownVersHtml('Échéance prévue'), contains('Échéance prévue'));
    });
  });

  group('documentA4', () {
    test('document autonome, en français, au format A4', () {
      final doc = documentA4(titre: 'Suivi', corps: '<p>x</p>');
      expect(doc, startsWith('<!doctype html>'));
      expect(doc, contains('<html lang="fr">'));
      expect(doc, contains('<meta charset="utf-8">'));
      expect(doc, contains('<title>Suivi</title>'));
      expect(doc, contains('size: A4'));
      expect(doc, contains('<p>x</p>'));
      expect(doc, isNot(contains('http://')));
      expect(doc, isNot(contains('https://')));
    });
  });

  group('htmlVersPdf', () {
    test('sans convertisseur, renvoie false sans lever d\'erreur', () async {
      final dossier = Directory.systemTemp.createTempSync('suivi_pdf');
      addTearDown(() => dossier.deleteSync(recursive: true));
      final ok = await htmlVersPdf(
        '<p>x</p>',
        '${dossier.path}/x.pdf',
        commande: 'commande-pdf-inexistante-histolyon',
      );
      expect(ok, isFalse);
      expect(File('${dossier.path}/x.pdf').existsSync(), isFalse);
    });
  });
}
