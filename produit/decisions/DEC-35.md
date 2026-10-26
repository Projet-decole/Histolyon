---
id: DEC-35
type: decision
titre: "FLX-B5 : AR retirée, la vue 3D plein écran est conservée"
statut: mvp
liens:
  capacites: [CAP-D2.5]
anciens_ids: []
sources:
  - conception/06-flows/02-consultation-pin.yaml:324
  - conception/08-contenu/04-microcopy-grand-public.yaml:390
derniere_verif: 2026-10-24
---

## Décision proposée
Dans le flux d’origine B5 « Consultation 3D immersive et basculement AR », seule la partie 3D plein écran est reprise au MVP. La bascule AR (permission caméra, ancrage, action « Voir sur place ») est reportée en S2.

## Sources en conflit
FLX-B5 d’origine mêle vue 3D et AR. La feuille de route interdit l’AR avant le rendu (DEC-05 écarte aussi la géolocalisation).

## Conséquence
FLX-B5 décrit la vue 3D sans caméra ; FLX-B4 mène à cette vue. Le libellé « Voir sur place » n’est pas repris.
