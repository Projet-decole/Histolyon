---
id: DEC-60
type: decision
titre: "Layouts : deux fiches écrites comme patrons d’écran, pas de layout parcours ni profil"
statut: mvp
liens:
  composants: [COMP-LAYOUT-CARTE-PRINCIPALE, COMP-LAYOUT-CONSULTATION-PIN-APPROFONDIE]
anciens_ids: []
sources:
  - conception/10-composants/04-shell.yaml:33
  - conception/10-composants/04-shell.yaml:44
  - conception/10-composants/04-shell.yaml:752
  - conception/10-composants/04-shell.yaml:887
derniere_verif: 2026-10-24
---

## Décision proposée
Écrire les fiches COMP-LAYOUT-CARTE-PRINCIPALE et COMP-LAYOUT-CONSULTATION-PIN-APPROFONDIE, en les présentant comme des patrons d’écran : spec des emplacements et de leur cardinalité, sans composant Figma. Ne pas écrire de fiche pour le layout parcours ni le layout profil (leurs écrans de premier niveau, catalogue et profil, ne font pas partie de la tranche).

## Sources en conflit
- Le bandeau d’en-tête de `04-shell.yaml` dit que les quatre layouts « ne sont PLUS componentisés » (supprimés de Figma, devenus des patrons d’écran) et que la famille shell passe de 19 à 14 composants.
- Les fiches elles-mêmes restent définies, et les notes de la fiche consultation justifient encore « le maintien en composant shell » pour réutilisation par deux écrans.
- La fiche consultation cite aussi le mode présentation, écran hors tranche.

## Conséquence
Les deux fiches gardent les emplacements et leurs conditions de visibilité, mais le montage des écrans reste décidé dans les fiches `ECR-…`. Les emplacements neutralisés (audio, commentaires, post-narratif, permission) sont signalés sans lien dans « Hors MVP ». Question de fond : QO-513 (garder ces deux fiches comme type COMP ou les fondre dans les fiches d’écran).
