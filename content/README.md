# content/ — contenu éditorial

Contenu éditorial en YAML, relu en PR comme du code. `dart run tools/validate_content.dart` le valide contre `content/schema/` (généré depuis la base par `tools/gen_types.dart`) ; `dart run tools/seed.dart` le charge en base (upsert par `slug`, provenance `editorial`, jamais `statut`).

| Dossier | Contenu | Clés principales |
| --- | --- | --- |
| `epoques/` | Catalogue des époques du slider (I7) | `id`, `slug`, `libelle`, `borne_debut`, `borne_fin`, `ordre` |
| `categories/` | Catalogue des catégories (I7), slugs = `nom_palier_13` de `conception/13-icones/02-icones-categories.yaml` | `id`, `slug`, `libelle`, `ordre` |
| `sources/` | Sources documentaires (I4) | `id`, `slug`, `type`, `reference`, `credit`, `lien`, `description` |
| `pins/` | Pins éditoriaux | `id`, `slug`, `titre`, `categorie`, `epoques`, `sources`, `localisation: {lat, lon}`, `contenu_narratif`, `post_narratif` |
| `medias.yaml` | Manifeste des médias réels (bucket, chemin, licence, crédit) | voir l'en-tête du fichier |
| `demo/` | Exemple **fictif** de tout ce qu'un pin peut porter. Jamais chargé en base. | — |

## Ajouter un pin

1. Copier la structure de `demo/pins/demo-pin-exemple.yaml` (forme du texte : `dart run tools/ctx.dart 08-contenu/02`), avec un `id` uuid v4 neuf et un `slug` en kebab-case.
2. Citer au moins une source de `sources/` (I4) et au moins une époque de `epoques/` par leur slug.
3. `dart run tools/validate_content.dart`, puis `melos run local` pour le voir dans l'app.
4. Le pin reste `brouillon` en base : l'Éditeur de contenu le soumet puis le fait valider (RPC `pin_soumettre`, `pin_valider`, `pin_publier`). En local seulement, `tools/publier_local.dart` publie tout.

Les images, sons et modèles 3D ne sont jamais committés : ils vont dans Supabase Storage via `tools/media_push.dart`, et `content/` ne référence que leurs chemins. La licence d'un média est portée par `medias.yaml` ; celle d'un texte cité, par la description de sa source.

Bornes d'époques : les époques voisines partagent leur année-frontière ; la convention (intervalle inclusif ou semi-ouvert) reste à fixer avec la question ouverte D1.2.
