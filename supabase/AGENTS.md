# AGENTS.md — supabase

Backend Supabase : migrations, RPC de transition, tests pgTAP. Racine du dépôt : [../AGENTS.md](../AGENTS.md) — commandes workspace, workflow story/PR et interdits globaux valables ici aussi, non répétés ci-dessous.

État réel aujourd'hui : seul `README.md` existe dans `supabase/` ; migrations, RLS, RPC et tests arrivent à partir de l'Epic 3. Les rubriques ci-dessous décrivent la convention **cible**, pas l'état actuel.

## Commandes

- `supabase start` — démarre Supabase en local (Docker).
- `supabase db reset` — rejoue toutes les migrations puis le seed depuis `content/` sur une base vide.
- `supabase test db` — exécute les tests pgTAP de `tests/`.

## Conventions de nommage

- Migrations dans `migrations/`, une par PR, horodatage postérieur au dernier de `main` (AD-16, vérifié en CI).
- Statut & provenance : deux colonnes enum Postgres distinctes, jamais un booléen `publie`.
- Polymorphisme (Signalement, Favori, Lien universel) : `(type_de_cible enum, cible_id uuid)` + contrainte `CHECK`, jamais de table de jointure par type.
- Chaque invariant I1-I10 est une contrainte SQL et/ou une policy RLS, avec son test pgTAP dans `tests/`.
- Toute transition de `statut`/`provenance` est une fonction SQL exposée en RPC, qui écrit sa Trace (AD-6) — jamais un `UPDATE` direct sur une colonne de cycle de vie (RLS + trigger).
- Rôles d'équipe via la table `membre_equipe(compte_id, role)`, `role` enum `editeur | validateur | moderateur`, portée par les policies.

## Où chercher

- `migrations/` — vérité du schéma (pas encore peuplé).
- `functions_sql/` — RPC de transition, incluses par les migrations (pas encore peuplé).
- `tests/` — pgTAP par invariant, par policy et par RPC (pas encore peuplé).
- `seed/` — scripts appelés par `tools/seed` (pas encore peuplé).

## Jamais

- Modifier un projet Supabase à la main — toute modification de base passe par `migrations/`.
- `UPDATE` direct sur une colonne de cycle de vie (`statut`, `provenance`) — toujours via la RPC de transition dédiée.
- Committer une clé secrète (`sb_secret_*`) — seule la clé publiable (`sb_publishable_*`) vit dans les apps, la clé secrète ne vit qu'en CI et dans `tools/`.
- Voir aussi les interdits transverses du [racine](../AGENTS.md#jamais) (secrets/URLs en dur, fichiers générés édités à la main) : ils s'appliquent ici aussi et ne sont pas répétés.
