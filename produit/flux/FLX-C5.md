---
id: FLX-C5
type: flux
titre: "Vivre le parcours (pas à pas manuel)"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  ecrans: [ECR-PARCOURS-EN-COURS-TERRAIN, ECR-TRANSVERSES-PARCOURS-PERSISTANT]
  invariants: [INV-09]
  decisions: [DEC-05, DEC-07, DEC-09]
anciens_ids: [C5]
sources:
  - conception/06-flows/03-parcours.yaml:204
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
Parcours lancé (FLX-C4), ou tap sur la surface persistante.

## Déroulé
1. L’écran du parcours montre l’étape courante et « Étape n sur Y ».
2. L’utilisateur ouvre l’étape (FLX-E3) ; la consultation du pin s’ouvre.
3. Au retour, l’étape suivante devient courante ; la progression et le slider se mettent à jour (DEC-07).
4. Il répète jusqu’à la dernière étape.

## Bifurcations
- « Sauter cette étape » : FLX-C8.
- « Étape précédente » ou tap dans la liste : change l’étape courante.
- Dernière étape vue ou sautée : FLX-C9.
- « Abandonner » + confirmation : parcours abandonné, surface persistante retirée.

## Sorties
Fin (FLX-C9) ou abandon.

## Cas particuliers
- Géolocalisation, alerte de proximité, déviation, pause, hors-ligne, audio : hors MVP (DEC-05).

## Invariants
INV-09
