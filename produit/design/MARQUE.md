---
id: DOC-DESIGN-MARQUE
type: document
titre: "Marque : logo et icône d’application"
statut: mvp
liens:
  decisions: [DEC-12]
  questions: [QO-807]
anciens_ids: []
sources:
  - conception/14-surfaces-hors-app/07-marque-logo-et-app-icon.yaml:59
  - conception/14-surfaces-hors-app/07-marque-logo-et-app-icon.yaml:127
  - conception/14-surfaces-hors-app/07-marque-logo-et-app-icon.yaml:224
  - conception/15-maquette.md:157
derniere_verif: 2026-10-24
---

# Marque

Au MVP, seule l’**icône d’application** (Android, avec le code partagé prêt pour iOS) sert de surface de marque. Le logo en est la matière.

## Le logo
Composition du fond vers le premier plan : dégradé terracotta (`TOK-COLOR-PRIMARY` vers `TOK-COLOR-PRIMARY-FONCE`), silhouette claire de la skyline de Lyon (Fourvière), lion héraldique dressé qui tient un téléphone, mot-symbole « HistoLyon » (Playfair Display, ton conteur), signature « LYON IMMERSIVE » sous le mot-symbole (conservée, décision du porteur du 2026-05-08).
Trois déclinaisons : couleur (référence, la seule éditée à la main dans la maquette), monochrome encre sur parchemin (`TOK-COLOR-TEXTE-PRINCIPAL` sur `TOK-COLOR-FOND-PRINCIPAL`), monochrome parchemin sur encre (`TOK-COLOR-BLANC-NARRATIF` sur `TOK-COLOR-TEXTE-PRINCIPAL`).
R1. Espace de respiration minimal autour du logo : au moins la hauteur du mot-symbole.
R2. À petite taille, on garde la silhouette la plus reconnaissable (le lion) et on retire mot-symbole et signature.
R3. Pas de marketing de ville : le ton reste patrimonial et sobre.

## Icône d’application
R4. L’icône reprend la composition complète du logo en couleur, assez grande pour que chaque élément reste lisible.
R5. iOS : carré sans coins arrondis (le système arrondit), 1024 × 1024.
R6. Android : icône adaptative en deux couches, premier plan (logo, dans la zone de sécurité) et arrière-plan (terracotta uni ou dégradé), 108 × 108 dp par densité.
R7. Dette connue : le premier plan Android a été retiré de la maquette. S’il est exigé par la chaîne de construction, il se reconstruit à partir de l’icône iOS (QO-807).

## Dans la maquette
Page « 04 · Marque » (`375:2`) : logo couleur `378:2` (source de vérité), monochrome encre `384:2`, monochrome parchemin `384:26`, icône iOS `385:2`, arrière-plan Android `385:26`, règles d’usage `387:31`. Styles de texte dédiés : mot-symbole en Playfair Display Bold 52, signature en Inter Medium 15 avec espacement de lettres de 18 %, texte « LYON IMMERSIVE ».

## Hors MVP
Favicons et page web, signature de l’image partageable, signature du code visuel (déclinaisons du logo pour des surfaces de partage hors de l’app, reportées avec le partage).
