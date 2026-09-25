-- RPC pin_valider (en_revue -> valide) : garde de statut (I4 est testée
-- séparément dans i4_source_obligatoire_validation.sql), et garde
-- d'autorisation (seul un membre de l'équipe peut valider), cas nominal et
-- type_de_validation déduit (05-production : auto_validation si validateur =
-- auteur, c.-à-d. celui qui a soumis le Pin ; sinon validation_par_tiers).
begin;
select plan(7);

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

-- Cas nominal : un Pin soumis par un autre membre -> validation_par_tiers ;
-- un Pin soumis par le validateur lui-même -> auto_validation.
insert into auth.users (id, email) values ('44444444-4444-4444-4444-44444444444a', 'editeur-valider@histolyon.local');
insert into membre_equipe (compte_id, role) values ('44444444-4444-4444-4444-44444444444a', 'editeur');
insert into source_documentaire (id, slug, type, reference, credit) values ('55555555-5555-5555-5555-55555555555a', 'test-source-valider', 'livre', 'Réf.', 'Crédit');
insert into pin (id, slug, titre, categorie_id, statut) values
    ('22222222-2222-2222-2222-22222222222c', 'test-pin-valider-tiers', 'Tiers', '11111111-1111-1111-1111-111111111116', 'brouillon'),
    ('22222222-2222-2222-2222-22222222222d', 'test-pin-valider-auto', 'Auto', '11111111-1111-1111-1111-111111111116', 'brouillon');
insert into pin_source (pin_id, source_id) values
    ('22222222-2222-2222-2222-22222222222c', '55555555-5555-5555-5555-55555555555a'),
    ('22222222-2222-2222-2222-22222222222d', '55555555-5555-5555-5555-55555555555a');

select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-44444444444a', true);
select pin_soumettre('22222222-2222-2222-2222-22222222222c'::uuid);
select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444443', true);
select pin_soumettre('22222222-2222-2222-2222-22222222222d'::uuid);

select lives_ok(
    $$ select pin_valider('22222222-2222-2222-2222-22222222222c'::uuid) $$,
    'pin_valider réussit sur un Pin en_revue sourcé'
);
select is(
    (select type_de_validation from trace_validation where pin_id = '22222222-2222-2222-2222-22222222222c' and decision = 'approuve'),
    'validation_par_tiers',
    'valider le Pin soumis par un autre membre est une validation par tiers'
);
select pin_valider('22222222-2222-2222-2222-22222222222d'::uuid);
select is(
    (select type_de_validation from trace_validation where pin_id = '22222222-2222-2222-2222-22222222222d' and decision = 'approuve'),
    'auto_validation',
    'valider son propre Pin est tracé en auto_validation, quel que soit l''appelant'
);
select hasnt_function(
    'public', 'pin_valider', array['uuid', 'text', 'text'],
    'le type de validation n''est plus fourni par l''appelant'
);

select * from finish();
rollback;
