---
id: DOC-DESIGN-MOUVEMENT
type: document
titre: "Mouvement : durées, courbes, chorégraphies et comportements"
statut: mvp
liens:
  decisions: [DEC-05, DEC-07, DEC-09, DEC-20]
  questions: [QO-804, QO-805, QO-806]
anciens_ids: []
sources:
  - conception/11-reponse-parametrique/01-durees-et-courbes.yaml:43
  - conception/11-reponse-parametrique/01-durees-et-courbes.yaml:156
  - conception/11-reponse-parametrique/02-haptique-et-feedback-non-visuel.yaml:38
  - conception/11-reponse-parametrique/03-chorégraphies.yaml:74
  - conception/11-reponse-parametrique/03-chorégraphies.yaml:340
  - conception/11-reponse-parametrique/04-mappings-parametriques.yaml:60
  - conception/11-reponse-parametrique/04-mappings-parametriques.yaml:301
  - conception/11-reponse-parametrique/05-comportements-temporels-purs.yaml:37
  - conception/11-reponse-parametrique/05-comportements-temporels-purs.yaml:139
derniere_verif: 2026-10-24
---

# Mouvement

Tout ce qui bouge ou réagit à un état. Les tokens statiques sont dans TOKENS.md. Les sections de durée et de courbe ci-dessous fixent des valeurs : une chorégraphie choisit dans cet inventaire, elle n’invente pas de durée. Ces valeurs sont indépendantes de la plateforme.

## Règles générales
R1. Les opacités des voiles de surface ne sont pas ici mais dans TOKENS.md (`TOK-OPACITY-BACKDROP-M6`, `TOK-OPACITY-BACKDROP-M8`).
R2. Apparition : courbe `TOK-CRV-EASE-OUT`. Disparition : `TOK-CRV-EASE-IN`. Bascule entre deux états équivalents : `TOK-CRV-EASE-IN-OUT`.
R3. Une chorégraphie n’enchaîne jamais deux `TOK-DUR-LONG`.
R4. Mouvement réduit (réglage système) : les transitions d’état d’un bouton, les messages éphémères, les dialogues et le chargement restent inchangés ; `TOK-DUR-AMPLE` et `TOK-DUR-LONG` deviennent `TOK-DUR-STANDARD`, `TOK-DUR-STANDARD` devient `TOK-DUR-COURT` ; les ressorts deviennent `TOK-CRV-EASE-OUT` ; la célébration de fin devient un fondu simple ; la mise en relief pulsée (si elle existe) est supprimée ; le recadrage automatique de la carte est instantané.
R5. Exception : l’interpolation du fond pendant le glissement du slider est **conservée** en mouvement réduit, sans elle le slider n’est plus un voyage temporel (seul le rebond du calage disparaît).

## Durées

## TOK-DUR-INSTANT — Instant (60 ms)
Micro-retour de causalité : interrupteur, chip sélectionné.

## TOK-DUR-COURT — Court (150 ms)
Passage d’un état à l’autre d’un bouton ou d’un chip, apparition et disparition d’un message éphémère, bandeau hors ligne, rechargement des pins après un calage.

## TOK-DUR-STANDARD — Standard (250 ms)
Durée par défaut : aperçu de pin, surface ponctuelle, calage du slider, recadrage léger de la carte, saut entre les trois sections, retour.

## TOK-DUR-LONG — Long (400 ms)
Transitions structurelles : ouverture de la consultation approfondie, lancement d’un parcours, dialogue de confirmation, pilotage automatique du slider.

## TOK-DUR-AMPLE — Ample (600 ms)
Réservée à la célébration de fin de parcours. Usage parcimonieux.

## TOK-DUR-CONTINU — Continu (piloté par le geste)
Pas de durée fixe : l’animation suit le geste (glisser du slider, déplacer ou zoomer la carte).

## Courbes

## TOK-CRV-LINEAIRE — Linéaire
Vitesse constante : indicateurs de progression et interpolation pendant un geste. Courbe `cubic-bezier(0, 0, 1, 1)`.

