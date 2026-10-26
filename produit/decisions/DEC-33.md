---
id: DEC-33
type: decision
titre: "Catégorie : classement porté par les données, pas de saisie ni de filtre au MVP"
statut: mvp
liens:
  capacites: [CAP-D2.2]
anciens_ids: []
sources:
  - conception/03-fonctionnalites/02-pins-et-contenu.yaml:204
  - brief:lot1
derniere_verif: 2026-10-24
---

## Décision proposée
« Catégorie obligatoire à la création » et « filtrage par catégorie dans la recherche » ne sont pas des critères du MVP. La contrainte devient : tout pin de l’instantané embarqué a exactement une catégorie valide.

## Sources en conflit
CAP-D2.2 d’origine : création par l’éditrice (back-office) et filtre dans la recherche (D1.4). DEC-04 : contenu embarqué ; pas de saisie dans l’app mobile.

## Conséquence
Vérification à la génération de l’instantané. Le filtre relève de CAP-D1.4 si cette capacité l’adopte.
