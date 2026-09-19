-- pin_transitions.sql — copie de référence lisible des 4 RPC de transition du
-- cycle de vie Pin (AD-6). Le SQL réellement exécuté par `supabase db reset`
-- vit dans `supabase/migrations/0001_socle.sql` (Postgres n'a pas de mécanisme
-- d'inclusion entre fichiers de migration) ; ce fichier est tenu synchronisé à
-- la main, comme `docs/ARCHITECTURE-SPINE.md` est une copie de référence de la
-- spine. Toute modification de ces fonctions doit être faite dans la migration
-- d'abord, puis recopiée ici à l'identique.

-- brouillon -> en_revue
create function pin_soumettre(p_pin_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
    v_statut statut_pin;
begin
    perform verifier_membre_equipe();

    select statut into v_statut from pin where id = p_pin_id for update;
    if not found then
        raise exception 'pin % introuvable', p_pin_id;
    end if;
    if v_statut <> 'brouillon' then
        raise exception 'pin_soumettre exige le statut brouillon (statut actuel : %)', v_statut;
    end if;

    perform set_config('histolyon.transition_autorisee', 'on', true);
    update pin set statut = 'en_revue' where id = p_pin_id;
    perform set_config('histolyon.transition_autorisee', 'off', true);
end;
$$;

-- en_revue -> valide (I4 : au moins une Source rattachée)
create function pin_valider(p_pin_id uuid, p_type_de_validation text default 'validation_par_tiers', p_motif text default null)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
    v_statut statut_pin;
    v_nb_sources integer;
begin
    perform verifier_membre_equipe();

    select statut into v_statut from pin where id = p_pin_id for update;
    if not found then
        raise exception 'pin % introuvable', p_pin_id;
    end if;
    if v_statut <> 'en_revue' then
        raise exception 'pin_valider exige le statut en_revue (statut actuel : %)', v_statut;
    end if;

    select count(*) into v_nb_sources from pin_source where pin_id = p_pin_id;
    if v_nb_sources < 1 then
        raise exception 'pin_valider exige au moins une Source rattachée (I4) — pin %', p_pin_id;
    end if;

    if p_type_de_validation not in ('auto_validation', 'validation_par_tiers') then
        raise exception 'type_de_validation invalide : %', p_type_de_validation;
    end if;

    perform set_config('histolyon.transition_autorisee', 'on', true);
    update pin set statut = 'valide' where id = p_pin_id;
    perform set_config('histolyon.transition_autorisee', 'off', true);

    insert into trace_validation (pin_id, validateur, decision, type_de_validation, motif)
    values (p_pin_id, auth.uid(), 'approuve', p_type_de_validation, p_motif);
end;
$$;

-- valide -> publie
create function pin_publier(p_pin_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
    v_statut statut_pin;
begin
    perform verifier_membre_equipe();

    select statut into v_statut from pin where id = p_pin_id for update;
    if not found then
        raise exception 'pin % introuvable', p_pin_id;
    end if;
    if v_statut <> 'valide' then
        raise exception 'pin_publier exige le statut valide (statut actuel : %)', v_statut;
    end if;

    perform set_config('histolyon.transition_autorisee', 'on', true);
    update pin set statut = 'publie' where id = p_pin_id;
    perform set_config('histolyon.transition_autorisee', 'off', true);
end;
$$;

-- publie -> retire
create function pin_retirer(p_pin_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
    v_statut statut_pin;
begin
    perform verifier_membre_equipe();

    select statut into v_statut from pin where id = p_pin_id for update;
    if not found then
        raise exception 'pin % introuvable', p_pin_id;
    end if;
    if v_statut <> 'publie' then
        raise exception 'pin_retirer exige le statut publie (statut actuel : %)', v_statut;
    end if;

    perform set_config('histolyon.transition_autorisee', 'on', true);
    update pin set statut = 'retire' where id = p_pin_id;
    perform set_config('histolyon.transition_autorisee', 'off', true);
end;
$$;

grant execute on function pin_soumettre(uuid) to authenticated;
grant execute on function pin_valider(uuid, text, text) to authenticated;
grant execute on function pin_publier(uuid) to authenticated;
grant execute on function pin_retirer(uuid) to authenticated;
