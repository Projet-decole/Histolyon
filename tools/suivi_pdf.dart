// Mise en PDF des documents du dossier `suivi-client/` (#181) : un
// convertisseur Markdown → HTML réduit au strict nécessaire (titres,
// paragraphes, listes à puces, tableaux, gras, code, images SVG en ligne),
// un gabarit HTML A4 autonome, puis la conversion par `weasyprint`.
//
// Le Markdown converti est celui que ce dépôt écrit lui-même (la page client
// de `suivi_page.dart`, `suivi-client/feuille-de-route.md`) : ce n'est pas un
// moteur Markdown général.

import 'dart:io';

String _esc(String s) =>
    s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

final _image = RegExp(r'!\[([^\]]*)\]\(([^)]+)\)');

/// Mise en forme dans une ligne : échappement, `code`, **gras**, images.
String _enLigne(String texte, Map<String, String> images) {
  final morceaux = <String>[];
  var reste = texte;
  // Les images sont traitées avant l'échappement : leur SVG reste brut.
  while (true) {
    final m = _image.firstMatch(reste);
    if (m == null) break;
    morceaux.add(_formate(reste.substring(0, m.start)));
    final svg = images[m.group(2)!];
    morceaux.add(
      svg != null
          ? '<figure>$svg</figure>'
          : '<em>${_esc(m.group(1)!)} (graphique non disponible)</em>',
    );
    reste = reste.substring(m.end);
  }
  morceaux.add(_formate(reste));
  return morceaux.join();
}

String _formate(String s) => _esc(s)
    .replaceAllMapped(RegExp(r'`([^`]+)`'), (m) => '<code>${m[1]}</code>')
    .replaceAllMapped(
      RegExp(r'\*\*([^*]+)\*\*'),
      (m) => '<strong>${m[1]}</strong>',
    );

List<String> _cellules(String ligne) {
  var l = ligne.trim();
  if (l.startsWith('|')) l = l.substring(1);
  if (l.endsWith('|')) l = l.substring(0, l.length - 1);
  return [for (final c in l.split('|')) c.trim()];
}

bool _separateur(String ligne) =>
    RegExp(r'^\s*\|?\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)*\|?\s*$')
        .hasMatch(ligne);

/// Convertit le Markdown de ce dépôt en HTML. [images] associe un nom de
/// fichier (`burnup.svg`) au SVG à insérer en ligne à la place de l'image.
String markdownVersHtml(String md, {Map<String, String> images = const {}}) {
  final lignes = md.replaceAll('\r\n', '\n').split('\n');
  final b = StringBuffer();
  final paragraphe = <String>[];

  void fermeParagraphe() {
    if (paragraphe.isEmpty) return;
    final texte = paragraphe.join(' ');
    paragraphe.clear();
    // Une image seule sur sa ligne n'est pas un paragraphe de texte.
    if (_image.hasMatch(texte) && texte.replaceAll(_image, '').trim().isEmpty) {
      b.write(_enLigne(texte, images));
    } else {
      b.write('<p>${_enLigne(texte, images)}</p>');
    }
  }

  var i = 0;
  while (i < lignes.length) {
    final ligne = lignes[i];
    final t = ligne.trim();
    final titre = RegExp(r'^(#{1,4})\s+(.*)$').firstMatch(t);
    if (t.isEmpty) {
      fermeParagraphe();
      i++;
    } else if (titre != null) {
      fermeParagraphe();
      final n = titre.group(1)!.length;
      b.write('<h$n>${_enLigne(titre.group(2)!, images)}</h$n>');
      i++;
    } else if (t.startsWith('- ') || t.startsWith('* ')) {
      fermeParagraphe();
      b.write('<ul>');
      while (i < lignes.length) {
        final l = lignes[i].trim();
        if (l.startsWith('- ') || l.startsWith('* ')) {
          b.write('<li>${_enLigne(l.substring(2).trim(), images)}</li>');
        } else if (l.isNotEmpty &&
            lignes[i].startsWith('  ') &&
            b.toString().endsWith('</li>')) {
          // Suite d'un élément de liste sur la ligne suivante.
          final s = b.toString();
          b
            ..clear()
            ..write(s.substring(0, s.length - 5))
            ..write(' ${_enLigne(l, images)}</li>');
        } else {
          break;
        }
        i++;
      }
      b.write('</ul>');
    } else if (t.startsWith('|') &&
        i + 1 < lignes.length &&
        _separateur(lignes[i + 1])) {
      fermeParagraphe();
      b.write('<table><thead><tr>');
      for (final c in _cellules(t)) {
        b.write('<th>${_enLigne(c, images)}</th>');
      }
      b.write('</tr></thead><tbody>');
      i += 2;
      while (i < lignes.length && lignes[i].trim().startsWith('|')) {
        b.write('<tr>');
        for (final c in _cellules(lignes[i])) {
          b.write('<td>${_enLigne(c, images)}</td>');
        }
        b.write('</tr>');
        i++;
      }
      b.write('</tbody></table>');
    } else {
      paragraphe.add(t);
      i++;
    }
  }
  fermeParagraphe();
  return b.toString();
}

