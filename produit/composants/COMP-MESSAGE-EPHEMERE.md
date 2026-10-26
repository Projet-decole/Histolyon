---
id: COMP-MESSAGE-EPHEMERE
type: composant
titre: "Message éphémère"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-ICONE, COMP-LIBELLE-TEXTE, COMP-BUTTON-TERTIARY]
  ecrans: [ECR-TRANSVERSES-MESSAGE-EPHEMERE]
  decisions: []
anciens_ids: [comp-message-ephemere]
sources:
  - conception/10-composants/04-shell.yaml:467
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Confirmation transitoire non bloquante d’une action, ou signal léger. Disparaît seul après un délai. Pas d’usage promotionnel ni décoratif.

## Variantes et états
- Type : succès, erreur, information, avertissement (couleur et icône).
- États : émis, expiré, fermé par glissement latéral, remplacé par un message suivant.
- File simple : un message en cours cède la place au suivant.

## Composition
- `icone` (0..1) : COMP-ICONE.
- `message` (1) : COMP-LIBELLE-TEXTE.
- `action` (0..1) : COMP-BUTTON-TERTIARY, par exemple « Annuler ».

## Tokens
Ombre TOK-SHADOW-SM, délai TOK-TMP-AUTO-DISMISS-M9, apparition et disparition TOK-CHO-OUVERTURE-M9 et TOK-CHO-DISMISS-M9.

## Interactions natives
Disparition après délai ; glissement latéral : fermeture anticipée ; tap sur l’action : le parent câble. Peut surgir sur toute surface.

## Remarque Figma
Aucun nœud référencé.
