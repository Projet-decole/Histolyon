---
id: COMP-LAYOUT-CARTE-PRINCIPALE
type: composant
titre: "Gabarit de la carte principale"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  composants: [COMP-CARTE, COMP-SELECTEUR-SECTION-PRINCIPALE, COMP-SURFACE-PERSISTANTE-PARCOURS, COMP-BANDEAU-INFORMATION-OFFLINE]
  ecrans: [ECR-CARTE-PRINCIPALE]
  decisions: [DEC-60]
anciens_ids: [comp-layout-carte-principale]
sources:
  - conception/10-composants/04-shell.yaml:752
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Patron des emplacements de l’écran Carte : carte plein écran, navigation, surfaces persistantes. Ce n’est pas un composant Figma (voir DEC-60) mais la spec des emplacements que l’écran doit respecter.

## Variantes et états
- Mode présentation : actif ou inactif (absent de la tranche).
- États : nominal.

## Composition
- `carte` (1) : COMP-CARTE.
- `nav` (1) : COMP-SELECTEUR-SECTION-PRINCIPALE.
- `persistent_p2` (0..1) : COMP-SURFACE-PERSISTANTE-PARCOURS, visible si un parcours est en cours.
- `persistent_p3` (0..1) : COMP-BANDEAU-INFORMATION-OFFLINE, visible hors-ligne.

## Tokens
Marge latérale TOK-SPACE-LG. Aucun autre token propre documenté.

## Interactions natives
Aucune propre. Les surfaces temporaires (aperçu rapide, dialogue, message éphémère) se posent au-dessus de la carte.

## Hors MVP
Hors MVP : neutralisé : comp-surface-persistante-audio (emplacement `persistent_p1`, audio), comp-surface-ponctuelle-recherche, comp-surface-ponctuelle-filtres-couches, comp-alerte-proximite, comp-invitation-microparcours, comp-indication-onboarding, comp-dialogue-permission, comp-indicateur-permission (hors tranche).

## Remarque Figma
La source dit « supprimés de Figma mais toujours définis » : voir DEC-60. Aucun nœud référencé. La hiérarchie des emplacements de la mini-barre et de la navigation est décidée par la fiche de l’écran.
