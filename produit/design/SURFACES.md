---
id: DOC-DESIGN-SURFACES
type: document
titre: "Surfaces et modes de présentation"
statut: mvp
liens:
  decisions: [DEC-04, DEC-05, DEC-06]
  questions: [QO-101, QO-404, QO-809]
anciens_ids: []
sources:
  - conception/05-architecture-info.yaml:93
  - conception/05-architecture-info.yaml:259
  - conception/05-architecture-info.yaml:370
  - conception/05-architecture-info.yaml:428
  - conception/05-architecture-info.yaml:496
  - conception/05-architecture-info.yaml:543
derniere_verif: 2026-10-24
---

# Surfaces et modes

Ce document n’était pas dans la liste de départ de `design/` : il y est ajouté pour donner un foyer aux neuf modes de présentation (MOD-M1 à MOD-M9), aux trois sections (SRF-S1 à SRF-S3) et aux trois surfaces persistantes (SRF-P1 à SRF-P3), cités par les fiches d’écran et par MOUVEMENT.md.

Vocabulaire : « aperçu rapide » (et non « bottom sheet »), « surface ponctuelle », « dialogue de confirmation », « message éphémère », « sélecteur de section principale ».

## Navigation
Trois sections au même niveau, choisies dans un sélecteur : **Carte**, **Parcours**, **Profil**. La Carte est l’accueil. Chaque section ouvre des sous-surfaces (aperçu, consultation, surface ponctuelle). Les surfaces persistantes flottent au-dessus.
R1. Le retour ramène d’un seul geste au niveau immédiatement supérieur.
R2. Passer d’une section à l’autre est un saut latéral : chaque section garde l’état de sa pile.
R3. Une consultation approfondie ouverte depuis un aperçu revient sur cet aperçu, pas sur la surface principale ; ouverte directement, elle revient à la section d’origine.
R4. Une surface ponctuelle sans action explicite se ferme proprement (annulation implicite), la surface appelante reste intacte.
R5. Un dialogue de confirmation est strictement bloquant ; au plus un à la fois.
R6. L’app en arrière-plan préserve tout son état et le retrouve à l’identique.
R7. Un message éphémère ne déplace ni la pile ni la surface courante ; plusieurs messages se remplacent en file simple.
R8. L’aperçu rapide n’efface pas la surface principale derrière ; la consultation approfondie la cache temporairement.
R9. Au premier lancement, l’app arrive directement sur la Carte, sans écran d’accueil ni demande de permission (DEC-05, DEC-06).

## Modes de présentation

## MOD-M1 — Surface principale
Vue par défaut d’une section. Les sous-surfaces y ramènent ; quitter la section la met en sommeil sans la fermer. MVP : oui.

## MOD-M2 — Aperçu rapide
Consultation courte d’un objet qui laisse la surface principale visible derrière ; un geste neutre le ferme ; il peut proposer d’approfondir. MVP : aperçu d’un pin sur la carte (ECR-CARTE-APERCU-PIN).

## MOD-M3 — Consultation approfondie
Vue dédiée à un objet, qui cache la surface principale. On y entre depuis un aperçu ou directement. MVP : consultation d’un pin (ECR-PIN-CONSULTATION-APPROFONDIE), fiche d’un parcours, vue 3D (ECR-PIN-CONSULTATION-3D).

## MOD-M4 — Mode présentation
Consultation sans aucun élément d’interface, pour la projection. Hors MVP : la consultation approfondie le reporte (QO-101).

## MOD-M5 — Surface persistante de progression
Petite surface toujours visible (hors mode présentation) qui rappelle un état en cours et y ramène d’un tap. Au plus une par catégorie d’état. MVP : parcours en cours seulement (SRF-P2).

## MOD-M6 — Surface ponctuelle
Traite une intention courte puis disparaît, sans laisser de trace dans la pile. MVP : lancement d’un parcours et saut d’étape ; recherche et filtres sont hors MVP.

## MOD-M7 — Alerte ponctuelle
Signal entrant transitoire de proximité ou d’arrivée à une étape. Hors MVP : pas de géolocalisation ni de proximité (DEC-05, DEC-06).

## MOD-M8 — Dialogue de confirmation
Surface bloquante qui demande une décision sur un acte sensible, avec au moins deux issues. À utiliser avec parcimonie. MVP : confirmation d’abandon d’un parcours (ECR-TRANSVERSES-DIALOGUE-CONFIRMATION).

## MOD-M9 — Message éphémère
Retour non bloquant qui disparaît seul après un court délai (TOK-TMP-AUTO-DISMISS-M9). MVP : oui (ECR-TRANSVERSES-MESSAGE-EPHEMERE). Pas d’usage promotionnel ou décoratif.

## Sections

## SRF-S1 — Carte
Section d’accueil : carte temporelle, slider d’époques, pins. Sous-surfaces : aperçu d’un pin (MOD-M2), consultation (MOD-M3). La recherche et les couches (MOD-M6) sont hors MVP. Entrée : lancement de l’app ou tap sur la section. Écran principal : ECR-CARTE-PRINCIPALE.

## SRF-S2 — Parcours
Tout ce qui concerne les parcours. MVP : choisir un parcours, voir sa fiche (MOD-M3), le lancer. Catalogue communautaire, parcours personnels, création, filtres sont hors MVP (DEC-04). Écrans : ECR-PARCOURS-FICHE-DETAIL.

## SRF-S3 — Profil
Section de mémoire et de paramètres de l’utilisateur (favoris, historique, paramètres, compte). Sa place au MVP est ouverte : QO-809.

## Surfaces persistantes

## SRF-P1 — Lecture audio persistante
Rappel d’une narration audio en cours. Hors MVP (audio reporté).

## SRF-P2 — Parcours en cours
Apparaît au lancement d’un parcours quand on quitte la fiche ; rappelle le parcours et l’étape courante avec un indicateur de progression ; un tap ramène à la consultation de l’étape courante. La fermer abandonne le parcours, après un dialogue de confirmation. Disparaît à la fin du parcours, à l’abandon, ou au changement de parcours.

## SRF-P3 — Bandeau d’information persistant
Information contextuelle persistante, par exemple le mode hors ligne ; un seul à la fois, visible sur toutes les sections ; disparaît quand la condition cesse. MVP : bandeau hors ligne (ECR-TRANSVERSES-BANDEAU-OFFLINE), son déclencheur est ouvert (QO-404).

## Coexistence
- Les trois surfaces persistantes se superposent sans bloquer la navigation ; deux persistantes (audio et parcours) peuvent coexister, ce qui ne concerne le MVP que pour le parcours.
- Le mode présentation met en sommeil toutes les persistantes : hors MVP.
- Les alertes ponctuelles ne bloquent jamais : hors MVP.

## Hors MVP
Entrées externes (lien universel reçu, notification système) : aucune au MVP, il n’y a ni partage ni notification (DEC-04, DEC-05).
