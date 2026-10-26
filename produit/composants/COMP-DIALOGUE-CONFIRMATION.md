---
id: COMP-DIALOGUE-CONFIRMATION
type: composant
titre: "Dialogue de confirmation"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE, COMP-BUTTON-SECONDARY, COMP-BUTTON-PRIMARY, COMP-BACKDROP]
  ecrans: [ECR-TRANSVERSES-DIALOGUE-CONFIRMATION]
  decisions: [DEC-05, DEC-61]
anciens_ids: [comp-dialogue-confirmation]
sources:
  - conception/10-composants/04-shell.yaml:366
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Dialogue strictement bloquant à deux issues explicites, pour une action sensible. À employer avec parcimonie. Au MVP, une seule instance : l’abandon d’un parcours en cours.

## Variantes et états
- Sévérité : neutre, destructif (le bouton de confirmation prend un registre destructif).
- États : visible, fermé par annulation, fermé par confirmation.
- Au plus un dialogue à la fois. Aucun geste ne contourne le dialogue.

## Composition
- `titre` (1), `description` (1) : COMP-LIBELLE-TEXTE (vouvoiement, DEC-14).
- `cta_annuler` (1) : COMP-BUTTON-SECONDARY.
- `cta_confirmer` (1) : COMP-BUTTON-PRIMARY.
- Voile : COMP-BACKDROP.

## Tokens
Rayon TOK-RADIUS-LG, voile TOK-OPACITY-BACKDROP-M8.

## Interactions natives
Annuler : signal d’annulation, l’écran parent décide. Confirmer : signal de confirmation ; pour l’abandon, le parcours en cours est terminé. L’écran parent câble les deux issues. Le focus reste dans le dialogue tant qu’il est ouvert.

## Hors MVP
Hors MVP : neutralisé : suppression de compte, effacement d’historique, suppression de parcours personnel (comptes, profil et parcours personnels hors tranche).

## Remarque Figma
Aucun nœud référencé. Les écrans cités par la source portent des identifiants erronés : voir DEC-61.
