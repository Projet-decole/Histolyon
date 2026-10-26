---
id: CAP-D3.4
type: capacite
titre: "Lancement de parcours"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  ecrans: [ECR-PARCOURS-FICHE-DETAIL, ECR-TRANSVERSES-PARCOURS-PERSISTANT]
  flux: [FLX-C4]
  entites: [ENT-PARCOURS, ENT-ETAPE, ENT-HISTORIQUE-DE-VISITE]
  invariants: []
  composants: [COMP-TRACE-PARCOURS, COMP-SLIDER-EPOQUE, COMP-SURFACE-PERSISTANTE-PARCOURS]
  decisions: [DEC-05, DEC-07]
  questions: []
anciens_ids: [D3.4]
sources:
  - conception/03-fonctionnalites/03-parcours.yaml:325
  - conception/06-flows/03-parcours.yaml:159
  - conception/11-reponse-parametrique/03-chorégraphies.yaml:395
derniere_verif: 2026-10-24
budget_tokens: 2500
---

## Intention
Faire le pont entre « décider » et « vivre » : un seul geste depuis la fiche, la carte se recadre, le tracé apparaît, le parcours est en cours. Un moment d’émerveillement, pas un écran de réglages.

## Persona (litmus)
Une personne appuie sur « Démarrer ce parcours » et voit tout de suite où aller : la première étape est en relief sur le tracé.

## Version MVP / reporté
- MVP : lancement direct depuis la fiche, sans choix de mode ni écran dédié (DEC-05). La carte est l’écran.
- Reporté (S2) : variantes terrain et canapé, application de navigation système, écran Lancement (E-PARCOURS-LANCEMENT).

## Règles
R1. « Démarrer ce parcours » lance le parcours sans demande de mode ni de permission (DEC-05).
R2. Il n’existe pas d’écran « Lancement » : la bascule se fait vers la surface Carte.
R3. Le parcours passe à l’état « en cours » et un événement « parcours commencé » est écrit dans l’historique (ENT-HISTORIQUE-DE-VISITE).
R4. La carte se recadre sur l’ensemble de l’itinéraire puis sur la première étape, en une seule transition fluide (TOK-CHO-LANCEMENT-PARCOURS).
R5. L’itinéraire apparaît comme une ligne reliant les pins dans l’ordre (COMP-TRACE-PARCOURS), avec une distinction visuelle entre segments parcourus et à venir. Les pins du parcours sont mis en avant et numérotés ; les autres sont atténués mais restent cliquables (CAP-D2.1).
R6. La surface persistante du parcours apparaît (ECR-TRANSVERSES-PARCOURS-PERSISTANT) avec le titre et « Étape 1 sur Y ».
R7. Le slider d’époques se positionne sur l’époque de l’étape 1 si elle diffère de l’époque courante (DEC-07, TOK-CHO-PILOTAGE-AUTOMATIQUE-EPOQUE). La règle complète est dans CAP-D3.5.
R8. Aucun tutoriel ni pop-up explicatif n’apparaît au lancement. Aucun guidage pas à pas type GPS.
R9. Le lecteur d’écran annonce le démarrage du parcours ; les contrôles de la surface persistante ont un libellé vocal.
R10. Le MVP n’a qu’un parcours : le cas « un autre parcours est déjà en cours » ne se présente pas.

## États et cas limites
- **Lancement depuis « Recommencer »** : le parcours repart de l’étape 1 (usage du libellé : recommencer un parcours terminé ou abandonné).
- **Réduction des animations** : la transition devient un fondu simple (TOK-CHO-LANCEMENT-PARCOURS).

## Critères de fin
CF1. Depuis la fiche, un seul tap fait passer le parcours en cours, sans écran intermédiaire.
CF2. La carte affiche le tracé, les pins du parcours numérotés et les autres atténués.
CF3. La surface persistante indique « Étape 1 sur Y ».
CF4. Le slider est sur l’époque de l’étape 1.
CF5. Aucune demande de permission ni de choix de mode n’est présentée.

## Hors MVP
- Choix terrain/canapé, détection de proximité, application de navigation système « S’y rendre » (DEC-05).
- Écran E-PARCOURS-LANCEMENT, dialogue de permission, micro-parcours découverte (DEC-05).
- Voix-off de bienvenue (audio, S2).
- Écart de source : la capacité d’origine dit « pas d’écran Lancement dédié » alors que l’écran existe dans les écrans d’origine ; tranché par DEC-05 (écran écarté).

## Questions ouvertes
Aucune.
