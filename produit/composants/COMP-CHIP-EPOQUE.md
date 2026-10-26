---
id: COMP-CHIP-EPOQUE
type: composant
titre: "Chip d’époque"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-CHIP, COMP-ICONE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: [DEC-02, DEC-03]
anciens_ids: [comp-chip-epoque]
sources:
  - conception/10-composants/01-atomes.yaml:295
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Affiche une époque. Dans la source, il sert aussi à choisir l’époque alternative d’un pin multi-époques. Au MVP (DEC-02), un pin n’a qu’une époque : le chip est un affichage, sans bascule.

## Variantes et états
- Sélection : défaut, actif, désactivé.
- États : défaut, pressé, actif, désactivé, focus clavier.

## Composition
- `label` (1) : COMP-LIBELLE-CHIP.
- `icone` (0..1) : COMP-ICONE.

## Tokens
Libellé actif en TOK-TYPO-DISPLAY-SM (typographie éditoriale), forme TOK-RADIUS-PILL, ombre TOK-SHADOW-SM à l’état actif.

## Interactions natives
Au MVP, aucune bascule. La source prévoit l’émission d’un signal d’époque alternative ; l’état partagé « époque courante » ne serait alors lu qu’en lecture seule pour mettre en relief l’époque active.

## Hors MVP
Hors MVP : neutralisé : comp-frise-chronologique (navigation entre époques d’un pin, DEC-02, DEC-03).

## Remarque Figma
Aucun nœud référencé.
