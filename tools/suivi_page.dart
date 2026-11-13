// Vue client du suivi (ticket #126) : graphiques SVG et page Markdown publiés
// sur la branche `suivi`, lisibles sur GitHub. Fonctions pures : elles
// reçoivent l'instantané public et la série hebdomadaire, jamais la vue
// interne (aucun détail par personne).

import 'suivi_historique.dart';

const _largeur = 720.0;
const _hauteur = 320.0;
const _gauche = 72.0;
const _droite = 24.0;
const _haut = 48.0;
const _bas = 48.0;

const _bleu = '#1f6feb';
const _vert = '#2da44e';
const _orange = '#d1801a';
const _gris = '#8c959f';
const _texte = '#24292f';

String _esc(String s) =>
    s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

String _n(double v) => v.toStringAsFixed(1);

/// Cadre commun : fond blanc (lisible en thème sombre), titre, légende.
String _cadre(String titre, List<(String, String)> legende, String corps) {
  final b = StringBuffer()
    ..writeln(
      '<svg xmlns="http://www.w3.org/2000/svg" width="${_largeur.toInt()}" '
      'height="${_hauteur.toInt()}" viewBox="0 0 $_largeur $_hauteur" '
      'font-family="sans-serif" font-size="12">',
    )
    ..writeln('<rect width="100%" height="100%" fill="#ffffff"/>')
    ..writeln(
      '<text x="$_gauche" y="24" font-size="15" font-weight="bold" '
      'fill="$_texte">${_esc(titre)}</text>',
    );
  var x = _largeur - _droite;
  for (final (nom, couleur) in legende.reversed) {
    x -= nom.length * 7 + 28;
    b
      ..writeln(
        '<rect x="${_n(x)}" y="14" width="12" height="12" fill="$couleur"/>',
      )
      ..writeln(
        '<text x="${_n(x + 16)}" y="24" fill="$_texte">${_esc(nom)}</text>',
      );
  }
  b
    ..write(corps)
    ..writeln('</svg>');
  return b.toString();
}

String _vide(String titre) => _cadre(
  titre,
  const [],
  '<text x="${_largeur / 2}" y="${_hauteur / 2}" text-anchor="middle" '
  'fill="$_gris">Pas encore de données</text>\n',
);

double _xPoint(int i, int n) {
  final utile = _largeur - _gauche - _droite;
  return n <= 1 ? _gauche + utile / 2 : _gauche + utile * i / (n - 1);
}

double _y(double v, double min, double max) {
  final utile = _hauteur - _haut - _bas;
  final etendue = max - min == 0 ? 1 : max - min;
  return _hauteur - _bas - (v - min) / etendue * utile;
}

/// Axes, graduations horizontales et étiquettes des dates en abscisse.
String _axes(
  List<PointSuivi> points,
  double min,
  double max,
  String Function(double) etiquette, {
  double Function(int, int) xDe = _xPoint,
}) {
  final b = StringBuffer();
  final ticks = [for (var i = 0; i <= 4; i++) min + (max - min) * i / 4];
  for (final v in ticks) {
    final y = _n(_y(v, min, max));
    b
      ..writeln(
        '<line x1="$_gauche" y1="$y" x2="${_largeur - _droite}" y2="$y" '
        'stroke="#d0d7de" stroke-width="1"/>',
      )
      ..writeln(
        '<text x="${_gauche - 6}" y="$y" dy="4" text-anchor="end" '
        'fill="$_gris">${_esc(etiquette(v))}</text>',
      );
  }
  final pas = (points.length / 8).ceil().clamp(1, 1 << 30);
  for (var i = 0; i < points.length; i++) {
    if (i % pas != 0 && i != points.length - 1) continue;
    b.writeln(
      '<text x="${_n(xDe(i, points.length))}" y="${_hauteur - _bas + 18}" '
      'text-anchor="middle" fill="$_gris">'
      '${jourIso(points[i].date).substring(5)}</text>',
    );
  }
  return b.toString();
}

String _polyline(List<(double, double)> xy, String couleur) =>
    '<polyline fill="none" stroke="$couleur" stroke-width="2.5" points="'
    '${xy.map((p) => '${_n(p.$1)},${_n(p.$2)}').join(' ')}"/>\n';

