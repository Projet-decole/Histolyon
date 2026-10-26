---
id: COMP-BUTTON-FERMETURE-OVERLAY
type: composant
titre: "Bouton de fermeture d’overlay"
statut: mvp
priorite: important
jalon: JAL-FU2
liens:
  composants: [COMP-ICONE]
  ecrans: [ECR-CARTE-APERCU-PIN]
  decisions: [DEC-05]
anciens_ids: [comp-button-fermeture-overlay]
sources:
  - conception/10-composants/01-atomes.yaml:190
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Renoncer à une surface ponctuelle en la fermant sur place. Sémantique distincte du retour : il ne remonte pas la pile de navigation. Intention close.

## Variantes et états
États : défaut, pressé, désactivé, focus clavier. Pas de texte variable.

## Composition
- `icone` (1) : COMP-ICONE, icône de fermeture.

## Tokens
Aucun token propre documenté. Cible tactile généreuse, comme pour tout bouton icône seule.

## Interactions natives
Tap : ferme la surface. Si l’overlay accepte aussi le tap hors de la surface, ce bouton en est l’équivalent explicite (accessibilité, clarté).

## Hors MVP
Hors MVP : neutralisé : comp-recherche-surface, comp-filtres-couches (surfaces de recherche et de couches, hors tranche) ; comp-alerte-proximite (DEC-05).

## Remarque Figma
Aucun nœud référencé.
