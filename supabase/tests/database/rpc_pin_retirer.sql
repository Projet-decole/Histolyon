-- RPC pin_retirer (publie -> retire).
begin;
select plan(6);

insert into auth.users (id, email) values ('44444444-4444-4444-4444-444444444445', 'membre-retirer@histolyon.local');
insert into membre_equipe (compte_id, role) values ('44444444-4444-4444-4444-444444444445', 'moderateur');
insert into auth.users (id, email) values ('55555555-5555-5555-5555-555555555555', 'non-membre-retirer@histolyon.local');
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444445', true);

insert into categorie (id, slug, libelle, ordre) values ('11111111-1111-1111-1111-111111111118', 'test-categorie-retirer', 'Catégorie test', 1);
insert into pin (id, slug, titre, categorie_id, statut) values ('22222222-2222-2222-2222-222222222228', 'test-pin-retirer', 'Pin publié', '11111111-1111-1111-1111-111111111118', 'publie');
insert into pin (id, slug, titre, categorie_id, statut) values ('22222222-2222-2222-2222-22222222222b', 'test-pin-retirer-valide', 'Pin valide', '11111111-1111-1111-1111-111111111118', 'valide');

select set_config('request.jwt.claim.sub', '55555555-5555-5555-5555-555555555555', true);
select throws_ok(
    $$ select pin_retirer('22222222-2222-2222-2222-222222222228'::uuid) $$,
    'P0001',
    'seul un membre de l''équipe peut effectuer cette transition',
    'pin_retirer refuse un appelant absent de membre_equipe'
);
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444445', true);

select throws_ok(
    $$ select pin_retirer('22222222-2222-2222-2222-222222222226'::uuid) $$,
    'P0001',
    'pin 22222222-2222-2222-2222-222222222226 introuvable',
    'pin_retirer refuse un identifiant de Pin inexistant'
);

select throws_ok(
    $$ select pin_retirer('22222222-2222-2222-2222-22222222222b'::uuid) $$,
    'P0001',
    'pin_retirer exige le statut publie (statut actuel : valide)',
    'pin_retirer refuse un Pin qui n''est pas publié'
);

select lives_ok(
    $$ select pin_retirer('22222222-2222-2222-2222-222222222228'::uuid) $$,
    'pin_retirer réussit sur un Pin publié'
);

select is(
    (select statut::text from pin where id = '22222222-2222-2222-2222-222222222228'),
    'retire',
    'le Pin passe bien au statut retire'
);

select is(
    (select count(*)::int from trace_validation where pin_id = '22222222-2222-2222-2222-222222222228' and decision = 'retire'),
    1,
    'pin_retirer écrit sa trace_validation (AD-6)'
);

select * from finish();
rollback;
