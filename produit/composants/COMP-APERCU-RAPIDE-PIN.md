---
id: COMP-APERCU-RAPIDE-PIN
type: composant
titre: "Aperçu rapide d’un pin"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  composants: [COMP-CHIP-CATEGORIE, COMP-LIBELLE-TEXTE, COMP-IMAGE-AVATAR-SMALL, COMP-BUTTON-PRIMARY, COMP-BACKDROP]
  ecrans: [ECR-CARTE-APERCU-PIN]
  decisions: [DEC-03]
anciens_ids: [comp-apercu-rapide-pin]
sources:
  - conception/10-composants/04-shell.yaml:132
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Fiche d’aperçu d’un pin posée sur la carte, qui reste visible derrière. Réversible d'un geste neutre. Propose de passer à la consultation approfondie. Intention close.

## Variantes et états
États : visible, fermé. Vignette absente : mise en page sans image. Teaser long : ellipse.

## Composition
- `categorie` (1) : COMP-CHIP-CATEGORIE.
- `titre` (1), `teaser` (1) : COMP-LIBELLE-TEXTE.
- `vignette` (0..1) : COMP-IMAGE-AVATAR-SMALL.
- `cta_approfondir` (1) : COMP-BUTTON-PRIMARY.
- Voile : COMP-BACKDROP, posé derrière par l’écran.

## Tokens
Rayon TOK-RADIUS-LG, ombre TOK-SHADOW-MD, titre TOK-TYPO-DISPLAY-MD, teaser TOK-TYPO-BODY-MD.

## Interactions natives
Tap sur le bouton : ouvre la consultation approfondie. Tap hors de la fiche : ferme l’aperçu (retour à la carte). Reste au-dessus de la surface persistante de parcours sans la masquer.

## Hors MVP
Hors MVP : neutralisé : comp-controle-favori, comp-controle-partage, signalement (favori, partage, signalement ; contenu éditorial seul au MVP).

## Remarque Figma
Aucun nœud référencé.
