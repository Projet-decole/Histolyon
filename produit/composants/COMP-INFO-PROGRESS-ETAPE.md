---
id: COMP-INFO-PROGRESS-ETAPE
type: composant
titre: "Info de progression d’étape"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-BADGE-NOMBRE, COMP-ICONE, COMP-LIBELLE-TEXTE]
  ecrans: [ECR-PARCOURS-EN-COURS-TERRAIN, ECR-TRANSVERSES-PARCOURS-PERSISTANT]
  decisions: [DEC-05, DEC-09]
anciens_ids: [comp-info-progress-etape]
sources:
  - conception/10-composants/02-molecules.yaml:708
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Synthèse compacte de la progression dans un parcours actif : numéro d’étape, icône d’état, libellé « Étape n/N ». Affichage seul, logé dans la surface persistante du parcours.

## Variantes et états
Aucune variante. Numéro élevé (10 et plus) : mise en page adaptée. Parcours sans étape : non rendu.

## Composition
- `numero_etape` (1) : COMP-BADGE-NOMBRE.
- `icone_etat` (1) : COMP-ICONE.
- `libelle` (1) : COMP-LIBELLE-TEXTE.

## Tokens
Aucun token propre documenté.

## Interactions natives
Aucune ; le tap est porté par la surface parente. Les valeurs suivent le parcours en cours (étape courante et total). Une étape sautée n’est pas comptée comme complétée (DEC-09).

## Remarque Figma
Aucun nœud référencé. La source distingue des icônes terrain et canapé : au MVP il n’y a qu’un mode, pas à pas manuel (DEC-05).
