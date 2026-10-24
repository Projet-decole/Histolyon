---
id: COMP-CHIP-CATEGORIE
type: composant
titre: "Chip de catégorie"
statut: mvp
priorite: important
jalon: JAL-FU2
liens:
  composants: [COMP-ICONE, COMP-LIBELLE-CHIP]
  ecrans: [ECR-CARTE-APERCU-PIN, ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: []
anciens_ids: [comp-chip-categorie]
sources:
  - conception/10-composants/01-atomes.yaml:347
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Affiche la catégorie d’un pin ou d’un parcours (icône et libellé). Non interactif.

## Variantes et états
Taille : standard, compact. Aucun état interactif.

## Composition
- `icone` (1) : COMP-ICONE, icône de catégorie. Absente : icône générique de repli.
- `label` (1) : COMP-LIBELLE-CHIP.

## Tokens
Libellé TOK-TYPO-UI-MD, forme TOK-RADIUS-PILL (TOK-RADIUS-SM en compact), écart icône-libellé TOK-SPACE-XS.

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé. À ne pas confondre avec COMP-TAG-CATEGORIE (texte seul, sans icône).
