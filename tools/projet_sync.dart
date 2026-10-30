// Remise d'équerre du tableau de projet GitHub (ticket #168) : lit les
// éléments du tableau et signale ce qui est incohérent (charge, priorité,
// nature, assigné, statut, semaine). Ne modifie rien sans `--appliquer`, qui
// ne corrige que la charge (déduite de l'étiquette `charge:N`, sans ambiguïté).
//
// Usage : dart run tools/projet_sync.dart [--appliquer]
//                                         [--organisation Projet-decole]
//                                         [--projet 1]
//
// Prérequis : l'outil `gh` connecté à GitHub avec la portée `project`.

import 'dart:convert';
import 'dart:io';

/// Statuts où un ticket doit avoir quelqu'un d'assigné et une semaine.
const _statutsActifs = {'Ready', 'In progress', 'In review'};

/// Jours sans mouvement au-delà desquels un ticket en cours est signalé.
const _joursSansMouvement = 14;

class ElementProjet {
  const ElementProjet({
    required this.numero,
    required this.titre,
    required this.ouvert,
    required this.statut,
    required this.etiquettes,
    required this.assignes,
    required this.jalon,
    required this.charge,
    required this.priorite,
    required this.nature,
    required this.semaine,
    required this.misAJour,
  });

  final int numero;
  final String titre;
  final bool ouvert;
  final String statut;
  final List<String> etiquettes;
  final List<String> assignes;
  final String? jalon;
  final num? charge;
  final String? priorite;
  final String? nature;
  final String? semaine;
  final DateTime misAJour;
}

enum TypeAnomalie {
  chargeIncoherente('Charge différente de l\'étiquette charge:N'),
  prioriteManquante('Priorité non renseignée'),
  natureManquante('Nature non renseignée'),
  sansAssigne('Prêt, en cours ou en relecture sans assigné'),
  statutIncoherent('Statut incohérent avec l\'état du ticket'),
  sansMouvement('En cours sans mouvement depuis $_joursSansMouvement jours'),
  sansSemaine('Prêt, en cours ou en relecture sans semaine planifiée');

  const TypeAnomalie(this.libelle);

  final String libelle;
}

class Anomalie {
  const Anomalie(this.type, this.numero, this.titre);

  final TypeAnomalie type;
  final int numero;
  final String titre;
}

/// La charge portée par l'étiquette `charge:N`, ou null si absente.
int? chargeDepuisEtiquettes(List<String> etiquettes) {
  for (final e in etiquettes) {
    if (e.startsWith('charge:')) {
      final n = int.tryParse(e.substring('charge:'.length));
      if (n != null) return n;
    }
  }
  return null;
}

List<Anomalie> analyser(List<ElementProjet> elements, DateTime maintenant) {
  final anomalies = <Anomalie>[];
  void ajouter(TypeAnomalie t, ElementProjet e) =>
      anomalies.add(Anomalie(t, e.numero, e.titre));

  for (final e in elements) {
    final etiquette = chargeDepuisEtiquettes(e.etiquettes);
    if (etiquette != null && e.charge != etiquette) {
      ajouter(TypeAnomalie.chargeIncoherente, e);
    }
    if (e.ouvert && e.priorite == null) {
      ajouter(TypeAnomalie.prioriteManquante, e);
    }
    if (e.nature == null) ajouter(TypeAnomalie.natureManquante, e);

    final actif = e.ouvert && _statutsActifs.contains(e.statut);
    if (actif && e.assignes.isEmpty) ajouter(TypeAnomalie.sansAssigne, e);
    if (actif && e.semaine == null) ajouter(TypeAnomalie.sansSemaine, e);

    final done = e.statut == 'Done';
    if ((!e.ouvert && !done) || (e.ouvert && done)) {
      ajouter(TypeAnomalie.statutIncoherent, e);
    }
    if (e.ouvert &&
        e.statut == 'In progress' &&
        maintenant.difference(e.misAJour).inDays >= _joursSansMouvement) {
      ajouter(TypeAnomalie.sansMouvement, e);
    }
  }
  return anomalies;
}

/// Numéro de ticket → charge à écrire, pour chaque écart avec l'étiquette.
Map<int, int> chargesACorriger(List<ElementProjet> elements) => {
  for (final e in elements)
    if (chargeDepuisEtiquettes(e.etiquettes) case final c? when e.charge != c)
      e.numero: c,
};

String formaterRapport(List<Anomalie> anomalies) {
  if (anomalies.isEmpty) return 'Tout est cohérent.\n';
  final texte = StringBuffer();
  for (final type in TypeAnomalie.values) {
    final liste = anomalies.where((a) => a.type == type).toList();
    if (liste.isEmpty) continue;
    texte.writeln('${type.libelle} (${liste.length})');
    for (final a in liste) {
      texte.writeln('  #${a.numero} ${a.titre}');
    }
  }
  return texte.toString();
}

// --- Lecture de GitHub ------------------------------------------------------

