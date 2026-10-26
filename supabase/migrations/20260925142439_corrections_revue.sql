-- 20260925142439_corrections_revue.sql — #113
-- Corrige les écarts relevés par la revue de code du dossier supabase/ :
-- visibilité I3 incomplète, contournements d'AD-6, anonymisation à la
-- suppression d'un compte (docs/DECISIONS.md, 2026-09-25), contraintes et index.

-- =============================================================================
-- pin_valider : le type de validation est déduit, jamais fourni par l'appelant
-- (conception 04-donnees/05-production : auto_validation si validateur =
-- auteur du Pin). L'auteur est celui qui l'a soumis (dernière Trace « soumis »)
-- ou, pour un Pin communautaire, son auteur_communautaire_id.
-- =============================================================================
drop function pin_valider(uuid, text, text);

create function pin_valider(p_pin_id uuid, p_motif text default null)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
    v_statut statut_pin;
    v_auteur_communautaire uuid;
    v_soumetteur uuid;
    v_type text;
begin
    perform verifier_membre_equipe();

    select statut, auteur_communautaire_id into v_statut, v_auteur_communautaire
    from pin where id = p_pin_id for update;
    if not found then
        raise exception 'pin % introuvable', p_pin_id;
    end if;
    if v_statut <> 'en_revue' then
        raise exception 'pin_valider exige le statut en_revue (statut actuel : %)', v_statut;
    end if;

    if not exists (select 1 from pin_source where pin_id = p_pin_id) then
        raise exception 'pin_valider exige au moins une Source rattachée (I4) — pin %', p_pin_id;
    end if;

    select validateur into v_soumetteur
    from trace_validation
    where pin_id = p_pin_id and decision = 'soumis'
    order by horodatage desc
    limit 1;

    if auth.uid() = v_soumetteur or auth.uid() = v_auteur_communautaire then
        v_type := 'auto_validation';
    else
        v_type := 'validation_par_tiers';
    end if;

    perform set_config('histolyon.transition_autorisee', 'on', true);
    update pin set statut = 'valide' where id = p_pin_id;
    perform set_config('histolyon.transition_autorisee', 'off', true);

    insert into trace_validation (pin_id, validateur, decision, type_de_validation, motif)
    values (p_pin_id, auth.uid(), 'approuve', v_type, p_motif);
end;
$$;

-- Par défaut PostgreSQL accorde EXECUTE à PUBLIC : le grant seul ne restreint
-- rien. Les RPC de transition ne sont appelables que par un utilisateur connecté.
revoke execute on function pin_soumettre(uuid) from public, anon;
revoke execute on function pin_valider(uuid, text) from public, anon;
revoke execute on function pin_publier(uuid) from public, anon;
revoke execute on function pin_retirer(uuid) from public, anon;
grant execute on function pin_valider(uuid, text) to authenticated;

-- =============================================================================
-- AD-6 : cycle de vie
-- =============================================================================

