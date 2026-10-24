---
id: COMP-BUTTON-TERTIARY
type: composant
titre: "Bouton tertiaire"
statut: mvp
priorite: important
jalon: JAL-FU2
liens:
  composants: [COMP-LIBELLE-BOUTON, COMP-ICONE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE, ECR-PIN-CONSULTATION-3D, ECR-TRANSVERSES-MESSAGE-EPHEMERE]
  decisions: [DEC-03]
anciens_ids: [comp-button-tertiary]
sources:
  - conception/10-composants/01-atomes.yaml:131
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Action légère, discrète, sans dominance visuelle. Intention ouverte : le parent câble. Au MVP : action facultative d’un message éphémère (par exemple « Annuler »).

## Variantes et états
- Forme : compacte, icône seule. L’icône seule exige un libellé d’accessibilité et une cible tactile généreuse.
- États : défaut, pressé, désactivé, focus clavier.

## Composition
- `label` (0..1) : COMP-LIBELLE-BOUTON.
- `icone` (0..1) : COMP-ICONE.

## Tokens
Libellé TOK-TYPO-UI-LG, rayon TOK-RADIUS-MD, désactivé TOK-OPACITY-DESACTIVE.

## Interactions natives
Tap : émet l’action au parent.

## Hors MVP
Hors MVP : neutralisé : comp-camera-ar (bascule vers la réalité augmentée du viewer 3D, AR écartée avant le rendu) ; comp-quiz, comp-enigme, comp-puzzle (DEC-03) ; comp-button-play-audio (audio).

## Remarque Figma
Aucun nœud référencé.
