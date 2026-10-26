---
id: DEC-70
type: decision
titre: "Parcours : provenance « personnel » absente du SQL, MVP éditorial seul"
statut: mvp
liens:
  entites: [ENT-PARCOURS]
anciens_ids: []
sources:
  - conception/04-donnees/02-parcours.yaml:59
  - supabase/migrations/20260925120000_schema_complet.sql:23
derniere_verif: 2026-10-24
---

## Décision proposée
Au MVP, tous les parcours ont la provenance `editorial`. La provenance `personnel` n’est pas modélisée en base serveur.

## Sources en conflit
La source liste trois provenances (éditorial, communautaire, personnel). L’enum SQL `provenance_parcours` n’en a que deux : les parcours personnels sont prévus en local (Drift), mais `schema.drift` n’a aucune table pour eux.

## Conséquence
ENT-PARCOURS décrit `editorial` (MVP) et `communautaire` (hors MVP). Les parcours personnels sont hors MVP ; le choix du stockage local sera pris au moment de les introduire.
