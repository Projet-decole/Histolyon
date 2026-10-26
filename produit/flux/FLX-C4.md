---
id: FLX-C4
type: flux
titre: "Lancement du parcours depuis la fiche"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  ecrans: [ECR-PARCOURS-FICHE-DETAIL, ECR-TRANSVERSES-PARCOURS-PERSISTANT]
  invariants: []
  decisions: [DEC-05, DEC-07]
anciens_ids: [C4]
sources:
  - conception/06-flows/03-parcours.yaml:159
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
Tap sur « Démarrer ce parcours » (ou « Recommencer ») dans la fiche (CAP-D3.4).

## Déroulé
1. Le parcours passe à l’état « en cours » ; « parcours commencé » est écrit dans l’historique.
2. L’app bascule sur la carte, qui se recadre sur l’itinéraire puis sur l’étape 1 (TOK-CHO-LANCEMENT-PARCOURS).
3. Le tracé apparaît, les pins du parcours sont numérotés, les autres atténués.
4. La surface persistante apparaît (« Étape 1 sur Y »).
5. Le slider se positionne sur l’époque de l’étape 1 (DEC-07).

## Bifurcations
Aucune : pas de choix terrain/canapé, pas de permission (DEC-05).

## Sorties
Vie du parcours (FLX-C5).

## Cas particuliers
- Un seul parcours au MVP : pas de conflit avec un autre parcours en cours.
- Parcours déjà en cours : la fiche propose « Reprendre », pas de relancement.

## Invariants
Aucun.
