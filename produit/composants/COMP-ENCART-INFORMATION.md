---
id: COMP-ENCART-INFORMATION
type: composant
titre: "Encart d’information"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-ICONE, COMP-LIBELLE-TEXTE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: [DEC-03]
anciens_ids: [comp-encart-information]
sources:
  - conception/10-composants/02-molecules.yaml:635
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Bloc d’information générique (icône, titre, contenu) : conseil, alerte, succès, erreur. Dans la narration d’un pin, il porte les encarts texte du MVP (DEC-03). Non interactif.

## Variantes et états
Type : info, succès, avertissement, erreur (couleur et icône adaptées). Contenu long : repli possible.

## Composition
- `icone` (1) : COMP-ICONE.
- `titre` (1), `contenu` (1) : COMP-LIBELLE-TEXTE.

## Tokens
Rayon TOK-RADIUS-LG, marge interne TOK-SPACE-MD. Couleurs : TOK-COLOR-FONCTIONNEL-INFO, TOK-COLOR-FONCTIONNEL-SUCCES, TOK-COLOR-FONCTIONNEL-ERREUR (avertissement : pas de token fonctionnel dédié, voir QO-509).

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé.
