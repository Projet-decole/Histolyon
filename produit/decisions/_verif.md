---
id: DOC-VERIF
type: document
titre: "Contre-vérification indépendante (échantillon)"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

# Rapport de vérification indépendante (échantillon lot 1)

Gravité : H haute, M moyenne, B basse. Toutes les lignes `sources:` de frontmatter vérifiées sont correctes, sauf mention.

## Unité CAP-D1.2
- Contradiction (M) : R11 et CF reprennent « Glissez pour traverser les époques. » (aussi FLX-A1, ECR-CARTE-PRINCIPALE) alors que QO-CONTENU (a) dit l’avoir « écarté par prudence » (onboarding neutralisé).
- Invention (B) : R5 « Aucun repli à fréquence réduite n’est prévu au MVP » est une simple proposition de question ouverte (05-comportements-temporels-purs.yaml:139) ; ce fichier n’est pas dans `sources`.
- Omissions : aucune (règles :177-181 et DoD :202-206 toutes tracées dans `_tri-D1`).

## Unité CAP-D2.4
- Contradiction interne (M) : R9 définit un message « Ce pin n’est plus disponible… » alors que ECR-CARTE-APERCU-PIN déclare « pin retiré : sans objet » ; R3 exige « une image » alors que l’écran la rend optionnelle (QO-104) et `liens.questions: []` l’ignore.
- Source manquante (B) : « titre sans préfixe » vient de microcopy:185, non listé.
- Omissions : « Pas de scroll long » repris (R4) mais absent du `_tri-D2` (B). Rien d’autre.

## Unité CAP-D3.5
- Erreur de lien (M) : `invariants: INV-08` (multi-époques). Le flux source C5 déclare `invariants_respectes: [I9]` donc INV-09 (aussi FLX-C5).
- Source (B) : R6 « Étape précédente » provient de microcopy:500 / 03-parcours.yaml:555 (canapé), non cités. R9 (introduction d’étape) sans source citée.
- Omissions : aucune ; DoD :490-498 tracés dans `_tri-D3`. Écart d’ordre « vue à l’ouverture » documenté.

## Unité CAP-D3.9
- Source manquante (M) : R7 (tap sur une étape) et la mention « Parcours achevé » (R3) viennent de 07-ecrans/parcours/08-fin-celebration.yaml et microcopy:517, absents de `sources`.
- Omission (B) : cas « parcours retiré entre-temps, message éphémère » (flux C9) ni repris ni rejeté dans `_tri-D3`. Le « partiellement achevé » de la source est transformé en « mention adaptée (QO-304) » ; tension avec CF5 « aucune mention d’incomplétude ».
- Inventions : aucune.

## Unité CAP-D8.1
- Invention (M) : règle d’apparition (3) « son fichier est disponible dans l’app » et cas « fichier manquant traité comme absent » ; DEC-50 dit seulement « publié, avec au moins une source ».
- Invention (B) : R4 « ouvrir la 3D ne fait pas avancer le parcours » (la source 3D parle de « progression n’a pas avancé » dans l’écran 3D, pas dans D8.1).
- Omissions : aucune (:97-101 et :122-126 tracés).

## Unité CAP-D2.6
- Lien (B) : INV-04 (pin sans source ne devient pas valide) cité pour « citation sans source non affichée » ; l’invariant ne dit pas cela (la règle vient de « pas de contenu sans source visible »).
- Invention (B) : « Encart long : sans défilement interne ».
- Omissions : texte alternatif / alternatives non gestuelles rejetés avec DEC-03 mais non listés (B). Sinon `_tri-D2` complet.

## Unité ECR-CARTE-APERCU-PIN
- Erreurs (M) : `liens.capacites: [CAP-D1.1]` alors que l’unité est CAP-D2.4 ; « ouvre la consultation approfondie (CAP-D2.4) » devrait être CAP-D2.5 (deux occurrences). Époque en COMP-LIBELLE-TEXTE alors que CAP-D2.4 liste COMP-CHIP-EPOQUE.
- Omission (M) : signal « Ce lieu n’est pas dans votre parcours » (R7 de la capacité) absent ; focus/lecteur d’écran absents.
## Unité ECR-PARCOURS-FIN-CELEBRATION
- Omissions (B) : lecture intégrale au lecteur d’écran, animation TOK-CHO-FIN-PARCOURS, réduction des animations absentes. Libellés corrects (microcopy:517). RAS sur les inventions.
## Unité ECR-PIN-CONSULTATION-3D
- Correct vis-à-vis de la source ; « Erreur de chargement » (état erreur) est un libellé non présent dans microcopy:387 (B, à signaler comme libellé proposé). Pas d’omission notable (AR et sélecteur rejetés par DEC-50).
## Unité COMP-SLIDER-EPOQUE
- RAS (sources 172 et 698 exactes, aucune invention).
## Unité COMP-PIN
- Inventions (B) : « Au MVP : éditorial seul (DEC-04) » et « vérification : absente au MVP » ; DEC-04 ne dit pas cela. « Règle R1 » est en réalité I3. Omission (B) : « accessible via recherche » (I9).
## Unité FLX-C5
- Erreur (M) : INV-08 au lieu d’INV-09. « Étape précédente » non sourcé (B). Source unique ; le pilotage slider relève de la chorégraphie :369.
## Unité ENT-ETAPE
- Conforme au SQL (table `etape` ligne 238, colonnes et contrainte différée exactes). Omissions (B) : lien rompu si pin retiré, décalage des positions, restriction de l’introduction aux parcours éditoriaux/communautaires.

## Compte
13 unités examinées. Hautes : 0. Moyennes : 8 (D1.2 R11, D2.4 R9/image, D3.5 INV, D3.9 sources, D8.1 fichier, ECR-APERCU x2, FLX-C5 INV). Basses : environ 17. Omissions réelles de règles/DoD : 0 sur D1.2, D2.4, D3.5, D3.9, D8.1, D2.6 (tri exhaustif). Aucune contradiction avec DEC-01…15 constatée.
