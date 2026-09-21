-- RPC pin_soumettre (brouillon -> en_revue) + garantie AD-6 : pin.statut ne se
-- modifie jamais par UPDATE direct, seulement par une RPC de transition ;
-- chaque transition écrit sa trace_validation ; seul un membre de l'équipe
-- peut l'exécuter.
begin;
select plan(6);

insert into auth.users (id, email) values ('44444444-4444-4444-4444-444444444442', 'membre-soumettre@histolyon.local');
insert into membre_equipe (compte_id, role) values ('44444444-4444-4444-4444-444444444442', 'editeur');
insert into auth.users (id, email) values ('55555555-5555-5555-5555-555555555552', 'non-membre-soumettre@histolyon.local');
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444442', true);

insert into categorie (id, slug, libelle, ordre) values ('11111111-1111-1111-1111-111111111115', 'test-categorie-soumettre', 'Catégorie test', 1);
insert into pin (id, slug, titre, categorie_id, statut) values ('22222222-2222-2222-2222-222222222225', 'test-pin-soumettre', 'Pin brouillon', '11111111-1111-1111-1111-111111111115', 'brouillon');

select set_config('request.jwt.claim.sub', '55555555-5555-5555-5555-555555555552', true);
select throws_ok(
    $$ select pin_soumettre('22222222-2222-2222-2222-222222222225'::uuid) $$,
    'P0001',
    'seul un membre de l''équipe peut effectuer cette transition',
    'pin_soumettre refuse un appelant absent de membre_equipe'
);
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444442', true);

select throws_ok(
    $$ update pin set statut = 'en_revue' where id = '22222222-2222-2222-2222-222222222225' $$,
    'P0001',
    'pin.statut ne se modifie que par une RPC de transition (pin_soumettre/pin_valider/pin_publier/pin_retirer), jamais par UPDATE direct',
    'un UPDATE direct de pin.statut est refusé (AD-6)'
);

select lives_ok(
    $$ select pin_soumettre('22222222-2222-2222-2222-222222222225'::uuid) $$,
    'pin_soumettre réussit sur un Pin brouillon'
);

select is(
    (select statut::text from pin where id = '22222222-2222-2222-2222-222222222225'),
    'en_revue',
    'le Pin passe bien au statut en_revue'
);

select is(
    (select count(*)::int from trace_validation where pin_id = '22222222-2222-2222-2222-222222222225' and decision = 'soumis'),
    1,
    'pin_soumettre écrit sa trace_validation (AD-6)'
);

select throws_ok(
    $$ select pin_soumettre('22222222-2222-2222-2222-222222222225'::uuid) $$,
    'P0001',
    'pin_soumettre exige le statut brouillon (statut actuel : en_revue)',
    'pin_soumettre refuse un Pin déjà en_revue'
);

select * from finish();
rollback;
