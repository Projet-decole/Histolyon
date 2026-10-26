-- AD-6 — Colonnes de cycle de vie (statut, provenance) : jamais modifiées hors
-- RPC, y compris à l'INSERT par un client, et updated_at tenu à jour.
begin;
select plan(9);

insert into auth.users (id, email) values
    ('a6000000-0000-0000-0000-000000000001', 'membre-ad6@histolyon.local'),
    ('a6000000-0000-0000-0000-000000000002', 'auteur-ad6@histolyon.local');
insert into membre_equipe (compte_id, role) values ('a6000000-0000-0000-0000-000000000001', 'editeur');
insert into compte (id, pseudonyme) values ('a6000000-0000-0000-0000-000000000002', 'ad6-auteur');
insert into categorie (id, slug, libelle, ordre) values ('c6000000-0000-0000-0000-000000000001', 'test-cat-ad6', 'Cat', 1);
insert into pin (id, slug, titre, categorie_id, statut, provenance, auteur_communautaire_id) values
    ('b6000000-0000-0000-0000-000000000001', 'ad6-communautaire', 'Communautaire', 'c6000000-0000-0000-0000-000000000001', 'en_revue', 'communautaire', 'a6000000-0000-0000-0000-000000000002'),
    ('b6000000-0000-0000-0000-000000000002', 'ad6-publie', 'Publié', 'c6000000-0000-0000-0000-000000000001', 'publie', 'editorial', null);
insert into parcours (id, slug, titre, provenance, statut, auteur_communautaire_id, updated_at) values
    ('d6000000-0000-0000-0000-000000000001', 'ad6-parcours-brouillon', 'Brouillon', 'communautaire', 'brouillon', 'a6000000-0000-0000-0000-000000000002', '2000-01-01T00:00:00Z');
insert into retour_parcours (id, parcours_id, auteur_id, evaluation) values
    ('e6000000-0000-0000-0000-000000000001', 'd6000000-0000-0000-0000-000000000001', 'a6000000-0000-0000-0000-000000000002', 4);

-- updated_at (trigger générique) : se met à jour à chaque UPDATE.
update parcours set titre = 'Brouillon renommé' where id = 'd6000000-0000-0000-0000-000000000001';
select ok(
    (select updated_at > '2000-01-01T00:00:00Z' from parcours where id = 'd6000000-0000-0000-0000-000000000001'),
    'parcours.updated_at est mis à jour par UPDATE'
);

-- Membre de l'équipe via l'API : naît en brouillon, provenance figée.
set local role authenticated;
select set_config('request.jwt.claim.sub', 'a6000000-0000-0000-0000-000000000001', true);
select throws_ok(
    $$ insert into pin (slug, titre, categorie_id, statut) values ('ad6-direct-publie', 'X', 'c6000000-0000-0000-0000-000000000001', 'publie') $$,
    'P0001',
    null,
    'un membre ne peut pas insérer un pin directement publié (contournerait I4 et la trace)'
);
select throws_ok(
    $$ insert into parcours (slug, titre, statut) values ('ad6-parcours-publie', 'X', 'publie') $$,
    'P0001',
    null,
    'un membre ne peut pas insérer un parcours directement publié'
);
select lives_ok(
    $$ insert into pin (slug, titre, categorie_id) values ('ad6-brouillon', 'X', 'c6000000-0000-0000-0000-000000000001') $$,
    'un membre peut créer un pin en brouillon'
);
select throws_ok(
    $$ update pin set provenance = 'editorial' where id = 'b6000000-0000-0000-0000-000000000001' $$,
    'P0001',
    null,
    'pin.provenance ne change pas par UPDATE direct (promotion I10 = RPC)'
);

-- Propriétaire d'un compte / d'un parcours / d'un retour : statut protégé.
select set_config('request.jwt.claim.sub', 'a6000000-0000-0000-0000-000000000002', true);
select throws_ok(
    $$ update compte set statut = 'suspendu' where id = 'a6000000-0000-0000-0000-000000000002' $$,
    'P0001',
    null,
    'compte.statut ne change pas par UPDATE direct'
);
select throws_ok(
    $$ update parcours set statut = 'publie' where id = 'd6000000-0000-0000-0000-000000000001' $$,
    'P0001',
    null,
    'parcours.statut ne change pas par UPDATE direct'
);
select throws_ok(
    $$ update retour_parcours set statut = 'publie' where id = 'e6000000-0000-0000-0000-000000000001' $$,
    'P0001',
    null,
    'retour_parcours.statut ne change pas par UPDATE direct'
);
select throws_ok(
    $$ update parcours set provenance = 'editorial' where id = 'd6000000-0000-0000-0000-000000000001' $$,
    'P0001',
    null,
    'parcours.provenance ne change pas par UPDATE direct'
);

select * from finish();
rollback;
