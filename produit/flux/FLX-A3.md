---
id: FLX-A3
type: flux
titre: "Navigation sur la carte et sélection d’époque"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  ecrans: [ECR-CARTE-PRINCIPALE, ECR-CARTE-APERCU-PIN]
  invariants: [INV-07, INV-09]
  decisions: [DEC-02, DEC-07, DEC-08]
anciens_ids: [A3]
sources:
  - conception/06-flows/01-decouverte.yaml:141
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
La personne déplace ou zoome la carte, ou fait glisser le slider d’époques.

## Déroulé
1. Déplacement ou zoom : la carte se recadre dans l’emprise ; les pins visibles suivent l’époque sélectionnée.
2. Glissement du slider (CAP-D1.2) : l’apparence de la carte évolue progressivement (CAP-D1.3) et l’année courante est lisible.
3. Relâche : l’époque se cale sur la plus proche du catalogue (INV-07, TOK-CHO-CALAGE-EPOQUE) ; les pins de cette époque se chargent, pas pendant le geste.
4. Sur « Aujourd’hui », tous les pins de toutes les époques sont visibles.

## Bifurcations
- Tap sur un pin → ECR-CARTE-APERCU-PIN ; fermeture → retour à la carte.
- Parcours actif : le slider se place sur l’époque de l’étape ; un geste manuel prime sans casser le parcours (DEC-07).

## Sorties
Carte recadrée ou époque mise à jour ; exploration continue.

## Cas particuliers
- Aucun pin à l’époque : message d’invitation (ECR-CARTE-PRINCIPALE).
- Un pin sans position n’est pas affiché sur la carte (INV-09).
- Sans réseau : sans effet (DEC-04).

## Invariants
INV-07, INV-09.
