---
id: CAP-D1.1
type: capacite
titre: "Carte de base de Lyon"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  ecrans: [ECR-CARTE-PRINCIPALE, ECR-CARTE-APERCU-PIN]
  flux: [FLX-A1, FLX-A3]
  entites: [ENT-PIN]
  invariants: [INV-01, INV-06]
  composants: []
  decisions: [DEC-04, DEC-06, DEC-21]
  questions: [QO-101]
anciens_ids: [D1.1]
sources:
  - conception/03-fonctionnalites/01-carte-exploration-temporelle.yaml:55
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
L’app s’ouvre directement sur la carte de Lyon, sans écran intermédiaire ni demande. La carte est le socle des pins (CAP-D2.1) et des parcours (CAP-D3.3). Premier geste de la sérendipité : l’app est prête avant que la personne ait rien demandé.

## Persona (litmus)
Le père lyonnais ouvre l’app et n’a aucune friction ; Kenji comprend en moins d’une minute qu’il est sur Lyon, sans lire de texte.

## Version MVP / reporté
- MVP : carte de base navigable (déplacement, zoom) dans l’emprise des tuiles embarquées, centrée sur Bellecour, sans géolocalisation (DEC-06, DEC-21).
- Reporté (S2) : « Me localiser », recentrage sur la position, message « hors zone », permission de localisation, mode hors-ligne par étendue de tuiles téléchargées.

## Règles
R1. L’app s’ouvre directement sur la carte : aucun écran intermédiaire.
R2. Le centrage initial est toujours Bellecour (DEC-21).
R3. « À Lyon » signifie l’emprise du fichier de tuiles embarqué (DEC-06) ; la navigation ne sort pas de cette emprise (pas de carte du monde).
R4. Aucune permission, aucune demande, aucun message au lancement.
R5. La position de la personne n’est jamais lue ni stockée : l’app n’a aucune fonction de localisation (DEC-06, INV-06).
R6. Les tuiles viennent de l’instantané embarqué (DEC-04) : la carte s’affiche sans réseau.
R7. L’attribution OpenStreetMap/Protomaps est toujours visible sur la carte (règle du projet, AGENTS.md).
R8. La carte accueille les pins de l’époque sélectionnée (CAP-D1.2) et leur aperçu (ECR-CARTE-APERCU-PIN).
R9. Le geste de déplacement et de zoom reste fluide (valeurs : TOK-TMP-THROTTLE-PAN-ZOOM-CARTE).

## États et cas limites
- **Chargement initial** : les tuiles se dessinent ; le slider reste utilisable (voir ECR-CARTE-PRINCIPALE).
- **Pas de pin à l’époque** : message d’invitation à changer d’époque (voir ECR-CARTE-PRINCIPALE).
- **Hors emprise** : le geste est borné ; la carte revient dans l’emprise sans message.

## Critères de fin
CF1. Au lancement, la carte centrée sur Bellecour s’affiche sans écran intermédiaire ni dialogue.
CF2. Aucune permission système n’est demandée de toute la session.
CF3. Le déplacement et le zoom fonctionnent dans l’emprise des tuiles ; on ne peut pas en sortir.
CF4. L’attribution OpenStreetMap/Protomaps est visible à tout moment.
CF5. La carte s’affiche en mode avion (tuiles embarquées).

## Hors MVP
- « Me localiser », recentrage sur la position, message hors zone, détection « à Lyon », permission de localisation (DEC-06).
- Mode hors-ligne par téléchargement et bandeau hors-ligne sur la carte (DEC-04 : le contenu est local).
- Mode Surprenez-moi et alertes de proximité (CAP-D4.2, DEC-05).
- Projection de la carte en mode présentation : voir QO-101 et CAP-D2.5.

## Questions ouvertes
QO-101 — la carte est-elle projetable en mode présentation (CAP-D2.5) ?
