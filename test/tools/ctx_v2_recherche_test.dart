// Test de recherche sur le vrai corpus `produit/` : 15 questions types, la
// bonne unité doit sortir dans les 3 premiers résultats de `ctx chercher`.

import 'dart:io';

import 'package:test/test.dart';

import '../../tools/ctx_corpus.dart';
import '../../tools/ctx_v2.dart';

const _questions = <String, List<String>>{
  'Quelle est la couleur d’un pin communautaire ?': ['TOK-COLOR-PIN-COMMUNAUTAIRE', 'COMP-PIN', 'CAP-D2.1'],
  'Que se passe-t-il si on tape un autre pin pendant l’aperçu ?': ['CAP-D2.4', 'FLX-B1', 'ECR-CARTE-APERCU-PIN'],
  'Quelles sont les bornes de l’époque XIXe ?': ['EPQ-XIXE-SIECLE', 'DOC-DESIGN-CARTE'],
  'Dans quel ordre sont les 10 époques ?': ['DOC-DESIGN-CARTE', 'ENT-EPOQUE'],
  'Quelle est la règle d’écriture d’un teaser ?': ['DOC-GUIDE-REDACTION', 'DOC-GABARIT-PIN'],
  'Quand afficher la visionneuse 3D ?': ['CAP-D8.1', 'ECR-PIN-CONSULTATION-3D', 'COMP-VIEWER-3D'],
  'Que se passe-t-il si on saute une étape ?': ['DEC-09', 'DEC-40', 'CAP-D3.5', 'CAP-D3.9'],
  'Combien de temps reste le message éphémère ?': ['ECR-TRANSVERSES-MESSAGE-EPHEMERE', 'COMP-MESSAGE-EPHEMERE', 'TOK-TMP-AUTO-DISMISS-M9'],
  'Le slider bouge-t-il tout seul pendant un parcours ?': ['DEC-07', 'CAP-D1.2', 'CAP-D3.5'],
  'Combien de sources faut-il au minimum pour un pin ?': ['INV-04', 'DOC-GUIDE-REDACTION', 'ENT-SOURCE'],
  'Quelle icône pour la catégorie architecture ?': ['ICN-CAT-ARCHITECTURE', 'DOC-DESIGN-ICONES'],
  'À quoi sert le bandeau hors ligne ?': ['ECR-TRANSVERSES-BANDEAU-OFFLINE', 'COMP-BANDEAU-INFORMATION-OFFLINE'],
  'Quelle longueur pour le récit d’un pin ?': ['DOC-GUIDE-REDACTION', 'DOC-GABARIT-PIN'],
  'Pourquoi pas de géolocalisation sur la carte ?': ['DEC-06', 'CAP-D1.1'],
  'Que montre l’écran de fin de parcours ?': ['ECR-PARCOURS-FIN-CELEBRATION', 'CAP-D3.9'],
};

void main() {
  final dir = Directory('produit');
  if (!dir.existsSync() || !File('produit/_perimetre-mvp.yaml').existsSync()) {
    return;
  }
  final corpus = Corpus.charge(dir);
  _questions.forEach((question, attendus) {
    test(question, () {
      final top = cherche(corpus, question, max: 3).map((r) => r.entree.id.split('#').first).toList();
      expect(
        top.any(attendus.contains),
        isTrue,
        reason: 'attendu l’un de $attendus, obtenu $top',
      );
    });
  });
}