## TOK-CRV-EASE-OUT — Décélération
Courbe des apparitions et du calage. `cubic-bezier(0, 0, 0.2, 1)`.

## TOK-CRV-EASE-IN — Accélération
Courbe des disparitions. `cubic-bezier(0.4, 0, 1, 1)`.

## TOK-CRV-EASE-IN-OUT — Symétrique
Bascules équivalentes : saut entre sections, pilotage automatique du slider. `cubic-bezier(0.4, 0, 0.2, 1)`.

## TOK-CRV-SPRING-DOUX — Ressort doux
Ressort sans rebond (masse 1, raideur 170, amortissement 26, environ 250 à 300 ms) pour l’arrivée d’une surface persistante.

## TOK-CRV-SPRING-NET — Ressort net
Ressort avec léger dépassement (masse 1, raideur 300, amortissement 20). Usage prévu : confirmation d’un favori (hors MVP) ; option non retenue pour le calage du slider (voir QO-806).

## Haptique
Trois classes. Le calage du slider est `franc`, le tap sur un élément interactif `léger`, la fin de parcours `net`. Le message éphémère et le dialogue n’ont pas d’haptique. L’haptique respecte le mode silencieux du système.

## TOK-HAP-LEGER — Léger
Intensité relative 0,4, 10 ms. Tap, sélection d’un chip, ouverture d’un aperçu.

## TOK-HAP-FRANC — Franc
Intensité relative 0,7, 15 ms. Calage du slider d’époque (pas en pilotage automatique).

## TOK-HAP-NET — Net
Intensité relative 1,0, 20 ms. Fin de parcours ; un par session courante au plus.

## Comportements temporels

## TOK-TMP-AUTO-DISMISS-M9 — Disparition d’un message éphémère (3000 ms)
Le message disparaît seul après 3 s. Un nouveau message remplace le courant (file simple). Le minuteur est suspendu quand l’app passe en arrière-plan.

## TOK-TMP-THROTTLE-DRAG-SLIDER — Échantillonnage du glisser du slider (60 Hz)
La position du slider est lue au moins 60 fois par seconde (16 ms). Pas de repli à fréquence réduite au MVP.

## TOK-TMP-THROTTLE-PAN-ZOOM-CARTE — Échantillonnage du déplacement de la carte (60 Hz)
Position et échelle mises à jour à 60 Hz pendant un déplacement ou un zoom.

## Mappings paramétriques

## TOK-MAP-SLIDER-VERS-AXES-CARTE — Slider vers les cinq axes du fond
Entrée : position du slider, continue de 0,0 à 1,0. Les dix époques sont des ancres de cet axe (distribution non uniforme, plus large pour les époques anciennes). Sorties interpolées en continu :

| axe | unité | plage indicative |
|---|---|---|
| température chromatique | écart en kelvins (positif = plus chaud) | -200 à +1000 |
| désaturation | facteur de saturation (1,0 = pleine) | 0,0 à 1,0 |
| grain et texture | intensité relative | 0,0 à 1,0 |
| vignettage | intensité relative | 0,0 à 1,0 |
| contraste | facteur (1,0 = neutre) | 0,85 à 1,20 |

Ancres (cibles **indicatives**, à calibrer sur la maquette, sauf « Aujourd’hui » définitive ; QO-804) :

