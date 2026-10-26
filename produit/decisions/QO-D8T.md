---
id: DOC-QO-D8T
type: document
titre: "Questions ouvertes du groupe D8T (3D et transverses)"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

## QO-401 — Le fichier du modèle 3D est-il embarqué ou téléchargé ?
Bloque : les états « chargement », « hors ligne » et « erreur » de la visionneuse. DEC-04 embarque le contenu, mais le contrat du dépôt place les modèles dans le stockage distant et interdit de committer un média. Sans réponse, la visionneuse spécifie les états chargement et erreur (valables dans les deux cas) et l’état « hors ligne » seulement si le fichier est distant. Unités : CAP-D8.2, ECR-PIN-CONSULTATION-3D. Sources : `conception/07-ecrans/pin/03-consultation-3d.yaml:57`, DEC-04.

## QO-402 — Comment s’ouvre la liste des sources de la reconstitution ?
Bloque : la forme de l’action « Sources de la reconstitution » (panneau, feuille, page). La source renvoie à une décision de design qui n’existe plus. Unités : CAP-D8.2, ECR-PIN-CONSULTATION-3D. Source : `conception/07-ecrans/pin/03-consultation-3d.yaml:67`.

## QO-403 — Que faire si l’appareil ne rend pas le modèle de façon fluide ?
Bloque : l’état « ressources insuffisantes » (version simplifiée, message seul…). À arbitrer avec les spécialistes 3D. Unités : CAP-D8.2, ECR-PIN-CONSULTATION-3D. Source : `conception/07-ecrans/pin/03-consultation-3d.yaml:59`.

## QO-404 — Quelle ressource distante déclenche le bandeau hors ligne au MVP ?
Bloque : le déclencheur du bandeau. Avec un instantané embarqué (DEC-04) et des tuiles embarquées (DEC-06), aucune ressource distante n’est identifiée, sauf peut-être le modèle 3D (QO-401). Unité : ECR-TRANSVERSES-BANDEAU-OFFLINE. Source : `conception/07-ecrans/transverses/03-bandeau-offline.yaml:37`.

## QO-405 — Faut-il afficher une attribution pour le modèle de la fontaine de la place des Jacobins ?
Bloque : le contenu de la zone de contextualisation. La feuille de route dit que les droits du modèle sont à vérifier. Unités : CAP-D8.2, ECR-PIN-CONSULTATION-3D. Source : `produit/FEUILLE-DE-ROUTE.md`.
