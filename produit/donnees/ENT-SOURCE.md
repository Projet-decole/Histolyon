---
id: ENT-SOURCE
type: entite
titre: "Source documentaire"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  entites: [ENT-PIN, ENT-MODELE-3D]
  invariants: [INV-04]
  decisions: [DEC-04, DEC-74]
anciens_ids: [source]
sources:
  - conception/04-donnees/01-contenu.yaml:235
  - supabase/migrations/0001_socle.sql:73
  - content/sources/wikipedia-canuts.yaml:1
budget_tokens: 1500
derniere_verif: 2026-10-24
---

## Rôle
Documente chaque affirmation d’un pin ou d’un modèle 3D. C’est l’engagement d’historicité : pas de source, pas de validation (INV-04).

## Attributs
| nom | type | obligatoire | règle |
|---|---|---|---|
| id / slug | uuid / texte unique | oui | slug stable (`wikipedia-canuts`) |
| type | enum : livre, archive, article, entretien, photo, page_web, autre | oui | |
| reference | texte | oui | non vide ; contenu selon le type (ISBN, cote, URL…) |
| credit | texte | oui | non vide ; propriété intellectuelle |
| lien | texte | non | si consultable en ligne |
| description | texte | non | contexte du choix |

## Relations
Citée par 1..n pins (n-n) et par 0..n modèles 3D (n-n). Une source citée par un pin publié ne se supprime pas.

## Cycle de vie
Aucun statut.

## Invariants
INV-04 ; crédit obligatoire ; pas de suppression d’une source citée.

## Correspondance SQL
Table `source_documentaire` : `id`, `slug`, `type` (check sur les 7 valeurs), `reference`, `credit`, `lien`, `description`, `created_at`. Liaisons : `pin_source`, `modele_3d_source`. Nom SQL ≠ nom métier : la table n’est pas `source`.

## Hors MVP
Ajout de sources par un contributeur communautaire (question ouverte de la source). Le seul pin réel actuel cite des sources publiques générales (Wikipédia, Musée Gadagne) : à compléter par l’historienne (QO-603).