| époque | position | température | saturation | grain | vignettage | contraste |
|---|---|---|---|---|---|---|
| EPQ-ANTIQUITE-ROMAINE | 0,00 | +800 | 0,55 | 0,70 | 0,50 | 0,95 |
| EPQ-HAUT-MOYEN-AGE | 0,10 | +600 | 0,30 | 0,60 | 0,70 | 1,05 |
| EPQ-MOYEN-AGE | 0,25 | +700 | 0,65 | 0,60 | 0,40 | 1,00 |
| EPQ-RENAISSANCE | 0,42 | +400 | 0,85 | 0,40 | 0,25 | 1,05 |
| EPQ-EPOQUE-CLASSIQUE | 0,55 | -100 | 0,80 | 0,30 | 0,20 | 1,15 |
| EPQ-REVOLUTION-EMPIRE | 0,65 | +300 | 0,65 | 0,45 | 0,30 | 1,20 |
| EPQ-XIXE-SIECLE | 0,75 | +200 | 0,40 | 0,55 | 0,30 | 1,05 |
| EPQ-SECONDE-GUERRE-MONDIALE | 0,85 | 0 | 0,10 | 0,65 | 0,35 | 1,15 |
| EPQ-XXE-SIECLE | 0,92 | +250 | 0,95 | 0,30 | 0,15 | 1,00 |
| EPQ-AUJOURDHUI | 1,00 | 0 | 1,00 | 0,00 | 0,00 | 1,00 |

Entre deux ancres, l’interpolation est linéaire et toujours continue (aucun saut). Exceptions possibles, à valider visuellement : courbe `TOK-CRV-EASE-IN-OUT` sur le contraste entre l’époque classique et la Révolution-Empire, et sur la désaturation et le contraste entre le XIXe siècle et la Seconde Guerre mondiale. Le type de texture bascule par zone, sans interpolation : parchemin et aquarelle de 0,0 à 0,42, grain de film de 0,65 à 0,92, aucune texture de 0,92 à 1,0. Les profils d’apparence de chaque époque sont dans CARTE.md.

## TOK-MAP-CONTEXTE-PARCOURS-VERS-PIN — Contexte de parcours vers le pin
Modulation d’un pin selon son rôle dans le parcours actif (opacité, halo, saturation relative) :

| contexte | opacité | halo | saturation |
|---|---|---|---|
| normal | 1,0 | aucun | 1,0 |
| étape courante | 1,0 | statique, intensité 0,8, taille ×1,4 | 1,10 |
| étape complétée | 0,85 | aucun | 0,90 |
| étape à venir | 1,0 | aucun | 1,0 |
| hors parcours | 0,35 | aucun | 0,70 |

La mise en relief de l’étape courante est stable (pas de pulsation). PR1 : étape courante et déjà visité, la mise en relief l’emporte. PR2 : hors parcours et déjà visité, les deux modulations se cumulent. Au MVP, « étape complétée » signifie étape réellement vue (DEC-09).

## TOK-MAP-DEJA-VISITE-VERS-PIN — Déjà visité vers le pin
Un pin déjà visité a une teinte relative de 0,95 et une saturation relative de 0,85 (adoucissement discret). Priorités : voir TOK-MAP-CONTEXTE-PARCOURS-VERS-PIN.

## TOK-MAP-MODE-OFFLINE-VERS-CARTE — Réseau vers carte
En ligne ou hors ligne avec fonds de carte disponibles : opacité des tuiles 1,0. Hors ligne sans fonds : opacité 0,5 et fond uni clair neutre avec un quadrillage léger là où il n’y a pas de tuiles, sans masquer les pins. Au MVP les tuiles sont embarquées (DEC-06) ; le cas se déclenche seulement si une ressource distante manque (QO-404).

## Chorégraphies
Chaque chorégraphie liste ses étapes avec leur durée et leur courbe.

## TOK-CHO-CALAGE-EPOQUE — Calage du slider
Au relâchement du doigt : le curseur se cale sur l’époque ancrée la plus proche et le fond prend les valeurs de l’ancre (`TOK-DUR-STANDARD`, `TOK-CRV-EASE-OUT`, `TOK-HAP-FRANC`) ; ensuite les pins de l’époque apparaissent en fondu par lot, sans animation pin par pin (`TOK-DUR-COURT`), puis les regroupements sont recalculés, puis, si un parcours est actif, l’atténuation des étapes hors époque. Pendant le glissement, le fond s’interpole sans que les pins se rechargent (`TOK-DUR-CONTINU`, `TOK-CRV-LINEAIRE`).

