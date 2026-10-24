---
id: ENT-HISTORIQUE-DE-VISITE
type: entite
titre: "Historique de visite"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  entites: [ENT-PROFIL, ENT-PIN, ENT-PARCOURS, ENT-ETAPE]
  invariants: [INV-01, INV-06]
  decisions: [DEC-05, DEC-09, DEC-72]
anciens_ids: [historique_de_visite]
sources:
  - conception/04-donnees/03-utilisateur.yaml:352
  - apps/mobile/lib/core/db/schema.drift:30
budget_tokens: 1500
derniere_verif: 2026-10-24
---

## Rôle
Trace locale de ce que l’utilisateur a consulté ou parcouru, pour retrouver un contenu sans l’avoir mis en favori. Donnée sensible : jamais hors du terminal (INV-06).

## Attributs
| nom | type | obligatoire | règle |
|---|---|---|---|
| id | texte | oui | |
| profil_id | réf. ENT-PROFIL | oui | |
| type_evenement | texte | oui | MVP : `consultation_pin`, `etape_visitee`, `parcours_engage`, `parcours_termine` |
| type_de_cible | `pin` \| `parcours` | oui | check Drift (voir DEC-72) |
| cible_id | texte | oui | uuid serveur de la cible |
| horodatage | date-heure | oui | précision à la minute suffisante ; aucune position GPS |
| duree_secondes | entier | non | |
| score_quiz | entier | non | hors MVP |

## Relations
Appartient à un profil ; vise un pin ou un parcours (une étape selon la source, voir DEC-72).

## Cycle de vie
Append-only : une entrée n’est jamais modifiée, seul l’effacement (une entrée ou tout) la supprime. Une visite répétée crée une nouvelle entrée.

## Règles MVP
1. Seules les étapes réellement vues sont enregistrées ; une étape sautée n’est pas complétée (DEC-09).
2. L’écran de fin lit « X étapes vues sur Y » à partir de ces entrées.
3. Aucune entrée n’est créée si l’enregistrement est désactivé ; les entrées existantes restent.
4. « Parcours engagé » marque le démarrage en pas à pas manuel (DEC-05) ; « terminé » marque l’arrivée à la fin.

## Invariants
INV-06 ; INV-01 ; aucune géolocalisation continue.

## Correspondance SQL
Aucune table Supabase. Drift : `historique_visite` (`id`, `profil_id`, `type_evenement`, `type_de_cible`, `cible_id`, `horodatage`, `duree_secondes`, `score_quiz`). Écarts avec la source : noms d’événements sans accent, `resultat_quiz`, cible Étape : DEC-72.

## Hors MVP
Résultats de quiz, rétention glissante, synchronisation, sections engageantes (statistiques).
