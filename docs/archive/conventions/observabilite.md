# Observabilité

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Observabilité ». AD liée : AD-20 (`core/log` cité parmi les services transverses de `core/`).

## Convention

- Les logs applicatifs passent par `core/log` (niveaux standard, sans PII) côté client, et par les logs Supabase côté serveur.
- Rien de plus (pas de plateforme d'observabilité tierce, pas de métriques custom) tant qu'un besoin n'est pas documenté explicitement.

## Pourquoi

AD-20 range `core/log` parmi les services transverses de `core/`, au même titre que `permissions` ou `location` : un point d'entrée unique pour logger, plutôt qu'un `print()` ou un logger ad hoc par feature. La limite « rien de plus tant qu'un besoin n'est pas documenté » évite d'ajouter une dépendance d'observabilité (et son risque de collecte de données, cf. convention Vie privée) avant qu'un problème concret ne le justifie — cohérent avec le refus des SDK de tracking.

## Exemple

Une feature qui a besoin de tracer un échec réseau appelle `core.log.warn('[proximite] geofence hors-ligne')`, pas `print(...)` ni l'ajout d'un SDK de crash-reporting tiers pour ce seul besoin.
