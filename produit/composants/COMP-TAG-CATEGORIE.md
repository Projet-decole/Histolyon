---
id: COMP-TAG-CATEGORIE
type: composant
titre: "Tag de catégorie"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: []
anciens_ids: [comp-tag-categorie]
sources:
  - conception/10-composants/01-atomes.yaml:947
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Étiquette textuelle de la catégorie d’un pin, sans icône. Non interactive.

## Variantes et états
Aucune variante. Libellé de catégorie tronqué si trop long.

## Composition
- `texte` (1) : COMP-LIBELLE-TEXTE.

## Tokens
Libellé TOK-TYPO-UI-MD. Aucun autre token propre documenté.

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé. La source envisage une fusion avec COMP-CHIP-CATEGORIE si la redondance se confirme : à trancher à l’intégration (QO-505).
