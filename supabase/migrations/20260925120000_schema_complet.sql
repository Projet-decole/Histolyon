-- 20260925120000_schema_complet.sql
-- Complète le schéma serveur pour que les features puissent démarrer sans
-- écrire de SQL de structure : toutes les tables côté serveur des clusters
-- C1 (contenu), C2 (parcours), C3 (compte), C4 (communauté) existent ici,
-- avec leurs policies RLS de lecture et d'écriture de base.
--
-- Ce que cette migration NE fait PAS (volontairement laissé aux issues) :
-- les RPC de transition des nouveaux cycles de vie (parcours, commentaire,
-- retour_parcours, signalement, compte) — les colonnes `statut` sont déjà
-- protégées contre l'UPDATE direct, il ne reste qu'à écrire la RPC dans le
-- même style que pin_publier.
--
-- Hors serveur, par décision (voir docs/DECISIONS.md, 2026-09-25) :
-- Profil, Favori, Historique de visite et Parcours personnels vivent dans la
-- base locale Drift (I6, AD-4) ; Lien universel = URL dérivée du slug (pas
-- de table) ; Image partageable et Code visuel sont générés côté app ;
-- Template et Couche cartographique sont décrits dans le code, pas en base.

-- =============================================================================
-- Enums
-- =============================================================================
create type statut_parcours as enum ('brouillon', 'en_revue', 'valide', 'publie', 'retire');
create type provenance_parcours as enum ('editorial', 'communautaire');
create type densite_contenu as enum ('legere', 'intermediaire', 'dense');
create type type_media as enum (
    'image', 'archive_colorisee', 'archive_brute',
    'audio_narration', 'audio_ambiance', 'element_interactif'
);
create type statut_compte as enum ('actif', 'suspendu', 'supprime');
create type statut_contribution as enum ('en_attente', 'publie', 'refuse', 'masque', 'supprime_par_auteur');
create type statut_signalement as enum ('nouveau', 'en_examen', 'rejete', 'remedie');
create type motif_signalement as enum ('inapproprie', 'historiquement_faux', 'hors_sujet', 'atteinte_vie_privee', 'autre');
create type decision_moderation as enum (
    'publie', 'refuse', 'masque', 'demasque', 'rejete', 'remedie',
    'valide_sources_verifiees', 'retire_sources_insuffisantes'
);
create type action_moderation as enum ('aucune', 'cible_masquee', 'cible_retiree', 'cible_corrigee');

-- =============================================================================
-- Fonctions utilitaires pour les policies (security definer : lisent
-- membre_equipe sans dépendre de sa propre RLS).
-- =============================================================================
create function est_membre_equipe()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
    select exists (select 1 from membre_equipe where compte_id = auth.uid());
$$;

create function est_moderateur()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
    select exists (select 1 from membre_equipe where compte_id = auth.uid() and role = 'moderateur');
$$;

-- Garde générique des colonnes de cycle de vie (AD-6) : même mécanisme que
-- pin_interdire_changement_statut_direct (0001_socle.sql). Une RPC de
-- transition positionne histolyon.transition_autorisee = on avant d'écrire.
create function interdire_changement_statut_direct()
returns trigger
language plpgsql
as $$
begin
    if new.statut is distinct from old.statut
        and coalesce(current_setting('histolyon.transition_autorisee', true), 'off') <> 'on'
    then
        raise exception '%.statut ne se modifie que par une RPC de transition, jamais par UPDATE direct', tg_table_name;
    end if;
    return new;
end;
$$;

create function interdire_modification_append_only()
returns trigger
language plpgsql
as $$
begin
    raise exception '% est append-only : % interdit', tg_table_name, tg_op;
end;
$$;

-- =============================================================================
-- compte — C3. L'email reste dans auth.users (I1 : jamais d'identité civile).
-- =============================================================================
create table compte (
    id uuid primary key references auth.users (id) on delete cascade,
    pseudonyme text not null unique check (pseudonyme <> ''),
    avatar text,
    statut statut_compte not null default 'actif',
    created_at timestamptz not null default now()
);

