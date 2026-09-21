-- I7 — Catégories et Époques sont des catalogues ouverts : addition libre à
-- tout moment, pas de mécanisme d'archivage.
begin;
select plan(4);

select lives_ok(
    $$ insert into categorie (slug, libelle, ordre) values ('test-categorie-i7', 'Catégorie de test', 1) $$,
    'une nouvelle Catégorie peut être ajoutée à tout moment'
);

select lives_ok(
    $$ insert into epoque (slug, libelle, borne_debut, borne_fin, ordre) values ('test-epoque-i7', 'Époque de test', 1800, 1900, 1) $$,
    'une nouvelle Époque peut être ajoutée à tout moment'
);

select hasnt_column('public', 'categorie', 'archive', 'categorie n''a pas de colonne d''archivage (catalogue ouvert)');
select hasnt_column('public', 'epoque', 'archive', 'epoque n''a pas de colonne d''archivage (catalogue ouvert)');

select * from finish();
rollback;
