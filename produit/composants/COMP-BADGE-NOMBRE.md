---
id: COMP-BADGE-NOMBRE
type: composant
titre: "Badge de nombre"
statut: mvp
priorite: important
jalon: JAL-FU2
liens:
  composants: [COMP-LIBELLE-TEXTE]
  ecrans: [ECR-CARTE-PRINCIPALE, ECR-PARCOURS-FICHE-DETAIL, ECR-PARCOURS-EN-COURS-TERRAIN]
  decisions: [DEC-02]
anciens_ids: [comp-badge-nombre]
sources:
  - conception/10-composants/01-atomes.yaml:413
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Compteur visuel : numéro d’ordre d’une étape, nombre de pins d’un cluster. Non interactif. La source l’utilise aussi pour le badge multi-époques d’un pin, inutile au MVP (DEC-02).

## Variantes et états
Taille : standard, compact. Au-delà d’un seuil, le nombre est abrégé (seuil non fixé : QO-503).

## Composition
- `compteur` (1) : COMP-LIBELLE-TEXTE.

## Tokens
Libellé TOK-TYPO-UI-MD, rayon TOK-RADIUS-SM, marge interne TOK-SPACE-XS.

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé.
