-- I9 — Un Pin sans coordonnées géographiques existe mais ne s'affiche pas sur
-- la Carte (filtré côté requête applicative sur localisation is not null).
begin;
select plan(3);

insert into categorie (id, slug, libelle, ordre) values ('11111111-1111-1111-1111-111111111111', 'test-categorie-i9', 'Catégorie test I9', 1);

select lives_ok(
    $$ insert into pin (id, slug, titre, categorie_id, statut) values ('22222222-2222-2222-2222-222222222222', 'test-pin-i9', 'Pin sans localisation', '11111111-1111-1111-1111-111111111111', 'brouillon') $$,
    'un Pin sans localisation peut être créé (I9)'
);

select is(
    (select localisation from pin where id = '22222222-2222-2222-2222-222222222222'),
    null,
    'la localisation est bien absente (NULL), pas une valeur par défaut arbitraire'
);

select is(
    (select count(*)::int from pin where id = '22222222-2222-2222-2222-222222222222' and localisation is not null),
    0,
    'une requête filtrant sur localisation is not null exclut ce Pin (comportement carte)'
);

select * from finish();
rollback;
