---
id: DEC-04
type: decision
titre: "Données du MVP : instantané embarqué dans l’app"
statut: mvp
liens: {}
anciens_ids: []
sources:
  - brief:lot1
derniere_verif: 2026-10-24
---

## Décision
Le contenu (pins, parcours, époques) est un instantané embarqué dans l’app. Supabase (lecture à distance, comptes, communauté) vient au second semestre.

## Pourquoi
Supprimer la dépendance réseau et le backend du chemin critique du rendu du 07/02/2027.

## Conséquences
Les entités sont décrites avec leur correspondance SQL, mais le MVP lit un instantané local. Le mode hors-ligne est donc le fonctionnement normal pour le contenu ; le bandeau hors-ligne reste prévu pour les cas où l’app tente une ressource distante.
