import 'package:test/test.dart';

import '../../tools/validate_content.dart';

void main() {
  test('content/ absent -> rien à valider (0)', () {
    expect(
      evaluerValidationContent(contentExiste: false, schemaExiste: false),
      0,
    );
  });

  test('content/ existe sans content/schema/ -> refus (1)', () {
    expect(
      evaluerValidationContent(contentExiste: true, schemaExiste: false),
      1,
    );
  });

  test('content/ et content/schema/ existent mais validation non écrite -> refus (1)', () {
    expect(
      evaluerValidationContent(contentExiste: true, schemaExiste: true),
      1,
    );
  });
}
