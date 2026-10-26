---
id: FLX-B5
type: flux
titre: "Consultation 3D immersive (sans AR)"
statut: mvp
priorite: coeur
jalon: JAL-GEL
liens:
  ecrans: [ECR-PIN-CONSULTATION-3D, ECR-PIN-CONSULTATION-APPROFONDIE]
  invariants: []
  decisions: [DEC-05, DEC-13]
  questions: [QO-203]
anciens_ids: [B5]
sources:
  - conception/06-flows/02-consultation-pin.yaml:324
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
Ouverture de ECR-PIN-CONSULTATION-3D depuis FLX-B4. Dans l’origine, B5 est la bascule AR avec permission caméra ; au MVP seule la vue 3D plein écran est conservée (voir DEC-35).

## Déroulé
1. Le modèle 3D occupe l’écran, sans caméra ni permission.
2. L’utilisateur manipule le modèle (rotation, zoom).
3. Il consulte le titre, l’époque recréée et les sources de la reconstitution.
4. Il revient à la consultation approfondie.

## Bifurcations
- Retour → FLX-B2 du même pin.

## Sorties
Retour à la consultation approfondie.

## Cas particuliers
- Aucune action « Voir sur place » : l’AR, la permission caméra et l’ancrage géographique sont hors MVP (S2, DEC-05).
- Parcours actif : aucune progression pendant la vue 3D ; il reprend au retour.
- App mise en arrière-plan : le modèle se recharge au retour (QO-203).

## Invariants
Aucun.
