---
id: DEC-51
type: decision
titre: "La visionneuse 3D masque elle-même son chrome, sans mode présentation"
statut: mvp
liens:
  capacites: [CAP-D8.2]
anciens_ids: []
sources:
  - brief:lot1
  - conception/03-fonctionnalites/08-3d-ar.yaml:188
  - conception/07-ecrans/pin/03-consultation-3d.yaml:32
derniere_verif: 2026-10-24
---

## Décision proposée
La visionneuse 3D du MVP est un écran plein écran autonome. Elle masque elle-même le chrome non essentiel (navigation, bandeau hors ligne, surfaces persistantes) et ne dépend pas du mode présentation, qui est hors MVP.

## Sources en conflit
Les sources disent que la consultation 3D « est une forme du mode présentation » défini par la consultation approfondie ; or l’écran du mode présentation est écarté du MVP.

## Conséquence
Le comportement exact de ce mode n’étant pas livré, CAP-D8.2 définit seule le masquage. Si le mode présentation revient en S2, la visionneuse s’y alignera.
