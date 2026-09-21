# Vie privée

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Vie privée ». AD liée : AD-2 (invariant I1, cité dans la règle : « un fournisseur tiers n'est admis que s'il n'importe aucune identité civile ») et la ligne de convention « Refus hérités de l'essence » (pas d'inscription obligatoire, pas de notification de proximité par défaut).

## Convention

- Aucun SDK d'analytics ni de tracking n'est intégré à l'application (ni mobile, ni admin).
- Les logs ne contiennent aucun identifiant utilisateur (pas d'email, pas d'`uuid` de compte en clair dans un message de log applicatif).

## Pourquoi

Le projet est construit sur le refus explicite de collecter des identités civiles (I1, AD-2) et sur des refus hérités de l'essence du produit (pas d'inscription obligatoire, pas de notification de proximité par défaut) : un SDK de tracking tiers introduirait une collecte de comportement qu'aucune de ces règles n'autorise, et souvent hors du contrôle du schéma versionné qui est censé être l'unique vérité (AD-2). Des logs sans identifiant utilisateur limitent la surface de ce qu'une fuite de logs peut exposer.

## Exemple

`core/log` (AD-20) logue `[pin] échec chargement (raison: reseau)`, jamais `[pin] échec chargement pour compte 3fa8...`. Un plan d'intégration de Firebase Analytics ou Sentry avec collecte d'identifiants passerait par un amendement d'AD, pas par une PR ordinaire.
