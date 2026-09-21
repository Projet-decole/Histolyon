-- I4 — Aucun Pin ne peut atteindre l'état validé sans au moins une Source
-- documentaire rattachée.
begin;
select plan(4);

insert into auth.users (id, email) values ('44444444-4444-4444-4444-444444444441', 'validateur-i4@histolyon.local');
insert into membre_equipe (compte_id, role) values ('44444444-4444-4444-4444-444444444441', 'validateur');
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444441', true);

insert into categorie (id, slug, libelle, ordre) values ('11111111-1111-1111-1111-111111111114', 'test-categorie-i4', 'Catégorie test I4', 1);
insert into pin (id, slug, titre, categorie_id, statut) values ('22222222-2222-2222-2222-222222222224', 'test-pin-i4', 'Pin sans source', '11111111-1111-1111-1111-111111111114', 'en_revue');

select throws_ok(
    $$ select pin_valider('22222222-2222-2222-2222-222222222224'::uuid) $$,
    'P0001',
    'pin_valider exige au moins une Source rattachée (I4) — pin 22222222-2222-2222-2222-222222222224',
    'pin_valider refuse un Pin sans Source (I4)'
);

insert into source_documentaire (id, slug, type, reference, credit) values ('55555555-5555-5555-5555-555555555551', 'test-source-i4', 'livre', 'Réf. test', 'Crédit test');
insert into pin_source (pin_id, source_id) values ('22222222-2222-2222-2222-222222222224', '55555555-5555-5555-5555-555555555551');

select lives_ok(
    $$ select pin_valider('22222222-2222-2222-2222-222222222224'::uuid) $$,
    'pin_valider réussit une fois une Source rattachée'
);

select is(
    (select statut::text from pin where id = '22222222-2222-2222-2222-222222222224'),
    'valide',
    'le Pin passe bien au statut valide'
);

select is(
    (select decision from trace_validation where pin_id = '22222222-2222-2222-2222-222222222224'),
    'approuve',
    'une Trace de validation approuve est bien créée'
);

select * from finish();
rollback;
