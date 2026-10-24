---
id: DOC-QO-COMP
type: document
titre: "Questions ouvertes (groupe COMP)"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

## QO-501 — Tokens non documentés pour certains composants
Les fichiers de tokens ne précisent ni fond du bouton secondaire, ni couleur du lien, ni typographie du titre d’en-tête, ni famille de la citation. Pourquoi bloquant : le design ne peut pas être monté sans choix. Unités : COMP-BUTTON-SECONDARY, COMP-LIEN-TEXTE, COMP-HEADER-RETOUR-TITRE, COMP-CITATION. Source : `conception/12-tokens/02-typographies.yaml:85`.

## QO-502 — Bouton retour avec libellé visible
Faut-il une variante avec libellé pour l’accessibilité ? Unité : COMP-BUTTON-BACK. Source : `conception/10-composants/01-atomes.yaml:187`.

## QO-503 — Seuil d’abréviation des compteurs
Seuil au-delà duquel un nombre est abrégé (par exemple « 5+ »). Unités : COMP-BADGE-NOMBRE, COMP-CLUSTER-DENSITE. Source : `conception/10-composants/01-atomes.yaml:426`.

## QO-504 — Usage du tag générique
Aucun composant parent n’est déclaré : où apparaît-il au MVP ? Unité : COMP-TAG. Source : `conception/10-composants/01-atomes.yaml:912`.

## QO-505 — Fusion du tag de catégorie et du chip de catégorie
La source envisage la fusion si la redondance est confirmée. Unités : COMP-TAG-CATEGORIE, COMP-CHIP-CATEGORIE. Source : `conception/10-composants/01-atomes.yaml:960`.

## QO-506 — Garder le statut « en vérification » dans la tranche
Le contenu étant éditorial (DEC-04), le composant n’apparaît jamais. Unité : COMP-STATUS-PIN-VERIFICATION. Source : `conception/10-composants/01-atomes.yaml:982`.

## QO-507 — Action de l’en-tête de consultation
Toutes les actions citées (favori, partage, signalement, mode présentation) sont écartées : quelle action reste, ou faut-il l’en-tête sans action ? Unités : COMP-HEADER-RETOUR-TITRE-ACTION, COMP-LAYOUT-CONSULTATION-PIN-APPROFONDIE. Source : `conception/10-composants/02-molecules.yaml:94`.

## QO-508 — Zone des sources repliable
Seuil et comportement de repli. Unité : COMP-ZONE-SOURCES. Source : `conception/10-composants/04-shell.yaml:938`.

## QO-509 — Couleur de l’avertissement
Aucun token fonctionnel « avertissement » (le package a succès, erreur, info). Unités : COMP-ENCART-INFORMATION, COMP-MESSAGE-EPHEMERE. Source : `packages/design_tokens/lib/src/colors.dart:1`.

## QO-510 — Doublon entre bloc récapitulatif et zone des sources
Deux composants pour les mêmes sources. Unités : COMP-BLOC-SOURCES, COMP-ZONE-SOURCES. Source : `conception/10-composants/02-molecules.yaml:652`.

## QO-511 — Tap sur la section active
Sans effet ou retour en haut ? Unité : COMP-SELECTEUR-SECTION-PRINCIPALE. Source : `conception/10-composants/04-shell.yaml:129`.

## QO-512 — Voile d’arrière-plan : tokens d’opacité ou peinture directe
La source shell dit que l’opacité du voile n’est pas un token (0,4 ; 0,28 ; 0,05 selon le type), alors que `TOK_OPACITY_BACKDROP_M6` (0,4) et `TOK_OPACITY_BACKDROP_M8` (0,65) existent dans `packages/design_tokens`. DEC-12 donne l’autorité au package. Unité : COMP-BACKDROP. Source : `conception/10-composants/04-shell.yaml:622`.

## QO-513 — Layouts : type COMP ou fiche d’écran
Voir DEC-60. Unités : COMP-LAYOUT-CARTE-PRINCIPALE, COMP-LAYOUT-CONSULTATION-PIN-APPROFONDIE. Source : `conception/10-composants/04-shell.yaml:44`.

## QO-514 — Composant « comp-liste-simple »
Cité par le séparateur sans définition ; probablement l’item de liste simple. Voir DEC-62. Source : `conception/10-composants/01-atomes.yaml:737`.
