---
id: COMP-CITATION
type: composant
titre: "Citation historique"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: [DEC-03, DEC-14]
anciens_ids: [comp-citation]
sources:
  - conception/10-composants/03-fonctionnels.yaml:511
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Encart texte : archive ou témoignage qui prolonge le récit dans le registre de l’époque. Bloc statique, source visible. Un des deux encarts retenus par DEC-03.

## Variantes et états
Aucun état interactif. Citation de longueur variable (du vers au paragraphe) ; le crédit est obligatoire.

## Composition
- `intro` (0..1) : amorce sobre du conteur, au tutoiement narratif (DEC-14).
- `citation` (1) : texte cité entre guillemets.
- `attribution` (1) : crédit, date, source. Tous en COMP-LIBELLE-TEXTE.

## Tokens
Texte TOK-COLOR-TEXTE-SECONDAIRE (citation en italique éditorial) sur fond TOK-COLOR-FOND-SECONDAIRE. Famille TOK-FONT-TITRE-EDITORIAL ou TOK-FONT-CORPS-NARRATIF non fixée par la source : QO-501.

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé.