/// Burn-up du MVP : périmètre (charge connue) et charge terminée.
String svgBurnUp(List<PointSuivi> points) {
  const titre = 'Burn-up du MVP (charge)';
  if (points.isEmpty) return _vide(titre);
  final max = points
      .map((p) => p.perimetre)
      .fold<int>(1, (a, b) => a > b ? a : b)
      .toDouble();
  final n = points.length;
  final corps = StringBuffer()
    ..write(_axes(points, 0, max, (v) => v.round().toString()))
    ..write(
      _polyline([
        for (var i = 0; i < n; i++)
          (_xPoint(i, n), _y(points[i].perimetre.toDouble(), 0, max)),
      ], _gris),
    )
    ..write(
      _polyline([
        for (var i = 0; i < n; i++)
          (_xPoint(i, n), _y(points[i].terminee.toDouble(), 0, max)),
      ], _vert),
    );
  return _cadre(titre, const [
    ('Périmètre', _gris),
    ('Terminé', _vert),
  ], corps.toString());
}

/// Fin prévue du MVP semaine après semaine, face à son échéance.
String svgDatePrevue(List<PointSuivi> points, DateTime? echeance) {
  const titre = 'Fin prévue du MVP, semaine après semaine';
  final connues = [
    for (var i = 0; i < points.length; i++)
      if (points[i].datePrevue != null) i,
  ];
  if (connues.isEmpty) return _vide(titre);
  final origine = points.first.date;
  double jours(DateTime d) => d.difference(origine).inHours / 24;
  final valeurs = [
    for (final i in connues) jours(points[i].datePrevue!),
    if (echeance != null) jours(echeance),
  ];
  final min = valeurs.reduce((a, b) => a < b ? a : b) - 7;
  var max = valeurs.reduce((a, b) => a > b ? a : b) + 7;
  if (max <= min) max = min + 7;
  String etiquette(double v) =>
      jourIso(origine.add(Duration(hours: (v * 24).round())));
  final n = points.length;
  final corps = StringBuffer()..write(_axes(points, min, max, etiquette));
  if (echeance != null) {
    final y = _n(_y(jours(echeance), min, max));
    corps
      ..writeln(
        '<line x1="$_gauche" y1="$y" x2="${_largeur - _droite}" y2="$y" '
        'stroke="$_orange" stroke-width="2" stroke-dasharray="6 4"/>',
      )
      ..writeln(
        '<text x="${_largeur - _droite}" y="$y" dy="-6" text-anchor="end" '
        'fill="$_orange">Échéance ${jourIso(echeance)}</text>',
      );
  }
  // Une courbe par suite de semaines où la date est calculable.
  var segment = <(double, double)>[];
  void fermer() {
    if (segment.length > 1) corps.write(_polyline(segment, _bleu));
    segment = [];
  }

  for (var i = 0; i < n; i++) {
    final d = points[i].datePrevue;
    if (d == null) {
      fermer();
      continue;
    }
    final x = _xPoint(i, n), y = _y(jours(d), min, max);
    segment.add((x, y));
    corps.writeln(
      '<circle cx="${_n(x)}" cy="${_n(y)}" r="3.5" fill="$_bleu"/>',
    );
  }
  fermer();
  return _cadre(titre, const [
    ('Fin prévue', _bleu),
    ('Échéance', _orange),
  ], corps.toString());
}

