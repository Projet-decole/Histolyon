---
id: COMP-BUTTON-PRIMARY
type: composant
titre: "Bouton primaire"
statut: mvp
priorite: important
jalon: JAL-FU2
liens:
  composants: [COMP-LIBELLE-BOUTON, COMP-ICONE]
  ecrans: [ECR-PARCOURS-FICHE-DETAIL, ECR-PIN-CONSULTATION-APPROFONDIE, ECR-TRANSVERSES-DIALOGUE-CONFIRMATION]
  decisions: [DEC-03]
anciens_ids: [comp-button-primary]
sources:
  - conception/10-composants/01-atomes.yaml:76
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Cible de l’action principale d’une surface. Intention ouverte : l’écran ou le composant parent câble la cible (lancer un parcours, confirmer, revenir à la carte).

## Variantes et états
- Taille : standard, compact. Pleine largeur : oui, non.
- États : défaut, pressé, désactivé, chargement (le libellé laisse la place à un indicateur), focus clavier.
- Texte trop long : tronqué avec ellipse.

## Composition
- `label` (1) : COMP-LIBELLE-BOUTON.
- `icone` (0..1) : COMP-ICONE, fonctionnelle.

## Tokens
Fond TOK-COLOR-PRIMARY, pressé TOK-COLOR-PRIMARY-FONCE, libellé TOK-COLOR-BLANC-NARRATIF, rayon TOK-RADIUS-MD, espacement TOK-SPACE-SM. Désactivé : TOK-OPACITY-DESACTIVE avec fond et texte en TOK-COLOR-TEXTE-TERTIAIRE (contraste).

## Interactions natives
Tap : émet l’action au parent. Focus clavier : état focus.

## Hors MVP
Hors MVP : neutralisé : comp-quiz (quiz non repris, DEC-03).

## Remarque Figma
Aucun nœud référencé.
