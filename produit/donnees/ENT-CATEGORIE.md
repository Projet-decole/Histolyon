---
id: ENT-CATEGORIE
type: entite
titre: "Catégorie"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  entites: [ENT-PIN]
  invariants: [INV-07]
  decisions: [DEC-04]
anciens_ids: [categorie]
sources:
  - conception/04-donnees/01-contenu.yaml:149
  - supabase/migrations/0001_socle.sql:43
  - content/categories/anecdote.yaml:1
budget_tokens: 1500
derniere_verif: 2026-10-24
---

## Rôle
Classe un pin par nature thématique (anecdote, lieu disparu…) pour filtrer et différencier visuellement sur la carte. Catalogue ouvert (INV-07).

## Attributs
| nom | type | obligatoire | règle |
|---|---|---|---|
| id / slug | uuid / texte unique | oui | slug stable, jamais réattribué |
| libelle | texte | oui | non vide |
| ordre | entier | oui | ordre d’affichage |
| description | texte | non | sens de la catégorie |

## Relations
Référencée par 0..n pins (ENT-PIN) ; chaque pin a exactement une catégorie.

## Cycle de vie
Aucun statut. Une catégorie ne s’archive pas : toute évolution est une addition (INV-07).

## Invariants
INV-07. L’identifiant est unique et stable.

## Correspondance SQL
Table `categorie` : `id`, `slug` (unique), `libelle` (non vide), `description`, `ordre`, `created_at`. Contenu : `content/categories/*.yaml` (11 fichiers : anecdote, architecture, classique, evenement, gastronomie, lieu-disparu, musee-institution, nature-geographie, patrimoine-vivant, personne, vie-quotidienne). La liste définitive reste à valider avec l’équipe éditoriale (QO-602).

## Hors MVP
Couches cartographiques (non reprises, voir DOC-TRI-DONNEES). Ajout de catégories par l’admin.
