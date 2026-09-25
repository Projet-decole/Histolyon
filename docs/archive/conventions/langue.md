# Langue

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Langue ». Source spine : frontmatter `sources: conception/08-contenu/06-i18n.yaml` (palier 8).

## Convention

- L'application est en français uniquement : `supportedLocales = [fr]`, formats de date/nombre `fr_FR`.
- Les textes d'interface vivent dans un fichier ARB `fr` dont les **clés sont les ids de microcopy du palier 8** (pas des clés inventées à la volée par feature).
- Pas de contenu éditorial multilingue (un Pin, un Parcours n'ont qu'une version linguistique).

## Pourquoi

Le palier 8 de la conception (`conception/08-contenu/06-i18n.yaml`, une des sources citées par la spine elle-même) tranche pour le français uniquement — cohérent avec le refus d'une deuxième stack ou d'une complexité que l'équipe n'a pas les moyens de maintenir pendant le format du projet (voir aussi AD-1 sur la stack unique). Utiliser les ids de microcopy du palier 8 comme clés ARB garde une correspondance directe et traçable entre la conception éditoriale et le code, plutôt que deux nomenclatures à synchroniser à la main.

## Exemple

`lib/l10n/app_fr.arb` contient `"onboarding_bienvenue_titre": "Bienvenue"` où `onboarding_bienvenue_titre` est l'id de microcopy du palier 8, pas `"welcomeTitle"` inventé dans la feature.
