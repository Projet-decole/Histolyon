-- Suppression d'un compte (DECISIONS 2026-09-25) : les traces d'audit et les
-- signalements sont anonymisés (conservés sans auteur), les contenus rédigés
-- (commentaire, retour) sont effacés. Plus quelques contraintes de données.
begin;
select plan(10);

insert into auth.users (id, email) values
    ('a5000000-0000-0000-0000-000000000001', 'membre-supp@histolyon.local'),
    ('a5000000-0000-0000-0000-000000000002', 'compte-supp@histolyon.local');
insert into membre_equipe (compte_id, role) values ('a5000000-0000-0000-0000-000000000001', 'moderateur');
insert into compte (id, pseudonyme) values ('a5000000-0000-0000-0000-000000000002', 'Supp-Canut');
insert into categorie (id, slug, libelle, ordre) values ('c5000000-0000-0000-0000-000000000001', 'test-cat-supp', 'Cat', 1);
insert into epoque (id, slug, libelle, borne_debut, borne_fin, ordre) values ('f5000000-0000-0000-0000-000000000001', 'test-epoque-supp', 'Époque', 1800, 1900, 1);
insert into pin (id, slug, titre, categorie_id, statut) values
    ('b5000000-0000-0000-0000-000000000001', 'supp-pin', 'Pin', 'c5000000-0000-0000-0000-000000000001', 'publie');

select set_config('request.jwt.claim.sub', 'a5000000-0000-0000-0000-000000000001', true);
select pin_retirer('b5000000-0000-0000-0000-000000000001'::uuid);
insert into trace_moderation (type_de_cible, cible_id, moderateur, decision) values
    ('pin', 'b5000000-0000-0000-0000-000000000001', 'a5000000-0000-0000-0000-000000000001', 'masque');
insert into signalement (id, signaleur_id, type_de_cible, cible_id, motif) values
    ('55000000-0000-0000-0000-000000000001', 'a5000000-0000-0000-0000-000000000002', 'pin', 'b5000000-0000-0000-0000-000000000001', 'autre');
insert into commentaire (pin_id, auteur_id, contenu) values
    ('b5000000-0000-0000-0000-000000000001', 'a5000000-0000-0000-0000-000000000002', 'À effacer');

-- Les traces restent append-only pour tout autre changement.
select throws_ok(
    $$ update trace_validation set motif = 'réécrit' where pin_id = 'b5000000-0000-0000-0000-000000000001' $$,
    'P0001',
    null,
    'trace_validation reste append-only'
);

select lives_ok(
    $$ delete from auth.users where id in ('a5000000-0000-0000-0000-000000000001', 'a5000000-0000-0000-0000-000000000002') $$,
    'supprimer un membre de l''équipe et un compte réussit'
);
select is(
    (select count(*)::int from trace_validation where pin_id = 'b5000000-0000-0000-0000-000000000001' and validateur is null),
    1,
    'la trace_validation est conservée, anonymisée'
);
select is(
    (select count(*)::int from trace_moderation where cible_id = 'b5000000-0000-0000-0000-000000000001' and moderateur is null),
    1,
    'la trace_moderation est conservée, anonymisée'
);
select is(
    (select signaleur_id from signalement where id = '55000000-0000-0000-0000-000000000001'),
    null,
    'le signalement est conservé, anonymisé (preuve de modération)'
);
select is(
    (select count(*)::int from commentaire where contenu = 'À effacer'),
    0,
    'le commentaire rédigé par le compte supprimé est effacé'
);

-- Pseudonyme : unique sans tenir compte de la casse, jamais blanc.
insert into auth.users (id, email) values
    ('a5000000-0000-0000-0000-000000000003', 'pseudo1@histolyon.local'),
    ('a5000000-0000-0000-0000-000000000004', 'pseudo2@histolyon.local');
insert into compte (id, pseudonyme) values ('a5000000-0000-0000-0000-000000000003', 'Traboule');
select throws_ok(
    $$ insert into compte (id, pseudonyme) values ('a5000000-0000-0000-0000-000000000004', 'traboule') $$,
    '23505',
    null,
    'un pseudonyme ne peut pas en usurper un autre par la casse'
);
select throws_ok(
    $$ insert into compte (id, pseudonyme) values ('a5000000-0000-0000-0000-000000000004', '   ') $$,
    '23514',
    null,
    'un pseudonyme ne peut pas être blanc'
);

-- Modèle 3D : orientation et échelle cohérentes pour l'AR.
select throws_ok(
    $$ insert into modele_3d (slug, titre, epoque_id, chemin_storage, licence, cap_degres) values ('supp-3d-cap', 'X', 'f5000000-0000-0000-0000-000000000001', 'models/x.glb', 'CC0', 400) $$,
    '23514',
    null,
    'cap_degres est borné à [0, 360['
);
select throws_ok(
    $$ insert into modele_3d (slug, titre, epoque_id, chemin_storage, licence, echelle) values ('supp-3d-echelle', 'X', 'f5000000-0000-0000-0000-000000000001', 'models/x.glb', 'CC0', 0) $$,
    '23514',
    null,
    'echelle est strictement positive'
);

select * from finish();
rollback;
