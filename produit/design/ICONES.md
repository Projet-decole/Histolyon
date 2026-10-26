---
id: DOC-DESIGN-ICONES
type: document
titre: "Icônes : table identifiant, nom Lucide, écrans"
statut: mvp
liens:
  decisions: [DEC-11, DEC-80]
  questions: [QO-809]
anciens_ids: [ICON-CAT-CLASSIQUE, ICON-CAT-ANECDOTE, ICON-CAT-MUSEE-INSTITUTION, ICON-CAT-PERSONNE, ICON-CAT-EVENEMENT, ICON-CAT-LIEU-DISPARU, ICON-CAT-VIE-QUOTIDIENNE, ICON-CAT-ARCHITECTURE, ICON-CAT-NATURE-GEOGRAPHIE, ICON-CAT-PATRIMOINE-VIVANT, ICON-CAT-GASTRONOMIE, ICON-UI-RETOUR, ICON-UI-FERMETURE, ICON-UI-LIEU, ICON-UI-CALENDRIER, ICON-UI-SUCCES, ICON-UI-ERREUR, ICON-UI-INFO, ICON-UI-CHARGEMENT, ICON-UI-OFFLINE, ICON-UI-SECTION-CARTE, ICON-UI-SECTION-PARCOURS, ICON-UI-SECTION-PROFIL, ICON-UI-LIEN-EXTERNE, ICON-UI-DUREE, ICON-UI-DISTANCE, ICON-UI-ETAPES, ICON-UI-CHECK]
sources:
  - conception/13-icones/02-icones-categories.yaml:46
  - conception/13-icones/03-icones-ui-fonctionnelles.yaml:30
  - conception/13-icones/01-charte-graphique.yaml:76
  - conception/13-icones/assets/MANIFEST.yaml:1
  - conception/15-maquette.md:121
derniere_verif: 2026-10-24
---

# Icônes

Source des icônes : bibliothèque Lucide (licence ISC), version épinglée `lucide-static@1.21.0`, plus deux icônes personnalisées (DEC-11, DEC-80). `MANIFEST.yaml` ne donne pas de correspondance Lucide : les noms viennent des fiches d’icône (champ `source`) et de la maquette.

## Export Figma des icônes (26/10/2026)
L’export contient 63 fichiers SVG qui sont des planches et non des icônes prêtes à l’emploi : chaque fichier fait 150 × 62, contient l’icône en 14 px et en 24 px, plus l’étiquette de son nom dessinée en contours, avec un trait de couleur écrit en dur (noir ou `#1C1108`). Ils ne servent qu’à la lecture. Ils ne sont pas versionnés, sauf les deux icônes personnalisées, nettoyées dans `produit/design/icones/` (tracé 24 px seul, grille 24 × 24, couleur héritée `currentColor`) : `ICN-CAT-ARCHITECTURE.svg` et `ICN-CAT-LIEU-DISPARU.svg`. Les 61 autres sont réputées venir de Lucide (DEC-11, d’après la maquette) ; ce n’est pas confirmé pour les 7 plus récentes ci-dessous.
L’export compte 7 icônes d’interface que ni la conception ni ce document ne décrivent : compte, image, impression, paramètres, case vide (bouton radio), visibilité et visibilité masquée. Elles sont hors MVP et restent à documenter si une fonction les demande.

## Règles
R1. Style monoline contour seul (pas de remplissage), grille 24×24, trait de 1,5, bouts arrondis, couleur héritée (`currentColor`). Pas d’autre bibliothèque mélangée.
R2. Tailles : 14 px (XS) pour l’icône à l’intérieur d’un pin sur la carte, 20 px (MD) dans les chips, 24 px (LG) pour l’interface. Seule la taille XS a un dessin dédié (trait de 2) pour les 11 icônes de catégorie.
R3. Couleur : dans un pin, `TOK-COLOR-BLANC-NARRATIF` ; dans un chip de catégorie, `TOK-COLOR-TEXTE-PRINCIPAL` ; icône d’interface par défaut `TOK-COLOR-TEXTE-PRINCIPAL`, `TOK-COLOR-TEXTE-TERTIAIRE` quand elle est inactive.
R4. La catégorie d’un pin se lit par son icône, jamais par une couleur (voir TOKENS.md).
R5. Un état de chargement est un squelette ; l’icône de chargement ne sert qu’à une micro-attente isolée.

## Catégories de pin (11)
Chaque icône existe en 24 px (aperçu, consultation) et en 14 px (pin sur la carte). Écrans : ECR-CARTE-PRINCIPALE (pin), ECR-CARTE-APERCU-PIN et ECR-PIN-CONSULTATION-APPROFONDIE (chip de catégorie).

## ICN-CAT-CLASSIQUE — Classique
Lucide `landmark` : monument à fronton et colonnes.

## ICN-CAT-ANECDOTE — Anecdote
Lucide `sparkles` : étincelles.

## ICN-CAT-MUSEE-INSTITUTION — Musée et institution
Lucide `building-2` : bâtiment urbain.

## ICN-CAT-PERSONNE — Personne
Lucide `user-round` : une vie singulière.

## ICN-CAT-EVENEMENT — Événement
Lucide `zap` : éclair.

## ICN-CAT-LIEU-DISPARU — Lieu disparu
**Personnalisée** : le monument de `landmark` barré d’une diagonale (`landmark-off` n’existe pas dans `lucide-static@1.21.0`). La version 14 px (trait de 2) est obligatoire : la diagonale porte le sens.

