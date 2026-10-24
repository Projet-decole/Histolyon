---
id: CAP-D3.5
type: capacite
titre: "Vivre un parcours étape par étape"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  ecrans: [ECR-PARCOURS-EN-COURS-TERRAIN, ECR-TRANSVERSES-PARCOURS-PERSISTANT]
  flux: [FLX-C5, FLX-E3]
  entites: [ENT-PARCOURS, ENT-ETAPE, ENT-HISTORIQUE-DE-VISITE]
  invariants: [INV-08]
  composants: [COMP-SLIDER-EPOQUE, COMP-DIALOGUE-CONFIRMATION]
  decisions: [DEC-05, DEC-07, DEC-09, DEC-40]
  questions: [QO-301, QO-303]
anciens_ids: [D3.5]
sources:
  - conception/03-fonctionnalites/03-parcours.yaml:426
  - conception/06-flows/03-parcours.yaml:204
  - conception/06-flows/05-notifications.yaml:173
  - conception/11-reponse-parametrique/03-chorégraphies.yaml:369
derniere_verif: 2026-10-24
budget_tokens: 2500
---

## Intention
Accompagner de l’étape 1 à la dernière, sans friction : l’app est un compagnon de lecture, pas un GPS. Le parcours se vit en un seul mode, le pas à pas manuel.

## Persona (litmus)
Une personne avance à son rythme, saute une étape sans se sentir jugée et sait où elle en est.

## Version MVP / reporté
- MVP : pas à pas manuel unique (DEC-05). L’utilisateur déclare lui-même qu’il ouvre l’étape (FLX-E3).
- Reporté (S2) : géolocalisation, arrivée détectée, alertes de proximité, direction et distance, pause, déviation, audio, transitions narratives (voir Hors MVP).

## Règles
R1. Le parcours se vit en un seul mode. Aucune position, direction, distance ni alerte de proximité n’est utilisée (DEC-05).
R2. L’étape courante est l’étape 1 au lancement. Elle est mise en avant sur la carte et dans la surface persistante : titre, « Étape n sur Y » (microcopy de progression), accès au parcours en cours.
R3. L’utilisateur ouvre la consultation approfondie du pin d’étape (CAP-D2.5) en touchant l’étape courante ou une étape de la liste. L’ouverture n’est jamais automatique : elle exige un tap (DEC-05).
R4. Dès l’ouverture, l’étape est marquée vue dans l’historique, sans vérification (FLX-E3). Si l’utilisateur ferme aussitôt, elle reste vue.
R5. Au retour de la consultation, l’étape suivante devient l’étape courante. Le tracé sur la carte met à jour les segments parcourus et à venir.
R6. La navigation est libre : « Étape suivante », « Étape précédente », ou tap sur une étape de la liste pour la rendre courante. Revenir à une étape déjà vue ne change pas la progression.
R7. « Sauter cette étape » passe à la suivante en laissant l’étape non complétée, sans confirmation ni jugement (DEC-40, DEC-09).
R8. La liste distingue quatre états d’étape : vue, courante, à venir, sautée. « Sautée » veut dire passée sans avoir été vue ; l’historique ne la stocke pas à part (DEC-09).
R9. L’introduction d’étape, si elle existe, s’affiche sur l’étape courante.
R10. Slider : à chaque changement d’étape courante, le slider se positionne sur l’époque de l’étape (TOK-CHO-PILOTAGE-AUTOMATIQUE-EPOQUE). L’utilisateur peut le déplacer à tout moment ; son geste prime et le parcours continue (DEC-07). Le positionnement ne se rejoue qu’au changement d’étape. Sans haptique.
R11. Tap sur la surface persistante, depuis n’importe quelle surface, ramène à ECR-PARCOURS-EN-COURS-TERRAIN.
R12. « Abandonner » ouvre un dialogue de confirmation. Si confirmé, le parcours est abandonné, la surface persistante disparaît, le tracé s’efface et les pins reprennent leur apparence normale.
R13. Quand la dernière étape est vue ou sautée, le parcours se termine (CAP-D3.9).
R14. Le lecteur d’écran annonce « Étape n sur Y » à chaque changement.

## États et cas limites
- **Ordre libre** : sauter puis revenir est permis ; une étape sautée devient vue si on l’ouvre ensuite.
- **Fermeture de l’app** : la reprise du parcours est en question (QO-301).

## Critères de fin
CF1. Du lancement à la fin, tout se fait par taps, sans permission demandée.
CF2. L’ouverture d’une étape marque cette étape vue ; « Sauter cette étape » la laisse non complétée.
CF3. La progression « Étape n sur Y » est correcte à chaque changement.
CF4. Le slider suit l’époque de l’étape au changement d’étape et reste librement déplaçable.
CF5. L’abandon demande confirmation et retire le tracé.
CF6. Toucher la surface persistante ramène à l’écran du parcours en cours.

## Hors MVP
- Détection d’arrivée, signal discret, ouverture automatique à l’arrivée, déclenchement par proximité : géolocalisation écartée (DEC-05). Écart de source : la capacité d’origine parle d’ouverture automatique, le flux d’origine exige un tap ; tranché par DEC-05 (tap).
- Direction, distance, application de navigation système (DEC-05).
- Audio en arrière-plan (S2) ; transitions narratives (QO-303).
- Pause, déviation, rappel, mode groupé (CAP-D3.10) ; mode canapé et bascule terrain (CAP-D3.6).

## Questions ouvertes
QO-301 — reprise après fermeture de l’app. QO-303 — transitions narratives entre étapes.
