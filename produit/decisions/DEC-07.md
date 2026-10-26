---
id: DEC-07
type: decision
titre: "Slider et parcours : l’utilisateur prime"
statut: mvp
liens: {}
anciens_ids: []
sources:
  - brief:lot1
derniere_verif: 2026-10-24
---

## Décision
Quand un parcours est actif, il positionne le slider sur l’époque de l’étape courante ; l’utilisateur peut ensuite déplacer le slider librement.

## Pourquoi
Tranche la question ouverte de priorité entre pilotage automatique et manipulation manuelle (D1.2, C5).

## Conséquences
Un déplacement manuel ne casse pas le parcours. Le positionnement automatique se rejoue au changement d’étape (CHO-PILOTAGE-AUTOMATIQUE-EPOQUE).
