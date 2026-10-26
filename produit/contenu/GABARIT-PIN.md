---
id: DOC-GABARIT-PIN
type: document
titre: "Gabarit de rédaction d’un pin"
statut: mvp
liens:
  decisions: [DEC-02, DEC-03, DEC-14]
  invariants: [INV-04]
  questions: [QO-901, QO-902, QO-903]
anciens_ids: []
sources:
  - conception/08-contenu/02-template-pin.yaml:60
  - conception/08-contenu/02-template-pin.yaml:99
  - conception/08-contenu/02-template-pin.yaml:146
  - conception/08-contenu/02-template-pin.yaml:279
  - conception/08-contenu/02-template-pin.yaml:374
  - content/pins/cour-des-voraces.yaml:24
  - content/pins/cour-des-voraces.yaml:43
  - content/schema/pin.schema.json:1
  - content/README.md:1
  - DEC-02
  - DEC-03
derniere_verif: 2026-10-24
---

# Gabarit : un pin

Fichier à créer : `content/pins/<slug>.yaml`. Chargé par `dart run tools/seed.dart`, validé par `dart run tools/validate_content.dart`. Les règles d’écriture (R…) sont dans DOC-GUIDE-REDACTION. Aucun média n’est versionné ici (DEC-03 : le MVP ne porte que du texte).

## Champs du fichier (alignés sur le dépôt)

| Champ | Contrainte |
|---|---|
| `id` | UUID, unique, fixé à la création |
| `slug` | minuscules et tirets, stable (clé d’upsert) |
| `titre` | le nom du lieu ou du sujet, sans préfixe (« Bellecour », pas « Pin : Bellecour ») |
| `categorie` | un seul slug de `content/categories/` : anecdote, architecture, classique, evenement, gastronomie, lieu_disparu, musee_institution, nature_geographie, patrimoine_vivant, personne, vie_quotidienne |
| `epoques` | liste d’**une seule** époque (DEC-02), slug de `content/epoques/` (ex. `xixe_siecle`) |
| `sources` | liste d’au moins **une** source, slugs de `content/sources/` (INV-04) |
| `localisation` | `lat` et `lon` décimaux ; précision de l’ordre de la dizaine de mètres, à vérifier avant publication |
| `contenu_narratif` | `teaser`, `narration`, `post_narratif` (ci-dessous) |

Gérés par le script ou la base, à ne pas écrire : `provenance` (toujours éditoriale), `statut` (passe par les transitions, jamais par le fichier), dates.

## `contenu_narratif`

| Segment | Voix | Longueur | Rôle |
|---|---|---|---|
| `teaser` | tu (récit) | une phrase, ≈ 10 à 25 mots | porte d’entrée lue en quelques secondes dans l’aperçu sur la carte (QO-901) |
| `narration` | tu (récit) | ≈ 200 à 800 mots, plusieurs paragraphes | le récit, de l’ouverture à la clôture (R15 à R18) |
| `post_narratif` | tu pour le contenu | liste, en pratique 0 ou 1 entrée (l’empilement est déconseillé, 02-template-pin.yaml:365-368) | `le_saviez_vous` ou `citation_historique` seulement (DEC-03, R20) |

Structure interne de la narration : ouverture sensorielle ou spatiale, cœur en respirations, transitions sobres, clôture sans morale (02-template-pin.yaml:161-179).

- `le_saviez_vous` : champ `texte`, commence par « Le saviez-vous. », puis un fait qui prolonge le récit (phrase à court paragraphe).
- `citation_historique` : introduction sobre du conteur, citation entre guillemets, crédit court (02-template-pin.yaml:338-349). Forme exacte du champ non encore fixée : QO-902.
- Sources : une citation porte son crédit court à côté ; le pied de page « Sources » reprend toutes les sources (R22 à R24).

## Contrôles avant relecture

1. Une époque, une catégorie, au moins une source. 2. Teaser qui ne dévoile pas tout. 3. Aucun interdit de R29 à R34. 4. Termes lyonnais glosés, dates en forme littéraire (R37, R42). 5. Sources : ne pas se limiter à Wikipédia (QO-903). 6. Relecture par l’historienne avant publication.

## Exemple réel : `content/pins/cour-des-voraces.yaml`

Champs (lignes 24 à 41) : `slug: cour-des-voraces`, `titre: La Cour des Voraces`, `categorie: architecture`, `epoques: [xixe_siecle]`, trois sources (`wikipedia-cour-des-voraces`, `wikipedia-canuts`, `musee-gadagne-canuts`), `localisation` 45.7706 / 4.8298 (« approximatives, à affiner »).

**Teaser** (ligne 44) :
> Une porte cochère, une cour, et soudain un escalier de pierre qui grimpe sur six étages à ciel ouvert. Ici, la soie passait — et, parfois, une révolte.

Un détail saillant, un pourquoi qui donne envie, rien de dévoilé. Deux phrases courtes (28 mots) : voir QO-901.

**Narration** (lignes 49 à 77, ≈ 260 mots, quatre paragraphes), lecture annotée :
1. *Ouverture spatiale* : « Tu pousses la porte, place Colbert, et tu te retrouves dans une cour intérieure vertigineuse… » (ligne 50). Tutoiement narratif, ancrage dans le lieu (R16).
2. *Cœur, usage* : les canuts, les traboules, la pluie. « Canuts » est glosé dans la phrase (« les ouvriers tisseurs »), « traboules » aussi (« ces passages qui traversent les immeubles… ») (lignes 56-62 ; R42).
3. *Cœur, mise en perspective* : 1831 et 1834, les cours comme voies de circulation « hors de vue des troupes » (lignes 64-71). Les dates sont tissées dans la phrase (R8).
4. *Clôture sans morale* : l’origine du nom « reste discutée », l’incertitude est dite, puis « le décor, lui, n’a pas bougé » (lignes 73-77). Pas de conclusion académique (R18, R25).

**Post-narratif** (lignes 79-86) : un seul `le_saviez_vous`, qui élargit (des centaines de traboules, souvent privées) au lieu de résumer (R20).

Ce que l’exemple ne montre pas : aucune citation d’archive (QO-902) ; les trois sources sont générales, pas archivistiques (QO-903) ; le fichier est encore un brouillon non relu par l’historienne.
