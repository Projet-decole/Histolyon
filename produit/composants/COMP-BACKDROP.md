---
id: COMP-BACKDROP
type: composant
titre: "Voile d’arrière-plan"
statut: mvp
priorite: important
jalon: JAL-FU2
liens:
  composants: []
  ecrans: [ECR-CARTE-APERCU-PIN, ECR-TRANSVERSES-DIALOGUE-CONFIRMATION]
  decisions: [DEC-12]
anciens_ids: [comp-backdrop]
sources:
  - conception/10-composants/04-shell.yaml:597
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Voile plein écran posé derrière toute surface flottante (aperçu, dialogue). Il assombrit et/ou floute le contenu, et capte le tap hors de la surface. L’écran l’instancie entre le contenu et la surface.

## Variantes et états
- Type : assombri, flou, assombri et flou.
- États : visible, fermé.

## Composition
Aucun sous-composant.

## Tokens
TOK-OPACITY-BACKDROP-M6 (surfaces ponctuelles, aperçu), TOK-OPACITY-BACKDROP-M8 (dialogue bloquant), couleur de base TOK-COLOR-TEXTE-PRINCIPAL. La source Figma note que l’opacité du voile n’est pas liée à un token (intensités indicatives : assombri 0,4 ; assombri et flou 0,28 ; flou 0,05), contredisant les tokens ci-dessus : voir QO-512.

## Interactions natives
Tap sur le voile : ferme la surface au premier plan (le parent câble la cible). La carte reste visible derrière un aperçu.

## Remarque Figma
Exception validée côté maquette : peinture directe en TOK-COLOR-TEXTE-PRINCIPAL, sans variable. Aucun identifiant de nœud référencé.
