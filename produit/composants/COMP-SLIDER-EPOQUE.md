---
id: COMP-SLIDER-EPOQUE
type: composant
titre: "Slider d’époque"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  composants: [COMP-LIBELLE-TEXTE]
  ecrans: [ECR-CARTE-PRINCIPALE]
  decisions: [DEC-07, DEC-08]
  capacites: [CAP-D1.2]
anciens_ids: [comp-slider-epoque]
sources:
  - conception/10-composants/03-fonctionnels.yaml:172
  - conception/10-composants/03-fonctionnels.yaml:698
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Navigateur temporel : un glissé continu interpole le fond de la carte, le relâchement cale sur une époque. C’est la source primaire de l’époque sélectionnée. Intention close : ce comportement est invariant.

## Variantes et états
- Orientation : horizontale ou verticale (fixée par l’écran).
- États : repos, glissé, calage, pilotage automatique.
- Transitions : repos vers glissé au contact de la poignée ; glissé vers calage au relâchement ; calage vers repos à l’époque ancrée la plus proche. Repos vers pilotage automatique quand un parcours impose une époque. Le contact de la poignée l’emporte sur le pilotage automatique (DEC-07).

## Composition
- `epoque_courante` (1), `dates_courantes` (1) : COMP-LIBELLE-TEXTE. Les 10 époques viennent des fichiers `content/epoques/*.yaml`, à valider par l’historienne (DEC-08).

## Tokens
TOK-MAP-SLIDER-VERS-AXES-CARTE, TOK-CHO-CALAGE-EPOQUE, TOK-CHO-PILOTAGE-AUTOMATIQUE-EPOQUE, TOK-TMP-THROTTLE-DRAG-SLIDER.

## Interactions natives
Pendant le glissé, la position interpolée (0 à 1) met à jour en continu le fond de carte. Au calage, l’époque finale est fixée et les pins sont rechargés. Quand un parcours est actif, le slider se positionne sur l’époque de l’étape courante, sans interdire le déplacement manuel.

## Remarque Figma
Aucun nœud référencé. Libellé d’époque long : troncature ou taille adaptée.
