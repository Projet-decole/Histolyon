---
id: COMP-ZONE-NARRATION
type: composant
titre: "Zone de narration"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE, COMP-LIEN-TEXTE, COMP-ENCART-INFORMATION, COMP-CITATION, COMP-SAVIEZ-VOUS]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: [DEC-03, DEC-14]
anciens_ids: [comp-zone-narration]
sources:
  - conception/10-composants/02-molecules.yaml:416
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Bloc central de la consultation d’un pin : titre de section, récit, liens, encarts texte. Au MVP, le récit et des encarts texte seulement (DEC-03). Le récit s’adresse à une seule personne, au tutoiement (DEC-14).

## Variantes et états
Récit long : défilement vertical de l’écran. Sans média : bloc de texte seul, valide. Non interactif en lui-même.

## Composition
- `titre` (1), `contenu_narratif` (1) : COMP-LIBELLE-TEXTE.
- `liens` (0..n) : COMP-LIEN-TEXTE.
- `encarts` (0..n) : COMP-ENCART-INFORMATION ; citation et « Le saviez-vous » : COMP-CITATION, COMP-SAVIEZ-VOUS.

## Tokens
Récit TOK-TYPO-BODY-LG, titres de section TOK-TYPO-DISPLAY-MD, écart entre paragraphes TOK-SPACE-LG.

## Interactions natives
Aucune propre ; les enfants portent les leurs.

## Hors MVP
Hors MVP : neutralisé : comp-image-hero en médias intégrés, comp-avant-apres, comp-quiz, comp-puzzle, comp-lecteur-video, comp-carousel, comp-frise-chronologique, comp-enigme (DEC-03).

## Remarque Figma
Aucun nœud référencé.