comment on table compte is 'Compte pseudonyme (C3). Opt-in : un Profil anonyme local n''a pas de ligne ici (I6).';

create trigger compte_statut_proteger
    before update on compte
    for each row execute function interdire_changement_statut_direct();

-- =============================================================================
-- badge — C1, catalogue fermé
-- =============================================================================
create table badge (
    id uuid primary key default gen_random_uuid(),
    slug text not null unique,
    libelle text not null check (libelle <> ''),
    description text not null,
    created_at timestamptz not null default now()
);

-- =============================================================================
-- pin — compléments C1
-- =============================================================================
alter table pin add column badge_id uuid references badge (id);
alter table pin add column auteur_communautaire_id uuid references compte (id) on delete set null;
-- Pas de CHECK « auteur obligatoire si communautaire » : la suppression d'un
-- Compte anonymise ses contributions (set null) sans les effacer.

-- pins_liés (n-n, orienté)
create table pin_lie (
    pin_id uuid not null references pin (id) on delete cascade,
    pin_lie_id uuid not null references pin (id) on delete cascade,
    primary key (pin_id, pin_lie_id),
    constraint pin_lie_pas_soi_meme check (pin_id <> pin_lie_id)
);

-- =============================================================================
-- media — C1, appartient à exactement 1 Pin
-- =============================================================================
create table media (
    id uuid primary key default gen_random_uuid(),
    pin_id uuid not null references pin (id) on delete cascade,
    type type_media not null,
    chemin_storage text not null check (chemin_storage <> ''),
    credit text not null check (credit <> ''),
    legende text,
    description text,
    ordre integer not null default 0,
    created_at timestamptz not null default now()
);

comment on column media.chemin_storage is 'Chemin dans Supabase Storage (bucket/chemin). Aucun média dans le dépôt Git.';

create index media_pin_id_idx on media (pin_id);

-- =============================================================================
-- modele_3d — C1 (D8), consultation 3D et AR
-- =============================================================================
create table modele_3d (
    id uuid primary key default gen_random_uuid(),
    slug text not null unique,
    titre text not null check (titre <> ''),
    epoque_id uuid not null references epoque (id),
    pin_id uuid references pin (id) on delete set null,
    chemin_storage text not null check (chemin_storage <> ''),
    -- Ancrage AR (latitude, longitude, altitude) ; absent = consultation 3D seule.
    ancrage geography (pointz, 4326),
    -- Orientation du modèle en degrés par rapport au nord, pour l'AR.
    cap_degres real,
    echelle real not null default 1,
    description text,
    created_at timestamptz not null default now()
);

create table modele_3d_source (
    modele_3d_id uuid not null references modele_3d (id) on delete cascade,
    source_id uuid not null references source_documentaire (id),
    primary key (modele_3d_id, source_id)
);

create index modele_3d_pin_id_idx on modele_3d (pin_id);

-- =============================================================================
-- fragment_musical — C1 (D7.3)
-- =============================================================================
create table fragment_musical (
    id uuid primary key default gen_random_uuid(),
    slug text not null unique,
    titre text not null check (titre <> ''),
    epoque_id uuid not null references epoque (id),
    chemin_storage text not null check (chemin_storage <> ''),
    credit text not null check (credit <> ''),
    description text,
    created_at timestamptz not null default now()
);

create table pin_fragment_musical (
    pin_id uuid not null references pin (id) on delete cascade,
    fragment_musical_id uuid not null references fragment_musical (id),
    primary key (pin_id, fragment_musical_id)
);