// Couleurs reprises de `packages/design_tokens` (TOK_COLOR_PRIMARY,
// TOK_COLOR_TEXTE_PRINCIPAL, TOK_COLOR_TEXTE_SECONDAIRE,
// TOK_COLOR_FOND_SECONDAIRE). Ce script n'est pas une app Flutter : il ne
// peut pas importer le package, d'où la copie.
const _primaire = '#B85220';
const _texte = '#1C1108';
const _texteSecondaire = '#5C3D1E';
const _fondSecondaire = '#EDD9B5';

/// Document HTML autonome (aucune ressource externe), mis en page en A4.
String documentA4({required String titre, required String corps}) =>
    '''
<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<title>${_esc(titre)}</title>
<style>
@page { size: A4; margin: 18mm 16mm 18mm 16mm;
  @bottom-right { content: "HistoLyon · page " counter(page) " / " counter(pages);
    font-size: 8pt; color: $_texteSecondaire; } }
body { font-family: "DejaVu Sans", "Liberation Sans", Arial, sans-serif;
  font-size: 9.5pt; line-height: 1.45; color: $_texte; }
h1 { font-size: 18pt; color: $_primaire; margin: 0 0 6pt; }
h2 { font-size: 12.5pt; color: $_primaire; margin: 14pt 0 4pt;
  border-bottom: 1px solid $_fondSecondaire; padding-bottom: 2pt; }
h3 { font-size: 10.5pt; margin: 10pt 0 3pt; }
h4 { font-size: 9.5pt; margin: 8pt 0 2pt; }
h2, h3, h4 { break-after: avoid; }
p { margin: 0 0 5pt; }
ul { margin: 0 0 6pt; padding-left: 14pt; }
li { margin: 0 0 2pt; }
code { font-family: "DejaVu Sans Mono", monospace; font-size: 8.5pt; }
table { border-collapse: collapse; width: 100%; margin: 2pt 0 8pt;
  font-size: 8.5pt; break-inside: auto; }
tr { break-inside: avoid; }
th { background: $_fondSecondaire; text-align: left; }
th, td { border: 1px solid $_fondSecondaire; padding: 2.5pt 4pt; vertical-align: top; }
figure { margin: 4pt 0 6pt; break-inside: avoid; }
figure svg { width: 100%; height: auto; }
</style>
</head>
<body>
$corps
</body>
</html>
''';

/// Convertit [html] en PDF à [cheminPdf] avec [commande] (weasyprint).
/// Renvoie false, sans lever d'erreur, si la commande est absente ou échoue.
Future<bool> htmlVersPdf(
  String html,
  String cheminPdf, {
  String commande = 'weasyprint',
}) async {
  final tmp = Directory.systemTemp.createTempSync('suivi_pdf');
  try {
    final source = File('${tmp.path}/document.html')..writeAsStringSync(html);
    final ProcessResult r;
    try {
      r = await Process.run(commande, [source.path, cheminPdf]);
    } on ProcessException {
      return false;
    }
    if (r.exitCode != 0) {
      stderr.writeln('$commande a échoué : ${r.stderr}');
      return false;
    }
    return File(cheminPdf).existsSync();
  } finally {
    tmp.deleteSync(recursive: true);
  }
}
