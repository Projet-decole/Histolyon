-- 0001_socle.sql
-- Schéma minimal du cluster C1 (Contenu), RLS, RPC de transition et garanties
-- d'intégrité pour le socle HistoLyon (AD-2, AD-6, AD-14, AD-16).
--
-- Portée : membre_equipe, epoque, categorie, pin, source_documentaire,
-- trace_validation. Le contenu narratif détaillé, les médias, les parcours,
-- les comptes/profils (cluster C3) et le communautaire (I2, I3, I5, I6, I10)
-- arrivent avec des épics ultérieurs — cette migration ne modélise que ce que
-- l'Epic 3 exige explicitement.

-- =============================================================================
-- Extensions
-- =============================================================================
create extension if not exists postgis;
create extension if not exists pgtap;

-- =============================================================================
-- Enums
-- =============================================================================
create type statut_pin as enum ('brouillon', 'en_revue', 'valide', 'publie', 'retire');
create type provenance_pin as enum ('editorial', 'communautaire');
-- Cible polymorphe future (Signalement, Favori, Lien universel — clusters C4/C6,
-- pas encore modélisés) : l'enum est créé maintenant pour fixer la convention de
-- nommage (docs/conventions/polymorphisme.md, Story 2.5), étendu par ALTER TYPE
-- ADD VALUE quand ces tables arriveront.
create type type_de_cible as enum ('pin', 'parcours', 'commentaire', 'retour_parcours');
create type role_equipe as enum ('editeur', 'validateur', 'moderateur');

-- =============================================================================
-- membre_equipe — rôles d'équipe (AD-2)
-- =============================================================================
create table membre_equipe (
    compte_id uuid primary key references auth.users (id) on delete cascade,
    role role_equipe not null,
    created_at timestamptz not null default now()
);

comment on table membre_equipe is 'Rôle d''équipe par compte Supabase Auth (AD-2). Pas d''identité civile stockée (I1).';

-- =============================================================================
-- categorie — catalogue ouvert (I7)
-- =============================================================================
create table categorie (
    id uuid primary key default gen_random_uuid(),
    slug text not null unique,
    libelle text not null check (libelle <> ''),
    description text,
    ordre integer not null,
    created_at timestamptz not null default now()
);

comment on table categorie is 'Catalogue ouvert (I7) : addition libre, jamais d''archivage.';

-- =============================================================================
-- epoque — catalogue ouvert (I7), bornes numériques (I8 : multi-époques ailleurs)
-- =============================================================================
create table epoque (
    id uuid primary key default gen_random_uuid(),
    slug text not null unique,
    libelle text not null check (libelle <> ''),
    borne_debut integer not null,
    borne_fin integer not null,
    ordre integer not null,
    created_at timestamptz not null default now(),
    constraint epoque_bornes_coherentes check (borne_debut <= borne_fin)
);

comment on table epoque is 'Catalogue ouvert (I7). Bornes en années (négatif = avant J.-C.), simplification numérique de "année ou expression de période" (palier 4) pour piloter le slider.';

-- =============================================================================
-- source_documentaire (I4)
-- =============================================================================
create table source_documentaire (
    id uuid primary key default gen_random_uuid(),
    slug text not null unique,
    type text not null check (type in ('livre', 'archive', 'article', 'entretien', 'photo', 'page_web', 'autre')),
    reference text not null check (reference <> ''),
    credit text not null check (credit <> ''),
    lien text,
    description text,
    created_at timestamptz not null default now()
);

comment on table source_documentaire is 'Documente une affirmation d''un Pin (I4). Le crédit est obligatoire.';

