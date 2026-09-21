-- I8 — Un Pin peut être associé à plusieurs Époques (relation n-n).
begin;
select plan(2);

insert into categorie (id, slug, libelle, ordre) values ('11111111-1111-1111-1111-111111111112', 'test-categorie-i8', 'Catégorie test I8', 1);
insert into pin (id, slug, titre, categorie_id, statut) values ('22222222-2222-2222-2222-222222222223', 'test-pin-i8', 'Pin multi-époques', '11111111-1111-1111-1111-111111111112', 'brouillon');
insert into epoque (id, slug, libelle, borne_debut, borne_fin, ordre) values
    ('33333333-3333-3333-3333-333333333331', 'test-epoque-i8-a', 'Époque A', 1000, 1100, 1),
    ('33333333-3333-3333-3333-333333333332', 'test-epoque-i8-b', 'Époque B', 1500, 1600, 2);

select lives_ok(
    $$ insert into pin_epoque (pin_id, epoque_id) values
        ('22222222-2222-2222-2222-222222222223', '33333333-3333-3333-3333-333333333331'),
        ('22222222-2222-2222-2222-222222222223', '33333333-3333-3333-3333-333333333332')
    $$,
    'un même Pin peut être associé à 2 Époques distinctes (I8)'
);

select is(
    (select count(*)::int from pin_epoque where pin_id = '22222222-2222-2222-2222-222222222223'),
    2,
    'les 2 associations Pin-Époque sont bien enregistrées'
);

select * from finish();
rollback;