/// Flux hebdomadaire : PR fusionnées et charge terminée chaque semaine.
String svgFlux(List<PointSuivi> points) {
  const titre = 'Flux de la semaine';
  if (points.isEmpty) return _vide(titre);
  final max = [
    for (final p in points) ...[p.prFusionnees, p.chargeTermineeSemaine],
  ].fold<int>(1, (a, b) => a > b ? a : b).toDouble();
  final n = points.length;
  final utile = _largeur - _gauche - _droite;
  final colonne = utile / n;
  final barre = (colonne * 0.35).clamp(2.0, 24.0);
  final corps = StringBuffer()
    ..write(
      _axes(
        points,
        0,
        max,
        (v) => v.round().toString(),
        // Les dates se centrent sous les colonnes de barres.
        xDe: (i, _) => _gauche + colonne * (i + 0.5),
      ),
    );
  for (var i = 0; i < n; i++) {
    final centre = _gauche + colonne * (i + 0.5);
    for (final (k, valeur, couleur) in [
      (0, points[i].prFusionnees, _bleu),
      (1, points[i].chargeTermineeSemaine, _vert),
    ]) {
      final y = _y(valeur.toDouble(), 0, max);
      final x = centre - barre + k * barre;
      corps.writeln(
        '<rect class="barre" x="${_n(x)}" y="${_n(y)}" width="${_n(barre - 1)}" '
        'height="${_n(_hauteur - _bas - y)}" fill="$couleur"/>',
      );
    }
  }
  return _cadre(titre, const [
    ('PR fusionnées', _bleu),
    ('Charge terminée', _vert),
  ], corps.toString());
}

String _pct(Object? v) => v is num ? '${v.round()} %' : '—';
String _jours(Object? v) => v is num ? '${v.toStringAsFixed(1)} j' : '—';

