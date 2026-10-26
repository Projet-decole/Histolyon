---
id: COMP-TAG-PROVENANCE
type: composant
titre: "Tag de provenance"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE, COMP-ICONE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: [DEC-04]
anciens_ids: [comp-tag-provenance]
sources:
  - conception/10-composants/01-atomes.yaml:962
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Marqueur textuel de provenance d’un pin (éditorial, communautaire, personnel), pour les listes et fiches où la couleur du pin sur la carte n’est pas visible. Non interactif.

## Variantes et états
Provenance : éditorial, communautaire, personnel. Au MVP (contenu embarqué, DEC-04), tout le contenu est éditorial : seule cette valeur est affichée.

## Composition
- `texte` (1) : COMP-LIBELLE-TEXTE.
- `icone_provenance` (0..1) : COMP-ICONE.

## Tokens
Éditorial TOK-COLOR-PIN-EDITORIAL ; communautaire TOK-COLOR-PIN-COMMUNAUTAIRE (cohérence avec COMP-PIN).

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé.
