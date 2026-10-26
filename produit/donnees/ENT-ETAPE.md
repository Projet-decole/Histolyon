---
id: ENT-ETAPE
type: entite
titre: "Étape"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  entites: [ENT-PARCOURS, ENT-PIN, ENT-HISTORIQUE-DE-VISITE]
  invariants: [INV-08, INV-09]
  decisions: [DEC-05, DEC-09, DEC-71]
anciens_ids: [etape]
sources:
  - conception/04-donnees/02-parcours.yaml:296
  - supabase/migrations/20260925120000_schema_complet.sql:238
budget_tokens: 1500
derniere_verif: 2026-10-24
---

## Rôle
Maillon ordonné d’un parcours. Elle pointe vers un pin et porte le liant narratif propre au parcours ; elle ne copie ni titre, ni récit, ni média du pin.

## Attributs
| nom | type | obligatoire | règle |
|---|---|---|---|
| id | uuid | oui | |
| parcours | réf. ENT-PARCOURS | oui | composition stricte |
| position | entier ≥ 1 | oui | unique dans le parcours ; contiguë (pas de trou) |
| pin | réf. ENT-PIN | oui | exactement 1 |
| introduction | texte | non | lue au début de l’étape (« introduction d’étape ») |
| transition_depuis_precedente | texte | non | lue entre deux étapes ; vide pour la 1re (voir DEC-71) |

Le même pin peut figurer plusieurs fois dans un parcours : chaque occurrence est une étape distincte.

## Relations
Appartient à exactement 1 parcours ; référence exactement 1 pin. L’historique la désigne quand elle est vue (ENT-HISTORIQUE-DE-VISITE).

## Cycle de vie
Aucun statut propre : l’étape suit son parcours. « Complétée » ou « sautée » n’est pas un état de l’étape : une étape sautée n’est pas complétée et l’historique ne retient que les étapes vues (DEC-09). L’ordre est modifiable tant que le parcours est en `brouillon`.

## Invariants
Pas d’étape hors parcours ; positions contiguës et uniques ; pin existant. Un pin sans localisation (INV-09) reste admissible dans une étape, mais n’aurait pas de point sur la carte (QO-607).

## Correspondance SQL
Table `etape` : `id`, `parcours_id` (cascade), `position` (check ≥ 1), `pin_id`, `introduction`, `transition_depuis_precedente`. Contrainte `etape_position_unique` (parcours_id, position), différée à la fin de transaction. La contiguïté des positions n’est pas contrainte en base.

## Hors MVP
`note_personnelle` (parcours personnel et communautaire), étape optionnelle, signalement d’un pin retiré (rendu à définir).
