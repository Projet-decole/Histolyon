---
id: ECR-CARTE-PRINCIPALE
type: ecran
titre: "Carte d’accueil"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  capacites: [CAP-D1.1, CAP-D1.2, CAP-D1.3]
  flux: [FLX-A1, FLX-A3]
  composants: [COMP-LAYOUT-CARTE-PRINCIPALE, COMP-CARTE, COMP-SLIDER-EPOQUE, COMP-PIN, COMP-CLUSTER-DENSITE, COMP-SELECTEUR-SECTION-PRINCIPALE]
  entites: [ENT-PIN, ENT-EPOQUE]
  decisions: [DEC-04, DEC-06, DEC-07, DEC-21]
  questions: [QO-105]
anciens_ids: [E-CARTE-PRINCIPALE]
sources:
  - conception/07-ecrans/carte/01-principale.yaml:14
  - conception/08-contenu/04-microcopy-grand-public.yaml:306
images: []
budget_tokens: 2000
derniere_verif: 2026-10-24
---

## Rôle
Écran d’accueil et surface centrale : carte de Lyon, slider d’époques, pins de l’époque. La personne y revient après chaque consultation.

## Composition
De haut en bas, dans la coquille à trois sections (COMP-LAYOUT-CARTE-PRINCIPALE) :
- **Vue cartographique** (COMP-CARTE) : fond de carte, pins (COMP-PIN, regroupés par COMP-CLUSTER-DENSITE), attribution OpenStreetMap/Protomaps toujours visible.
- **Slider d’époques** (COMP-SLIDER-EPOQUE) : sélection d’une des 10 époques (CAP-D1.2).
- **Sélecteur de section** (COMP-SELECTEUR-SECTION-PRINCIPALE) : Carte, Parcours, Profil.

## États
- **nominal** — quand : la carte est chargée ; on voit : pins de l’époque calée, slider positionné sur l’époque par défaut (QO-105).
- **chargement** — quand : tuiles en cours de dessin ; on voit : le fond se remplit, slider et sélecteur déjà utilisables.
- **vide à l’époque** — quand : aucun pin pour l’époque ; on voit : le message d’invitation, la carte reste manipulable.
- **premier lancement** — quand : première ouverture ; on voit : la carte immédiatement, sans tutoriel, avec l’indication sur le slider (FLX-A1).
- **parcours en cours** — quand : un parcours est actif ; on voit : le slider positionné sur l’époque de l’étape, que la personne peut déplacer (DEC-07).

## Interactions
- Déplacement et zoom → la carte se recadre dans l’emprise (CAP-D1.1).
- Glissement du slider → apparence de la carte évolue ; relâche : calage, pins de l’époque (FLX-A3).
- Tap sur un pin → ECR-CARTE-APERCU-PIN.
- Tap sur Parcours ou Profil dans le sélecteur → autre section.

## Libellés de l’écran
- Titre de section : « Carte »
- Indication du premier passage : « Glissez pour traverser les époques. »
- Accueil discret au premier lancement (voix du récit, DEC-14) : « Lyon. Tu peux remonter le temps, ici, là où tu marches. »
- Vide à l’époque : « Aucun pin à cette époque dans cette zone. Élargissez la vue ou changez d’époque. »
- Chargement : « Chargement »

## Hors MVP
- Points d’accès recherche, couches, Surprenez-moi, localisation, et leurs écrans (carte/03-recherche, carte/04-filtres-couches, carte/05-alerte-proximité) : CAP-D1.4, CAP-D1.5, CAP-D4.2, DEC-05, DEC-06.
- États hors-ligne avec ou sans cache, bandeau hors-ligne : sans objet, le contenu est embarqué (DEC-04).
- État permission de localisation refusée (DEC-06).
- État audio en cours (audio hors MVP).
- État mode présentation : en attente de QO-101.
- Invitation au micro-parcours : onboarding hors MVP.
- Message « hors zone Lyon » : sans localisation (DEC-06).
