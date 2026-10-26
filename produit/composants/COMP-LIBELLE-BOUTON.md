---
id: COMP-LIBELLE-BOUTON
type: composant
titre: "Libellé de bouton"
statut: mvp
priorite: important
jalon: JAL-FU2
liens:
  composants: []
  ecrans: []
  decisions: [DEC-14]
anciens_ids: [comp-libelle-bouton]
sources:
  - conception/10-composants/01-atomes.yaml:697
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Texte propre aux boutons, avec une typographie distincte pour signaler qu’on peut agir. Non interactif en lui-même.

## Variantes et états
Taille : standard, compact. Texte long : tronqué avec ellipse.

## Composition
Aucun sous-composant. Utilisé par COMP-BUTTON-PRIMARY, COMP-BUTTON-SECONDARY et COMP-BUTTON-TERTIARY.

## Tokens
TOK-TYPO-UI-LG ; couleur TOK-COLOR-BLANC-NARRATIF sur fond TOK-COLOR-PRIMARY.

## Interactions natives
Aucune. Le texte vouvoie le lecteur (DEC-14).

## Remarque Figma
Aucun nœud référencé.
