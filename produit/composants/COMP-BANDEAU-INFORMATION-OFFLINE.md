---
id: COMP-BANDEAU-INFORMATION-OFFLINE
type: composant
titre: "Bandeau hors-ligne"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-ICONE, COMP-LIBELLE-TEXTE]
  ecrans: [ECR-TRANSVERSES-BANDEAU-OFFLINE]
  decisions: [DEC-04]
anciens_ids: [comp-bandeau-information-offline]
sources:
  - conception/10-composants/04-shell.yaml:727
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Bandeau minimal et persistant qui signale le mode hors-ligne. Informatif, non interactif. Visible sur les sections principales quand la connexion réseau est absente. Le contenu étant embarqué (DEC-04), le bandeau ne sert qu’aux ressources distantes.

## Variantes et états
États : visible, masqué (mode présentation, absent de la tranche).

## Composition
- `icone_offline` (1) : COMP-ICONE.
- `message` (1) : COMP-LIBELLE-TEXTE.

## Tokens
Apparition et disparition TOK-CHO-APPARITION-P3 et TOK-CHO-DISPARITION-P3, TOK-MAP-MODE-OFFLINE-VERS-CARTE.

## Interactions natives
Aucune. Suit l’état de connexion réseau : visible hors-ligne. Coexiste avec la surface persistante du parcours.

## Remarque Figma
Aucun nœud référencé.
