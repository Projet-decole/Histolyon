---
id: ENT-PARCOURS
type: entite
titre: "Parcours"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  entites: [ENT-ETAPE, ENT-EPOQUE, ENT-PIN, ENT-HISTORIQUE-DE-VISITE]
  invariants: [INV-01, INV-08]
  decisions: [DEC-04, DEC-05, DEC-07, DEC-09, DEC-13, DEC-70, DEC-71]
anciens_ids: [parcours]
sources:
  - conception/04-donnees/02-parcours.yaml:37
  - supabase/migrations/20260925120000_schema_complet.sql:206
budget_tokens: 1500
derniere_verif: 2026-10-24
---

## Rôle
Suite ordonnée d’étapes (chacune sur un pin), avec un teaser et une conclusion. Le parcours ne copie jamais le récit des pins. MVP : un parcours éditorial de 7 à 10 pins (DEC-13), vécu pas à pas à la main (DEC-05).

## Attributs
| nom | type | obligatoire | règle |
|---|---|---|---|
| id / slug | uuid / texte unique | oui | |
| titre | texte | oui | non vide |
| provenance | `editorial` (MVP) \| `communautaire` | oui | `personnel` absent du SQL (DEC-70) |
| etapes | liste ordonnée ENT-ETAPE | oui | ≥ 2 (vérifié à la publication, pas par contrainte) |
| epoques | réfs. ENT-EPOQUE | oui | ≥ 1, stockées explicitement |
| statut | enum | oui | défaut `brouillon` |
| teaser_narratif, conclusion_narrative | texte | requis pour publier (éditorial) | affichés en ouverture et en fin |
| signature_editoriale | texte | non | crédit collectif, pas une identité civile |
| duree_estimee_minutes, distance_estimee_metres | entiers > 0 | non | |
| densite | `legere` \| `intermediaire` \| `dense` | oui (SQL) | défaut `intermediaire` |
| badge, image d’ouverture | réfs. | non | hors MVP |

Dérivés, non stockés : nombre d’étapes, catégories couvertes. Le parcours actif place le slider sur l’époque de l’étape courante, sans le verrouiller (DEC-07).

## Relations
Compose 2..n étapes (suppression en cascade) ; associé à ≥ 1 époques ; référencé par l’historique (ENT-HISTORIQUE-DE-VISITE).

## Cycle de vie
Statuts `brouillon`, `en_revue`, `valide`, `publie`, `retire` ; l’instantané n’a que des parcours `publie` (DEC-04). Détail : DOC-CYCLES-DE-VIE.

## Invariants
Au moins 2 étapes ; au moins une époque ; teaser et conclusion avant publication éditoriale ; un retrait ne supprime ni étapes ni pins ; INV-01, INV-08.

## Correspondance SQL
Table `parcours` (`slug`, `titre`, `provenance` enum `provenance_parcours`, `statut`, `teaser_narratif`, `conclusion_narrative`, `signature_editoriale`, `auteur_communautaire_id`, `badge_id`, `image_ouverture_media_id`, `duree_estimee_minutes`, `distance_estimee_metres`, `densite`, `retours_actifs`, timestamps) ; `parcours_epoque`. Trigger `parcours_statut_proteger`. Les règles ≥ 2 étapes et ≥ 1 époque sont prévues dans les RPC, qui n’existent pas encore.

## Hors MVP
Parcours communautaires et personnels, retours, signalements, favoris, `retours_actifs`, partage par lien, quiz et badges de fin.
