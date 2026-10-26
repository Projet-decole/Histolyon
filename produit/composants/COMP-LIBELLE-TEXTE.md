---
id: COMP-LIBELLE-TEXTE
type: composant
titre: "Libellé texte"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  composants: []
  ecrans: [ECR-CARTE-PRINCIPALE, ECR-PIN-CONSULTATION-APPROFONDIE, ECR-PARCOURS-FICHE-DETAIL]
  decisions: [DEC-14, DEC-15]
anciens_ids: [comp-libelle-texte]
sources:
  - conception/10-composants/01-atomes.yaml:675
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Brique textuelle générique : titres, corps, métadonnées, légendes. Presque toute composition en contient. Non interactif.

## Variantes et états
- Sémantique : titre, corps, légende, surtitre, métadonnée. Niveau de titre H1 à H4 pour la sémantique « titre ».
- Poids : normal, moyen, gras.
- Texte long : tronqué avec ellipse selon le contexte ; le corps s’étend sur plusieurs lignes, le titre est limité.

## Composition
Aucun sous-composant.

## Tokens
Titres TOK-TYPO-DISPLAY-XL à TOK-TYPO-DISPLAY-SM, corps TOK-TYPO-BODY-LG, TOK-TYPO-BODY-MD, TOK-TYPO-BODY-SM, TOK-TYPO-BODY-EMPHASIS, interface TOK-TYPO-UI-LG à TOK-TYPO-UI-XS. Couleur TOK-COLOR-TEXTE-PRINCIPAL ou TOK-COLOR-TEXTE-SECONDAIRE (métadonnées).

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé. Langue : français seul au MVP (DEC-15) ; le récit tutoie, l’interface vouvoie (DEC-14).
