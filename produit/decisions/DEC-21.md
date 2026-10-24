---
id: DEC-21
type: decision
titre: "Centrage initial de la carte : Bellecour"
statut: mvp
liens:
  capacites: [CAP-D1.1]
anciens_ids: []
sources:
  - conception/03-fonctionnalites/01-carte-exploration-temporelle.yaml:78
  - conception/07-ecrans/carte/01-principale.yaml:96
  - brief:lot1
derniere_verif: 2026-10-24
---

## Décision proposée
La carte s’ouvre toujours centrée sur Bellecour. Bellecour doit se trouver dans l’emprise du fichier de tuiles embarqué (DEC-06).

## Sources en conflit
La capacité D1.1 fixe « Centrage initial systématique = Bellecour » ; la fiche d’écran garde ouverte la question du point d’ancrage (Bellecour, Vieux Lyon, vue large).

## Conséquence
CAP-D1.1/R2 et FLX-A1 appliquent Bellecour. Le niveau de zoom initial relève du groupe DESIGN (produit/design/CARTE.md).
