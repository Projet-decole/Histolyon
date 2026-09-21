# Identifiants de données

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Identifiants de données ». AD liée : AD-4 (« Les `uuid` sont générés côté client partout : un objet garde son id quand il monte au serveur ») et AD-7 (« `slug` … = clé de seed et d'URL »).

## Convention

- Toute table a une clé primaire `id uuid`, générée **côté client** (mobile ou admin), jamais côté serveur (pas de `gen_random_uuid()` comme source de vérité pour le client).
- Les entités éditoriales — Pin, Parcours, Époque, Catégorie, Modèle 3D — ont en plus une colonne `slug text unique`. Ce `slug` est la clé utilisée par `tools/seed` (upsert par `slug`, AD-7) et sert aussi de clé d'URL (Lien universel, D11).

## Pourquoi

Générer l'`uuid` côté client (AD-4) permet à un objet créé hors-ligne (par exemple un Parcours personnel) de garder le même identifiant quand il monte au serveur : pas de table de correspondance id-local / id-serveur, pas de re-parenting des lignes liées. Le `slug` sert de clé stable et lisible pour le seed idempotent (`tools/seed` upsert-only par `slug`, AD-7) : rejouer le seed ne duplique jamais une entité éditoriale.

## Exemple

Un Parcours personnel créé hors-ligne dans `core/db` (Drift) a déjà son `id uuid` final avant toute synchronisation ; le jour où l'utilisateur le partage via `parcours_partager`, la ligne Postgres créée porte ce même `id`. Le pin de seed `content/pins/place-bellecour.yaml` porte `slug: place-bellecour`, réutilisé tel quel par `tools/seed` à chaque exécution.
