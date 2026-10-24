---
id: COMP-TAG
type: composant
titre: "Tag"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE, ECR-PARCOURS-FICHE-DETAIL]
  decisions: []
anciens_ids: [comp-tag]
sources:
  - conception/10-composants/01-atomes.yaml:912
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Étiquette textuelle libre (mots-clés, métadonnées). Non interactive ; distincte du chip et de COMP-TAG-CATEGORIE (sémantique précise).

## Variantes et états
Couleur sémantique : neutre, accent, succès, attention, danger. Texte court, tronqué au-delà d’un seuil compact.

## Composition
- `texte` (1) : COMP-LIBELLE-TEXTE.

## Tokens
Neutre TOK-COLOR-FOND-SECONDAIRE ; succès TOK-COLOR-FONCTIONNEL-SUCCES ; danger TOK-COLOR-FONCTIONNEL-ERREUR ; accent TOK-COLOR-PRIMARY. Pas de texte en TOK-COLOR-OR-ACCENT (interdit en texte).

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé. Aucun composant parent n’est déclaré dans la source : l’usage exact au MVP est à confirmer (QO-504).