/// Page Markdown de la vue client.
String pageClient({
  required Map<String, Object?> instantane,
  required List<PointSuivi> points,
  required DateTime? echeanceFin,
  required List<String> alertes,
}) {
  final charges = (instantane['charge'] as Map?) ?? const {};
  final prevues = (instantane['date_prevue'] as Map?) ?? const {};
  final flux = (instantane['flux'] as Map?) ?? const {};
  final qualite = (instantane['qualite'] as Map?) ?? const {};
  final tests = (qualite['tests'] as Map?) ?? const {};
  final contenu = (instantane['contenu'] as Map?) ?? const {};
  final pins = (contenu['pins'] as Map?) ?? const {};
  final debit = instantane['debit_3sem'];

  final b = StringBuffer()
    ..writeln('# Suivi du projet — vue client')
    ..writeln()
    ..writeln(
      'Instantané du **${instantane['date']}**, calculé automatiquement '
      'depuis GitHub chaque semaine par `tools/suivi.dart` (workflow '
      '`suivi`). Ne pas éditer à la main. Les définitions sont celles de '
      '`docs/PROCESS.md` (§ Le suivi).',
    )
    ..writeln()
    ..writeln('## Les jalons')
    ..writeln()
    ..writeln(
      'Débit des trois dernières semaines : '
      '**${debit is num ? debit.toStringAsFixed(1) : '—'}** de charge par '
      'semaine. La fin prévue d\'un jalon cumule le reste des jalons '
      'qui le précèdent.',
    )
    ..writeln()
    ..writeln(
      '| Jalon | Terminé / total | Reste | Ajouté en cours | Fin prévue |',
    )
    ..writeln('|---|---|---|---|---|');
  for (final e in charges.entries) {
    final c = e.value as Map;
    b.writeln(
      '| ${e.key} | ${c['terminee']} / ${c['total']} | ${c['restante']} | '
      '${c['ajoutee']} | ${prevues[e.key] ?? 'inconnue'} |',
    );
  }
  b
    ..writeln()
    ..writeln('## À surveiller')
    ..writeln();
  if (alertes.isEmpty) {
    b.writeln('Aucun seuil d\'alerte franchi.');
  } else {
    for (final a in alertes) {
      b.writeln('- $a');
    }
  }
  b
    ..writeln()
    ..writeln('## Avancement')
    ..writeln()
    ..writeln('![Burn-up](burnup.svg)')
    ..writeln()
    ..writeln(
      'En gris, le périmètre du MVP (charge des tickets des jalons à '
      'échéance) ; en vert, la charge terminée. Un écart qui se creuse ou '
      'une courbe verte plate signale un blocage.',
    )
    ..writeln()
    ..writeln('![Fin prévue du MVP](date-prevue.svg)')
    ..writeln()
    ..writeln(
      'Chaque point est la fin prévue du MVP calculée cette semaine-là '
      '(reste divisé par le débit des trois semaines précédentes)'
      '${echeanceFin == null ? '' : ', face à l\'échéance du ${jourIso(echeanceFin)}'}. '
      'Un point manquant : débit nul, aucune date calculable.',
    )
    ..writeln()
    ..writeln('## Flux')
    ..writeln()
    ..writeln('![Flux](flux.svg)')
    ..writeln()
    ..writeln('| Indicateur | Valeur |')
    ..writeln('|---|---|')
    ..writeln(
      '| Temps de cycle médian (premier commit → fusion) | ${_jours(flux['cycle_median_j'])} |',
    )
    ..writeln(
      '| Âge du plus vieux ticket en cours | ${_jours(flux['age_max_en_cours_j'])} |',
    )
    ..writeln(
      '| Tickets sans mouvement depuis 14 jours | ${flux['sans_mouvement_14j'] ?? '—'} |',
    )
    ..writeln(
      '| Délai médian avant la première relecture | ${_jours(flux['delai_premiere_relecture_j'])} |',
    )
    ..writeln(
      '| PR fusionnées relues par une autre personne | ${_pct(flux['pr_relues_par_autre_pct'])} |',
    )
    ..writeln()
    ..writeln('## Qualité')
    ..writeln()
    ..writeln('| Indicateur | Valeur |')
    ..writeln('|---|---|')
    ..writeln(
      '| Tests (unité / widget / intégration / SQL) | '
      '${tests['unite'] ?? '—'} / ${tests['widget'] ?? '—'} / '
      '${tests['integration'] ?? '—'} / ${tests['sql'] ?? '—'} |',
    )
    ..writeln(
      '| Couverture du code de l\'app (`lib/`) | ${_pct(qualite['couverture_lib_pct'])} |',
    )
    ..writeln(
      '| CI verte sur 4 semaines | ${_pct(qualite['ci_verte_4sem_pct'])} |',
    )
    ..writeln()
    ..writeln('## Contenu')
    ..writeln()
    ..writeln(
      '- Pins rédigés / relus / publiés : ${pins['redige'] ?? 0} / '
      '${pins['relu'] ?? 0} / ${pins['publie'] ?? 0} (cible : 7 à 10)',
    )
    ..writeln('- Modèle 3D : ${contenu['modele_3d'] ?? 'inconnu'}')
    ..writeln()
    ..writeln('## Semaine par semaine')
    ..writeln()
    ..writeln(
      '| Date | Périmètre | Terminé | Reste | Débit | Fin prévue | '
      'PR fusionnées | Charge de la semaine | CI verte |',
    )
    ..writeln('|---|---|---|---|---|---|---|---|---|');
  for (final p in points) {
    b.writeln(
      '| ${jourIso(p.date)} | ${p.perimetre} | ${p.terminee} | ${p.restante} | '
      '${p.debit.toStringAsFixed(1)} | '
      '${p.datePrevue == null ? '—' : jourIso(p.datePrevue!)} | '
      '${p.prFusionnees} | ${p.chargeTermineeSemaine} | '
      '${_pct(p.ciVertePct)} |',
    );
  }
  b
    ..writeln()
    ..writeln('## Limites connues')
    ..writeln()
    ..writeln(
      '- **Reconstitution.** Les charges et les jalons n\'existent que '
      'depuis le recadrage du 26/10/2026. La série est recalculée avec les '
      'étiquettes `charge:N` et les jalons **tels qu\'ils sont aujourd\'hui** : '
      'avant le 26/10/2026, elle ne reflète pas ce qui était prévu à '
      'l\'époque, et les tickets d\'avant le recadrage (sans charge) n\'y '
      'figurent pas.',
    )
    ..writeln(
      '- Un ticket fermé compte comme terminé, quelle que soit la raison de '
      'sa fermeture ; un ticket rouvert compte comme jamais terminé.',
    )
    ..writeln(
      '- La CI ne compte que les runs déclenchés par une PR (les 500 plus '
      'récents) ; la couverture n\'est mesurée que si le rapport lcov de '
      'l\'app existe au moment du calcul.',
    )
    ..writeln(
      '- Les fichiers `instantanes/instantane-AAAA-MM-JJ.json` sont les '
      'instantanés bruts de chaque semaine ; `historique.json` est la série '
      'ci-dessus.',
    );
  return b.toString();
}
