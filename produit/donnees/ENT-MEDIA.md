---
id: ENT-MEDIA
type: entite
titre: "Média"
statut: s2
priorite: support
jalon: JAL-S2
liens:
  entites: [ENT-PIN]
  invariants: [INV-01]
  decisions: [DEC-03, DEC-04, DEC-74]
anciens_ids: [media]
sources:
  - conception/04-donnees/01-contenu.yaml:285
  - supabase/migrations/20260925120000_schema_complet.sql:136
budget_tokens: 1500
derniere_verif: 2026-10-24
---

## Rôle
Matière sensorielle d’un pin : images, archives, audio, éléments interactifs. Décrit pour mémoire : le MVP n’en utilise pas (DEC-03 : récit et encarts texte, ni archives ni audio).

## Attributs
| nom | type | obligatoire | règle |
|---|---|---|---|
| id | uuid | oui | |
| pin | réf. ENT-PIN | oui | un média appartient à exactement 1 pin |
| type | enum : image, archive_colorisee, archive_brute, audio_narration, audio_ambiance, element_interactif | oui | |
| credit | texte | oui | non vide |
| licence | texte | oui (SQL) | non vide ; absent de la source (DEC-74) |
| chemin_storage | texte | oui (SQL) | chemin Storage, jamais de binaire dans le dépôt |
| legende, description | texte | non | |
| ordre | entier | oui (SQL) | défaut 0 |

## Relations
Appartient à exactement 1 pin ; suppression du pin supprime ses médias. Image d’ouverture d’un parcours : hors MVP.

## Cycle de vie
Aucun statut propre.

## Invariants
Crédit obligatoire (droits d’auteur) ; pas de média hors d’un pin.

## Correspondance SQL
Table `media` (`pin_id` cascade, `type` enum `type_media`, `chemin_storage`, `credit`, `licence`, `legende`, `description`, `ordre`, `created_at`). Manifeste : `content/medias.yaml` (chemins et licences, aucun binaire).

## Hors MVP
Tout : le MVP ne livre aucun média rattaché à un pin. Les éléments interactifs (puzzle, énigme, avant/après, frise) sont neutralisés par DEC-03. Le modèle 3D est une entité à part (ENT-MODELE-3D).
