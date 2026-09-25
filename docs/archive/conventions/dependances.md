# Dépendances

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Dépendances ». AD liée : AD-13 (trunk-based : `main` toujours livrable, fusion uniquement si CI verte sur une branche à jour).

## Convention

- `pubspec.lock` est committé (aucune app du workspace ne dépend de versions résolues « au hasard » selon la machine).
- Une montée de version de dépendance a sa **propre PR dédiée**, étiquetée `label:deps` — jamais mêlée au code d'une feature.

## Pourquoi

AD-13 exige que `main` reste livrable et que la CI ait vu le résultat exact de la fusion : committer `pubspec.lock` garantit que la CI, chaque poste de dev et chaque build testent la même résolution de dépendances. Isoler les montées de version dans des PR `label:deps` évite qu'une régression de dépendance soit noyée dans le diff d'une feature — la revue peut se concentrer sur la dépendance seule, et un rollback ciblé reste possible sans emporter du code fonctionnel.

## Exemple

Monter `maplibre_gl` de `0.27.1` à une version plus récente se fait dans une PR `chore(deps): monter maplibre_gl` seule, `label:deps`, sans aucun changement dans `features/carte` au même endroit.
