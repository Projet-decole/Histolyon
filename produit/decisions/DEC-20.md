---
id: DEC-20
type: decision
titre: "Apparence par époque : paramètres sur un style de tuiles unique"
statut: mvp
liens:
  capacites: [CAP-D1.3]
anciens_ids: []
sources:
  - conception/03-fonctionnalites/01-carte-exploration-temporelle.yaml:258
  - conception/11-reponse-parametrique/04-mappings-parametriques.yaml:60
  - brief:lot1
derniere_verif: 2026-10-24
---

## Décision proposée
« Un seul style de carte » (DEC-06) signifie un seul fichier de tuiles et un seul style de fond. L’« apparence distincte par époque » (CAP-D1.3) est obtenue en faisant varier des paramètres d’affichage de ce fond (TOK-MAP-SLIDER-VERS-AXES-CARTE), sans second style.

## Sources en conflit
CAP-D1.3 exige une apparence distincte par époque (conception/…/01-carte-exploration-temporelle.yaml:258) ; DEC-06 impose un seul style au MVP.

## Conséquence
Solution la plus prudente appliquée dans CAP-D1.3 (R1, R6, CF5). Le calibrage des valeurs relève du groupe DESIGN.
