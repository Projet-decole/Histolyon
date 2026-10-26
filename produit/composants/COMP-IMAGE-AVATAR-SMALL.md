---
id: COMP-IMAGE-AVATAR-SMALL
type: composant
titre: "Miniature (avatar miniature)"
statut: mvp
priorite: important
jalon: JAL-FU2
liens:
  composants: []
  ecrans: [ECR-CARTE-APERCU-PIN, ECR-PARCOURS-FICHE-DETAIL]
  decisions: [DEC-62]
anciens_ids: [comp-image-avatar-small]
sources:
  - conception/10-composants/01-atomes.yaml:896
  - conception/10-composants/02-molecules.yaml:294
  - conception/10-composants/04-shell.yaml:132
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Miniature de taille fixe. Dans la source, c’est la variante compacte de l’avatar d’un compte. Au MVP, elle sert de vignette du média principal d’un pin (aperçu rapide, vignette de pin d’une étape) ; il n’y a pas de compte.

## Variantes et états
Source de l’image : photo, silhouette, initiales (seule la photo de pin est utile au MVP). Image absente : silhouette ou monogramme, ou icône de catégorie en repli. Non interactive.

## Composition
Aucun sous-composant.

## Tokens
Aucun token propre documenté. Voir DEC-62 : le nom « avatar » ne correspond plus à l’usage retenu.

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé.
