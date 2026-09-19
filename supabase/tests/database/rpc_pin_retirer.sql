-- RPC pin_retirer (publie -> retire).
begin;
select plan(3);

insert into auth.users (id, email) values ('44444444-4444-4444-4444-444444444445', 'membre-retirer@histolyon.local');
insert into membre_equipe (compte_id, role) values ('44444444-4444-4444-4444-444444444445', 'moderateur');
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444445', true);

insert into categorie (id, slug, libelle, ordre) values ('11111111-1111-1111-1111-111111111118', 'test-categorie-retirer', 'Catégorie test', 1);
insert into pin (id, slug, titre, categorie_id, statut) values ('22222222-2222-2222-2222-222222222228', 'test-pin-retirer', 'Pin publié', '11111111-1111-1111-1111-111111111118', 'publie');

select throws_ok(
    $$ select pin_retirer('22222222-2222-2222-2222-222222222226'::uuid) $$,
    'P0001',
    'pin 22222222-2222-2222-2222-222222222226 introuvable',
    'pin_retirer refuse un identifiant de Pin inexistant'
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

select * from finish();
rollback;