-- =============================================================================
-- pin — unité atomique de contenu (cœur du cluster C1)
-- =============================================================================
create table pin (
    id uuid primary key default gen_random_uuid(),
    slug text not null unique,
    titre text not null check (titre <> ''),
    provenance provenance_pin not null default 'editorial',
    categorie_id uuid not null references categorie (id),
    contenu_narratif jsonb not null default '{}'::jsonb,
    statut statut_pin not null default 'brouillon',
    -- I9 : localisation optionnelle, un Pin sans coordonnées existe mais ne
    -- s'affiche pas sur la carte (filtré côté requête applicative).
    localisation geography (point, 4326),
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

comment on table pin is 'Unité atomique de contenu géolocalisé (cluster C1, palier 4). auteur_communautaire différé à l''épic qui introduit les Comptes.';

-- I8 : un Pin est associé à ≥ 1 Époque, relation n-n.
create table pin_epoque (
    pin_id uuid not null references pin (id) on delete cascade,
    epoque_id uuid not null references epoque (id),
    primary key (pin_id, epoque_id)
);

-- Un Pin référence ≥ 1 Source pour atteindre l'état validé (I4), relation n-n.
create table pin_source (
    pin_id uuid not null references pin (id) on delete cascade,
    source_id uuid not null references source_documentaire (id),
    primary key (pin_id, source_id)
);

create index pin_categorie_id_idx on pin (categorie_id);
create index pin_statut_idx on pin (statut);
create index pin_localisation_idx on pin using gist (localisation);

-- =============================================================================
-- trace_validation — audit append-only (I1 : pas d'identité civile, pseudonyme
-- via auth.users uniquement)
-- =============================================================================
create table trace_validation (
    id uuid primary key default gen_random_uuid(),
    pin_id uuid not null references pin (id),
    validateur uuid not null references auth.users (id),
    decision text not null check (decision in ('approuve', 'demande_complement', 'refuse')),
    type_de_validation text not null check (type_de_validation in ('auto_validation', 'validation_par_tiers')),
    motif text,
    horodatage timestamptz not null default now()
);

comment on table trace_validation is 'Une Trace par décision, jamais modifiée ni supprimée après création (append-only).';

create index trace_validation_pin_id_idx on trace_validation (pin_id);

-- Immutabilité : une Trace ne peut être ni modifiée ni supprimée après création.
create function trace_validation_interdire_modification()
returns trigger
language plpgsql
as $$
begin
    raise exception 'trace_validation est append-only : % interdit sur trace_validation (id=%)', tg_op, old.id;
end;
$$;

create trigger trace_validation_immuable
    before update or delete on trace_validation
    for each row
    execute function trace_validation_interdire_modification();

-- =============================================================================
-- pin.statut : colonne de cycle de vie non modifiable par UPDATE direct (AD-6).
-- Les RPC de transition ci-dessous positionnent un paramètre de session avant
-- d'écrire, que ce trigger exige.
-- =============================================================================
create function pin_interdire_changement_statut_direct()
returns trigger
language plpgsql
as $$
begin
    if new.statut is distinct from old.statut
        and coalesce(current_setting('histolyon.transition_autorisee', true), 'off') <> 'on'
    then
        raise exception 'pin.statut ne se modifie que par une RPC de transition (pin_soumettre/pin_valider/pin_publier/pin_retirer), jamais par UPDATE direct';
    end if;
    new.updated_at := now();
    return new;
end;
$$;

create trigger pin_statut_proteger
    before update on pin
    for each row
    execute function pin_interdire_changement_statut_direct();

-- =============================================================================
-- Fonction utilitaire partagée par les RPC de transition : vérifie que
-- l'appelant est un membre de l'équipe (tout rôle confondu — les rôles fins
-- par transition ne sont pas encore spécifiés par la conception).
-- =============================================================================
create function verifier_membre_equipe()
returns void
language plpgsql
as $$
begin
    if not exists (select 1 from membre_equipe where compte_id = auth.uid()) then
        raise exception 'seul un membre de l''équipe peut effectuer cette transition';
    end if;
end;
$$;

-- =============================================================================
-- RPC de transition (AD-6) — voir aussi supabase/functions_sql/pin_transitions.sql
-- pour la copie de référence lisible de ces 4 fonctions.
-- =============================================================================

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

-- =============================================================================
-- RLS
-- =============================================================================
alter table membre_equipe enable row level security;
alter table categorie enable row level security;
alter table epoque enable row level security;
alter table source_documentaire enable row level security;
alter table pin enable row level security;
alter table pin_epoque enable row level security;
alter table pin_source enable row level security;
alter table trace_validation enable row level security;

-- Catalogues ouverts : lecture publique (I7).
create policy categorie_lecture_publique on categorie for select using (true);
create policy epoque_lecture_publique on epoque for select using (true);

-- Sources : lecture publique (attribution/crédit affichés côté app).
create policy source_documentaire_lecture_publique on source_documentaire for select using (true);

-- membre_equipe : chacun ne voit que sa propre ligne ; pas de lecture publique.
create policy membre_equipe_lecture_soi on membre_equipe for select using (auth.uid() = compte_id);

-- pin : lecture publique des seuls pins publiés ; les membres de l'équipe
-- voient tout (pour l'admin de validation).
create policy pin_lecture_publique on pin for select using (
    statut = 'publie'
    or exists (select 1 from membre_equipe where compte_id = auth.uid())
);

create policy pin_epoque_lecture on pin_epoque for select using (
    exists (
        select 1 from pin
        where pin.id = pin_epoque.pin_id
          and (pin.statut = 'publie' or exists (select 1 from membre_equipe where compte_id = auth.uid()))
    )
);

create policy pin_source_lecture on pin_source for select using (
    exists (
        select 1 from pin
        where pin.id = pin_source.pin_id
          and (pin.statut = 'publie' or exists (select 1 from membre_equipe where compte_id = auth.uid()))
    )
);

-- trace_validation : réservée aux membres de l'équipe (audit interne).
create policy trace_validation_lecture_equipe on trace_validation for select using (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
);

-- Écritures : uniquement par les membres de l'équipe (seed/admin), au-delà des
-- RPC de transition qui gèrent statut/trace_validation elles-mêmes.
create policy categorie_ecriture_equipe on categorie for all using (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
) with check (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
);

create policy epoque_ecriture_equipe on epoque for all using (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
) with check (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
);

create policy source_documentaire_ecriture_equipe on source_documentaire for all using (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
) with check (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
);

create policy pin_ecriture_equipe on pin for insert with check (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
);

create policy pin_maj_equipe on pin for update using (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
);

create policy pin_epoque_ecriture_equipe on pin_epoque for all using (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
) with check (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
);

create policy pin_source_ecriture_equipe on pin_source for all using (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
) with check (
    exists (select 1 from membre_equipe where compte_id = auth.uid())
);
