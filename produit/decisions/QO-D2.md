---
id: DOC-QO-D2
type: document
titre: "Questions ouvertes du groupe D2 (pins et contenu)"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

## QO-201 — seuil de zoom du regroupement des pins
Bloque l’implémentation du cluster (R9). La source ne fixe aucun seuil (« niveaux qualifiés, seuils chiffrés non posés »). Unité : CAP-D2.1. Source : conception/09-cartographie/04-densite-zoom.yaml:55.

## QO-202 — format des encarts : citation et position d’insertion
Le seul exemple de données est un « Le saviez-vous » sans position ; aucun type « citation » n’existe dans les données. Bloque l’affichage des citations sourcées. Unité : CAP-D2.6 (voir DEC-30). Source : content/pins/cour-des-voraces.yaml:78.

## QO-203 — le modèle 3D est-il embarqué avec l’instantané ?
DEC-04 embarque le contenu ; la règle du dépôt interdit de committer un `.glb` (Supabase Storage). Bloque le comportement de FLX-B4 et FLX-B5 sans réseau. Unités : FLX-B4, FLX-B5. Source : conception/06-flows/02-consultation-pin.yaml:309.
