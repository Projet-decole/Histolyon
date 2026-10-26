---
id: DOC-QO-DESIGN
type: document
titre: "Questions ouvertes du groupe DESIGN"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

## QO-801 — Les trois fontes doivent-elles avoir une constante dans le package ?
Bloque : rien d’urgent, mais `TOK-FONT-TITRE-EDITORIAL`, `TOK-FONT-CORPS-NARRATIF` et `TOK-FONT-INTERFACE` n’existent que comme noms de famille écrits dans chaque style typographique. Unité : TOKENS.md. Sources : `conception/12-tokens/02-typographies.yaml:38`, `packages/design_tokens/lib/src/typography.dart:1`.

## QO-802 — Quel est le niveau de zoom initial de la carte ?
Bloque : l’état nominal de ECR-CARTE-PRINCIPALE (DEC-21 fixe seulement le centrage sur Bellecour). La conception ne donne que trois niveaux qualitatifs (large, intermédiaire, proche) et associe le niveau large au premier lancement. Unité : CARTE.md. Sources : `conception/09-cartographie/04-densite-zoom.yaml:20`, `conception/07-ecrans/carte/01-principale.yaml:100`.

## QO-803 — Quelle est l’emprise exacte du fichier de tuiles ?
Bloque : la limite de déplacement de la carte (CAP-D1.1) et la vérification que Bellecour y figure. Le document d’architecture note que l’emprise et la taille réelles (estimées à moins de 150 Mo) restent à mesurer. Unité : CARTE.md. Source : `docs/ARCHITECTURE-SPINE.md:336`.

## QO-804 — Qui calibre les ancres d’apparence de la carte, et quand ?
Bloque : le rendu final de CAP-D1.3. Les 50 valeurs (10 ancres, 5 axes) sont des cibles indicatives ; seule « Aujourd’hui » est définitive. La plage de positions entre 0,42 et 0,65 n’a pas de type de texture défini. Unités : MOUVEMENT.md (TOK-MAP-SLIDER-VERS-AXES-CARTE), CARTE.md. Source : `conception/11-reponse-parametrique/04-mappings-parametriques.yaml:60`.

## QO-805 — Quelle forme prend l’animation de fin de parcours ?
Bloque : l’état d’arrivée de ECR-PARCOURS-FIN-CELEBRATION. La source hésite entre confettis, expansion radiale et simple révélation du récapitulatif. Unité : MOUVEMENT.md (TOK-CHO-FIN-PARCOURS). Source : `conception/11-reponse-parametrique/03-chorégraphies.yaml:435`.

## QO-806 — Décélération ou ressort pour l’aperçu d’un pin et le calage du slider ?
Ne bloque pas : la valeur par défaut (décélération) est appliquée. La conception propose de réserver le ressort aux transitions matérielles et se demande si un dépassement distrait en projection. Unité : MOUVEMENT.md. Source : `conception/11-reponse-parametrique/01-durees-et-courbes.yaml:213`.

## QO-807 — Faut-il reconstruire le premier plan de l’icône Android ?
Bloque : la production de l’icône adaptative si la chaîne de construction exige deux couches. Le premier plan a été retiré de la maquette. Unité : MARQUE.md. Source : `conception/15-maquette.md:157`.

## QO-808 — Quelle est la borne de fin d’« Aujourd’hui » ?
Ne bloque pas : la valeur 2026 est l’année courante, provisoire, à rafraîchir (le schéma impose une fin). Même question pour la borne de début (2000). Unité : CARTE.md (EPQ-AUJOURDHUI). Source : `content/epoques/aujourdhui.yaml:1`.

## QO-809 — Que montre la section Profil au MVP ?
Bloque : l’écran principal du profil et ICN-UI-SECTION-PROFIL. Le sélecteur de sections prévoit trois entrées, mais la feuille de route range « profil et compte » dans le second semestre. Unité : SURFACES.md (SRF-S3). Sources : `conception/05-architecture-info.yaml:335`, `produit/FEUILLE-DE-ROUTE.md`.

## QO-810 — Quelle frame Figma sert de référence au parcours en cours ?
Bloque : l’image de référence de l’écran du parcours en cours (DEC-10). La maquette a une frame « terrain » et une frame « canapé » ; le MVP n’a qu’un mode (DEC-05). Le bandeau hors ligne n’a pas de frame d’écran, seulement un composant. Unité : MAQUETTE.md. Source : `conception/15-maquette.md:209`.
