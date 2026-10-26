---
id: ENT-PROFIL
type: entite
titre: "Profil"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  entites: [ENT-HISTORIQUE-DE-VISITE]
  invariants: [INV-01, INV-06]
  decisions: [DEC-04, DEC-05, DEC-15, DEC-73]
anciens_ids: [profil]
sources:
  - conception/04-donnees/03-utilisateur.yaml:44
  - apps/mobile/lib/core/db/schema.drift:5
budget_tokens: 1500
derniere_verif: 2026-10-24
---

## Rôle
Racine anonyme de l’utilisateur. Il existe dès la première ouverture, sans saisie ni inscription, et reste sur le terminal (INV-06).

## Attributs
Colonnes réelles (base locale Drift, pas Supabase) :

| nom | type | obligatoire | règle |
|---|---|---|---|
| id | texte (uuid v4 généré par l’app) | oui | anonyme, jamais transmis |
| cree_le | date-heure | oui | |
| preferences | paires `cle` / `valeur` (texte) | non | clé unique par profil |

Réglages prévus par la source, à ranger en préférences s’ils servent au MVP : indicateur de première ouverture, enregistrement de l’historique actif ou non, préférences d’accessibilité (liste non fixée). Hors MVP : langue (l’app est en français, DEC-15), mode de notification de proximité (DEC-05), permissions déjà demandées, synchronisation, compte associé.

## Relations
Possède 0..n entrées d’historique (ENT-HISTORIQUE-DE-VISITE). Favoris et parcours personnels : hors MVP.

## Cycle de vie
Créé au premier lancement. Pas de statut. Une réinstallation crée un nouveau profil (l’ancien disparaît avec l’app).

## Invariants
INV-01 (pas d’identité civile, aucun pseudonyme ici), INV-06 (strictement local). Effacer l’historique est une action sur le profil et ne touche pas aux préférences.

## Correspondance SQL
Aucune table Supabase. Drift : `profil` (`id`, `cree_le`) et `preference` (`profil_id`, `cle`, `valeur`, clé primaire composée). Écart source/Drift : DEC-73.

## Hors MVP
Compte, pseudonyme, favoris, synchronisation, section badges et statistiques (`affichage_section_engageante`).
