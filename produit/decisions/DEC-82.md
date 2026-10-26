---
id: DEC-82
type: decision
titre: "Fond de carte : un seul style, l’apparence par époque vient de paramètres"
statut: mvp
liens:
  decisions: [DEC-06, DEC-20]
anciens_ids: []
sources:
  - brief:lot1
  - docs/ARCHITECTURE-SPINE.md:113
  - conception/09-cartographie/01-fond-et-epoques.yaml:41
  - conception/11-reponse-parametrique/04-mappings-parametriques.yaml:60
derniere_verif: 2026-10-24
---

## Décision proposée
Au MVP il y a un seul style de fond de carte et un seul fichier de tuiles (DEC-06). L’apparence propre à chaque époque est obtenue en faisant varier les cinq axes d’affichage (température, désaturation, grain, vignettage, contraste) en fonction de la position du slider (DEC-20, TOK-MAP-SLIDER-VERS-AXES-CARTE). Le MVP ne crée pas de style de carte par époque.

## Sources en conflit
- Le document d’architecture prévoit « un style JSON de fond par Époque » avec un slider qui « ne fait que changer de style » (`docs/ARCHITECTURE-SPINE.md:113`).
- La conception veut une apparence qui varie de façon **continue** pendant le glissement, avec dix ancres (`01-fond-et-epoques.yaml:41`, `04-mappings-parametriques.yaml:60`), ce qu’un changement de style discret ne rend pas.
- DEC-06 impose un seul style au MVP.

## Conséquence
CARTE.md et MOUVEMENT.md décrivent le comportement paramétrique continu. L’architecture technique doit être alignée plus tard (hors périmètre de `produit/`) : soit des paramètres de rendu sur un style unique, soit un style par ancre avec interpolation, mais jamais un saut discret.
