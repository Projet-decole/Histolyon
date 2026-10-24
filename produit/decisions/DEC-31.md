---
id: DEC-31
type: decision
titre: "Un pin porte exactement une époque au MVP"
statut: mvp
liens:
  capacites: [CAP-D2.1]
anciens_ids: []
sources:
  - conception/03-fonctionnalites/02-pins-et-contenu.yaml:88
  - brief:lot1
derniere_verif: 2026-10-24
---

## Décision proposée
La règle « au moins une époque (multi-époques admis) » est lue « exactement une époque » pour le MVP. Les données (`content/pins/*.yaml`) l’appliquent déjà par une liste d’un élément.

## Sources en conflit
CAP-D2.1 d’origine : association à au moins une époque. DEC-02 : un pin, une époque.

## Conséquence
Pas de marque multi-époques ni de navigation entre époques. Le modèle de données n’interdit pas plusieurs époques (S2, CAP-D2.3).
