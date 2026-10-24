---
id: COMP-ZONE-SOURCES
type: composant
titre: "Zone des sources"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE, COMP-LIEN-TEXTE, COMP-ICONE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: [DEC-04]
anciens_ids: [comp-zone-sources]
sources:
  - conception/10-composants/02-molecules.yaml:437
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Liste des sources documentaires d’un pin, sous le récit, avec badge éventuel de validation scientifique. Consultation seule au MVP.

## Variantes et états
- Contexte : consultation (retenu), édition (soumission communautaire, hors MVP).
- États : défaut, focus.
- Aucune source : message gracieux à la place du bloc.

## Composition
- `titre` (1) : COMP-LIBELLE-TEXTE.
- `sources` (1..n) : COMP-LIEN-TEXTE, une entrée par source.
- `validation_badge` (0..1) : COMP-ICONE.

## Tokens
Contenu TOK-TYPO-BODY-SM.

## Interactions natives
Tap sur une source : ouvre le lien externe dans le navigateur, ou le pin lié. Hors-ligne, le contenu externe est inaccessible (voir COMP-BANDEAU-INFORMATION-OFFLINE).

## Remarque Figma
Aucun nœud référencé. La zone peut être repliable si les sources sont nombreuses (non tranché : QO-508).
