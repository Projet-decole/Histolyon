import 'dart:io';

// Story 9.2 : calcule la couverture de lignes totale d'un rapport lcov et
// la compare à une référence (cliquet, AD-14 — la couverture publiée ne
// doit jamais baisser par rapport au dernier `main`).
//
// Usage : dart run tools/coverage_ratchet.dart <lcov.info> <baseline.txt>
// `baseline.txt` contient un seul nombre (pourcentage). Mettre à jour la
// référence après un merge sur `main` est un geste manuel de
// l'Intégrateur (`echo "82.50" > apps/mobile/coverage_baseline.txt`) : ce
// script ne l'automatise pas, une écriture automatique sur `main` protégé
// (AD-13) exigerait un contournement de la protection de branche non
// souhaitable ici.

double calculerCouverturePourcent(String lcov) {
  var linesFound = 0;
  var linesHit = 0;
  for (final ligne in lcov.split('\n')) {
    final propre = ligne.trim();
    if (propre.startsWith('LF:')) {
      linesFound += int.tryParse(propre.substring(3)) ?? 0;
    }
    if (propre.startsWith('LH:')) {
      linesHit += int.tryParse(propre.substring(3)) ?? 0;
    }
  }
  if (linesFound == 0) return 100;
  return linesHit / linesFound * 100;
}

/// Référence lue dans `coverage_baseline.txt` : vide -> 0, illisible -> null.
double? lireReference(String contenu) {
  final propre = contenu.trim();
  return propre.isEmpty ? 0.0 : double.tryParse(propre);
}

/// Tolérance d'arrondi : deux exécutions du même code ne doivent pas
/// échouer pour 0.01 point de flottant.
int comparerAuCliquet({required double actuelle, required double reference}) {
  const tolerance = 0.01;
  return actuelle + tolerance < reference ? 1 : 0;
}

void main(List<String> args) {
  if (args.length != 2) {
    stderr.writeln(
      'Usage: dart run tools/coverage_ratchet.dart <lcov.info> <baseline.txt>',
    );
    exitCode = 2;
    return;
  }

  final lcovFile = File(args[0]);
  if (!lcovFile.existsSync()) {
    stderr.writeln('Rapport lcov introuvable : ${args[0]}');
    exitCode = 2;
    return;
  }
  final actuelle = calculerCouverturePourcent(lcovFile.readAsStringSync());
  final baselineFile = File(args[1]);
  final reference = lireReference(
    baselineFile.existsSync() ? baselineFile.readAsStringSync() : '',
  );
  if (reference == null) {
    stderr.writeln(
      'Référence de couverture illisible dans ${args[1]} : un seul nombre '
      'attendu (ex. 82.50).',
    );
    exitCode = 2;
    return;
  }

  stdout.writeln(
    'Couverture : ${actuelle.toStringAsFixed(2)}% '
    '(référence main : ${reference.toStringAsFixed(2)}%)',
  );

  exitCode = comparerAuCliquet(actuelle: actuelle, reference: reference);
  if (exitCode != 0) {
    stderr.writeln(
      'La couverture a baissé par rapport à main — cliquet refusé.',
    );
  }
}