## TOK-CHO-PILOTAGE-AUTOMATIQUE-EPOQUE — Slider piloté par le parcours
À chaque changement d’étape qui impose une autre époque, le curseur glisse vers l’époque cible et le fond s’interpole en même temps (`TOK-DUR-LONG`, `TOK-CRV-EASE-IN-OUT`), puis les pins de l’époque apparaissent (`TOK-DUR-COURT`). Pas d’haptique. Si l’utilisateur touche le slider, il prend la main et le pilotage s’arrête (DEC-07).

## TOK-CHO-LANCEMENT-PARCOURS — Lancement d’un parcours
Tap sur « lancer » dans la fiche du parcours : la fiche sort en fondu et glisse vers le bas (`TOK-DUR-LONG`, `TOK-CRV-EASE-IN`, `TOK-HAP-LEGER`) ; à 100 ms les pins passent à leurs variantes de contexte et le tracé apparaît en fondu (`TOK-DUR-STANDARD`, `TOK-CRV-EASE-OUT`) ; à 200 ms la surface persistante de parcours arrive (`TOK-DUR-STANDARD`, `TOK-CRV-SPRING-DOUX`) ; enfin le slider se place sur l’époque de l’étape courante si elle est différente (variante raccourcie, `TOK-DUR-STANDARD`, `TOK-CRV-EASE-IN-OUT`). Un seul mode, pas à pas manuel (DEC-05).

## TOK-CHO-ABANDON-PARCOURS — Abandon d’un parcours
Fermer la surface persistante ouvre d’abord un dialogue de confirmation. Si l’utilisateur confirme : la surface sort, le tracé s’efface (`TOK-DUR-STANDARD`, `TOK-CRV-EASE-IN`), les pins reviennent à leur variante normale, puis un message éphémère « Parcours abandonné » apparaît. Si l’utilisateur annule, rien ne change.

## TOK-CHO-FIN-PARCOURS — Fin de parcours
Navigation vers l’écran de fin (`TOK-DUR-LONG`, `TOK-CRV-EASE-OUT`), animation d’aboutissement (`TOK-DUR-AMPLE`, `TOK-CRV-EASE-IN-OUT`, `TOK-HAP-NET`), puis la surface persistante de parcours disparaît. La forme de l’animation n’est pas choisie (QO-805).

## TOK-CHO-OUVERTURE-M2 — Ouverture de l’aperçu d’un pin
Tap sur un pin : le pin passe à l’état sélectionné (`TOK-DUR-COURT`, `TOK-CRV-EASE-OUT`, `TOK-HAP-LEGER`) en même temps que l’aperçu monte en fondu (`TOK-DUR-STANDARD`, `TOK-CRV-EASE-OUT`) ; à 100 ms, la carte se recadre légèrement si le pin est proche d’un bord. La fermeture inverse l’ordre (`TOK-CRV-EASE-IN`), sans recadrage. Ressort doux ou décélération pour l’aperçu : voir QO-806.

## TOK-CHO-FERMETURE-M2 — Fermeture de l’aperçu d’un pin
Tap hors de l’aperçu ou geste de fermeture : le pin redevient normal (`TOK-DUR-COURT`, `TOK-CRV-EASE-IN`, sans haptique) et l’aperçu descend en fondu (`TOK-DUR-STANDARD`, `TOK-CRV-EASE-IN`). Pas de nouveau recadrage.

## TOK-CHO-OUVERTURE-M3 — Ouverture de la consultation approfondie
Tap sur le bouton principal de l’aperçu : l’aperçu sort (`TOK-DUR-COURT`, `TOK-CRV-EASE-IN`, `TOK-HAP-LEGER`) ; à 50 ms la consultation monte depuis le bas et la carte s’atténue derrière (`TOK-DUR-LONG`, `TOK-CRV-EASE-OUT`).

