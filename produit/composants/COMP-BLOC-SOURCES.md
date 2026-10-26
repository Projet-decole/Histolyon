---
id: COMP-BLOC-SOURCES
type: composant
titre: "Bloc récapitulatif des sources"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: []
anciens_ids: [comp-bloc-sources]
sources:
  - conception/10-composants/02-molecules.yaml:652
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Récapitulatif informatif des sources et crédits en pied d’un pin. Distinct de COMP-ZONE-SOURCES (structurante et cliquable). Non interactif.

## Variantes et états
Aucune variante. Aucune source (cas rare) : le bloc n’est pas rendu.

## Composition
- `sources` (1..n) : COMP-LIBELLE-TEXTE, une ligne par source.
- `credits` (0..n) : COMP-LIBELLE-TEXTE (crédits d’images, contributeurs).

## Tokens
TOK-TYPO-BODY-SM (cohérent avec la zone des sources).

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé. Le doublon fonctionnel avec COMP-ZONE-SOURCES est à lever : QO-510.
