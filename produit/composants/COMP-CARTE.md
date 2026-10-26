---
id: COMP-CARTE
type: composant
titre: "Carte"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  composants: [COMP-PIN, COMP-CLUSTER-DENSITE, COMP-TRACE-PARCOURS, COMP-SLIDER-EPOQUE]
  ecrans: [ECR-CARTE-PRINCIPALE]
  decisions: [DEC-04, DEC-06, DEC-07]
  capacites: [CAP-D1.1]
anciens_ids: [comp-carte]
sources:
  - conception/10-composants/03-fonctionnels.yaml:139
  - conception/10-composants/03-fonctionnels.yaml:710
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Affichage cartographique dont le fond s’interpole selon l’époque, avec pins, clusters et tracé du parcours actif. Le slider d’époque est intégré.

## Variantes et états
- Niveau de zoom : large, intermédiaire, proche (regroupement des pins selon le zoom).
- Mode hors-ligne : nominal, hors-ligne avec tuiles, hors-ligne sans tuiles. Au MVP les tuiles sont embarquées (DEC-04, DEC-06) : le mode hors-ligne sans tuiles n’est qu’un cas d’erreur.
- États : repos, déplacement, zoom, chargement de tuiles, pin sélectionné. Le curseur de position de la source est hors MVP (DEC-06).

## Composition
- `pins` (0..n) : COMP-PIN. `clusters` (0..n) : COMP-CLUSTER-DENSITE.
- `trace_actif` (0..1) : COMP-TRACE-PARCOURS.
- `navigateur_temporel` (1) : COMP-SLIDER-EPOQUE.

## Tokens
TOK-MAP-SLIDER-VERS-AXES-CARTE (fond interpolé par époque), TOK-MAP-MODE-OFFLINE-VERS-CARTE, TOK-TMP-THROTTLE-PAN-ZOOM-CARTE.

## Interactions natives
Glisser : recadrer. Pincer : zoomer. Tap pin : signal « pin sélectionné » au parent (aperçu rapide). Tap cluster : zoom sur la zone. Aucun pin à l’époque : état vide gracieux. La carte lit l’époque sélectionnée (interpolation continue) et le parcours en cours (tracé, étape en relief).

## Hors MVP
Hors MVP : neutralisé : curseur de géolocalisation (DEC-06) ; comp-indicateur-permission (permission).

## Remarque Figma
Aucun nœud référencé. L’emprise de la carte est celle des tuiles embarquées (DEC-06).
