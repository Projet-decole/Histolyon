---
id: CAP-D3.9
type: capacite
titre: "Fin et célébration"
statut: mvp
priorite: important
jalon: JAL-GEL
liens:
  ecrans: [ECR-PARCOURS-FIN-CELEBRATION]
  flux: [FLX-C9]
  entites: [ENT-PARCOURS, ENT-ETAPE, ENT-HISTORIQUE-DE-VISITE]
  invariants: []
  composants: [COMP-ITEM-LISTE-ETAPE]
  decisions: [DEC-05, DEC-09]
  questions: [QO-304]
anciens_ids: [D3.9]
sources:
  - conception/03-fonctionnalites/03-parcours.yaml:838
  - conception/06-flows/03-parcours.yaml:395
  - conception/11-reponse-parametrique/03-chorégraphies.yaml:435
derniere_verif: 2026-10-24
budget_tokens: 2500
---

## Intention
Marquer la fin d’un parcours par un moment de gratification honnête : une phrase de clôture, un récapitulatif de ce qui a été vu, sans reproche si des étapes ont été laissées de côté.

## Persona (litmus)
Une personne termine le parcours et sourit : elle voit ce qu’elle a parcouru, même si elle a sauté des étapes.

## Version MVP / reporté
- MVP : écran de fin avec phrase de clôture, « X étapes vues sur Y », durée, époques traversées, liste des étapes cochées (DEC-09).
- Reporté (S2) : statistiques de distance et de quiz, image partageable, badge, retour communautaire.

## Règles
R1. La fin se déclenche quand la dernière étape est vue ou sautée (CAP-D3.5). La surface persistante disparaît, une surface dédiée s’affiche.
R2. L’écran ne se ferme jamais tout seul.
R3. L’en-tête porte le titre et la mention « Parcours achevé » si toutes les étapes sont vues, sinon une mention de fin adaptée (QO-304).
R4. La phrase de conclusion du parcours s’affiche si elle existe (parcours éditorial) ; elle fait écho au début du parcours.
R5. Le récapitulatif affiche « X étapes vues sur Y » (DEC-09). Un parcours avec étapes sautées n’est jamais qualifié d’incomplet, et la célébration reste pleine.
R6. Le récapitulatif affiche aussi la durée totale et les époques traversées.
R7. La liste des étapes est rendue avec coche sur les étapes vues. Un tap sur une étape rouvre la consultation de son pin.
R8. Le parcours est enregistré comme terminé dans l’historique avec les seules étapes réellement vues (DEC-09). Il reste relançable à tout moment (« Recommencer » sur la fiche).
R9. Le moment est animé par TOK-CHO-FIN-PARCOURS ; avec la réduction des animations, un fondu simple.
R10. L’écran est lu en entier par le lecteur d’écran.
R11. Aucune demande de note de l’app, aucun classement, aucune obligation de partager.
R12. L’action de sortie ramène à la fiche du parcours (QO-304 pour le libellé).

## États et cas limites
- **Toutes les étapes vues** : récapitulatif positif, mention « Parcours achevé ».
- **Étapes sautées** : « X étapes vues sur Y », étapes sautées non cochées.
- **Aucune conclusion rédigée** : la zone de conclusion est absente.

## Critères de fin
CF1. Voir la dernière étape ou la sauter déclenche l’écran de fin en un seul passage.
CF2. « X étapes vues sur Y » est exact pour tout scénario de saut.
CF3. L’historique ne marque comme visitées que les étapes réellement vues.
CF4. La conclusion s’affiche si elle existe et seulement alors.
CF5. Aucune mention d’échec ni d’incomplétude n’apparaît.
CF6. La sortie ramène à la fiche, où l’action est « Recommencer ».

## Hors MVP
- Distance parcourue (pas de géolocalisation), quiz réussis (quiz neutralisé).
- Image partageable et partage (S2) ; badge collectionnable (S2) ; retour de parcours communautaire.
- Relance depuis l’espace personnel, et vue « Mes parcours » (catalogue écarté, DEC-05).
- Écart de source : les critères d’origine renvoient à des capacités hors MVP (image partageable, badge) ; non repris, voir `_tri-D3`.

## Questions ouvertes
QO-304 — libellés de fin à adapter (mention partielle, retour).
