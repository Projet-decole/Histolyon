-- RPC pin_valider (en_revue -> valide) : garde de statut (I4 est testée
-- séparément dans i4_source_obligatoire_validation.sql), et garde
-- d'autorisation (seul un membre de l'équipe peut valider).
begin;
select plan(3);

insert into auth.users (id, email) values ('44444444-4444-4444-4444-444444444443', 'membre-valider@histolyon.local');
insert into membre_equipe (compte_id, role) values ('44444444-4444-4444-4444-444444444443', 'validateur');
insert into auth.users (id, email) values ('55555555-5555-5555-5555-555555555553', 'non-membre-valider@histolyon.local');
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444443', true);

insert into categorie (id, slug, libelle, ordre) values ('11111111-1111-1111-1111-111111111116', 'test-categorie-valider', 'Catégorie test', 1);
insert into pin (id, slug, titre, categorie_id, statut) values ('22222222-2222-2222-2222-222222222226', 'test-pin-valider', 'Pin brouillon', '11111111-1111-1111-1111-111111111116', 'brouillon');

select set_config('request.jwt.claim.sub', '55555555-5555-5555-5555-555555555553', true);
select throws_ok(
    $$ select pin_valider('22222222-2222-2222-2222-222222222226'::uuid) $$,
    'P0001',
    'seul un membre de l''équipe peut effectuer cette transition',
    'pin_valider refuse un appelant absent de membre_equipe'
);
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444443', true);

select throws_ok(
    $$ select pin_valider('22222222-2222-2222-2222-222222222226'::uuid) $$,
    'P0001',
    'pin_valider exige le statut en_revue (statut actuel : brouillon)',
    'pin_valider refuse un Pin encore brouillon'
);

select throws_ok(
    $$ select pin_valider('00000000-0000-0000-0000-000000000000'::uuid) $$,
    'P0001',
    'pin 00000000-0000-0000-0000-000000000000 introuvable',
    'pin_valider refuse un identifiant de Pin inexistant'
);

select * from finish();
rollback;
