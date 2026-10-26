---
id: DEC-50
type: decision
titre: "Vue 3D du MVP : un modèle par pin, sans AR, point d’accès fondé sur le modèle"
statut: mvp
liens:
  capacites: [CAP-D8.1, CAP-D8.2, CAP-D8.3, CAP-D8.4]
anciens_ids: []
sources:
  - brief:lot1
  - conception/03-fonctionnalites/08-3d-ar.yaml:97
  - conception/06-flows/02-consultation-pin.yaml:262
  - conception/04-donnees/01-contenu.yaml:369
derniere_verif: 2026-10-24
---

## Décision proposée
Au MVP, un pin porte au plus un modèle 3D. Le point d’accès « Voir en 3D » dépend de l’existence de ce modèle (publié, avec au moins une source), pas d’un « contenu AR ». La bascule vers l’AR et le sélecteur de plusieurs modèles sont absents.

## Sources en conflit
- `08-3d-ar.yaml:97` conditionne le point d’accès à un « contenu 3D/AR » ; `02-consultation-pin.yaml:262` à « un modèle 3D validé » ; l’entité (`01-contenu.yaml:369`) rend l’ancrage géographique optionnel.
- `08-3d-ar.yaml` (D8.4) et l’écran 3D admettent plusieurs modèles par pin ; DEC-02 limite le pin à une époque et un récit.
- Les critères de fin de la consultation 3D exigent la bascule AR ; l’AR, la géolocalisation et la permission caméra sont reportées (DEC-05, DEC-06, feuille de route).

## Conséquence
Solution prudente appliquée : règle d’apparition fondée sur le modèle seul, pas de sélecteur, pas de bascule AR. Les critères de fin qui renvoient à l’AR sont rejetés dans `_tri-D8T`. L’AR et le multi-modèles reviennent en S2 (CAP-D8.3).
