# Guide — Ajouter une feature

**AD source :** AD-5 (« Direction des dépendances dans une app », [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md)).

Ce guide te permet de créer une nouvelle feature mobile (`apps/mobile/lib/features/<slug>`) qui respecte l'architecture en couches sans avoir à relire la spine.

## 1. Choisir le slug

Le nom du dossier de la feature est fixé par le domaine fonctionnel (D1…D11), pas inventé à la volée. Voir [`docs/conventions/langue-des-identifiants.md`](../conventions/langue-des-identifiants.md) pour la table domaine → slug (`carte`, `pins`, `parcours`, `proximite`, `onboarding`, `profil`, `audio`, `immersion`, `communaute`, `partage`). Si ta feature ne correspond à aucun slug déjà listé : n'invente pas un nom. Ouvre une question sur l'issue GitHub de la story (le slug est une décision d'équipe, pas une décision d'implémentation locale) et attends la réponse avant de créer le dossier.

## 2. Créer l'arborescence à trois couches

Sous `apps/mobile/lib/features/<slug>/`, crée exactement :

```
features/<slug>/
  data/
  domain/
  presentation/
```

Règle de dépendance stricte, dans ce sens uniquement : `presentation → domain → data`.

- `domain/` peut importer `data/`.
- `data/` n'importe ni `domain/` ni `presentation/`.
- `presentation/` n'importe pas directement `data/` : elle passe par ce que `domain/` expose.

## 3. Poser les providers Riverpod, couche par couche

Chaque couche expose ses providers avec `@riverpod` (riverpod_generator) ; la couche du dessus les lit, jamais l'inverse :

- `data/<slug>_repository.dart` : expose un provider `@riverpod` qui construit le repository (client Supabase / DAO Drift injectés **uniquement ici**). Toute méthode publique renvoie `Result<T, Failure>` (voir [`docs/conventions/erreurs.md`](../conventions/erreurs.md)) — jamais une exception Supabase/Drift brute.
- `domain/` : providers `@riverpod` qui consomment le repository de `data/` et exposent des cas d'usage / entités métier à `presentation/`. C'est ici, et seulement ici, qu'on traduit un `Failure` en décision (retry, message, état vide).
- `presentation/` : widgets qui lisent les providers de `domain/` via `ref.watch`/`ref.read`. Pas de `setState` au-delà d'un état d'UI purement local (voir [`docs/conventions/etat.md`](../conventions/etat.md)).

## 4. Déclarer les routes, jamais les assembler soi-même

- Les **noms** et chemins de route de la feature vont dans `apps/mobile/lib/core/router` (`core/router` ne contient que ça : noms et chemins, pas de logique).
- La feature exporte ses `GoRoute` (ex. `<slug>Routes` dans `presentation/`).
- **`app/` est l'unique composition root** : c'est `apps/mobile/lib/app/router.dart` qui importe les `GoRoute` de chaque feature pour construire le routeur global, avec le bootstrap et le `ProviderScope`. Une feature ne construit jamais elle-même son propre `GoRouter` ni n'importe le routeur d'une autre feature.

## 5. Ce qu'on ne fait jamais

- **Jamais** une feature qui importe une autre feature (`features/parcours` n'importe rien depuis `features/carte`, et réciproquement). Si deux features doivent communiquer : navigation nommée (via `core/router`) ou état partagé dans `core/session` (liste fermée de providers, voir AD-20) — jamais un import croisé.
- **Jamais** `core/` ou `packages/` qui importe une feature (la dépendance ne va que vers le bas).
- **Jamais** de widget dans `presentation/` qui instancie directement un client Supabase ou un DAO Drift — ça n'existe que dans `data/`.
- **Jamais** de valeur visuelle littérale (couleur, taille) dans une feature : utiliser les tokens de `packages/design_tokens` et les composants `comp-*` de `packages/ui_kit` (voir `packages/ui_kit/FIGMA-MAP.md` une fois ce package peuplé).

## 6. Vérifier

- Lint d'imports en CI : la direction des dépendances (`presentation → domain → data`, pas de feature-à-feature, pas de `core`/`packages` → feature) est vérifiée automatiquement. Une violation fait échouer la CI, pas seulement la revue humaine.
- Premier commit de la branche = tests rouges de la couche `presentation` : au minimum un widget test des composants `ui_kit` touchés (voir [`docs/guides/ecrire-un-test-de-widget.md`](ecrire-un-test-de-widget.md)).
