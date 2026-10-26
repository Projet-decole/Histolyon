---
id: DOC-QO-D1
type: document
titre: "Questions ouvertes du domaine D1"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

## QO-101 — La carte est-elle projetable en mode présentation ?
Bloque : le contenu de l’état « mode présentation » de ECR-CARTE-PRINCIPALE, via CAP-D2.5. La source D1.1 renvoie à D2.5 « à confirmer » ; la recommandation du persona est « oui ». Unité : CAP-D1.1, ECR-CARTE-PRINCIPALE. Source : conception/03-fonctionnalites/01-carte-exploration-temporelle.yaml:146.

## QO-102 — Alternative non gestuelle au slider continu
Bloque : l’accessibilité de CAP-D1.2 pour les personnes à déficience motrice (« à anticiper »). Aucune forme n’est décrite. Unité : CAP-D1.2. Source : conception/03-fonctionnalites/01-carte-exploration-temporelle.yaml:208.

## QO-104 — Vignette de couverture dans l’aperçu d’un pin
Bloque : la composition de ECR-CARTE-APERCU-PIN. La source prévoit la vignette si un média existe ; DEC-03 écarte les images d’archives. Faut-il une image de couverture au MVP ? Unité : ECR-CARTE-APERCU-PIN. Source : conception/07-ecrans/carte/02-apercu-pin.yaml:28.

## QO-105 — Époque sélectionnée par défaut au lancement
Bloque : l’état nominal de ECR-CARTE-PRINCIPALE (« époque par défaut » non définie ; « Aujourd’hui » est la candidate naturelle, vue cumulée). Unité : CAP-D1.2, ECR-CARTE-PRINCIPALE. Source : conception/07-ecrans/carte/01-principale.yaml:48.
