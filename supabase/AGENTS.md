# AGENTS.md — supabase

Backend : schéma Postgres, RLS, RPC de transition et tests pgTAP. Les règles globales sont dans le `AGENTS.md` racine.

## État réel

Le **schéma est complet** pour toutes les données serveur (`migrations/`) :

- **Contenu (C1)** : `pin`, `categorie`, `epoque`, `source_documentaire`, `pin_epoque`, `pin_source`, `pin_lie`, `media`, `badge`, `modele_3d` (+ `modele_3d_source`), `fragment_musical` (+ `pin_fragment_musical`).
- **Parcours (C2)** : `parcours`, `parcours_epoque`, `etape` (éditoriaux et communautaires ; les parcours personnels restent en local dans Drift).
- **Utilisateur (C3)** : `compte` (pseudonyme, `id` = `auth.users.id`). Profil, favoris et historique restent en local (I6).
- **Communauté (C4)** : `commentaire`, `retour_parcours`, `signalement`, `trace_moderation`.
- **Équipe et audit** : `membre_equipe` (rôles `editeur | validateur | moderateur`), `trace_validation`.

Pour voir les colonnes exactes, lis la migration concernée, ou `packages/api_types/lib/generated_classes.dart`.

**RPC de transition existantes** : `pin_soumettre`, `pin_valider`, `pin_publier`, `pin_retirer`. Toutes les autres transitions (parcours, commentaire, retour, signalement, compte, et pour les pins : demande de complément, réouverture, promotion I10) **n'existent pas encore**. Leurs colonnes `statut` sont déjà protégées par trigger, donc chaque transition manquante doit passer par une nouvelle RPC.

**Buckets Storage** : `audio`, `images`, `modeles-3d` (voir `config.toml`).

## Commandes

- `supabase start`, puis `supabase db reset` (migrations depuis zéro) et `supabase test db` (pgTAP de `tests/database/`).
- Après une migration : `dart run tools/gen_types.dart` pour régénérer `packages/api_types` et `content/schema/` dans la même PR.

## Conventions

- **Une migration par PR** : `supabase migration new <slug>`, avec un horodatage postérieur au dernier de `main` (vérifié en CI).
- **RPC de transition** : même patron que `pin_publier`. On y trouve `security definer`, la vérification du rôle, la vérification du statut de départ, `set_config('histolyon.transition_autorisee','on',true)` autour de l'`UPDATE`, puis l'insertion de la trace (`trace_validation` pour le processus éditorial, `trace_moderation` pour la communauté). Recette : `docs/guides/ecrire-une-migration.md`.
- **Tests** : chaque invariant, policy ou RPC a son fichier pgTAP dans `tests/database/`. Il couvre le cas nominal, le rejet d'un appelant non autorisé et le rejet d'un mauvais statut.
- **Polymorphisme** (signalement, trace_moderation) : colonnes `(type_de_cible, cible_id uuid)`, jamais une table par type.
- **Helpers pour les policies** : `est_membre_equipe()`, `est_moderateur()`, `pin_est_visible(id)`, `parcours_est_visible(id)`.

## Jamais

- Modifier un projet Supabase hébergé à la main : tout passe par `migrations/`.
- Modifier une migration déjà fusionnée dans `main` : on en écrit une nouvelle.
- Faire un `UPDATE` direct sur une colonne `statut` : toujours passer par une RPC.
- Committer une clé `sb_secret_*`.
