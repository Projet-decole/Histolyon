---
id: COMP-ICONE
type: composant
titre: "Icône"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  composants: []
  ecrans: [ECR-CARTE-PRINCIPALE, ECR-PIN-CONSULTATION-APPROFONDIE, ECR-PARCOURS-FICHE-DETAIL]
  decisions: [DEC-11]
anciens_ids: [comp-icone]
sources:
  - conception/10-composants/01-atomes.yaml:650
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Symbole fonctionnel présent dans presque tous les composants (boutons, chips, badges, en-têtes). Pure présentation : l’interactivité est portée par le composant englobant.

## Variantes et états
- Type : catégorie, action, état, statut, navigation.
- Taille : très petite, petite, standard, grande.
- Icône manquante : icône générique de repli. Tracé adapté à la taille.

## Composition
Aucun sous-composant. Le jeu d’icônes vient de Lucide plus deux icônes personnalisées (DEC-11), identifiées par des identifiants d’icône (catégories et interface).

## Tokens
Couleur héritée du composant englobant. Aucun token propre.

## Interactions natives
Aucune.

## Remarque Figma
Aucun nœud référencé.
