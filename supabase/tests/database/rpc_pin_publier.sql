-- RPC pin_publier (valide -> publie).
begin;
select plan(6);

insert into auth.users (id, email) values ('44444444-4444-4444-4444-444444444444', 'membre-publier@histolyon.local');
insert into membre_equipe (compte_id, role) values ('44444444-4444-4444-4444-444444444444', 'validateur');
insert into auth.users (id, email) values ('55555555-5555-5555-5555-555555555554', 'non-membre-publier@histolyon.local');
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444444', true);

insert into categorie (id, slug, libelle, ordre) values ('11111111-1111-1111-1111-111111111117', 'test-categorie-publier', 'Catégorie test', 1);
insert into pin (id, slug, titre, categorie_id, statut) values ('22222222-2222-2222-2222-222222222227', 'test-pin-publier', 'Pin valide', '11111111-1111-1111-1111-111111111117', 'valide');
insert into pin (id, slug, titre, categorie_id, statut) values ('22222222-2222-2222-2222-22222222222a', 'test-pin-publier-brouillon', 'Pin brouillon', '11111111-1111-1111-1111-111111111117', 'brouillon');

select set_config('request.jwt.claim.sub', '55555555-5555-5555-5555-555555555554', true);
select throws_ok(
    $$ select pin_publier('22222222-2222-2222-2222-222222222227'::uuid) $$,
    'P0001',
    'seul un membre de l''équipe peut effectuer cette transition',
    'pin_publier refuse un appelant absent de membre_equipe'
);
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444444', true);

select throws_ok(
    $$ select pin_publier('22222222-2222-2222-2222-222222222229'::uuid) $$,
    'P0001',
    'pin 22222222-2222-2222-2222-222222222229 introuvable',
    'pin_publier refuse un identifiant de Pin inexistant'
);

select throws_ok(
    $$ select pin_publier('22222222-2222-2222-2222-22222222222a'::uuid) $$,
    'P0001',
    'pin_publier exige le statut valide (statut actuel : brouillon)',
    'pin_publier refuse un Pin qui n''est pas valide'
);

select lives_ok(
    $$ select pin_publier('22222222-2222-2222-2222-222222222227'::uuid) $$,
    'pin_publier réussit sur un Pin valide'
);

select is(
    (select statut::text from pin where id = '22222222-2222-2222-2222-222222222227'),
    'publie',
    'le Pin passe bien au statut publie'
);

select is(
    (select count(*)::int from trace_validation where pin_id = '22222222-2222-2222-2222-222222222227' and decision = 'publie'),
    1,
    'pin_publier écrit sa trace_validation (AD-6)'
);

select * from finish();
rollback;
