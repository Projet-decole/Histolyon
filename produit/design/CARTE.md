---
id: DOC-DESIGN-CARTE
type: document
titre: "Carte : fond, attribution, emprise, regroupement et 10 époques"
statut: mvp
liens:
  decisions: [DEC-06, DEC-08, DEC-20, DEC-21, DEC-82, DEC-111]
  questions: [QO-802, QO-803, QO-804, QO-808]
anciens_ids: []
sources:
  - conception/09-cartographie/01-fond-et-epoques.yaml:41
  - conception/09-cartographie/01-fond-et-epoques.yaml:104
  - conception/09-cartographie/03-parcours-traces.yaml:24
  - conception/09-cartographie/04-densite-zoom.yaml:20
  - conception/09-cartographie/04-densite-zoom.yaml:133
  - conception/11-reponse-parametrique/04-mappings-parametriques.yaml:60
  - content/epoques/antiquite.yaml:1
  - content/epoques/haut-moyen-age.yaml:1
  - content/epoques/moyen-age-classique.yaml:1
  - content/epoques/bas-moyen-age.yaml:1
  - content/epoques/epoque-moderne.yaml:1
  - content/epoques/revolution-empire.yaml:1
  - content/epoques/xixe-siecle.yaml:1
  - content/epoques/guerres-mondiales.yaml:1
  - content/epoques/xxe-siecle.yaml:1
  - content/epoques/xxie-siecle.yaml:1
  - docs/ARCHITECTURE-SPINE.md:113
derniere_verif: 2026-11-19
---

# Carte

Valeurs d’apparence (axes, ancres chiffrées) : TOK-MAP-SLIDER-VERS-AXES-CARTE dans MOUVEMENT.md. Tokens : TOKENS.md.

## Fond de carte, emprise, attribution
R1. Un seul fond de carte au MVP : un fichier de tuiles vectorielles embarqué, un seul style (DEC-06, DEC-20). La conception d’architecture parle d’un style par époque : voir DEC-82.
R2. « À Lyon » signifie l’emprise de ce fichier de tuiles (DEC-06). La carte s’ouvre centrée sur Bellecour, qui doit se trouver dans l’emprise (DEC-21). Pas de carte du monde. Les coordonnées de l’emprise et le zoom initial ne sont pas encore fixés (QO-802, QO-803).
R3. L’attribution OpenStreetMap (licence ODbL) et Protomaps reste visible en permanence sur la carte.
R4. Pas de géolocalisation, donc pas de bouton « Me localiser » ni de recentrage sur la position (DEC-06).

## Apparence par époque
R5. L’apparence du fond est une **fonction continue** de la position du slider : cinq axes (température chromatique, désaturation, grain et texture, vignettage, contraste) sont interpolés pendant le geste. Au relâchement, le slider cale sur l’époque la plus proche et chaque axe prend sa valeur ancrée.
R6. Pendant le geste, les pins ne se rechargent pas ; ils se chargent au calage.
R7. Un parcours actif positionne le slider sur l’époque de l’étape courante ; l’utilisateur peut ensuite le déplacer (DEC-07).
R8. « XXIe siècle », dernière époque, est l’apparence neutre, sans filtre : le présent ne se filtre pas.
R9. Les ancres sont **indicatives** tant que le calibrage visuel n’est pas fait (QO-804).
R10. Lisibilité, prioritaire sur l’effet stylistique, à toute valeur d’axe : les pins restent visibles et identifiables ; le tracé d’un parcours actif reste visible ; les noms de rues et de quartiers restent lisibles.

## Pins et tracé sur la carte
R11. Provenance par la couleur du pin et du tracé (`TOK-COLOR-PIN-EDITORIAL`, `TOK-COLOR-PIN-COMMUNAUTAIRE`) ; catégorie par l’icône (ICONES.md) ; pas de signe particulier pour un pin à vue 3D (la carte ne pré-annonce pas).
R12. Un seul tracé actif à la fois. Avant lancement (fiche du parcours), le tracé s’affiche en entier sans étape courante.
R13. Parcours actif : segments déjà vus atténués, segments à venir pleins, étape courante en relief, numéro de l’étape intégré à son pin (pas d’étiquette séparée). Le détail des modulations est dans TOK-MAP-CONTEXTE-PARCOURS-VERS-PIN. Au MVP le parcours se vit pas à pas, sans position de l’utilisateur (DEC-05).
R14. Le tracé ne réagit pas à une déviation (sobriété) ; sans géolocalisation, il n’y a de toute façon pas de déviation à signaler.

