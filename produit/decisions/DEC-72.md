---
id: DEC-72
type: decision
titre: "Historique : cible d’une étape vue, et noms d’événements"
statut: mvp
liens:
  entites: [ENT-HISTORIQUE-DE-VISITE]
anciens_ids: []
sources:
  - conception/04-donnees/03-utilisateur.yaml:352
  - apps/mobile/lib/core/db/schema.drift:30
derniere_verif: 2026-10-24
---

## Décision proposée
ENT-HISTORIQUE-DE-VISITE décrit les entrées au niveau métier : une étape vue est une entrée d’événement `etape_visitee`. Le choix de la cible stockée n’est pas tranché ici (QO-601) ; `schema.drift` n’est pas modifié depuis `produit/`.

## Sources en conflit
La source dit que la cible d’une étape visitée est l’Étape. La table Drift limite `type_de_cible` à `pin` ou `parcours` et n’a pas de colonne d’étape. Les noms d’événements diffèrent aussi (`étape_de_parcours_visitée` / `etape_visitee`, `résultat_quiz_post_narratif` / `resultat_quiz`).

## Conséquence
Les noms Drift font foi. Avec DEC-09 (« X étapes vues sur Y »), il faut pouvoir compter les étapes vues d’un parcours : l’implémentation devra trancher (QO-601).