## ICN-CAT-VIE-QUOTIDIENNE — Vie quotidienne
Lucide `users` : pluralité de silhouettes (la même que la provenance communautaire, contextes disjoints).

## ICN-CAT-ARCHITECTURE — Architecture
**Personnalisée** : arche semi-circulaire sur deux pieds-droits, évoque les traboules (`archway` n’existe pas dans Lucide).

## ICN-CAT-NATURE-GEOGRAPHIE — Nature et géographie
Lucide `waves` : ondulations.

## ICN-CAT-PATRIMOINE-VIVANT — Patrimoine vivant
Lucide `heart-handshake`.

## ICN-CAT-GASTRONOMIE — Gastronomie
Lucide `utensils`.

## Interface utile au MVP

## ICN-UI-RETOUR — Retour
Lucide `arrow-left`. Bouton retour des écrans de consultation (ECR-PIN-CONSULTATION-APPROFONDIE, ECR-PIN-CONSULTATION-3D, ECR-PARCOURS-FICHE-DETAIL). Couleur `TOK-COLOR-TEXTE-PRINCIPAL`.

## ICN-UI-FERMETURE — Fermeture
Lucide `x`. Fermer une surface superposée ou retirer un filtre actif. Couleur `TOK-COLOR-TEXTE-PRINCIPAL`.

## ICN-UI-LIEU — Lieu
Lucide `map-pin`. Dans la source : icône d’un champ de saisie de lieu (formulaire de contribution, hors MVP), en gris sable au repos. À ne pas confondre avec le pin de la carte. Un écran MVP qui l’emploie pour afficher une adresse doit le dire dans sa fiche.

## ICN-UI-CALENDRIER — Calendrier
Lucide `calendar`. Dans la source : icône d’un champ de saisie de date (formulaire, hors MVP). Même remarque que `ICN-UI-LIEU`.

## ICN-UI-SUCCES — Succès
Lucide `circle-check`, couleur `TOK-COLOR-FONCTIONNEL-SUCCES`. Message de succès en ligne.

## ICN-UI-ERREUR — Erreur
Lucide `circle-alert`, couleur `TOK-COLOR-FONCTIONNEL-ERREUR`. Message d’erreur en ligne.

## ICN-UI-INFO — Information
Lucide `info`, couleur `TOK-COLOR-FONCTIONNEL-INFO`. Message éphémère d’information (ECR-TRANSVERSES-MESSAGE-EPHEMERE).

## ICN-UI-CHECK — Coche
Lucide `check`. Coche seule, sans cercle (à distinguer de `ICN-UI-SUCCES`) : état activé d’un interrupteur ou d’une case. Aucun écran MVP identifié ne l’emploie ; gardée pour un éventuel interrupteur.

## ICN-UI-CHARGEMENT — Chargement
Lucide `loader-circle`, couleur `TOK-COLOR-PRIMARY`. Micro-attente isolée, et version statique quand l’animation est réduite (R5).

## ICN-UI-OFFLINE — Hors ligne
Lucide `wifi-off`, couleur `TOK-COLOR-FONCTIONNEL-INFO` (un état documenté, pas une erreur). Bandeau d’information hors ligne (ECR-TRANSVERSES-BANDEAU-OFFLINE ; le déclencheur reste ouvert, voir QO-404).

## ICN-UI-SECTION-CARTE — Section Carte
Lucide `map`. Navigation à trois sections (SRF-S1) ; gris sable quand la section n’est pas active.

## ICN-UI-SECTION-PARCOURS — Section Parcours
Lucide `route`. Navigation (SRF-S2) ; gris sable quand inactive.

## ICN-UI-SECTION-PROFIL — Section Profil
Lucide `circle-user-round`. Navigation (SRF-S3) ; voir QO-809.

## ICN-UI-LIEN-EXTERNE — Lien externe
Lucide `external-link`, couleur `TOK-COLOR-FONCTIONNEL-INFO`. Petit signe à côté d’un lien texte qui ouvre une page hors de l’app.

## ICN-UI-DUREE — Durée
Lucide `clock`, couleur `TOK-COLOR-TEXTE-SECONDAIRE`. Durée d’un parcours (ECR-PARCOURS-FICHE-DETAIL).

## ICN-UI-DISTANCE — Distance
Lucide `route`, couleur `TOK-COLOR-TEXTE-SECONDAIRE`. Distance d’un parcours (même glyphe que `ICN-UI-SECTION-PARCOURS`, contextes disjoints).

## ICN-UI-ETAPES — Étapes
Lucide `milestone`, couleur `TOK-COLOR-TEXTE-SECONDAIRE`. Nombre d’étapes d’un parcours.

## Hors MVP
Tous les autres identifiants de l’inventaire, avec leur nom Lucide, restent à documenter ici quand leur fonction passe en MVP : lecture audio (`play`, `pause`), favori (`heart`), partage (`share`), signalement (`flag`), recherche (`search`), filtre (`sliders-horizontal`), couche cartographique (`layers`), création (`plus`), visibilité d’un mot de passe (`eye`, `eye-off`), caméra (`camera`), notification (`bell`), anonymat (`user-x`), provenance éditoriale (`badge-check`) et communautaire (`users`), vérification en cours (`clock`), mode surprise (`dice-5`), mode présentation (`monitor-play`), langue (`languages`), et les 10 icônes du back-office (`circle-check`, `circle-x`, `shield-check`, `book-open-check`, `circle-arrow-up`, `archive`, `archive-restore`, `layout-dashboard`, `list`, `eye`). Les 11 versions 14 px des catégories sont reportées dans la source (à produire à la validation visuelle).
