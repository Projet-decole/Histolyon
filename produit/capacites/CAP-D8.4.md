---
id: CAP-D8.4
type: capacite
titre: "Production des reconstitutions"
statut: s2
priorite: secondaire
jalon: JAL-S2
liens:
  capacites: [CAP-D8.1, CAP-D8.2]
  entites: [ENT-MODELE-3D]
  decisions: [DEC-04, DEC-50]
anciens_ids: [D8.4]
sources:
  - conception/03-fonctionnalites/08-3d-ar.yaml:387
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Raison d’être
Fournir au back-office le moyen d’attacher un modèle 3D à un pin, avec son époque, ses sources et son emplacement, de le faire valider puis de le publier. Sans cette production, les surfaces 3D n’ont rien à montrer.

## Pourquoi pas au MVP
Il n’y a pas de back-office au MVP : le modèle de démonstration est préparé hors outil et placé dans l’instantané embarqué (DEC-04). Le MVP exige seulement qu’un modèle ait une époque et au moins une source (ENT-MODELE-3D).
