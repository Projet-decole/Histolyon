---
id: COMP-HEADER-RETOUR-TITRE
type: composant
titre: "En-tête retour et titre"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-BUTTON-BACK, COMP-LIBELLE-TEXTE]
  ecrans: [ECR-PARCOURS-FICHE-DETAIL, ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: []
anciens_ids: [comp-header-retour-titre]
sources:
  - conception/10-composants/02-molecules.yaml:75
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
En-tête d’un écran de niveau 2 ou 3 : bouton retour à gauche, titre au centre. Le titre est informatif, non interactif.

## Variantes et états
Aucune variante. Titre long : tronqué ou taille adaptée.

## Composition
- `retour` (1) : COMP-BUTTON-BACK, retour gracieux.
- `titre` (1) : COMP-LIBELLE-TEXTE.

## Tokens
Titre : une typographie de titre (famille display ou TOK-TYPO-UI-LG) ; la source ne fixe pas laquelle (QO-501).

## Interactions natives
Tap sur le retour uniquement (intention close).

## Remarque Figma
Aucun nœud référencé.