-- =============================================================================
-- parcours / etape — C2. Les Parcours personnels restent en local (Drift).
-- =============================================================================
create table parcours (
    id uuid primary key default gen_random_uuid(),
    slug text not null unique,
    titre text not null check (titre <> ''),
    provenance provenance_parcours not null default 'editorial',
    statut statut_parcours not null default 'brouillon',
    teaser_narratif text,
    conclusion_narrative text,
    signature_editoriale text,
    auteur_communautaire_id uuid references compte (id) on delete set null,
    badge_id uuid references badge (id),
    image_ouverture_media_id uuid references media (id) on delete set null,
    duree_estimee_minutes integer check (duree_estimee_minutes > 0),
    distance_estimee_metres integer check (distance_estimee_metres > 0),
    densite densite_contenu not null default 'intermediaire',
    retours_actifs boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

comment on table parcours is 'Parcours éditorial ou communautaire (C2). Minimum 2 étapes et ≥ 1 époque : vérifiés par la RPC de soumission/publication, pas par contrainte (un brouillon se construit progressivement).';

create trigger parcours_statut_proteger
    before update on parcours
    for each row execute function interdire_changement_statut_direct();

create table parcours_epoque (
    parcours_id uuid not null references parcours (id) on delete cascade,
    epoque_id uuid not null references epoque (id),
    primary key (parcours_id, epoque_id)
);

create table etape (
    id uuid primary key default gen_random_uuid(),
    parcours_id uuid not null references parcours (id) on delete cascade,
    position integer not null check (position >= 1),
    pin_id uuid not null references pin (id),
    introduction text,
    -- Transition narrative depuis l'étape précédente (null pour la 1re).
    transition_depuis_precedente text,
    constraint etape_position_unique unique (parcours_id, position) deferrable initially deferred
);

create index etape_parcours_id_idx on etape (parcours_id);
create index parcours_statut_idx on parcours (statut);

-- =============================================================================
-- commentaire / retour_parcours — C4, modération a priori (I3)
-- =============================================================================
create table commentaire (
    id uuid primary key default gen_random_uuid(),
    pin_id uuid not null references pin (id) on delete cascade,
    auteur_id uuid not null references compte (id) on delete cascade,
    contenu text not null check (contenu <> ''),
    statut statut_contribution not null default 'en_attente',
    motif_de_refus text,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create trigger commentaire_statut_proteger
    before update on commentaire
    for each row execute function interdire_changement_statut_direct();

create index commentaire_pin_id_idx on commentaire (pin_id);

create table retour_parcours (
    id uuid primary key default gen_random_uuid(),
    parcours_id uuid not null references parcours (id) on delete cascade,
    auteur_id uuid not null references compte (id) on delete cascade,
    -- Échelle discrète 1..5 (forme d'affichage décidée côté écran).
    evaluation smallint not null check (evaluation between 1 and 5),
    commentaire_libre text,
    statut statut_contribution not null default 'en_attente',
    motif_de_refus text,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint retour_parcours_un_par_auteur unique (parcours_id, auteur_id)
);

create trigger retour_parcours_statut_proteger
    before update on retour_parcours
    for each row execute function interdire_changement_statut_direct();

-- =============================================================================
-- signalement — C4, polymorphe (docs/conventions/polymorphisme.md), I5
-- =============================================================================
create table signalement (
    id uuid primary key default gen_random_uuid(),
    signaleur_id uuid not null references compte (id) on delete cascade,
    type_de_cible type_de_cible not null,
    cible_id uuid not null,
    motif motif_signalement not null,
    precision_libre text,
    statut statut_signalement not null default 'nouveau',
    created_at timestamptz not null default now()
);

create trigger signalement_statut_proteger
    before update on signalement
    for each row execute function interdire_changement_statut_direct();

create index signalement_cible_idx on signalement (type_de_cible, cible_id);

-- =============================================================================
-- trace_moderation — C4, append-only, écrite par les RPC de modération
-- =============================================================================
create table trace_moderation (
    id uuid primary key default gen_random_uuid(),
    type_de_cible text not null check (type_de_cible in ('pin', 'parcours', 'commentaire', 'retour_parcours', 'signalement')),
    cible_id uuid not null,
    moderateur uuid not null references auth.users (id),
    decision decision_moderation not null,
    motif text,
    action_prise action_moderation not null default 'aucune',
    horodatage timestamptz not null default now()
);

create index trace_moderation_cible_idx on trace_moderation (type_de_cible, cible_id);

create trigger trace_moderation_immuable
    before update or delete on trace_moderation
    for each row execute function interdire_modification_append_only();

-- =============================================================================
-- RLS
-- =============================================================================
alter table compte enable row level security;
alter table badge enable row level security;
alter table pin_lie enable row level security;
alter table media enable row level security;
alter table modele_3d enable row level security;
alter table modele_3d_source enable row level security;
alter table fragment_musical enable row level security;
alter table pin_fragment_musical enable row level security;
alter table parcours enable row level security;
alter table parcours_epoque enable row level security;
alter table etape enable row level security;
alter table commentaire enable row level security;
alter table retour_parcours enable row level security;
alter table signalement enable row level security;
alter table trace_moderation enable row level security;

-- Visibilité d'un Pin, factorisée pour les tables filles.
-- I3 : un Pin communautaire est visible dès en_revue (avec marque distinctive
-- côté app) ; un Pin éditorial seulement une fois publié.
create function pin_est_visible(p_pin_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
    select exists (
        select 1 from pin
        where id = p_pin_id
          and (
              statut = 'publie'
              or (provenance = 'communautaire' and statut in ('en_revue', 'valide'))
              or auteur_communautaire_id = auth.uid()
              or est_membre_equipe()
          )
    );
$$;

create function parcours_est_visible(p_parcours_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
    select exists (
        select 1 from parcours
        where id = p_parcours_id
          and (statut = 'publie' or auteur_communautaire_id = auth.uid() or est_membre_equipe())
    );
$$;

-- pin : la policy de 0001 est remplacée pour intégrer I3 et l'auteur.
drop policy pin_lecture_publique on pin;
create policy pin_lecture on pin for select using (
    statut = 'publie'
    or (provenance = 'communautaire' and statut in ('en_revue', 'valide'))
    or auteur_communautaire_id = auth.uid()
    or est_membre_equipe()
);

-- Un Compte peut créer un Pin communautaire en brouillon à son nom (I2).
create policy pin_creation_communautaire on pin for insert with check (
    provenance = 'communautaire'
    and statut = 'brouillon'
    and auteur_communautaire_id = auth.uid()
    and exists (select 1 from compte where id = auth.uid() and statut = 'actif')
);

create policy pin_maj_auteur_brouillon on pin for update using (
    auteur_communautaire_id = auth.uid() and statut = 'brouillon'
) with check (
    auteur_communautaire_id = auth.uid() and provenance = 'communautaire'
);

-- compte : lecture publique du pseudonyme/avatar ; chacun crée et édite le sien.
create policy compte_lecture_publique on compte for select using (statut = 'actif' or id = auth.uid() or est_membre_equipe());
create policy compte_creation_soi on compte for insert with check (id = auth.uid() and statut = 'actif');
create policy compte_maj_soi on compte for update using (id = auth.uid()) with check (id = auth.uid());

-- Catalogues et contenu éditorial : lecture publique, écriture équipe.
create policy badge_lecture_publique on badge for select using (true);
create policy badge_ecriture_equipe on badge for all using (est_membre_equipe()) with check (est_membre_equipe());

create policy fragment_musical_lecture_publique on fragment_musical for select using (true);
create policy fragment_musical_ecriture_equipe on fragment_musical for all using (est_membre_equipe()) with check (est_membre_equipe());

create policy modele_3d_lecture_publique on modele_3d for select using (pin_id is null or pin_est_visible(pin_id));
create policy modele_3d_ecriture_equipe on modele_3d for all using (est_membre_equipe()) with check (est_membre_equipe());

create policy modele_3d_source_lecture_publique on modele_3d_source for select using (true);
create policy modele_3d_source_ecriture_equipe on modele_3d_source for all using (est_membre_equipe()) with check (est_membre_equipe());

-- Tables filles d'un Pin : visibles si le Pin l'est.
create policy media_lecture on media for select using (pin_est_visible(pin_id));
create policy media_ecriture_equipe on media for all using (est_membre_equipe()) with check (est_membre_equipe());

create policy pin_lie_lecture on pin_lie for select using (pin_est_visible(pin_id) and pin_est_visible(pin_lie_id));
create policy pin_lie_ecriture_equipe on pin_lie for all using (est_membre_equipe()) with check (est_membre_equipe());

create policy pin_fragment_musical_lecture on pin_fragment_musical for select using (pin_est_visible(pin_id));
create policy pin_fragment_musical_ecriture_equipe on pin_fragment_musical for all using (est_membre_equipe()) with check (est_membre_equipe());

-- parcours : public si publié ; l'auteur communautaire gère son brouillon.
create policy parcours_lecture on parcours for select using (
    statut = 'publie' or auteur_communautaire_id = auth.uid() or est_membre_equipe()
);
create policy parcours_ecriture_equipe on parcours for all using (est_membre_equipe()) with check (est_membre_equipe());
create policy parcours_creation_communautaire on parcours for insert with check (
    provenance = 'communautaire'
    and statut = 'brouillon'
    and auteur_communautaire_id = auth.uid()
    and exists (select 1 from compte where id = auth.uid() and statut = 'actif')
);
create policy parcours_maj_auteur_brouillon on parcours for update using (
    auteur_communautaire_id = auth.uid() and statut = 'brouillon'
) with check (
    auteur_communautaire_id = auth.uid() and provenance = 'communautaire'
);

create policy parcours_epoque_lecture on parcours_epoque for select using (parcours_est_visible(parcours_id));
create policy parcours_epoque_ecriture on parcours_epoque for all using (
    est_membre_equipe()
    or exists (select 1 from parcours p where p.id = parcours_id and p.auteur_communautaire_id = auth.uid() and p.statut = 'brouillon')
) with check (
    est_membre_equipe()
    or exists (select 1 from parcours p where p.id = parcours_id and p.auteur_communautaire_id = auth.uid() and p.statut = 'brouillon')
);

create policy etape_lecture on etape for select using (parcours_est_visible(parcours_id));
create policy etape_ecriture on etape for all using (
    est_membre_equipe()
    or exists (select 1 from parcours p where p.id = parcours_id and p.auteur_communautaire_id = auth.uid() and p.statut = 'brouillon')
) with check (
    est_membre_equipe()
    or exists (select 1 from parcours p where p.id = parcours_id and p.auteur_communautaire_id = auth.uid() and p.statut = 'brouillon')
);

-- commentaire / retour_parcours : visibles publiés ; l'auteur voit les siens ;
-- création en_attente uniquement (modération a priori, I3) par un Compte actif (I2).
create policy commentaire_lecture on commentaire for select using (
    (statut = 'publie' and pin_est_visible(pin_id)) or auteur_id = auth.uid() or est_moderateur()
);
create policy commentaire_creation on commentaire for insert with check (
    auteur_id = auth.uid()
    and statut = 'en_attente'
    and exists (select 1 from compte where id = auth.uid() and statut = 'actif')
    and pin_est_visible(pin_id)
);
create policy commentaire_maj_auteur on commentaire for update using (auteur_id = auth.uid() and statut = 'en_attente')
    with check (auteur_id = auth.uid());

create policy retour_parcours_lecture on retour_parcours for select using (
    (statut = 'publie' and parcours_est_visible(parcours_id)) or auteur_id = auth.uid() or est_moderateur()
);
create policy retour_parcours_creation on retour_parcours for insert with check (
    auteur_id = auth.uid()
    and statut = 'en_attente'
    and exists (select 1 from compte where id = auth.uid() and statut = 'actif')
    and exists (
        select 1 from parcours p
        where p.id = parcours_id and p.provenance = 'communautaire' and p.statut = 'publie' and p.retours_actifs
    )
);
create policy retour_parcours_maj_auteur on retour_parcours for update using (auteur_id = auth.uid() and statut = 'en_attente')
    with check (auteur_id = auth.uid());

-- signalement : I5 — seuls le signaleur et les modérateurs le voient.
create policy signalement_lecture on signalement for select using (signaleur_id = auth.uid() or est_moderateur());
create policy signalement_creation on signalement for insert with check (
    signaleur_id = auth.uid()
    and statut = 'nouveau'
    and exists (select 1 from compte where id = auth.uid() and statut = 'actif')
);

-- trace_moderation : lecture équipe, écriture uniquement par RPC (security definer).
create policy trace_moderation_lecture_equipe on trace_moderation for select using (est_membre_equipe());
