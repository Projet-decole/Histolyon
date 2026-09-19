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
    if (ligne.startsWith('LF:')) linesFound += int.parse(ligne.substring(3));
    if (ligne.startsWith('LH:')) linesHit += int.parse(ligne.substring(3));
  }
  if (linesFound == 0) return 100;
  return linesHit / linesFound * 100;
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

  final actuelle = calculerCouverturePourcent(File(args[0]).readAsStringSync());
  final baselineFile = File(args[1]);
  final baselineContenu = baselineFile.existsSync()
      ? baselineFile.readAsStringSync().trim()
      : '';
  final reference = baselineContenu.isEmpty
      ? 0.0
      : double.parse(baselineContenu);

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
