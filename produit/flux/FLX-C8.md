---
id: FLX-C8
type: flux
titre: "Sauter une étape"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  ecrans: [ECR-PARCOURS-EN-COURS-TERRAIN]
  invariants: []
  decisions: [DEC-09, DEC-40]
anciens_ids: [C8]
sources:
  - conception/06-flows/03-parcours.yaml:361
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
Tap sur « Sauter cette étape » dans l’écran du parcours en cours (DEC-40).

## Déroulé
1. L’étape courante reste non complétée : aucune entrée « visitée » n’est écrite (DEC-09).
2. L’étape suivante devient courante ; la progression et le slider se mettent à jour.
3. Aucune confirmation, aucun message de reproche.

## Bifurcations
- Étape sautée = dernière étape : FLX-C9 avec « X étapes vues sur Y ».

## Sorties
Retour à FLX-C5 ou fin FLX-C9.

## Cas particuliers
- Revenir à une étape déjà vue n’est pas un saut : reconsultation sans changer la progression.
- Rouvrir ensuite une étape sautée la rend vue.
- Pas de sélecteur multi-cibles ni de résumé d’impact (DEC-40).

## Invariants
Aucun.
