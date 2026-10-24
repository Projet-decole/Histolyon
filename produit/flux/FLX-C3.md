---
id: FLX-C3
type: flux
titre: "Consultation de la fiche du parcours"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  ecrans: [ECR-PARCOURS-FICHE-DETAIL]
  invariants: [INV-08]
  decisions: [DEC-04, DEC-13]
anciens_ids: [C3]
sources:
  - conception/06-flows/03-parcours.yaml:110
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
Ouverture de la surface Parcours : elle affiche la fiche de l’unique parcours embarqué (CAP-D3.3).

## Déroulé
1. La fiche s’affiche : titre, teaser, métadonnées, étapes.
2. L’utilisateur parcourt la liste et ouvre l’aperçu d’une étape.

## Bifurcations
- Tap sur « Démarrer ce parcours » : FLX-C4.
- Tap sur un pin d’étape dans l’aperçu : consultation approfondie du pin ; le retour ramène à la fiche.
- Retour : onglet d’origine.

## Sorties
Lancement (FLX-C4) ou retour à l’onglet.

## Cas particuliers
- Parcours en cours : action « Reprendre » vers l’écran du parcours.
- Entrée par lien universel, favori, signalement, retour : S2.

## Invariants
INV-08
