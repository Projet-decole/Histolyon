---
id: COMP-BUTTON-BACK
type: composant
titre: "Bouton retour"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  composants: [COMP-ICONE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE, ECR-PIN-CONSULTATION-3D, ECR-PARCOURS-FICHE-DETAIL, ECR-PARCOURS-EN-COURS-TERRAIN]
  decisions: []
anciens_ids: [comp-button-back]
sources:
  - conception/10-composants/01-atomes.yaml:154
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Retour gracieux d’un niveau vers le niveau immédiatement supérieur, en un seul geste. Intention close : l’écran fixe seulement la variante, jamais le comportement.

## Variantes et états
- Contexte : normal (écrans classiques), sombre (sur média immersif, comme le viewer 3D).
- États : défaut, pressé, désactivé, focus clavier.

## Composition
- `icone` (1) : COMP-ICONE, icône de retour.

## Tokens
Variante sombre : icône en TOK-COLOR-PRIMARY-CLAIR (lisibilité sur fond sombre). Contraste de la variante sombre sur média à valider.

## Interactions natives
Tap : retour gracieux. Si l’écran a été ouvert sans pile de navigation préalable (lien direct), le retour mène à la surface principale logique de la cible, et non à une sortie de l’app.

## Hors MVP
Hors MVP : neutralisé : comp-camera-ar (AR) ; le mode présentation du pin (écran hors tranche) n’est pas repris.

## Remarque Figma
Aucun nœud référencé. Question ouverte de la source : variante avec libellé visible (accessibilité), voir QO-502.
