---
id: DOC-QO-DONNEES
type: document
titre: "Questions ouvertes du groupe DONNEES"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

## QO-601 — Quelle cible stocker pour une étape vue ?
Pourquoi elle bloque : DEC-09 impose « X étapes vues sur Y », donc il faut retrouver les étapes vues d’un parcours. `historique_visite` n’accepte que `pin` ou `parcours` comme cible, sans colonne d’étape. Unité : ENT-HISTORIQUE-DE-VISITE. Source : `apps/mobile/lib/core/db/schema.drift:30` ; DEC-72.

## QO-602 — Liste définitive des catégories
Pourquoi : 11 catégories sont seedées dans `content/categories/`, jamais validées par l’équipe éditoriale. Unité : ENT-CATEGORIE. Source : `conception/04-donnees/01-contenu.yaml:185`.

## QO-603 — Sources des pins réels
Pourquoi : le seul pin réel cite des sources publiques générales, sans vérification par l’historienne. Les bornes d’époque attendent la même validation (DEC-08). Unités : ENT-SOURCE, ENT-EPOQUE. Source : `content/pins/cour-des-voraces.yaml:1`.

## QO-604 — Liste initiale des badges
Pourquoi : aucun badge défini ; l’entité est s2. Unité : ENT-BADGE. Source : `conception/04-donnees/01-contenu.yaml:364`.

## QO-605 — Cycle de vie d’un modèle 3D rattaché à un pin
Pourquoi : suit-il celui du pin ou est-il indépendant ? Le SQL n’a pas de statut sur `modele_3d`. Unité : ENT-MODELE-3D. Source : `conception/04-donnees/01-contenu.yaml:417`.

## QO-606 — Réalité augmentée au MVP ?
Pourquoi : l’`ancrage` AR est facultatif en base, mais DEC-13 ne parle que d’une « vue 3D ». Unité : ENT-MODELE-3D. Source : `conception/04-donnees/01-contenu.yaml:396`.

## QO-607 — Pin sans localisation dans une étape
Pourquoi : un parcours à pied suppose un point sur la carte ; la source recommande d’autoriser et de signaler à l’auteur. Au MVP, tous les pins d’un parcours doivent-ils être localisés ? Unité : ENT-ETAPE. Source : `conception/04-donnees/02-parcours.yaml:383`.
