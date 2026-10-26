---
id: COMP-CLUSTER-DENSITE
type: composant
titre: "Cluster de densité"
statut: mvp
priorite: important
jalon: JAL-FU2
liens:
  composants: [COMP-LIBELLE-TEXTE]
  ecrans: [ECR-CARTE-PRINCIPALE]
  decisions: [DEC-02]
anciens_ids: [comp-cluster-densite]
sources:
  - conception/10-composants/03-fonctionnels.yaml:201
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Regroupe visuellement des pins quand leur densité est élevée à un niveau de zoom donné. Hérite des registres du pin. Intention close : un tap zoome toujours sur la zone.

## Variantes et états
- Provenance dominante : éditorial (au moins un pin éditorial) ou communautaire.
- Hétérogénéité temporelle : homogène, hétérogène (forme empilée). Avec une seule époque par pin (DEC-02), seule la forme homogène se présente.
- Contient une vérification : non, oui (contour distinctif). Inutile au MVP.
- États : défaut, pressé.

## Composition
- `compteur` (1) : COMP-LIBELLE-TEXTE, abrégé au-delà d’un seuil (seuil non fixé : QO-503).

## Tokens
Couleur héritée de COMP-PIN : TOK-COLOR-PIN-EDITORIAL. Contour TOK-COLOR-CONTOUR-VERIFICATION.

## Interactions natives
Tap : zoom sur la zone du cluster. Les clusters sont recalculés à chaque changement d’époque sélectionnée.

## Remarque Figma
Aucun nœud référencé.
