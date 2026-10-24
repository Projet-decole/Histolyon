---
id: DEC-71
type: decision
titre: "Étape : le SQL fait foi pour introduction et transition"
statut: mvp
liens:
  entites: [ENT-ETAPE, ENT-PARCOURS]
anciens_ids: []
sources:
  - conception/04-donnees/02-parcours.yaml:107
  - conception/04-donnees/02-parcours.yaml:330
  - supabase/migrations/20260925120000_schema_complet.sql:238
derniere_verif: 2026-10-24
---

## Décision proposée
Les transitions narratives vivent sur l’étape (`transition_depuis_precedente`) et l’introduction s’appelle `introduction`, comme en SQL. `note_personnelle` n’existe pas au MVP.

## Sources en conflit
La source place `transitions_narratives` sur le Parcours (fragments entre deux étapes consécutives) et nomme `introduction_d_étape` et `note_personnelle` sur l’Étape. Le SQL n’a ni liste de transitions sur `parcours` ni `note_personnelle` ; il a `introduction` et `transition_depuis_precedente` (nulle pour la première étape).

## Conséquence
ENT-ETAPE suit le SQL. Même sémantique : la transition se lit entre deux étapes, l’introduction au début de l’étape.
