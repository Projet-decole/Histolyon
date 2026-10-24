---
id: COMP-STATUS-PIN-VERIFICATION
type: composant
titre: "Statut de pin en vérification"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-ICONE, COMP-LIBELLE-TEXTE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: [DEC-04]
anciens_ids: [comp-status-pin-verification]
sources:
  - conception/10-composants/01-atomes.yaml:982
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Badge « sources en vérification » d’un pin communautaire, équivalent textuel du contour distinctif du pin sur la carte. Un pin éditorial n’a jamais ce badge.

## Variantes et états
Aucune variante. Libellé précis, jamais tronqué. Non interactif.

## Composition
- `icone_verification` (1) : COMP-ICONE.
- `texte` (1) : COMP-LIBELLE-TEXTE.

## Tokens
TOK-COLOR-CONTOUR-VERIFICATION (cohérence avec le contour de COMP-PIN).

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé. Au MVP, le contenu est éditorial (DEC-04) : le composant n’apparaît jamais à l’écran. Il est conservé pour la cohérence avec COMP-PIN (QO-506 : le garder ou le reporter).
