---
id: CAP-D8.3
type: capacite
titre: "Superposition AR"
statut: s2
priorite: secondaire
jalon: JAL-S2
liens:
  capacites: [CAP-D8.2, CAP-D8.4]
  decisions: [DEC-05, DEC-06, DEC-50]
anciens_ids: [D8.3]
sources:
  - conception/03-fonctionnalites/08-3d-ar.yaml:266
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Raison d’être
Replacer la reconstitution dans la vue caméra, à l’endroit où le bâtiment se trouvait. Le geste est volontaire (lever le téléphone, accepter la caméra) ; un refus ramène à la vue 3D sans pénalité ; aucune image n’est conservée.

## Pourquoi pas au MVP
L’AR demande la géolocalisation, la permission caméra et un ancrage fiable, tous reportés (DEC-05, DEC-06) ; la feuille de route classe l’AR « jamais avant le rendu ». Le MVP livre la vue 3D seule (DEC-50, CAP-D8.2).
