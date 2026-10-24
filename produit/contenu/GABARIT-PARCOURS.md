---
id: DOC-GABARIT-PARCOURS
type: document
titre: "Gabarit de rédaction d’un parcours"
statut: mvp
liens:
  decisions: [DEC-02, DEC-03, DEC-05, DEC-07, DEC-09, DEC-13, DEC-14, DEC-90]
  invariants: [INV-01, INV-04]
  questions: [QO-904, QO-905]
anciens_ids: []
sources:
  - conception/08-contenu/03-template-parcours.yaml:48
  - conception/08-contenu/03-template-parcours.yaml:75
  - conception/08-contenu/03-template-parcours.yaml:120
  - conception/08-contenu/03-template-parcours.yaml:171
  - conception/08-contenu/03-template-parcours.yaml:219
  - conception/08-contenu/03-template-parcours.yaml:309
  - content/schema/parcours.schema.json:1
  - supabase/migrations/20260925120000_schema_complet.sql:238
  - DEC-13
  - DEC-90
derniere_verif: 2026-10-24
---

# Gabarit : un parcours

Un parcours n’est pas un agrégat de pins : c’est un fil qui choisit ses pins, les ordonne et leur donne une tonalité commune. Il ne répète jamais le récit d’un pin (03-template-parcours.yaml:50-59). Règles d’écriture : DOC-GUIDE-REDACTION (R26 à R28).

Au MVP, un seul parcours éditorial de 7 à 10 pins (DEC-13), vécu en pas à pas manuel (DEC-05). Pas de parcours communautaire ni personnel à rédiger (S2).

## Champs

Il n’existe pas encore de fichier `content/parcours/` ni de chargement par `tools/seed.dart` (QO-904). Les champs ci-dessous suivent le schéma réel (`content/schema/parcours.schema.json`, table `etape`).

| Champ | Voix | Longueur | Contrainte |
|---|---|---|---|
| `slug`, `titre` | voix du récit, posée et précise | un mot à une phrase courte | annonce un fil, pas une zone : « Sept traboules pour comprendre les Canuts » (03-template-parcours.yaml:84) |
| `teaser_narratif` | tu (récit) | un paragraphe, ≈ 50 à 150 mots | description de la fiche : tisse le fil, l’atmosphère, une contrainte sobre ; ne reprend pas les pins ni les listes (:120-137) |
| `conclusion_narrative` | tu (récit) | un paragraphe | **obligatoire** pour un parcours éditorial (:68) ; prolonge le fil, sans flatterie ni morale |
| `signature_editoriale` | collectif | quelques mots | signature de l’équipe, jamais d’identité civile (INV-01) |
| `duree_estimee_minutes`, `distance_estimee_metres` | | entiers | estimation du parcours à pied, pour la fiche |
| `densite` | | `legere`, `intermediaire`, `dense` | affichée « Lecture légère / moyenne / dense » |
| époques | | au moins une | celles des pins ; le slider suit l’époque de l’étape (DEC-07) |
| étapes | | 7 à 10 | voir ci-dessous |

Pas de description courte stockée : le schéma n’a pas de colonne pour elle (DEC-90). Pas d’image d’ouverture au MVP (DEC-03), pas de retours (communauté reportée).

### Étape (table `etape`)

| Champ | Contrainte |
|---|---|
| `position` | 1, 2, 3… sans trou |
| `pin` | un pin existant et publiable ; un pin par étape, une époque par pin (DEC-02) |
| `introduction` | facultative, tu (récit), une à trois phrases : annonce ce qui change (lieu, époque, angle), oriente le regard, ne raconte pas le pin. À omettre si l’étape est dans la continuité ou si le teaser du pin suffit (:171-192) |
| `transition_depuis_precedente` | facultative, absente de l’étape 1 ; même voix et mêmes règles que l’introduction. Source : colonne du schéma, usage éditorial non détaillé dans la source (QO-905) |

## Squelette annoté (à remplir, rien n’est inventé)

```yaml
slug: <slug-du-parcours>
titre: "<fil annoncé, pas une zone>"
signature_editoriale: "<équipe>"
duree_estimee_minutes: <entier>
distance_estimee_metres: <entier>
densite: intermediaire     # legere | intermediaire | dense
teaser_narratif: >-
  <un paragraphe : le geste ou le fil, l’atmosphère, une contrainte sobre ;
  en tu ; sans lister les étapes>
conclusion_narrative: >-
  <un paragraphe : ce que le lecteur emporte ; sans morale>
etapes:
  - position: 1
    pin: <slug-du-pin>          # 7 à 10 étapes au total
    introduction: >-            # facultative
      <1 à 3 phrases, tu>
  - position: 2
    pin: <slug-du-pin>
    introduction: >-
      <…>
    transition_depuis_precedente: >-   # facultative
      <…>
  # … positions 3 à 7 minimum, 10 maximum
```

Annotation : l’ordre des étapes suit une logique lisible (par exemple une journée de travail, ou un cheminement dans l’espace). Ce choix est éditorial.

## État du contenu disponible

`content/pins/` ne contient qu’un pin réel : `cour-des-voraces` (XIXe siècle). Il faut donc rédiger et faire valider six à neuf pins de plus avant d’écrire le parcours. Aucun titre ni texte de parcours n’est proposé ici. Les exemples de titre et de description de la source (« Sept traboules… ») illustrent le ton, pas un contenu à publier.

## Fin de parcours

La reconnaissance de fin est de l’interface : elle vouvoie et affiche « X étapes vues sur Y » (DEC-09 ; DOC-MICROCOPY). Seule la `conclusion_narrative`, texte de l’auteur, reste au tutoiement narratif (DEC-14). Elle doit fonctionner qu’on ait vu toutes les étapes ou une partie : ce qui a été vu vaut pour soi-même, l’incomplet n’est pas un trou à combler (03-template-parcours.yaml:238-302).

## Contrôles avant relecture

1. Entre 7 et 10 étapes, positions consécutives, pins tous publiables avec au moins une source (INV-04). 2. Titre qui annonce un fil. 3. Aucune introduction qui raconte le pin. 4. Conclusion présente. 5. Aucun interdit de R29 à R34.
