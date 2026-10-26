---
id: COMP-LAYOUT-CONSULTATION-PIN-APPROFONDIE
type: composant
titre: "Gabarit de consultation d’un pin"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  composants: [COMP-IMAGE-HERO, COMP-HEADER-RETOUR-TITRE-ACTION, COMP-CHIP-CATEGORIE, COMP-LIBELLE-TEXTE, COMP-ZONE-NARRATION, COMP-ZONE-SOURCES, COMP-BUTTON-PRIMARY]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: [DEC-03, DEC-60]
anciens_ids: [comp-layout-consultation-pin-approfondie]
sources:
  - conception/10-composants/04-shell.yaml:887
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Patron de la consultation approfondie d’un pin, dans l’ordre du récit : image, en-tête, catégorie, titre, narration, sources, retour à la carte. Spec des emplacements, pas un composant Figma (DEC-60).

## Variantes et états
- États : nominal, chargement des médias, erreur de chargement. Le mode présentation et la provenance communautaire (signalement) ne font pas partie de la tranche.
- Sources nombreuses : zone repliable (non tranché, voir COMP-ZONE-SOURCES). Narration longue : l’écran défile.

## Composition
- `hero` (1) : COMP-IMAGE-HERO. `header` (1) : COMP-HEADER-RETOUR-TITRE-ACTION. `category` (1) : COMP-CHIP-CATEGORIE. `title` (1) : COMP-LIBELLE-TEXTE.
- `narration` (1) : COMP-ZONE-NARRATION. `sources` (1) : COMP-ZONE-SOURCES.
- `cta_retour_carte` (1) : COMP-BUTTON-PRIMARY, retour à la carte centrée sur le pin.

## Tokens
Espace après l’image TOK-SPACE-XL, fond TOK-COLOR-FOND-PRINCIPAL.

## Interactions natives
Aucune propre ; les enfants portent leurs interactions.

## Hors MVP
Hors MVP : neutralisé : comp-zone-commentaires (commentaires), comp-zone-post-narrative (post-narratif), comp-lecteur-audio (audio), mode présentation.

## Remarque Figma
Source « supprimé de Figma mais toujours défini » : voir DEC-60. Aucun nœud référencé.
