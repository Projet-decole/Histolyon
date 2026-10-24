---
id: COMP-TRACE-PARCOURS
type: composant
titre: "Tracé de parcours"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  composants: []
  ecrans: [ECR-PARCOURS-EN-COURS-TERRAIN, ECR-PARCOURS-FICHE-DETAIL]
  decisions: [DEC-05, DEC-09]
anciens_ids: [comp-trace-parcours]
sources:
  - conception/10-composants/03-fonctionnels.yaml:226
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Tracé d’un parcours sur la carte : couleur de provenance, parcouru ou à parcourir par l’opacité, étape courante en relief.

## Variantes et états
- Provenance : éditorial, communautaire (éditorial seul au MVP).
- Segment : à parcourir (rendu vif), parcouru (atténué), étape courante (relief).
- Vérification : absente, en cours (contour distinctif, inutile au MVP).
- Mode : en cours (pas à pas manuel, DEC-05), non commencé (aperçu depuis la fiche détail). Les modes terrain et canapé de la source sont réduits à un seul mode en cours.
- États : défaut, chargement.

## Composition
Aucun sous-composant.

## Tokens
Couleur TOK-COLOR-PIN-EDITORIAL (même registre que le pin), contour TOK-COLOR-CONTOUR-VERIFICATION.

## Interactions natives
Le tap sur un segment (viser une étape) est facultatif : la carte parente le câble si utile, sinon le tracé est décoratif. L’état des segments suit le parcours en cours ; une étape sautée n’est pas parcourue (DEC-09). Les étapes hors de l’époque sélectionnée sont atténuées.

## Hors MVP
Hors MVP : neutralisé : mode canapé (DEC-05).

## Remarque Figma
Aucun nœud référencé. Un parcours sans coordonnées d’étapes est invisible sur la carte.
