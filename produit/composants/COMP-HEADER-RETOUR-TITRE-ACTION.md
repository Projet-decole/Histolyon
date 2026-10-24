---
id: COMP-HEADER-RETOUR-TITRE-ACTION
type: composant
titre: "En-tête retour, titre et action"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-BUTTON-BACK, COMP-LIBELLE-TEXTE, COMP-BUTTON-SECONDARY]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE, ECR-PARCOURS-FICHE-DETAIL]
  decisions: [DEC-03, DEC-13]
anciens_ids: [comp-header-retour-titre-action]
sources:
  - conception/10-composants/02-molecules.yaml:94
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
En-tête riche : retour (intention close), titre, action contextuelle (intention ouverte câblée par l’écran).

## Variantes et états
Aucune variante. Titre long : tronqué, la priorité visuelle va au retour et à l’action.

## Composition
- `retour` (1) : COMP-BUTTON-BACK.
- `titre` (1) : COMP-LIBELLE-TEXTE.
- `action` (1 dans la source) : COMP-BUTTON-SECONDARY.

## Tokens
Mêmes tokens que COMP-HEADER-RETOUR-TITRE.

## Interactions natives
Tap retour : retour gracieux. Tap action : câblé par le parent.

## Hors MVP
Hors MVP : neutralisé : comp-controle-favori, comp-controle-partage, comp-controle-signalement (favori, partage, signalement), mode présentation. Les actions citées par la source étant toutes neutralisées, l’action du MVP reste à définir : QO-507.

## Remarque Figma
Aucun nœud référencé.
