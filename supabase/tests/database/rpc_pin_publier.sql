-- RPC pin_publier (valide -> publie).
begin;
select plan(3);

insert into auth.users (id, email) values ('44444444-4444-4444-4444-444444444444', 'membre-publier@histolyon.local');
insert into membre_equipe (compte_id, role) values ('44444444-4444-4444-4444-444444444444', 'validateur');
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444444', true);

insert into categorie (id, slug, libelle, ordre) values ('11111111-1111-1111-1111-111111111117', 'test-categorie-publier', 'Catégorie test', 1);
insert into pin (id, slug, titre, categorie_id, statut) values ('22222222-2222-2222-2222-222222222227', 'test-pin-publier', 'Pin valide', '11111111-1111-1111-1111-111111111117', 'valide');

select throws_ok(
    $$ select pin_publier('22222222-2222-2222-2222-222222222229'::uuid) $$,
    'P0001',
    'pin 22222222-2222-2222-2222-222222222229 introuvable',
    'pin_publier refuse un identifiant de Pin inexistant'
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

select * from finish();
rollback;
