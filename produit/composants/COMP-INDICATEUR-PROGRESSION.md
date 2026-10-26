---
id: COMP-INDICATEUR-PROGRESSION
type: composant
titre: "Indicateur de progression"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE]
  ecrans: [ECR-PARCOURS-EN-COURS-TERRAIN, ECR-TRANSVERSES-PARCOURS-PERSISTANT]
  decisions: [DEC-09]
anciens_ids: [comp-indicateur-progression]
sources:
  - conception/10-composants/01-atomes.yaml:813
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Affiche une avancée chiffrée ou en barre : étape n sur N d’un parcours. Non interactif.

## Variantes et états
Type : barre, texte, mixte. Valeur indéterminée : bascule vers un indicateur infini générique (l’indicateur de chargement est hors périmètre de la tranche).

## Composition
- `valeur_textuelle` (0..1) : COMP-LIBELLE-TEXTE.

## Tokens
Aucun token propre documenté ; texte en TOK-TYPO-UI-SM.

## Interactions natives
Aucune. Sur la surface persistante, le tap est porté par la surface parente (COMP-SURFACE-PERSISTANTE-PARCOURS).

## Remarque Figma
Aucun nœud référencé. À la fin du parcours, l’écran de fin affiche « X étapes vues sur Y » (DEC-09) : l’indicateur n’y est pas utilisé.
