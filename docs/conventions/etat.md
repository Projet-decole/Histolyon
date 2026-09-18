# État

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « État ». AD liée : AD-5 (« chaque couche expose ses providers Riverpod ») et AD-20 (« `core/session` expose une liste fermée de providers »).

## Convention

- La gestion d'état passe par Riverpod avec `@riverpod` (riverpod_generator) — pas de `StateProvider`/`ChangeNotifier` ad hoc.
- Pas de `setState` au-delà du widget local (un simple toggle d'UI éphémère est acceptable ; tout ce qui doit survivre à un rebuild ou être lu par un autre widget passe par un provider).
- La navigation utilise des routes nommées `go_router` : les noms de routes vivent dans `core/router`, l'assemblage du routeur dans `app/` (AD-5).

## Pourquoi

`@riverpod` génère du code testable et typé (providers découverts, pas de clé magique comme avec `Provider(name: ...)`), cohérent avec AD-3 (rien n'est écrit à la main quand ça peut être généré). AD-20 réserve l'état transverse (époque sélectionnée, parcours actif, etc.) à une liste fermée de providers dans `core/session` : un `setState` local qui déborderait de son widget recréerait un état parallèle à `core/session`, exactement ce qu'AD-20 interdit (« dupliqués dans chaque feature avec des types différents »). Les routes nommées centralisées dans `core/router` évitent qu'une feature code en dur le chemin d'une autre.

## Exemple

Un compteur de pages dans un `PageView` local peut rester un `setState` du widget. Mais l'époque actuellement affichée sur la carte est `core/session.epoqueSelectionnee`, un `@riverpod` lu par `features/carte` — jamais un `setState` local à cette feature.
