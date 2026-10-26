---
id: DEC-81
type: decision
titre: "Opacité d’un composant désactivé : 0,5 (valeur du package)"
statut: mvp
liens:
  decisions: [DEC-12]
anciens_ids: []
sources:
  - brief:lot1
  - conception/12-tokens/04-opacites-constantes.yaml:71
  - conception/12-tokens/04-opacites-constantes.yaml:137
  - packages/design_tokens/lib/src/opacity.dart:1
derniere_verif: 2026-10-24
---

## Décision proposée
`TOK-OPACITY-DESACTIVE` vaut 0,5, comme dans le package (DEC-12) et dans la maquette, associée à la bascule de couleur vers `TOK-COLOR-TEXTE-TERTIAIRE` décrite dans TOKENS.md.

## Sources en conflit
Le fichier d’opacités annonce 0,5 dans la fiche du token (`04-opacites-constantes.yaml:71`) après une révision, mais garde 0,4 dans le tableau de répartition (`:137`) et dans la section d’accessibilité (`:167`).

## Conséquence
La valeur 0,4 est une trace de l’ancienne version. Rien à changer dans le package. Le contraste effectif d’un bouton désactivé reste à vérifier sur écran réel.
