---
id: COMP-IMAGE-HERO
type: composant
titre: "Image hero"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: []
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE, ECR-PARCOURS-FICHE-DETAIL]
  decisions: [DEC-03]
anciens_ids: [comp-image-hero]
sources:
  - conception/10-composants/01-atomes.yaml:450
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Illustration immersive en tête d’un écran de consultation (pin, parcours). Reflète le média principal. Non interactive.

## Variantes et états
- Ratio : 16:9, 4:3, 1:1, 21:9. Hauteur : standard, immersive, compacte.
- Image absente : placeholder gracieux. Image lente : flou progressif jusqu’au chargement.

## Composition
Aucun sous-composant. Le titre éventuel superposé est un libellé géré par le conteneur.

## Tokens
Titre superposé TOK-TYPO-DISPLAY-LG en TOK-COLOR-BLANC-NARRATIF sur voile TOK-COLOR-OVERLAY-SOMBRE.

## Interactions natives
Aucune.

## Hors MVP
Hors MVP : neutralisé : comp-avant-apres, comp-puzzle, comp-carousel (images d’archives et jeux, DEC-03).

## Remarque Figma
Aucun nœud référencé.