const _requete = r'''
query($org: String!, $num: Int!, $apres: String) {
  organization(login: $org) {
    projectV2(number: $num) {
      id
      items(first: 100, after: $apres) {
        pageInfo { hasNextPage endCursor }
        nodes {
          id
          content {
            ... on Issue {
              number title state updatedAt
              labels(first: 30) { nodes { name } }
              assignees(first: 10) { nodes { login } }
              milestone { title }
            }
          }
          statut: fieldValueByName(name: "Status") {
            ... on ProjectV2ItemFieldSingleSelectValue { name }
          }
          charge: fieldValueByName(name: "Charge") {
            ... on ProjectV2ItemFieldNumberValue { number }
          }
          priorite: fieldValueByName(name: "Priorité") {
            ... on ProjectV2ItemFieldSingleSelectValue { name }
          }
          nature: fieldValueByName(name: "Nature") {
            ... on ProjectV2ItemFieldSingleSelectValue { name }
          }
          semaine: fieldValueByName(name: "Semaine") {
            ... on ProjectV2ItemFieldIterationValue { title }
          }
        }
      }
    }
  }
}
''';

Future<Map<String, Object?>> _appelerGh(
  String requete,
  Map<String, Object?> variables,
) async {
  final process = await Process.start('gh', ['api', 'graphql', '--input', '-']);
  process.stdin.write(jsonEncode({'query': requete, 'variables': variables}));
  await process.stdin.close();
  final sortie = await utf8.decodeStream(process.stdout);
  final erreur = await utf8.decodeStream(process.stderr);
  if (await process.exitCode != 0) {
    throw StateError('gh api graphql : $erreur');
  }
  return jsonDecode(sortie) as Map<String, Object?>;
}

class _Lecture {
  _Lecture(this.projetId, this.elements, this.idsParNumero);

  final String projetId;
  final List<ElementProjet> elements;
  final Map<int, String> idsParNumero;
}

Future<_Lecture> _lire(String organisation, int projet) async {
  final elements = <ElementProjet>[];
  final ids = <int, String>{};
  String? curseur;
  String? projetId;
  do {
    final reponse = await _appelerGh(_requete, {
      'org': organisation,
      'num': projet,
      'apres': curseur,
    });
    final p =
        ((reponse['data'] as Map)['organization'] as Map)['projectV2'] as Map;
    projetId = p['id'] as String;
    final items = p['items'] as Map;
    for (final n in (items['nodes'] as List).cast<Map>()) {
      final c = n['content'] as Map?;
      if (c == null || c['number'] == null) continue;
      String? nom(String cle) => (n[cle] as Map?)?['name'] as String?;
      final numero = c['number'] as int;
      ids[numero] = n['id'] as String;
      elements.add(
        ElementProjet(
          numero: numero,
          titre: c['title'] as String,
          ouvert: c['state'] == 'OPEN',
          statut: nom('statut') ?? 'Backlog',
          etiquettes: [
            for (final l in (c['labels'] as Map)['nodes'] as List)
              (l as Map)['name'] as String,
          ],
          assignes: [
            for (final a in (c['assignees'] as Map)['nodes'] as List)
              (a as Map)['login'] as String,
          ],
          jalon: (c['milestone'] as Map?)?['title'] as String?,
          charge: (n['charge'] as Map?)?['number'] as num?,
          priorite: nom('priorite'),
          nature: nom('nature'),
          semaine: (n['semaine'] as Map?)?['title'] as String?,
          misAJour: DateTime.parse(c['updatedAt'] as String),
        ),
      );
    }
    final page = items['pageInfo'] as Map;
    curseur = page['hasNextPage'] == true ? page['endCursor'] as String : null;
  } while (curseur != null);
  return _Lecture(projetId, elements, ids);
}

Future<void> _ecrireCharge(
  _Lecture lecture,
  String champId,
  int numero,
  int charge,
) => _appelerGh(
  r'''
mutation($p: ID!, $i: ID!, $f: ID!, $v: Float!) {
  updateProjectV2ItemFieldValue(input: {
    projectId: $p, itemId: $i, fieldId: $f, value: {number: $v}
  }) { clientMutationId }
}''',
  {
    'p': lecture.projetId,
    'i': lecture.idsParNumero[numero],
    'f': champId,
    'v': charge.toDouble(),
  },
);

Future<String> _champCharge(String organisation, int projet) async {
  final r = await _appelerGh(
    r'''
query($org: String!, $num: Int!) {
  organization(login: $org) { projectV2(number: $num) {
    field(name: "Charge") { ... on ProjectV2FieldCommon { id } }
  } }
}''',
    {'org': organisation, 'num': projet},
  );
  final p = ((r['data'] as Map)['organization'] as Map)['projectV2'] as Map;
  return (p['field'] as Map)['id'] as String;
}

String _option(List<String> args, String nom, String defaut) {
  final i = args.indexOf(nom);
  return i >= 0 && i + 1 < args.length ? args[i + 1] : defaut;
}

Future<void> main(List<String> args) async {
  final organisation = _option(args, '--organisation', 'Projet-decole');
  final projet = int.parse(_option(args, '--projet', '1'));
  final lecture = await _lire(organisation, projet);

  stdout.write(
    formaterRapport(analyser(lecture.elements, DateTime.now().toUtc())),
  );

  if (args.contains('--appliquer')) {
    final aCorriger = chargesACorriger(lecture.elements);
    final champ = await _champCharge(organisation, projet);
    for (final e in aCorriger.entries) {
      await _ecrireCharge(lecture, champ, e.key, e.value);
    }
    stdout.writeln('${aCorriger.length} charge(s) corrigée(s).');
  }
}
