---
id: ENT-BADGE
type: entite
titre: "Badge"
statut: s2
priorite: support
jalon: JAL-S2
liens:
  entites: [ENT-PIN, ENT-PARCOURS]
  invariants: []
  decisions: [DEC-74]
anciens_ids: [badge]
sources:
  - conception/04-donnees/01-contenu.yaml:334
  - supabase/migrations/20260925120000_schema_complet.sql:109
budget_tokens: 1500
derniere_verif: 2026-10-24
---

## Rôle
Marque distinctive d’un pin ou d’un parcours (officiel, avant-première, partenaire). Catalogue fermé, géré par l’équipe.

## MVP
Aucune règle du MVP n’impose le badge : la source ne le rend pas obligatoire et la tranche verticale n’affiche aucune marque. Il est décrit pour que le schéma reste cohérent ; ne pas l’implémenter au MVP. Les badges d’engagement (récompenses de fin de parcours) sont hors MVP.

## Attributs
| nom | type | obligatoire | règle |
|---|---|---|---|
| id / slug | uuid / texte unique | oui | |
| libelle | texte | oui | non vide |
| description | texte | oui | critères d’attribution |

## Relations
Attaché à 0..n pins et 0..n parcours ; un pin ou un parcours porte au plus un badge (à arbitrer si plusieurs deviennent utiles).

## Cycle de vie
Aucun. Catalogue fermé : création par décision éditoriale.

## Invariants
Pas de saisie libre ; un badge « officiel » ne s’attache qu’à un objet éditorial.

## Correspondance SQL
Table `badge` (`id`, `slug`, `libelle`, `description`, `created_at`). Références : `pin.badge_id`, `parcours.badge_id`.

## Hors MVP
Toute l’entité (liste initiale des badges : QO-604).
