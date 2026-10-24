---
id: ECR-PARCOURS-EN-COURS-TERRAIN
type: ecran
titre: "Parcours en cours (pas à pas)"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  capacites: [CAP-D3.5, CAP-D3.4, CAP-D1.2]
  flux: [FLX-C5, FLX-E3, FLX-C8]
  composants: [COMP-INFO-PROGRESS-ETAPE, COMP-ITEM-LISTE-ETAPE, COMP-BUTTON-PRIMARY, COMP-BUTTON-SECONDARY, COMP-BUTTON-TERTIARY, COMP-DIALOGUE-CONFIRMATION]
  entites: [ENT-PARCOURS, ENT-ETAPE, ENT-HISTORIQUE-DE-VISITE]
  decisions: [DEC-05, DEC-07, DEC-09, DEC-40]
anciens_ids: [E-PARCOURS-EN-COURS-TERRAIN]
sources:
  - conception/07-ecrans/parcours/05-en-cours-terrain.yaml:16
  - conception/07-ecrans/parcours/07-saut-etape.yaml:16
  - conception/08-contenu/04-microcopy-grand-public.yaml:476
images: []
budget_tokens: 2000
derniere_verif: 2026-10-24
---

## Rôle
Montre où l’on en est dans le parcours et donne les contrôles du pas à pas manuel (CAP-D3.5). L’id garde « TERRAIN » pour la traçabilité : il n’y a ni géolocalisation ni proximité (DEC-05). Le tracé et les pins se voient sur la carte, qui reste navigable.

## Composition
De haut en bas :
1. **En-tête** : titre du parcours.
2. **Progression** (COMP-INFO-PROGRESS-ETAPE) : « Étape n sur Y ».
3. **Étape courante** : titre du pin, position, introduction d’étape si elle existe ; un tap ouvre la consultation approfondie.
4. **Navigation manuelle** : « Étape précédente » (COMP-BUTTON-SECONDARY), « Étape suivante » (COMP-BUTTON-PRIMARY), « Sauter cette étape » (COMP-BUTTON-TERTIARY).
5. **Liste des étapes** (COMP-ITEM-LISTE-ETAPE) : quatre états, vue, courante, à venir, sautée ; un tap rend l’étape courante.
6. **Abandonner** (COMP-BUTTON-TERTIARY), avec dialogue de confirmation (COMP-DIALOGUE-CONFIRMATION).

## États
- **nominal** — quand : parcours en cours ; on voit : étape courante, progression, liste.
- **dernière étape** — quand : étape Y ; on voit : l’ouvrir ou la sauter déclenche la fin (ECR-PARCOURS-FIN-CELEBRATION).
- **fin** — quand : dernière étape vue ou sautée ; on voit : bascule vers la célébration, la surface persistante disparaît.

## Interactions
- Tap sur l’étape courante ou sur une étape de la liste → consultation approfondie du pin ; l’étape est marquée vue dès l’ouverture (FLX-E3). Le retour amène l’étape suivante comme courante.
- « Étape suivante » / « Étape précédente » → change l’étape courante ; le slider se positionne sur son époque (DEC-07).
- « Sauter cette étape » → étape non complétée, passage à la suivante, sans confirmation (FLX-C8, DEC-40, DEC-09).
- « Abandonner » → dialogue ; si confirmé, parcours abandonné et retour à la fiche.

## Libellés de l’écran
« Étape {n} sur {total} », « Étape suivante », « Étape précédente », « Sauter cette étape », « Abandonner ». Dialogue : « Abandonner ce parcours ? » (description à adapter, QO-304).

## Hors MVP
- Géolocalisation, position, alerte et indication de proximité (DEC-05).
- Mode canapé (E-PARCOURS-EN-COURS-CANAPE) et bascule terrain/canapé.
- Pause, déviation, durée écoulée, hors-ligne (CAP-D3.10, DEC-04).
- Sélecteur de saut E-PARCOURS-SAUT-ETAPE (DEC-40).
- Audio persistant, mode présentation.
