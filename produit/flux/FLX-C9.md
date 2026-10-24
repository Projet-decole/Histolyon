---
id: FLX-C9
type: flux
titre: "Fin du parcours et célébration"
statut: mvp
priorite: important
jalon: JAL-GEL
liens:
  ecrans: [ECR-PARCOURS-FIN-CELEBRATION, ECR-TRANSVERSES-PARCOURS-PERSISTANT]
  invariants: []
  decisions: [DEC-09]
anciens_ids: [C9]
sources:
  - conception/06-flows/03-parcours.yaml:395
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
La dernière étape est vue ou sautée (FLX-C5, FLX-C8).

## Déroulé
1. L’app bascule sur l’écran de fin (TOK-CHO-FIN-PARCOURS) : conclusion si elle existe, « X étapes vues sur Y », durée, époques.
2. Le parcours est enregistré comme terminé ; seules les étapes réellement vues sont visitées (DEC-09).
3. La surface persistante disparaît.

## Bifurcations
- Tap sur une étape du récapitulatif : consultation du pin.
- Fermeture : retour à la fiche (action « Recommencer »).

## Sorties
Fiche du parcours.

## Cas particuliers
- Étapes sautées : récapitulatif sans reproche, célébration pleine.
- Partage d’image, retour de parcours : hors MVP.

## Invariants
Aucun.
