---
id: COMP-CARD-PARCOURS-LARGE
type: composant
titre: "Carte de parcours (large)"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-IMAGE-HERO, COMP-LIBELLE-TEXTE, COMP-BADGE-STATUT, COMP-BUTTON-PRIMARY]
  ecrans: [ECR-PARCOURS-FICHE-DETAIL]
  decisions: [DEC-05]
anciens_ids: [comp-card-parcours-large]
sources:
  - conception/10-composants/02-molecules.yaml:245
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Carte de mise en avant d’un parcours : image, titre, description, badge de provenance, bouton d’action principale.

## Variantes et états
- Provenance : éditorial, communautaire, personnel (seul l’éditorial au MVP, contenu embarqué).
- États : défaut, pressé, focus.
- Image absente : placeholder. Description longue : ellipse.

## Composition
- `image` (1) : COMP-IMAGE-HERO.
- `titre` (1), `description` (1) : COMP-LIBELLE-TEXTE.
- `provenance_badge` (1) : COMP-BADGE-STATUT.
- `cta` (1) : COMP-BUTTON-PRIMARY, câblé par le parent (« Découvrir », « Lancer »).

## Tokens
Rayon TOK-RADIUS-LG, marge TOK-SPACE-LG, ombre TOK-SHADOW-SM (défaut) puis TOK-SHADOW-MD (pressé), description TOK-TYPO-BODY-MD.

## Interactions natives
Tap hors bouton : ouvre la fiche détail. Tap bouton : action principale. Lancer un parcours démarre le pas à pas manuel, sans choix de mode (DEC-05).

## Remarque Figma
Aucun nœud référencé. La carte compacte de la source n’est pas reprise (catalogue et profil hors tranche) : voir le tri.
