---
id: COMP-SAVIEZ-VOUS
type: composant
titre: "Le saviez-vous"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-ICONE, COMP-LIBELLE-TEXTE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: [DEC-03, DEC-14]
anciens_ids: [comp-saviez-vous]
sources:
  - conception/10-composants/03-fonctionnels.yaml:530
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Encart texte : fait annexe qui prolonge le récit (anecdote, détail, écho contemporain). Il ajoute au récit sans le répéter. Bloc statique. Un des deux encarts retenus par DEC-03.

## Variantes et états
Aucun état interactif. Fait de longueur variable (une phrase à un court paragraphe).

## Composition
- `icone` (1) : COMP-ICONE, marqueur d’anecdote.
- `ouverture` (1) : COMP-LIBELLE-TEXTE, « Le saviez-vous ».
- `fait` (1) : COMP-LIBELLE-TEXTE, au tutoiement narratif (DEC-14).

## Tokens
Rayon TOK-RADIUS-MD (encart « Le saviez-vous » dans la zone narrative). Aucun autre token propre documenté.

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé.
