# Langue des identifiants

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Langue des identifiants ». AD liée : AD-5 (direction des dépendances, dossiers de features sous `apps/*/lib/features/<slug>`) et la table `Capability → Architecture Map` (D1…D11) pour la liste des slugs de features.

## Convention

Tous les identifiants (tables SQL, colonnes, fichiers, dossiers de features) sont en **français du glossaire du palier 4**, **sans accent**. Deux casses selon le contexte :

- `snake_case` en SQL et pour les noms de fichiers : `pin`, `epoque`, `parcours`, `etape`, `profil`, `compte`, `source_documentaire`.
- `lowerCamelCase` en Dart : `epoqueSelectionnee`, `parcoursActif`.

Les dossiers de features (`apps/mobile/lib/features/<slug>`) suivent la même règle et sont fixés par domaine :

| Domaine | Slug de feature |
| --- | --- |
| D1 Carte | `carte` |
| D2 Pins | `pins` |
| D3 Parcours | `parcours` |
| D4 Proximité | `proximite` |
| D5 Onboarding | `onboarding` |
| D6 Profil | `profil` |
| D7 Audio | `audio` |
| D8 Immersion (3D/AR) | `immersion` |
| D9 Communauté | `communaute` |
| D11 Partage | `partage` |

Côté `apps/admin` : `catalogue`, `saisie`, `validation`, `moderation`.

## Pourquoi

Un seul glossaire (celui du palier 4 de la conception) évite que le code, le schéma et la documentation dérivent chacun leur propre vocabulaire — un risque explicitement écarté par AD-5, qui fixe aussi la structure `features/<slug>/{data,domain,presentation}` : le nom du dossier engage tout le monde (routes, imports, tests) et ne doit pas être renégocié à chaque story.

## Exemple

Une nouvelle story sur la proximité crée `apps/mobile/lib/features/proximite/`, jamais `apps/mobile/lib/features/nearby/` ni `apps/mobile/lib/features/proximity/`. La colonne SQL correspondante s'appelle `derniere_position`, pas `last_position`.
