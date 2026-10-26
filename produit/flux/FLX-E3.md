---
id: FLX-E3
type: flux
titre: "Déclarer l’arrivée à une étape (manuel)"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  ecrans: [ECR-PARCOURS-EN-COURS-TERRAIN]
  invariants: []
  decisions: [DEC-05, DEC-09]
anciens_ids: [E3]
sources:
  - conception/06-flows/05-notifications.yaml:173
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
Tap de l’utilisateur sur l’étape courante ou sur une étape de la liste, dans l’écran du parcours en cours. À l’origine, c’est le repli manuel de l’arrivée ; au MVP, c’est le seul mécanisme d’arrivée (DEC-05).

## Déroulé
1. L’étape est marquée vue, sans vérification de position ni dialogue.
2. La consultation approfondie du pin de l’étape s’ouvre.
3. Au retour, l’étape suivante devient courante (FLX-C5).

## Bifurcations
- Fermeture immédiate : l’étape reste vue.
- Tap sur une étape non courante : elle devient courante ; les étapes passées sans consultation restent non complétées (DEC-09).

## Sorties
Retour à FLX-C5.

## Cas particuliers
- Étape déjà vue : simple reconsultation.
- Alerte de proximité, détection d’arrivée, confirmation de proximité : écartées (DEC-05).

## Invariants
Aucun.
