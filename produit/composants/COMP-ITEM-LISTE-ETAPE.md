---
id: COMP-ITEM-LISTE-ETAPE
type: composant
titre: "Item de liste d’étape"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  composants: [COMP-BADGE-NOMBRE, COMP-LIBELLE-TEXTE, COMP-ICONE]
  ecrans: [ECR-PARCOURS-FICHE-DETAIL, ECR-PARCOURS-EN-COURS-TERRAIN]
  decisions: [DEC-05, DEC-09]
anciens_ids: [comp-item-liste-etape]
sources:
  - conception/10-composants/02-molecules.yaml:217
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Rangée d’une étape dans la liste ordonnée d’un parcours : numéro, titre du pin, icône de statut.

## Variantes et états
- Statut : complétée, courante, à venir (icône et opacité).
- États : défaut, pressé, focus, sélectionné.
- Titre de pin introuvable : repli « Étape N ».

## Composition
- `numero` (1) : COMP-BADGE-NOMBRE.
- `titre_pin` (1) : COMP-LIBELLE-TEXTE.
- `icone_statut` (1) : COMP-ICONE.

## Tokens
Étape complétée : TOK-COLOR-FONCTIONNEL-SUCCES. Aucun autre token propre documenté.

## Interactions natives
Tap : le parent câble la cible (aperçu du pin, ouverture de l’étape). Le saut direct d’étape de la source n’est pas dans la tranche (voir ECR-PARCOURS-EN-COURS-TERRAIN).
Le statut dépend du parcours en cours : une étape sautée n’est pas complétée (DEC-09).

## Remarque Figma
Aucun nœud référencé. Parcours manuel pas à pas (DEC-05), sans choix terrain ou canapé.
