# Guide — Écrire une migration ou une RPC de transition

Le schéma serveur est complet. La plupart des issues `supabase` consistent donc à **ajouter une RPC de transition** (faire passer un `statut` d'un état à un autre) ou, plus rarement, une colonne. Le patron de référence est `pin_publier`, dans `supabase/migrations/20260921140832_trace_toutes_transitions.sql`.

## 1. Créer le fichier

```bash
supabase migration new commentaire_moderer    # → supabase/migrations/<horodatage>_commentaire_moderer.sql
```

Une seule migration par PR. Son horodatage doit être postérieur au dernier de `main`, ce que la CI vérifie. Si `main` a reçu une autre migration entre-temps, renomme ton fichier avec un horodatage plus récent.

## 2. Écrire le test d'abord (premier commit, rouge)

Crée `supabase/tests/database/rpc_<nom>.sql`. Trois cas au minimum :

```sql
begin;
select plan(4);

-- Données : un modérateur, un non-membre, un commentaire en_attente.
insert into auth.users (id, email) values
    ('11111111-0000-0000-0000-000000000001', 'modo@histolyon.local'),
    ('11111111-0000-0000-0000-000000000002', 'quidam@histolyon.local');
insert into membre_equipe (compte_id, role) values ('11111111-0000-0000-0000-000000000001', 'moderateur');
-- Chaîne de clés étrangères : compte (auteur) -> categorie -> pin -> commentaire.
insert into compte (id, pseudonyme) values ('11111111-0000-0000-0000-000000000002', 'quidam');
insert into categorie (id, slug, libelle, ordre) values ('22222222-0000-0000-0000-000000000001', 'test-cat', 'Cat', 1);
insert into pin (id, slug, titre, categorie_id, statut) values ('33333333-0000-0000-0000-000000000001', 'test-pin', 'Pin', '22222222-0000-0000-0000-000000000001', 'publie');
insert into commentaire (id, pin_id, auteur_id, contenu) values
    ('<id>', '33333333-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000002', 'En attente'),
    ('<id-publie>', '33333333-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000002', 'Déjà publié');
-- Statut de départ d'une fixture : même drapeau que les RPC (test uniquement).
select set_config('histolyon.transition_autorisee', 'on', true);
update commentaire set statut = 'publie' where id = '<id-publie>';
select set_config('histolyon.transition_autorisee', 'off', true);

-- 1. Rejet d'un appelant non autorisé
select set_config('request.jwt.claim.sub', '11111111-0000-0000-0000-000000000002', true);
select throws_ok($$ select commentaire_publier('<id>'::uuid) $$, 'P0001', null, 'refusé hors modérateurs');

-- 2. Cas nominal + 3. la trace est écrite
select set_config('request.jwt.claim.sub', '11111111-0000-0000-0000-000000000001', true);
select lives_ok($$ select commentaire_publier('<id>'::uuid) $$, 'le modérateur publie');
select is((select statut::text from commentaire where id = '<id>'), 'publie', 'statut publie');
select is((select count(*)::int from trace_moderation where cible_id = '<id>'), 1, 'trace écrite');

-- 4. Rejet si le statut de départ est mauvais
select throws_ok($$ select commentaire_publier('<id-publie>'::uuid) $$, 'P0001', null, 'refusé hors en_attente');

select * from finish();
rollback;
```

Vérifie qu'il échoue : `supabase test db`.

## 3. Écrire la RPC, sur le patron existant

```sql
-- en_attente -> publie
create function commentaire_publier(p_commentaire_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
    v_statut statut_contribution;
begin
    if not est_moderateur() then
        raise exception 'seul un modérateur peut publier un commentaire';
    end if;

    select statut into v_statut from commentaire where id = p_commentaire_id for update;
    if not found then
        raise exception 'commentaire % introuvable', p_commentaire_id;
    end if;
    if v_statut <> 'en_attente' then
        raise exception 'commentaire_publier exige en_attente (statut actuel : %)', v_statut;
    end if;

    -- Le trigger de protection du statut n'accepte l'UPDATE que dans cette fenêtre.
    perform set_config('histolyon.transition_autorisee', 'on', true);
    update commentaire set statut = 'publie', updated_at = now() where id = p_commentaire_id;
    perform set_config('histolyon.transition_autorisee', 'off', true);

    insert into trace_moderation (type_de_cible, cible_id, moderateur, decision)
    values ('commentaire', p_commentaire_id, auth.uid(), 'publie');
end;
$$;

-- Par défaut PostgreSQL accorde EXECUTE à PUBLIC : sans ce revoke, le grant
-- ne restreint rien.
revoke execute on function commentaire_publier(uuid) from public, anon;
grant execute on function commentaire_publier(uuid) to authenticated;
```

- **Trace** : `trace_validation` pour le processus éditorial des pins, `trace_moderation` pour tout ce qui est communautaire.
- **Autorisation** : `est_membre_equipe()`, `est_moderateur()`, ou `auth.uid() = auteur_id` quand c'est l'auteur qui agit (par exemple `supprime_par_auteur`).
- **Le cycle de vie exact** (états, transitions autorisées) est défini dans `conception/04-donnees/`. L'issue te donne l'ID à lire.

## 4. Vérifier et régénérer

```bash
supabase db reset && supabase test db                 # tout vert
dart run tools/gen_types.dart                         # si une table ou une colonne a changé
```

Nomme le fichier de test d'après ce qu'il vérifie (`rpc_<nom>.sql`, `i<n>_<invariant>.sql`). Un choix métier que la conception ne tranche pas s'ajoute à `docs/DECISIONS.md`.

Une RPC seule ne change pas les types, donc pas besoin de `gen_types`. Un changement de table ou de colonne demande de committer le `packages/api_types` et le `content/schema/` régénérés dans la même PR.

## Jamais

- Modifier une migration déjà fusionnée : on en écrit une nouvelle (`alter table …`, `create or replace function …`).
- `UPDATE … set statut` hors d'une RPC.
- Une colonne enum nullable : `gen_types` refuse de générer, à cause d'un bug de supadart. Mets une valeur par défaut.
