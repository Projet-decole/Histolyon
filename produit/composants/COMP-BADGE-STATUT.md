---
id: COMP-BADGE-STATUT
type: composant
titre: "Badge de statut"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE, COMP-ICONE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE, ECR-PARCOURS-FICHE-DETAIL]
  decisions: []
anciens_ids: [comp-badge-statut]
sources:
  - conception/10-composants/01-atomes.yaml:396
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Marqueur permanent d’un statut ou d’une provenance (par exemple sur la carte d’un parcours). Non interactif, distinct de COMP-TAG-PROVENANCE et de COMP-STATUS-PIN-VERIFICATION.

## Variantes et états
Type : officiel, en revue, retiré, brouillon, archivé. Libellé court, jamais tronqué. Au MVP, seul le contenu éditorial est publié ; les types de modération (en revue, retiré) n’ont pas d’usage utilisateur.

## Composition
- `texte` (1) : COMP-LIBELLE-TEXTE.
- `icone` (0..1) : COMP-ICONE.

## Tokens
Libellé TOK-TYPO-UI-MD, rayon TOK-RADIUS-SM.

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé.
