---
id: CAP-D1.2
type: capacite
titre: "Slider d’époques"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  ecrans: [ECR-CARTE-PRINCIPALE]
  flux: [FLX-A1, FLX-A3]
  entites: [ENT-EPOQUE, ENT-PIN]
  invariants: [INV-07]
  composants: []
  decisions: [DEC-02, DEC-07, DEC-08, DEC-21]
  questions: [QO-102, QO-105]
anciens_ids: [D1.2]
sources:
  - conception/03-fonctionnalites/01-carte-exploration-temporelle.yaml:153
  - conception/11-reponse-parametrique/03-chorégraphies.yaml:340
  - conception/11-reponse-parametrique/03-chorégraphies.yaml:369
  - conception/04-donnees/00-index.yaml:213
  - content/epoques/antiquite-romaine.yaml:1
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
Naviguer dans le temps d’un geste continu, sans liste d’options. C’est le geste signature : il transforme la carte moderne en livre vivant. Le contenu reste simple : des époques fixes.

## Persona (litmus)
Kenji comprend le mécanisme sans tutoriel ni texte ; Mme Martin défile entre trois époques en classe sans rupture visible.

## Version MVP / reporté
- MVP : slider continu sur les 10 époques de `content/epoques/*.yaml`, à valider par l’historienne (DEC-08) ; un pin appartient à une seule époque (DEC-02).
- Reporté (S2) : alternative non gestuelle pour les déficiences motrices (QO-102) ; pins multi-époques (CAP-D2.3).

## Règles
R1. Le slider est continu : la position du doigt pilote l’apparence de la carte pendant le geste (CAP-D1.3 ; mapping TOK-MAP-SLIDER-VERS-AXES-CARTE).
R2. L’année ou la période courante est lisible pendant le geste.
R3. À la relâche, l’époque se cale sur l’époque la plus proche (TOK-CHO-CALAGE-EPOQUE).
R4. Les pins se rechargent à la fin du geste, jamais pendant. Le rechargement apparaît comme un fondu et non comme une rupture.
R5. L’échantillonnage du geste est celui de TOK-TMP-THROTTLE-DRAG-SLIDER . Aucun repli à fréquence réduite n’est prévu au MVP.
R6. Les époques viennent du catalogue (ordre et bornes de `content/epoques/*.yaml`), pas d’une liste dans le code de l’écran. Le catalogue est ouvert (INV-07) ; le MVP en compte 10.
R7. Sur « Aujourd’hui », la carte montre tous les pins de toutes les époques (vue cumulée).
R8. Sur les autres époques, la carte montre les pins de cette seule époque (DEC-02).
R9. Quand un parcours est actif, il positionne le slider sur l’époque de l’étape courante (TOK-CHO-PILOTAGE-AUTOMATIQUE-EPOQUE), à chaque changement d’étape (DEC-07).
R10. Si la personne touche le slider pendant ce pilotage, son geste prime et le pilotage en cours s’arrête (DEC-07). Le parcours n’est pas interrompu.
R11. Au premier lancement, une indication « Glissez pour traverser les époques. » désigne le slider (FLX-A1) ; elle disparaît au premier geste.

## États et cas limites
- **Repos** : une époque est calée, ses pins sont affichés.
- **Glissement** : l’apparence évolue, aucun pin ne se recharge.
- **Pilotage par parcours** : le slider se déplace seul ; sans retour haptique.
- **Époque sans pin** : message d’invitation (ECR-CARTE-PRINCIPALE).

## Critères de fin
CF1. Un glissement continu traverse les 10 époques ; la période courante est lisible.
CF2. À la relâche, l’époque est calée et ses pins (et seulement les siens) sont affichés.
CF3. Sur « Aujourd’hui », tous les pins de toutes les époques sont visibles.
CF4. Aucun pin ne se recharge pendant le geste.
CF5. Un parcours actif place le slider sur l’époque de l’étape ; un geste manuel ensuite l’emporte sans casser le parcours.
CF6. L’ordre et les libellés du slider viennent du catalogue d’époques.

## Hors MVP
- Alternative accessible au geste continu : QO-102.
- Pins multi-époques (CAP-D2.3, DEC-02).
- Filtre époque de la recherche (CAP-D1.4).

## Questions ouvertes
QO-102 — alternative non gestuelle au slider continu (déficience motrice) : forme à définir.
QO-105 — époque sélectionnée par défaut au lancement.
