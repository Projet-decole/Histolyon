---
id: DOC-QO-CONTENU
type: document
titre: "Questions ouvertes du groupe CONTENU"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

## QO-901 — Longueur réelle du teaser
Bloque : le contrôle de longueur de DOC-GABARIT-PIN (R14 : une phrase, 10 à 25 mots). Le teaser réel de la Cour des Voraces fait deux phrases courtes (28 mots). Faut-il tolérer deux phrases courtes ou réécrire ? Unités : DOC-GUIDE-REDACTION, DOC-GABARIT-PIN. Source : content/pins/cour-des-voraces.yaml:44 ; conception/08-contenu/02-template-pin.yaml:109.

## QO-902 — Forme YAML d’une citation historique
Bloque : la rédaction d’un `post_narratif` de type citation. Le gabarit d’origine décrit introduction, citation et crédit, mais aucun fichier de `content/` n’en contient et `content/README.md` ne fixe pas les champs. Un seul champ `texte` (comme `le_saviez_vous`) ou des champs séparés (introduction, citation, crédit) ? Unité : DOC-GABARIT-PIN. Source : conception/08-contenu/02-template-pin.yaml:338.

## QO-903 — Sources du pin réel : générales, à compléter
Bloque : la publication de `cour-des-voraces`. Ses trois sources sont des références générales (deux articles Wikipédia, le musée Gadagne), sans cote d’archive ; les fichiers de sources le disent. INV-04 n’exige qu’une source, mais Mme Martin (DOC-VISION) attend des sources crédibles. Quelles sources archivistiques ou académiques ajouter, et qui valide ? Unité : DOC-GABARIT-PIN. Source : content/sources/wikipedia-cour-des-voraces.yaml:1.

## QO-904 — Format de fichier et chargement d’un parcours
Bloque : l’écriture du parcours de 7 à 10 pins. Il n’existe ni `content/parcours/`, ni lecture des parcours et des étapes dans `tools/seed.dart`, ni schéma de contenu pour les étapes. Quelle forme de fichier (le squelette de DOC-GABARIT-PARCOURS est une proposition alignée sur le schéma SQL) et qui écrit le chargement ? Unité : DOC-GABARIT-PARCOURS. Source : content/schema/parcours.schema.json:1 ; tools/seed.dart:94.

## QO-905 — Usage de `transition_depuis_precedente`
Bloque : la rédaction des étapes. Le schéma a ce champ ; la source d’origine l’exclut de son périmètre (« transitions narratives entre étapes… réservées éditorial ») sans règle. Garde-t-on le champ au MVP ou seulement l’introduction d’étape ? Unité : DOC-GABARIT-PARCOURS. Source : conception/08-contenu/03-template-parcours.yaml:37 ; supabase/migrations/20260925120000_schema_complet.sql:244.

## QO-906 — « Mes parcours » dans le dialogue d’abandon
Bloque : le texte du dialogue d’abandon (DOC-MICROCOPY M14). La description renvoie à « Mes parcours », vue de la source absente des écrans MVP (les parcours personnels restent hors MVP). Faut-il supprimer la seconde phrase, ou la remplacer par une phrase vouvoyante fournie par l’équipe ? Unité : DOC-MICROCOPY. Source : conception/08-contenu/04-microcopy-grand-public.yaml:269.

## QO-907 — Écran « Parcours » (liste) et vues de catalogue
Bloque : les libellés d’un écran de liste des parcours. L’onglet « Parcours » existe, mais aucune fiche d’écran de liste des parcours n’est écrite et le MVP n’a qu’un parcours (DEC-13). Faut-il un écran de liste, ou l’onglet ouvre-t-il directement la fiche ? Libellés d’origine écartés : « Catalogue », « Mes parcours », « Filtrer », « En cours », « Terminé », « Abandonné ». Unité : DOC-MICROCOPY. Source : conception/08-contenu/04-microcopy-grand-public.yaml:410.

## QO-908 — Libellés d’écrans non listés : indication du slider, parcours déjà en cours, dernière étape vue
Bloque : trois libellés écartés par prudence. (a) « Glissez pour traverser les époques. » : l’indication de premier passage relève de l’onboarding, neutralisé. (b) « Un autre parcours est déjà en cours. Voulez-vous l’abandonner pour démarrer celui-ci ? » : écran de lancement écarté (DEC-05), mais un seul parcours actif reste plausible. (c) « Marquer la dernière étape comme vue » : lié au mode canapé et à la complétion (DEC-09). Les garde-t-on ? Unité : DOC-MICROCOPY. Source : conception/08-contenu/04-microcopy-grand-public.yaml:310, 473, 501.

## QO-909 — Phrases d’ouverture de la fin de parcours
Bloque : la fin de parcours (DOC-MICROCOPY M11). Les phrases d’ouverture de la source sont au tutoiement (« Tu as parcouru… »), alors que la fin de parcours est de l’interface (vouvoiement, DEC-14), et la fiche ECR-PARCOURS-FIN-CELEBRATION les cite comme récit. Le récit tutoie-t-il ici, ou faut-il une version vouvoyante (texte à fournir) ? Unités : DOC-MICROCOPY, ECR-PARCOURS-FIN-CELEBRATION. Source : conception/08-contenu/04-microcopy-grand-public.yaml:520.
