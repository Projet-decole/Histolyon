---
id: COMP-SURFACE-PERSISTANTE-PARCOURS
type: composant
titre: "Surface persistante du parcours"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE, COMP-INFO-PROGRESS-ETAPE, COMP-BUTTON-SECONDARY, COMP-DIALOGUE-CONFIRMATION]
  ecrans: [ECR-TRANSVERSES-PARCOURS-PERSISTANT, ECR-PARCOURS-EN-COURS-TERRAIN]
  decisions: [DEC-05, DEC-09]
anciens_ids: [comp-surface-persistante-parcours]
sources:
  - conception/10-composants/04-shell.yaml:677
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Mini-barre du parcours en cours, qui survit à la navigation entre sections. Elle montre le titre, l’étape courante et la progression. Fermer passe par une confirmation d’abandon : on ne quitte jamais par accident. Au plus une instance visible.

## Variantes et états
- États : visible, en sommeil (mode présentation, absent de la tranche), fermée par fin du parcours, fermée par abandon.
- Variante terrain ou canapé de la source : réduite à un mode unique, pas à pas manuel (DEC-05).

## Composition
- `titre` (1), `etape_courante` (1) : COMP-LIBELLE-TEXTE.
- `progression` (1) : COMP-INFO-PROGRESS-ETAPE.
- `close` (1) : COMP-BUTTON-SECONDARY.

## Tokens
Apparition et disparition TOK-CHO-APPARITION-P2 et TOK-CHO-DISPARITION-P2. Mise en sommeil en mode présentation : hors MVP.

## Interactions natives
Tap sur la zone principale : retour à l’écran du parcours en cours. Tap sur fermer : ouvre COMP-DIALOGUE-CONFIRMATION de sévérité destructive ; à confirmation, le parcours est terminé (abandon : aucune étape ne devient complétée par ce geste, DEC-09). Visible tant qu’un parcours est en cours. Coexiste avec le bandeau hors-ligne.

## Hors MVP
Hors MVP : neutralisé : comp-surface-persistante-audio (audio).

## Remarque Figma
Aucun nœud référencé.
