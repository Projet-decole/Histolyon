// Story 9.1 (hook pre-commit) : valide `content/` contre `content/schema/`
// (Epics 4-5). Ni l'un ni l'autre n'existent encore à ce stade du
// bootstrap : ce script refuse bruyamment dès que `content/` contient
// quelque chose, plutôt que de laisser croire à une validation qui n'est
// pas encore écrite.
//
// Usage : dart run tools/validate_content.dart

import 'dart:io';

int evaluerValidationContent({
  required bool contentExiste,
  required bool schemaExiste,
}) {
  if (!contentExiste) {
    stdout.writeln('tools/validate_content: content/ absent — rien à valider.');
    return 0;
  }

  if (!schemaExiste) {
    stderr.writeln(
      'tools/validate_content: content/ existe mais content/schema/ est '
      'absent (Epic 4 non terminé) — refus par prudence plutôt que faux '
      'positif.',
    );
    return 1;
  }

  // TODO(Epic 5) : validation JSON Schema réelle de chaque
  // content/**/*.yaml contre content/schema/. Non implémenté : personne
  // n'a encore écrit de contenu ni de schéma à ce stade du bootstrap.
  stderr.writeln(
    'tools/validate_content: content/schema/ existe mais la validation '
    'réelle (JSON Schema) reste à écrire (Epic 5) — refus par prudence.',
  );
  return 1;
}

void main() {
  exitCode = evaluerValidationContent(
    contentExiste: Directory('content').existsSync(),
    schemaExiste: Directory('content/schema').existsSync(),
  );
}
