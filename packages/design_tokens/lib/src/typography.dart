// Typographie — Local Text Style `typo/<id>`, page 01 · Fondations
// (node `347:2`). 3 fontes : Playfair Display (titres éditoriaux), Lora
// (corps narratif), Inter (UI). `height` = interligne / taille de police
// (ex. 120% -> 1.2), au sens de TextStyle.height. Voir
// conception/15-maquette.md §4.

import 'package:flutter/painting.dart';

const TextStyle TOK_TYPO_DISPLAY_XL = TextStyle(
  fontFamily: 'Playfair Display',
  fontWeight: FontWeight.w800,
  fontSize: 32,
  height: 1.2,
);
const TextStyle TOK_TYPO_DISPLAY_LG = TextStyle(
  fontFamily: 'Playfair Display',
  fontWeight: FontWeight.w700,
  fontSize: 26,
  height: 1.25,
);
const TextStyle TOK_TYPO_DISPLAY_MD = TextStyle(
  fontFamily: 'Playfair Display',
  fontWeight: FontWeight.w700,
  fontSize: 22,
  height: 1.3,
);
const TextStyle TOK_TYPO_DISPLAY_SM = TextStyle(
  fontFamily: 'Playfair Display',
  fontWeight: FontWeight.w700,
  fontSize: 18,
  height: 1.35,
);
const TextStyle TOK_TYPO_BODY_LG = TextStyle(
  fontFamily: 'Lora',
  fontWeight: FontWeight.w400,
  fontSize: 17,
  height: 1.65,
);
const TextStyle TOK_TYPO_BODY_MD = TextStyle(
  fontFamily: 'Lora',
  fontWeight: FontWeight.w400,
  fontSize: 15,
  height: 1.6,
);
const TextStyle TOK_TYPO_BODY_SM = TextStyle(
  fontFamily: 'Lora',
  fontWeight: FontWeight.w400,
  fontSize: 14,
  height: 1.55,
);
const TextStyle TOK_TYPO_BODY_EMPHASIS = TextStyle(
  fontFamily: 'Lora',
  fontWeight: FontWeight.w600,
  fontSize: 17,
  height: 1.65,
);
const TextStyle TOK_TYPO_UI_LG = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 16,
  height: 1.4,
);
const TextStyle TOK_TYPO_UI_MD = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 14,
  height: 1.4,
);
const TextStyle TOK_TYPO_UI_SM = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
  fontSize: 12,
  height: 1.4,
);
const TextStyle TOK_TYPO_UI_XS = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 11,
  height: 1.3,
);
