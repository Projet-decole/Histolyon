---
id: CAP-D1.3
type: capacite
titre: "Apparence de la carte par époque"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  ecrans: [ECR-CARTE-PRINCIPALE]
  flux: [FLX-A3]
  entites: [ENT-EPOQUE]
  invariants: []
  composants: []
  decisions: [DEC-06, DEC-12, DEC-20]
  questions: []
anciens_ids: [D1.3]
sources:
  - conception/03-fonctionnalites/01-carte-exploration-temporelle.yaml:238
  - conception/11-reponse-parametrique/04-mappings-parametriques.yaml:60
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
Faire sentir le temps qui passe : la carte respire l’époque, elle n’est pas une base statique sur laquelle on filtre des pins. Sans cela, le slider n’est qu’un sélecteur.

## Persona (litmus)
Le père lyonnais distingue l’époque à l’œil sans lire l’année ; Mme Martin montre le voyage temporel à ses élèves en défilant trois époques.

## Version MVP / reporté
- MVP : une apparence par époque, obtenue en faisant varier des paramètres sur un style de carte unique (DEC-06, DEC-20). Valeurs : TOK-MAP-SLIDER-VERS-AXES-CARTE.
- Reporté (S2) : cartes d’archives en superposition (CAP-D1.5).

## Règles
R1. Chaque époque a une apparence distincte, définie par les ancres de TOK-MAP-SLIDER-VERS-AXES-CARTE.
R2. Pendant le geste, l’apparence passe progressivement de l’époque de départ à l’époque cible, sans saut net.
R3. À la relâche, l’apparence se cale exactement sur celle de l’époque sélectionnée (TOK-CHO-CALAGE-EPOQUE).
R4. Les pins restent visibles et touchables sous toutes les apparences : la lisibilité des pins prime sur la fidélité d’époque.
R5. L’apparence suit l’époque : la personne ne peut pas la personnaliser.
R6. Il n’y a qu’un seul fichier de tuiles et un seul style ; seules les valeurs paramétriques changent (DEC-06).
R7. « Aujourd’hui » est l’apparence de base neutre, y compris en vue cumulée ; les autres s’en écartent (TOK-MAP-SLIDER-VERS-AXES-CARTE).
R8. Le contraste entre pins et fond reste suffisant sur toutes les apparences (couleurs : DEC-12).

## États et cas limites
- **Transition** : apparence intermédiaire selon la position du doigt.
- **Époque calée** : apparence exacte de l’époque.
- **Valeurs non calibrées** : les ancres sont indicatives tant que le calibrage visuel n’est pas fait (voir TOK-MAP-SLIDER-VERS-AXES-CARTE).

## Critères de fin
CF1. Chacune des 10 époques a une apparence définie et appliquée.
CF2. La transition est progressive pendant le geste.
CF3. L’apparence se cale net à la relâche.
CF4. Les pins sont visibles et touchables sur les 10 apparences, y compris la plus chargée.
CF5. Aucun second style de carte n’est embarqué.

## Hors MVP
- Superposition de cartes d’archives et reconstitutions (CAP-D1.5).
- Personnalisation de l’apparence par la personne.

## Questions ouvertes
Aucune.
