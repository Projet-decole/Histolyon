---
id: DEC-01
type: decision
titre: "La vérité vit dans produit/, conception/ reste en archive"
statut: mvp
liens: {}
anciens_ids: []
sources:
  - brief:lot1
derniere_verif: 2026-10-24
---

## Décision
`produit/` est la source de lecture courante (organisée par capacité, écran, composant, flux, entité). `conception/` reste gelé et intact : on le cite comme source (`conception/…:ligne`), on ne le modifie plus.

## Pourquoi
`conception/` pèse ≈ 619 k tokens, organisé par paliers de production, avec des identifiants ambigus (voir DOC-COLLISIONS) et des références mortes. Il n’est pas exploitable par des agents.

## Conséquences
Toute évolution du produit se fait dans `produit/`. `_correspondance.csv` relie chaque ancien identifiant à son nouvel emplacement.
