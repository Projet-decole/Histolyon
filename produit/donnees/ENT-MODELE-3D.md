---
id: ENT-MODELE-3D
type: entite
titre: "Modèle 3D"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  entites: [ENT-PIN, ENT-EPOQUE, ENT-SOURCE]
  invariants: [INV-04]
  decisions: [DEC-04, DEC-13, DEC-74]
anciens_ids: [modele_3d]
sources:
  - conception/04-donnees/01-contenu.yaml:369
  - supabase/migrations/20260925120000_schema_complet.sql:157
budget_tokens: 1500
derniere_verif: 2026-10-24
---

## Rôle
Reconstitution historique consultable en 3D. La tranche verticale du MVP comprend un pin avec vue 3D (DEC-13).

## Attributs
| nom | type | obligatoire | règle |
|---|---|---|---|
| id / slug | uuid / texte unique | oui | |
| titre | texte | oui | non vide |
| epoque | réf. ENT-EPOQUE | oui | exactement 1 |
| sources | réfs. ENT-SOURCE | oui (métier) | ≥ 1 : la fidélité doit être justifiée |
| pin | réf. ENT-PIN | non | 0..1 ; un modèle peut exister sans pin |
| chemin_storage | texte | oui (SQL) | fichier dans Storage, pas dans le dépôt |
| licence | texte | oui (SQL) | non vide |
| ancrage | point 3D (lat, lon, altitude) | non | pour l’AR ; absent = consultation seule |
| cap_degres, echelle | réel | non / défaut 1 | orientation par rapport au nord, échelle (SQL seulement) |
| description | texte | non | |

## Relations
Appartient à une époque, référence ≥ 1 sources, associé à 0..1 pin (un pin peut avoir plusieurs modèles).

## Cycle de vie
Aucun statut propre. Question ouverte : suit-il celui du pin ? (QO-605)

## Invariants
INV-04 par analogie : un modèle sans source n’est pas crédible. La règle « ≥ 1 source » n’est pas une contrainte SQL.

## Correspondance SQL
Table `modele_3d` (`slug`, `titre`, `epoque_id`, `pin_id` set null, `chemin_storage`, `licence`, `ancrage` geography pointz 4326, `cap_degres`, `echelle`, `description`) ; liaison `modele_3d_source`. Colonnes absentes de la source : voir DEC-74.

## Hors MVP
Superposition AR au lieu réel : DEC-13 ne retient que la « vue 3D ». L’AR n’est pas décidée pour le MVP (QO-606) ; `ancrage` reste facultatif.
