// Tests boîte noire de `ctx` v2 (sous-commandes sur `produit/`), sur un
// corpus fictif construit dans un dossier temporaire.

import 'dart:io';

import 'package:test/test.dart';

const _budget = {
  'capacite': 2500,
  'ecran': 2000,
  'composant': 800,
  'flux': 500,
};

String _unite(
  String id,
  String type,
  String titre, {
  String liens = '{}',
  String corps = 'Corps.',
  String statut = 'mvp',
  String sources = '[brief:lot1]',
}) =>
    '---\nid: $id\ntype: $type\ntitre: "$titre"\nstatut: $statut\n'
    'priorite: coeur\njalon: JAL-FU2\nliens: $liens\nanciens_ids: []\n'
    'sources: $sources\nbudget_tokens: ${_budget[type] ?? 500}\nderniere_verif: 2026-10-24\n---\n'
    '$corps\n';

void main() {
  final repoRoot = Directory.current.path;
  late Directory racine;

  ProcessResult ctx(List<String> args) => Process.runSync('dart', [
    '$repoRoot/tools/ctx.dart',
    '--produit',
    '${racine.path}/produit',
    ...args,
  ], workingDirectory: racine.path);

  void ecrit(String rel, String contenu) {
    final f = File('${racine.path}/produit/$rel')..createSync(recursive: true);
    f.writeAsStringSync(contenu);
  }

  setUp(() {
    racine = Directory.systemTemp.createTempSync('ctx_v2_');
    ecrit(
      'capacites/CAP-D1.2.md',
      _unite(
        'CAP-D1.2',
        'capacite',
        "Slider d'époques",
        liens: '{ecrans: [ECR-CARTE], flux: [FLX-A1], invariants: [INV-03]}',
        corps: 'Le slider cale la carte sur une époque.',
      ),
    );
    ecrit(
      'ecrans/ECR-CARTE.md',
      _unite(
        'ECR-CARTE',
        'ecran',
        'Carte principale',
        liens: '{composants: [COMP-SLIDER]}',
        corps: 'Écran principal avec le slider.',
      ),
    );
    ecrit(
      'composants/COMP-SLIDER.md',
      _unite(
        'COMP-SLIDER',
        'composant',
        'Slider',
        corps: '## Rôle\nChoisir une époque.\nLigne deux.\nLigne trois.\nLigne quatre.',
      ),
    );
    ecrit(
      'flux/FLX-A1.md',
      _unite('FLX-A1', 'flux', 'Découverte', corps: 'Ouvrir la carte.'),
    );
    ecrit(
      'donnees/INVARIANTS.md',
      _unite(
        'DOC-INVARIANTS',
        'document',
        'Invariants',
        corps:
            '## INV-03 — Source obligatoire\nChaque pin cite une source.\n\n'
            '## INV-04 — Autre\nTexte.',
      ),
    );
  });

  tearDown(() => racine.deleteSync(recursive: true));

  test('lire par id, par chemin et par section', () {
    expect((ctx(['lire', 'CAP-D1.2']).stdout as String), contains('Slider'));
    expect(
      (ctx(['lire', 'capacites/CAP-D1.2']).stdout as String),
      contains('Slider'),
    );
    final sec = ctx(['lire', 'INV-03']).stdout as String;
    expect(sec, contains('Source obligatoire'));
    expect(sec, isNot(contains('Autre')));
    expect(ctx(['lire', 'CAP-XXX']).exitCode, isNot(0));
  });

  test('chemin donne fichier et ligne', () {
    expect(
      ctx(['chemin', 'INV-03']).stdout as String,
      contains('INVARIANTS.md:'),
    );
  });

  test('pack assemble écrans, flux, invariants, composants en résumé', () {
    final out = ctx(['pack', 'CAP-D1.2']).stdout as String;
    expect(out, contains('Carte principale'));
    expect(out, contains('Ouvrir la carte'));
    expect(out, contains('Source obligatoire'));
    expect(out, contains('COMP-SLIDER'));
    expect(out, isNot(contains('Ligne quatre')));
    expect(out, contains('coût du pack'));
    expect(
      ctx(['pack', 'CAP-D1.2', '--complet']).stdout as String,
      contains('Ligne quatre'),
    );
  });

  test('chercher ignore les accents et pondère le titre', () {
    final out = ctx(['chercher', 'epoques slider']).stdout as String;
    expect(out.split('\n').first, startsWith('CAP-D1.2'));
    final out2 = ctx(['chercher', 'source obligatoire']).stdout as String;
    expect(out2.split('\n').first, startsWith('INV-03'));
  });

  test('refs déduit les liens entrants', () {
    final out = ctx(['refs', 'FLX-A1']).stdout as String;
    expect(out, contains('CAP-D1.2'));
  });

  test('liste filtre par type et statut', () {
    final out = ctx(['liste', '--type', 'ecran']).stdout as String;
    expect(out, contains('ECR-CARTE'));
    expect(out, isNot(contains('CAP-D1.2')));
  });

  test('check vert sur un corpus cohérent', () {
    final r = ctx(['check']);
    expect(r.exitCode, 0, reason: '${r.stdout}');
  });

  test('check détecte doublon, lien mort, motif interdit', () {
    ecrit('flux/FLX-B.md', _unite('FLX-A1', 'flux', 'Double'));
    ecrit(
      'flux/FLX-C.md',
      _unite(
        'FLX-C',
        'flux',
        'Lien mort',
        liens: '{ecrans: [ECR-NEXISTE]}',
        corps: 'voir design/conception/x',
      ),
    );
    final r = ctx(['check']);
    expect(r.exitCode, isNot(0));
    final out = r.stdout as String;
    expect(out, contains('en double FLX-A1'));
    expect(out, contains('ECR-NEXISTE'));
    expect(out, contains('motif interdit'));
  });

  test('check signale un budget dépassé', () {
    ecrit(
      'flux/FLX-GROS.md',
      _unite('FLX-GROS', 'flux', 'Gros', corps: 'mot ' * 1000),
    );
    final r = ctx(['check']);
    expect(r.exitCode, isNot(0));
    expect(r.stdout as String, contains('budget dépassé'));
  });

  test('check vérifie les sources conception', () {
    Directory('${racine.path}/conception').createSync();
    File('${racine.path}/conception/a.yaml').writeAsStringSync('a: 1\nb: 2\n');
    ecrit(
      'flux/FLX-S.md',
      _unite('FLX-S', 'flux', 'Source', sources: '[conception/a.yaml:2]'),
    );
    expect(ctx(['check']).exitCode, 0);
    ecrit(
      'flux/FLX-S.md',
      _unite('FLX-S', 'flux', 'Source', sources: '[conception/a.yaml:99]'),
    );
    expect(ctx(['check']).exitCode, isNot(0));
  });
}
