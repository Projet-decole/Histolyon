---
id: COMP-VIEWER-3D
type: composant
titre: "Viewer 3D"
statut: mvp
priorite: important
jalon: JAL-GEL
liens:
  composants: [COMP-BUTTON-BACK]
  ecrans: [ECR-PIN-CONSULTATION-3D]
  decisions: [DEC-13, DEC-61]
anciens_ids: [comp-viewer-3d]
sources:
  - conception/10-composants/03-fonctionnels.yaml:386
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Visualisation du modèle 3D rattaché à un pin. Le MVP en propose une, celle de la fontaine de la place des Jacobins (DEC-13).

## Variantes et états
États : chargement, chargé, manipulation, erreur, plein écran. Modèle absent : message gracieux.

## Composition
- `retour` (1) : COMP-BUTTON-BACK, en variante sombre.
- `bascule_ar` (0..1) : voir « Hors MVP ».

## Tokens
Icône de retour en variante sombre : TOK-COLOR-PRIMARY-CLAIR. Aucun autre token propre documenté.

## Interactions natives
Glisser : rotation du modèle. Pincer : zoom. Intention locale : aucun état partagé n’est modifié.

## Hors MVP
Hors MVP : neutralisé : comp-camera-ar (réalité augmentée, jamais avant le rendu), bascule vers l’AR.

## Remarque Figma
Aucun nœud référencé. L’écran est cité dans la source sous un identifiant erroné : voir DEC-61.
