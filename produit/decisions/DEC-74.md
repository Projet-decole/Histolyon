---
id: DEC-74
type: decision
titre: "Colonnes SQL absentes de la source et bornes d’époque numériques"
statut: mvp
liens:
  entites: [ENT-PIN, ENT-EPOQUE, ENT-SOURCE, ENT-MEDIA, ENT-MODELE-3D, ENT-BADGE]
anciens_ids: []
sources:
  - conception/04-donnees/01-contenu.yaml:189
  - supabase/migrations/0001_socle.sql:57
  - supabase/migrations/20260925120000_schema_complet.sql:136
derniere_verif: 2026-10-24
---

## Décision proposée
Le SQL fait foi pour les colonnes. Les écarts sont documentés dans chaque entité : `slug` (en plus de l’identifiant), `licence` et `chemin_storage` (média, modèle 3D), `ordre` (média), `cap_degres` et `echelle` (modèle 3D), `created_at`/`updated_at`.

## Sources en conflit
La source n’a ni licence, ni chemin de stockage, ni échelle. Elle décrit les bornes d’époque comme « année ou expression de période » ; le SQL stocke des entiers (années, négatif avant J.-C.) pour piloter le slider.

## Conséquence
Les bornes des 10 époques sont des entiers (ENT-EPOQUE). Aucune colonne n’est ajoutée côté produit ; la licence de chaque média ou modèle reste obligatoire.