-- Le trigger générique tient updated_at à jour, comme sa version pin, sur les
-- tables qui ont la colonne (compte et signalement ne l'ont pas).
create or replace function interdire_changement_statut_direct()
returns trigger
language plpgsql
as $$
begin
    if new.statut is distinct from old.statut
        and coalesce(current_setting('histolyon.transition_autorisee', true), 'off') <> 'on'
    then
        raise exception '%.statut ne se modifie que par une RPC de transition, jamais par UPDATE direct', tg_table_name;
    end if;
    if to_jsonb(new) ? 'updated_at' then
        new := jsonb_populate_record(new, jsonb_build_object('updated_at', now()));
    end if;
    return new;
end;
$$;

-- provenance est une colonne de cycle de vie (AD-6) : la promotion I10 passera
-- par une RPC, jamais par UPDATE direct.
create function interdire_changement_provenance_direct()
returns trigger
language plpgsql
as $$
begin
    if new.provenance::text is distinct from old.provenance::text
        and coalesce(current_setting('histolyon.transition_autorisee', true), 'off') <> 'on'
    then
        raise exception '%.provenance ne se modifie que par une RPC de transition, jamais par UPDATE direct', tg_table_name;
    end if;
    return new;
end;
$$;

create trigger pin_provenance_proteger
    before update on pin
    for each row execute function interdire_changement_provenance_direct();

create trigger parcours_provenance_proteger
    before update on parcours
    for each row execute function interdire_changement_provenance_direct();

-- Un client (rôle authenticated, y compris un membre de l'équipe via l'admin)
-- crée toujours en brouillon : sinon un INSERT direct en `publie` contournerait
-- I4 et la Trace. Le seed (service_role) et les tests (postgres) ne sont pas
-- concernés.
create function imposer_statut_initial_brouillon()
returns trigger
language plpgsql
as $$
begin
    if current_user = 'authenticated' and new.statut::text <> 'brouillon' then
        raise exception '% naît en brouillon ; les changements de statut passent par une RPC de transition', tg_table_name;
    end if;
    return new;
end;
$$;

create trigger pin_statut_initial
    before insert on pin
    for each row execute function imposer_statut_initial_brouillon();

create trigger parcours_statut_initial
    before insert on parcours
    for each row execute function imposer_statut_initial_brouillon();

-- =============================================================================
-- I3 : tables filles d'un Pin alignées sur pin_est_visible ; Parcours
-- communautaires visibles dès en_revue, comme les Pins.
-- =============================================================================
drop policy pin_epoque_lecture on pin_epoque;
create policy pin_epoque_lecture on pin_epoque for select using (pin_est_visible(pin_id));

drop policy pin_source_lecture on pin_source;
create policy pin_source_lecture on pin_source for select using (pin_est_visible(pin_id));

create or replace function parcours_est_visible(p_parcours_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
    select exists (
        select 1 from parcours
        where id = p_parcours_id
          and (
              statut = 'publie'
              or (provenance = 'communautaire' and statut in ('en_revue', 'valide'))
              or auteur_communautaire_id = auth.uid()
              or est_membre_equipe()
          )
    );
$$;

drop policy parcours_lecture on parcours;
create policy parcours_lecture on parcours for select using (
    statut = 'publie'
    or (provenance = 'communautaire' and statut in ('en_revue', 'valide'))
    or auteur_communautaire_id = auth.uid()
    or est_membre_equipe()
);

-- =============================================================================
-- Écritures d'auteur : l'auteur d'un Pin communautaire brouillon lie ses
-- époques et sources (symétrie avec parcours_epoque / etape) ; une écriture
-- ne peut jamais viser un contenu invisible pour son auteur.
-- =============================================================================
drop policy pin_epoque_ecriture_equipe on pin_epoque;
create policy pin_epoque_ecriture on pin_epoque for all using (
    est_membre_equipe()
    or exists (select 1 from pin p where p.id = pin_id and p.auteur_communautaire_id = auth.uid() and p.statut = 'brouillon')
) with check (
    est_membre_equipe()
    or exists (select 1 from pin p where p.id = pin_id and p.auteur_communautaire_id = auth.uid() and p.statut = 'brouillon')
);

drop policy pin_source_ecriture_equipe on pin_source;
create policy pin_source_ecriture on pin_source for all using (
    est_membre_equipe()
    or exists (select 1 from pin p where p.id = pin_id and p.auteur_communautaire_id = auth.uid() and p.statut = 'brouillon')
) with check (
    est_membre_equipe()
    or exists (select 1 from pin p where p.id = pin_id and p.auteur_communautaire_id = auth.uid() and p.statut = 'brouillon')
);

drop policy etape_ecriture on etape;
create policy etape_ecriture on etape for all using (
    est_membre_equipe()
    or exists (select 1 from parcours p where p.id = parcours_id and p.auteur_communautaire_id = auth.uid() and p.statut = 'brouillon')
) with check (
    est_membre_equipe()
    or (
        exists (select 1 from parcours p where p.id = parcours_id and p.auteur_communautaire_id = auth.uid() and p.statut = 'brouillon')
        and pin_est_visible(pin_id)
    )
);

drop policy commentaire_maj_auteur on commentaire;
create policy commentaire_maj_auteur on commentaire for update using (auteur_id = auth.uid() and statut = 'en_attente')
    with check (auteur_id = auth.uid() and pin_est_visible(pin_id));

drop policy retour_parcours_maj_auteur on retour_parcours;
create policy retour_parcours_maj_auteur on retour_parcours for update using (auteur_id = auth.uid() and statut = 'en_attente')
    with check (
        auteur_id = auth.uid()
        and exists (
            select 1 from parcours p
            where p.id = parcours_id and p.provenance = 'communautaire' and p.statut = 'publie' and p.retours_actifs
        )
    );

-- =============================================================================
-- Suppression d'un compte (DECISIONS 2026-09-25) : traces d'audit et
-- signalements anonymisés, contenus rédigés effacés (cascade inchangée).
-- =============================================================================
alter table trace_validation alter column validateur drop not null;
alter table trace_validation drop constraint trace_validation_validateur_fkey;
alter table trace_validation add constraint trace_validation_validateur_fkey
    foreign key (validateur) references auth.users (id) on delete set null;

alter table trace_moderation alter column moderateur drop not null;
alter table trace_moderation drop constraint trace_moderation_moderateur_fkey;
alter table trace_moderation add constraint trace_moderation_moderateur_fkey
    foreign key (moderateur) references auth.users (id) on delete set null;

alter table signalement alter column signaleur_id drop not null;
alter table signalement drop constraint signalement_signaleur_id_fkey;
alter table signalement add constraint signalement_signaleur_id_fkey
    foreign key (signaleur_id) references compte (id) on delete set null;

-- Append-only, sauf l'anonymisation : seule la colonne d'auteur passée en
-- argument peut devenir NULL, rien d'autre ne change.
create function trace_append_only_sauf_anonymisation()
returns trigger
language plpgsql
as $$
declare
    v_colonne text := tg_argv[0];
begin
    if tg_op = 'UPDATE'
        and to_jsonb(new) ->> v_colonne is null
        and (to_jsonb(new) - v_colonne) = (to_jsonb(old) - v_colonne)
    then
        return new;
    end if;
    raise exception '% est append-only : % interdit', tg_table_name, tg_op;
end;
$$;

drop trigger trace_validation_immuable on trace_validation;
create trigger trace_validation_immuable
    before update or delete on trace_validation
    for each row execute function trace_append_only_sauf_anonymisation('validateur');

drop trigger trace_moderation_immuable on trace_moderation;
create trigger trace_moderation_immuable
    before update or delete on trace_moderation
    for each row execute function trace_append_only_sauf_anonymisation('moderateur');

-- =============================================================================
-- Contraintes de données
-- =============================================================================

-- Pseudonyme : pas d'usurpation par la casse ou les espaces, jamais blanc.
alter table compte add constraint compte_pseudonyme_non_blanc check (btrim(pseudonyme) <> '');
create unique index compte_pseudonyme_unique_idx on compte (lower(btrim(pseudonyme)));

-- Ancrage AR cohérent.
alter table modele_3d add constraint modele_3d_cap_degres_borne check (cap_degres >= 0 and cap_degres < 360);
alter table modele_3d add constraint modele_3d_echelle_positive check (echelle > 0);

-- =============================================================================
-- Index des colonnes lues par la RLS et par le filtre d'époque
-- =============================================================================
create index pin_auteur_communautaire_id_idx on pin (auteur_communautaire_id);
create index pin_epoque_epoque_id_idx on pin_epoque (epoque_id);
create index parcours_auteur_communautaire_id_idx on parcours (auteur_communautaire_id);
create index parcours_epoque_epoque_id_idx on parcours_epoque (epoque_id);
create index etape_pin_id_idx on etape (pin_id);
create index commentaire_auteur_id_idx on commentaire (auteur_id);
create index retour_parcours_auteur_id_idx on retour_parcours (auteur_id);
create index signalement_signaleur_id_idx on signalement (signaleur_id);
create index modele_3d_epoque_id_idx on modele_3d (epoque_id);
