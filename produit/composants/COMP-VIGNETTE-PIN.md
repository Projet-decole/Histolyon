---
id: COMP-VIGNETTE-PIN
type: composant
titre: "Vignette de pin"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE, COMP-IMAGE-AVATAR-SMALL, COMP-CHIP-EPOQUE, COMP-BADGE-STATUT]
  ecrans: [ECR-PARCOURS-FICHE-DETAIL]
  decisions: [DEC-02]
anciens_ids: [comp-vignette-pin]
sources:
  - conception/10-composants/02-molecules.yaml:294
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Vignette compacte d’un pin : image, titre, époque. Au MVP, elle illustre les étapes dans la fiche détail d’un parcours.

## Variantes et états
- Taille : petite, moyenne (la petite masque les chips d’époque).
- États : défaut, pressé, focus.
- Vignette absente : icône de catégorie centrée en repli.

## Composition
- `titre` (1) : COMP-LIBELLE-TEXTE.
- `vignette` (1) : COMP-IMAGE-AVATAR-SMALL.
- `epoques` (0..n) : COMP-CHIP-EPOQUE. Une seule époque par pin au MVP (DEC-02) : pas de « +N ».
- `badge` (0..1) : COMP-BADGE-STATUT, par exemple « déjà visité ».

## Tokens
Aucun token propre documenté.

## Interactions natives
Tap : ouvre l’aperçu rapide du pin (le parent câble).

## Hors MVP
Hors MVP : neutralisé : comp-carousel, comp-zone-suggestions (carrousels et suggestions) ; grille de recherche (hors tranche).

## Remarque Figma
Aucun nœud référencé.
