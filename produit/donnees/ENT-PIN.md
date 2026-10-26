---
id: ENT-PIN
type: entite
titre: "Pin"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  entites: [ENT-CATEGORIE, ENT-EPOQUE, ENT-SOURCE, ENT-MODELE-3D, ENT-ETAPE]
  invariants: [INV-01, INV-04, INV-08, INV-09]
  decisions: [DEC-02, DEC-03, DEC-04, DEC-74]
anciens_ids: [pin]
sources:
  - conception/04-donnees/01-contenu.yaml:32
  - supabase/migrations/0001_socle.sql:89
  - supabase/migrations/20260925120000_schema_complet.sql:105
  - content/pins/cour-des-voraces.yaml:25
budget_tokens: 1500
derniere_verif: 2026-10-24
---

## Rôle
Unité atomique de contenu : un lieu, un titre, un récit, des sources. L’app raconte Lyon pin par pin.

## Attributs
| nom | type | obligatoire | règle |
|---|---|---|---|
| id / slug | uuid / texte unique | oui | slug lisible et stable (`cour-des-voraces`) |
| titre | texte | oui | non vide |
| provenance | `editorial` \| `communautaire` | oui | MVP : `editorial` seul |
| categorie | réf. ENT-CATEGORIE | oui | exactement 1 |
| epoque | réf. ENT-EPOQUE | oui | MVP : exactement 1 (DEC-02) |
| contenu_narratif | objet : `teaser`, `narration`, `post_narratif` | oui | MVP : récit + encarts texte (DEC-03) |
| sources | réfs. ENT-SOURCE | oui pour être validé | ≥ 1 (INV-04) |
| statut | enum | oui | voir Cycle de vie |
| localisation | point WGS84 | non | absent = pin non affiché sur la carte (INV-09) |
| pins_lies | réfs. Pin | non | renvois éditoriaux, orientés, pas vers soi-même |
| badge | réf. ENT-BADGE | non | hors MVP |

`post_narratif` est une liste d’encarts texte (`type`, `texte`), par exemple « Le saviez-vous » ; la narration est au tutoiement (DEC-14).

## Relations
- 1 Catégorie, 1 Époque (MVP), ≥ 1 Source.
- 0..n Modèles 3D (le modèle porte le lien : ENT-MODELE-3D).
- 0..n Étapes de parcours (ENT-ETAPE), sans limite.
- Hors MVP : médias, commentaires, signalements, favoris, fragments musicaux, auteur communautaire.

## Cycle de vie
Statuts : `brouillon`, `en_revue`, `valide`, `publie`, `retire`. L’instantané embarqué ne contient que des pins `publie` (DEC-04). Détail : DOC-CYCLES-DE-VIE.

## Invariants
INV-04 (source avant validation), INV-09 (sans localisation, pas sur la carte), INV-08 (structure n-n, MVP à une époque), INV-01 (aucune identité civile).

## Correspondance SQL
Table `pin` : `id`, `slug`, `titre`, `provenance`, `categorie_id`, `contenu_narratif` (jsonb), `statut`, `localisation` (geography point 4326), `badge_id`, `auteur_communautaire_id`, `created_at`, `updated_at`. Tables de liaison : `pin_epoque` (n-n), `pin_source` (n-n), `pin_lie`. Le `statut` ne change que par RPC. La source YAML dit « identifiant » ; le SQL a `id` et `slug`.

## Hors MVP
Pins communautaires, promotion, commentaires, signalements, favoris, médias, fragments musicaux, plusieurs époques par pin (CAP-D2.3).
