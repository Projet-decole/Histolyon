-- Schéma complet (20260925120000) : RLS active partout, I2, I3, I5, AD-6.
begin;
select plan(11);

-- Aucune table publique sans RLS.
select is(
    (select count(*)::int from pg_tables where schemaname = 'public' and not rowsecurity and tablename <> 'spatial_ref_sys'),
    0,
    'toutes les tables du schéma public (hors spatial_ref_sys de PostGIS) ont la RLS activée'
);

-- Données : un compte actif, un utilisateur sans compte, un pin éditorial
-- brouillon, un pin éditorial publié, un pin communautaire en_revue.
insert into auth.users (id, email) values
    ('a0000000-0000-0000-0000-000000000001', 'auteur@histolyon.local'),
    ('a0000000-0000-0000-0000-000000000002', 'sans-compte@histolyon.local'),
    ('a0000000-0000-0000-0000-000000000003', 'autre@histolyon.local');
insert into compte (id, pseudonyme) values
    ('a0000000-0000-0000-0000-000000000001', 'canut42'),
    ('a0000000-0000-0000-0000-000000000003', 'traboule');
insert into categorie (id, slug, libelle, ordre) values ('c0000000-0000-0000-0000-000000000001', 'test-cat-rls', 'Cat', 1);
insert into pin (id, slug, titre, categorie_id, statut, provenance, auteur_communautaire_id) values
    ('b0000000-0000-0000-0000-000000000001', 'rls-brouillon', 'Brouillon', 'c0000000-0000-0000-0000-000000000001', 'brouillon', 'editorial', null),
    ('b0000000-0000-0000-0000-000000000002', 'rls-publie', 'Publié', 'c0000000-0000-0000-0000-000000000001', 'publie', 'editorial', null),
    ('b0000000-0000-0000-0000-000000000003', 'rls-communautaire', 'Communautaire', 'c0000000-0000-0000-0000-000000000001', 'en_revue', 'communautaire', 'a0000000-0000-0000-0000-000000000001');

-- Visiteur anonyme.
set local role anon;
select is(
    (select count(*)::int from pin where slug like 'rls-%'),
    2,
    'anonyme : voit le pin publié et le pin communautaire en_revue (I3), pas le brouillon éditorial'
);

-- Compte actif.
set local role authenticated;
select set_config('request.jwt.claim.sub', 'a0000000-0000-0000-0000-000000000001', true);

select lives_ok(
    $$ insert into commentaire (pin_id, auteur_id, contenu) values ('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'Superbe') $$,
    'un compte actif peut commenter un pin visible'
);
select is(
    (select statut::text from commentaire where contenu = 'Superbe'),
    'en_attente',
    'un commentaire naît en_attente (modération a priori, I3)'
);
select throws_ok(
    $$ insert into commentaire (pin_id, auteur_id, contenu, statut) values ('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'Triche', 'publie') $$,
    '42501',
    null,
    'impossible de créer un commentaire directement publié'
);
select throws_ok(
    $$ update commentaire set statut = 'publie' where contenu = 'Superbe' $$,
    'P0001',
    null,
    'commentaire.statut ne change pas par UPDATE direct (AD-6)'
);
select lives_ok(
    $$ insert into signalement (signaleur_id, type_de_cible, cible_id, motif) values ('a0000000-0000-0000-0000-000000000001', 'pin', 'b0000000-0000-0000-0000-000000000003', 'historiquement_faux') $$,
    'un compte actif peut signaler'
);

-- Autre compte : ne voit ni le signalement (I5) ni le commentaire en attente.
select set_config('request.jwt.claim.sub', 'a0000000-0000-0000-0000-000000000003', true);
select is((select count(*)::int from signalement), 0, 'un signalement est invisible des autres comptes (I5)');
select is((select count(*)::int from commentaire), 0, 'un commentaire en_attente est invisible des autres comptes');

-- Utilisateur authentifié sans compte pseudonyme : ne peut pas publier (I2).
select set_config('request.jwt.claim.sub', 'a0000000-0000-0000-0000-000000000002', true);
select throws_ok(
    $$ insert into commentaire (pin_id, auteur_id, contenu) values ('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000002', 'Sans compte') $$,
    '42501',
    null,
    'sans Compte, pas de commentaire (I2)'
);
select throws_ok(
    $$ insert into pin (slug, titre, categorie_id, provenance, auteur_communautaire_id) values ('rls-sans-compte', 'X', 'c0000000-0000-0000-0000-000000000001', 'communautaire', 'a0000000-0000-0000-0000-000000000002') $$,
    '42501',
    null,
    'sans Compte, pas de pin communautaire (I2)'
);

select * from finish();
rollback;
