// Ombres — Effect Style `shadow/<id>`, page 01 · Fondations (node `347:2`).
// Couleur toujours TOK_COLOR_TEXTE_PRINCIPAL (#1C1108) à opacité variable —
// voir conception/15-maquette.md §4.

import 'package:flutter/painting.dart';

const BoxShadow TOK_SHADOW_SM = BoxShadow(
  color: Color(0x1F1C1108),
  offset: Offset(0, 1),
  blurRadius: 3,
);
const BoxShadow TOK_SHADOW_MD = BoxShadow(
  color: Color(0x331C1108),
  offset: Offset(0, 2),
  blurRadius: 8,
);
const BoxShadow TOK_SHADOW_LG = BoxShadow(
  color: Color(0x4D1C1108),
  offset: Offset(0, 4),
  blurRadius: 16,
);
