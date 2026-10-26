---
id: DEC-12
type: decision
titre: "Tokens : packages/design_tokens est la référence"
statut: mvp
liens: {}
anciens_ids: []
sources:
  - brief:lot1
derniere_verif: 2026-10-24
---

## Décision
Après vérification dans Figma, `packages/design_tokens` fait référence pour les valeurs (couleurs, typographies, espacements, rayons, ombres). `produit/design/TOKENS.md` ne porte que les règles.

## Pourquoi
Une seule source de valeurs, déjà utilisée par le code et vérifiée par `tools/check_tokens.dart`.

## Conséquences
Ne pas modifier le package depuis `produit/`. Un écart constaté s’écrit comme question ouverte.

## Mise à jour du 26/10/2026
La vérification dans Figma est faite pour les variables (34 tokens, aucun écart) : voir DEC-100. Les styles de texte et les ombres restent à vérifier à l’occasion d’un export des styles.