## Regroupement des pins (R1 à R4 du regroupement)
Trois niveaux de zoom qualitatifs : **large** (Lyon en vue d’ensemble, regroupement systématique), **intermédiaire** (échelle de quartier, regroupement dans les zones denses), **proche** (échelle de la rue, aucun regroupement). Les seuils chiffrés ne sont pas fixés (QO-201).
Un regroupement reprend la couleur éditoriale s’il contient au moins un pin éditorial, porte le nombre de pins regroupés et n’hérite ni de la catégorie, ni de l’état « déjà visité », ni de l’étape courante.
R1. L’étape courante d’un parcours actif n’est jamais regroupée : elle reste un pin individuel, quel que soit le zoom.
R2. Un tap sur un regroupement zoome sur sa zone jusqu’à voir les pins ou des regroupements plus petits.
R3. Un regroupement reste lisible à toute valeur d’axe du fond.
R4. Aucun regroupement ne masque tout un tracé actif : le tracé passe devant.
Hors MVP : forme empilée d’un pin ou regroupement multi-époque (DEC-02), contour de vérification (communauté), couches d’archives superposées.

## Les 10 époques
Bornes et libellés **validés par l’historienne** (DEC-111) ; la source de vérité reste `content/epoques`. Les bornes sont des années (négatif = avant J.-C.) ; deux époques voisines se touchent. Les apparences restent indicatives (QO-804).

## EPQ-ANTIQUITE — Antiquité
Ordre 1 ; de -680 à 476. Apparence : chaleur ocre antique, désaturation marquée, texture aquarelle, vignettage présent.

## EPQ-HAUT-MOYEN-AGE — Haut Moyen Âge
Ordre 2 ; de 476 à 987. Apparence : sépia profond presque monochrome, vignettage fort, lecture austère.

## EPQ-MOYEN-AGE-CLASSIQUE — Moyen Âge classique
Ordre 3 ; de 987 à 1328. Apparence : ambre doré d’enluminure, texture parchemin, accents rouges et bleus préservés.

## EPQ-BAS-MOYEN-AGE — Bas Moyen Âge
Ordre 4 ; de 1328 à 1492. Apparence : provisoirement celle du Moyen Âge classique, à distinguer au calibrage (QO-804).

## EPQ-EPOQUE-MODERNE — Époque moderne
Ordre 5 ; de 1492 à 1789 (réunit l’ancienne Renaissance et l’époque classique). Apparence : dominante bleu froid noble, contraste accentué, géométrie nette.

## EPQ-REVOLUTION-EMPIRE — Révolution et Ier Empire
Ordre 6 ; de 1789 à 1815. Apparence : contraste brutal, désaturation partielle avec rouges accentués, grain papier.

## EPQ-XIXE-SIECLE — XIXe siècle
Ordre 7 ; de 1815 à 1914. Apparence : sépia argentique du daguerréotype, grain film, teinte légèrement froide.

## EPQ-GUERRES-MONDIALES — Guerres mondiales
Ordre 8 ; de 1914 à 1945 (les deux guerres et l’entre-deux-guerres). Apparence : monochrome quasi pur, grain fort, contraste brutal.

## EPQ-XXE-SIECLE — XXe siècle
Ordre 9 ; de 1945 à 2000. Apparence : Kodachrome chaleureux, saturation pop, grain film 35 mm.

## EPQ-XXIE-SIECLE — XXIe siècle
Ordre 10 ; de 2000 à 2027 (la fin est provisoire : QO-808). Dernière position du slider : vue cumulée (CAP-D1.2 R7). Apparence : neutre sans filtre. Ancre de référence.

## Questions types sur les bornes
- Antiquité : de -680 à 476. Haut Moyen Âge : de 476 à 987. Moyen Âge classique : de 987 à 1328. Bas Moyen Âge : de 1328 à 1492.
- Époque moderne : de 1492 à 1789. Révolution et Ier Empire : de 1789 à 1815. XIXe siècle : de 1815 à 1914.
- Guerres mondiales : de 1914 à 1945. XXe siècle : de 1945 à 2000. XXIe siècle : de 2000 à 2027.
- Ces bornes sont validées par l’historienne (DEC-111).