## TOK-CHO-FERMETURE-M3 — Retour de la consultation approfondie
Bouton retour : la consultation descend, l’aperçu d’origine revient s’il existait, sinon on retourne à la carte ; la carte se réveille. La sortie dure `TOK-DUR-STANDARD`, plus court que l’entrée.

## TOK-CHO-OUVERTURE-M6 — Ouverture d’une surface ponctuelle
Voile qui monte jusqu’à `TOK-OPACITY-BACKDROP-M6` et surface qui glisse depuis le bas en fondu, ensemble (`TOK-DUR-STANDARD`, `TOK-CRV-EASE-OUT`, `TOK-HAP-LEGER`). Au MVP : lancement de parcours, saut d’étape.

## TOK-CHO-FERMETURE-M6 — Fermeture d’une surface ponctuelle
Inverse de l’ouverture (`TOK-DUR-STANDARD`, `TOK-CRV-EASE-IN`) ; fondu simple au retour gracieux.

## TOK-CHO-OUVERTURE-M8 — Ouverture d’un dialogue de confirmation
Voile jusqu’à `TOK-OPACITY-BACKDROP-M8` et dialogue qui grandit de 0,92 à 1,0 en fondu, ensemble (`TOK-DUR-LONG`, `TOK-CRV-EASE-OUT`). Pas d’haptique. Un seul dialogue à la fois.

## TOK-CHO-FERMETURE-M8 — Fermeture d’un dialogue de confirmation
Inverse (`TOK-DUR-LONG`, `TOK-CRV-EASE-IN`), conservé en mouvement réduit.

## TOK-CHO-OUVERTURE-M9 — Apparition d’un message éphémère
Le message monte depuis le bas en fondu (`TOK-DUR-COURT`, `TOK-CRV-EASE-OUT`), sans haptique, sans bloquer la surface.

## TOK-CHO-DISMISS-M9 — Disparition d’un message éphémère
Après `TOK-TMP-AUTO-DISMISS-M9`, le message descend en fondu (`TOK-DUR-COURT`, `TOK-CRV-EASE-IN`). S’il est remplacé par un autre message, fondu enchaîné.

## TOK-CHO-APPARITION-P2 — Apparition de la surface de parcours en cours
Glisse depuis le bas en fondu avec une qualité tactile (`TOK-DUR-STANDARD`, `TOK-CRV-SPRING-DOUX`, `TOK-HAP-LEGER`).

## TOK-CHO-DISPARITION-P2 — Disparition de la surface de parcours en cours
`TOK-DUR-STANDARD`, `TOK-CRV-EASE-IN`.

## TOK-CHO-APPARITION-P3 — Apparition du bandeau hors ligne
Glisse depuis le haut en fondu (`TOK-DUR-COURT`, `TOK-CRV-EASE-OUT`) ; ce n’est pas une surface tactile.

## TOK-CHO-DISPARITION-P3 — Disparition du bandeau hors ligne
`TOK-DUR-COURT`, `TOK-CRV-EASE-IN`, quand la condition cesse.

## TOK-CHO-SAUT-LATERAL-S1-S2-S3 — Saut entre sections
La section quittée sort en fondu avec un léger glissement latéral, la nouvelle entre en sens inverse (`TOK-DUR-STANDARD`, `TOK-CRV-EASE-IN-OUT`, `TOK-HAP-LEGER`) ; l’icône de section active change en `TOK-DUR-COURT`.

## TOK-CHO-RETOUR-GRACIEUX — Retour
La surface courante sort selon son type (`TOK-DUR-STANDARD`, `TOK-CRV-EASE-IN`, `TOK-HAP-LEGER`) pendant que la surface parente se réveille (`TOK-CRV-EASE-OUT`).

## Hors MVP
Alerte de proximité et son délai, mode présentation et sommeil des surfaces persistantes, surface persistante audio, onboarding, recherche (délai de saisie), formulaires, défilement infini, appui long, double tap, délais réseau : conservés dans la conception, aucun écran MVP ne les emploie (DEC-05, DEC-04).
