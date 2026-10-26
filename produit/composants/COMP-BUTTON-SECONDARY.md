---
id: COMP-BUTTON-SECONDARY
type: composant
titre: "Bouton secondaire"
statut: mvp
priorite: important
jalon: JAL-FU2
liens:
  composants: [COMP-LIBELLE-BOUTON, COMP-ICONE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE, ECR-TRANSVERSES-DIALOGUE-CONFIRMATION]
  decisions: [DEC-03]
anciens_ids: [comp-button-secondary]
sources:
  - conception/10-composants/01-atomes.yaml:106
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Action secondaire, visuellement subordonnée au bouton primaire (alternative ou complément). Intention ouverte : le parent câble la cible. Au MVP : annulation d’un dialogue, fermeture de la surface persistante de parcours.

## Variantes et états
- Taille : standard, compact.
- États : défaut, pressé, désactivé, chargement, focus clavier.

## Composition
- `label` (1) : COMP-LIBELLE-BOUTON.
- `icone` (0..1) : COMP-ICONE.

## Tokens
Libellé TOK-TYPO-UI-LG, rayon TOK-RADIUS-MD, désactivé TOK-OPACITY-DESACTIVE. Aucune couleur de fond propre documentée pour ce bouton : voir QO-501.

## Interactions natives
Tap : émet l’action au parent.

## Hors MVP
Hors MVP : neutralisé : comp-quiz (réponses), comp-lecteur-video (lecture) (DEC-03).

## Remarque Figma
Aucun nœud référencé.
