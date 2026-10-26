---
id: DEC-73
type: decision
titre: "Profil : seules les colonnes Drift existent, le reste en préférences"
statut: mvp
liens:
  entites: [ENT-PROFIL]
anciens_ids: []
sources:
  - conception/04-donnees/03-utilisateur.yaml:44
  - apps/mobile/lib/core/db/schema.drift:5
derniere_verif: 2026-10-24
---

## Décision proposée
Le profil MVP se limite à `id` et `cree_le`, plus des paires clé/valeur dans `preference`. Aucun attribut de la source n’est promu en colonne.

## Sources en conflit
La source liste des attributs obligatoires (langue, mode de notification de proximité, historique actif, accessibilité, première ouverture, permissions déjà demandées). Drift n’a que `profil(id, cree_le)` et `preference(profil_id, cle, valeur)`.

## Conséquence
Langue (DEC-15) et proximité (DEC-05) sont hors MVP. Les réglages utiles (première ouverture, historique actif) seront des clés de préférence, à nommer à l’implémentation.
