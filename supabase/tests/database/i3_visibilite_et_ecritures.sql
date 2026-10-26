-- I3 — Visibilité immédiate des Pins ET Parcours communautaires, tables filles
-- alignées sur pin_est_visible / parcours_est_visible, et écritures d'auteur
-- qui ne peuvent pas viser un contenu invisible.
begin;
select plan(13);

insert into auth.users (id, email) values
    ('a3000000-0000-0000-0000-000000000001', 'auteur-i3@histolyon.local'),
    ('a3000000-0000-0000-0000-000000000002', 'autre-i3@histolyon.local');
insert into compte (id, pseudonyme) values
    ('a3000000-0000-0000-0000-000000000001', 'i3-auteur'),
    ('a3000000-0000-0000-0000-000000000002', 'i3-autre');
insert into categorie (id, slug, libelle, ordre) values ('c3000000-0000-0000-0000-000000000001', 'test-cat-i3', 'Cat', 1);
insert into epoque (id, slug, libelle, borne_debut, borne_fin, ordre) values
    ('f3000000-0000-0000-0000-000000000001', 'test-epoque-i3', 'Époque', 1800, 1900, 1),
    ('f3000000-0000-0000-0000-000000000002', 'test-epoque-i3-bis', 'Époque bis', 1900, 2000, 2);
insert into source_documentaire (id, slug, type, reference, credit) values
    ('53000000-0000-0000-0000-000000000001', 'test-source-i3', 'livre', 'Réf.', 'Crédit');
insert into pin (id, slug, titre, categorie_id, statut, provenance, auteur_communautaire_id) values
    ('b3000000-0000-0000-0000-000000000001', 'i3-brouillon', 'Brouillon éditorial', 'c3000000-0000-0000-0000-000000000001', 'brouillon', 'editorial', null),
    ('b3000000-0000-0000-0000-000000000002', 'i3-publie', 'Publié', 'c3000000-0000-0000-0000-000000000001', 'publie', 'editorial', null),
    ('b3000000-0000-0000-0000-000000000003', 'i3-communautaire', 'Communautaire en revue', 'c3000000-0000-0000-0000-000000000001', 'en_revue', 'communautaire', 'a3000000-0000-0000-0000-000000000001'),
    ('b3000000-0000-0000-0000-000000000004', 'i3-communautaire-brouillon', 'Communautaire brouillon', 'c3000000-0000-0000-0000-000000000001', 'brouillon', 'communautaire', 'a3000000-0000-0000-0000-000000000001');
insert into pin_epoque (pin_id, epoque_id) values ('b3000000-0000-0000-0000-000000000003', 'f3000000-0000-0000-0000-000000000001');
insert into pin_source (pin_id, source_id) values ('b3000000-0000-0000-0000-000000000003', '53000000-0000-0000-0000-000000000001');
insert into media (pin_id, type, chemin_storage, credit, licence) values
    ('b3000000-0000-0000-0000-000000000001', 'image', 'images/i3-brouillon.webp', 'Crédit', 'CC-BY 4.0'),
    ('b3000000-0000-0000-0000-000000000002', 'image', 'images/i3-publie.webp', 'Crédit', 'CC-BY 4.0');
insert into parcours (id, slug, titre, provenance, statut, auteur_communautaire_id) values
    ('d3000000-0000-0000-0000-000000000001', 'i3-parcours-communautaire', 'En revue', 'communautaire', 'en_revue', 'a3000000-0000-0000-0000-000000000001'),
    ('d3000000-0000-0000-0000-000000000002', 'i3-parcours-brouillon', 'Brouillon éditorial', 'editorial', 'brouillon', null),
    ('d3000000-0000-0000-0000-000000000003', 'i3-parcours-auteur', 'Brouillon auteur', 'communautaire', 'brouillon', 'a3000000-0000-0000-0000-000000000001');
insert into etape (parcours_id, pin_id, position) values ('d3000000-0000-0000-0000-000000000002', 'b3000000-0000-0000-0000-000000000002', 1);
insert into commentaire (id, pin_id, auteur_id, contenu) values
    ('13000000-0000-0000-0000-000000000001', 'b3000000-0000-0000-0000-000000000002', 'a3000000-0000-0000-0000-000000000001', 'En attente');

-- Visiteur anonyme.
set local role anon;
select is(
    (select count(*)::int from pin_epoque where pin_id = 'b3000000-0000-0000-0000-000000000003'),
    1,
    'anonyme : les époques d''un pin communautaire en_revue sont visibles (sinon absent du slider)'
);
select is(
    (select count(*)::int from pin_source where pin_id = 'b3000000-0000-0000-0000-000000000003'),
    1,
    'anonyme : les sources d''un pin communautaire en_revue sont visibles'
);
select is(
    (select count(*)::int from parcours where slug like 'i3-parcours-%'),
    1,
    'anonyme : un parcours communautaire en_revue est visible (I3), pas les brouillons'
);
select is(
    (select count(*)::int from media where chemin_storage like 'images/i3-%'),
    1,
    'anonyme : seul le média du pin publié est visible, pas celui du brouillon'
);
select is(
    (select count(*)::int from etape where parcours_id = 'd3000000-0000-0000-0000-000000000002'),
    0,
    'anonyme : les étapes d''un parcours brouillon sont invisibles'
);
select is(
    (select count(*)::int from pin_epoque where pin_id = 'b3000000-0000-0000-0000-000000000001'),
    0,
    'anonyme : les époques d''un brouillon éditorial restent invisibles'
);

-- Auteur communautaire.
set local role authenticated;
select set_config('request.jwt.claim.sub', 'a3000000-0000-0000-0000-000000000001', true);
select lives_ok(
    $$ insert into pin_epoque (pin_id, epoque_id) values ('b3000000-0000-0000-0000-000000000004', 'f3000000-0000-0000-0000-000000000001') $$,
    'l''auteur lie une époque à son pin communautaire brouillon'
);
select lives_ok(
    $$ insert into pin_source (pin_id, source_id) values ('b3000000-0000-0000-0000-000000000004', '53000000-0000-0000-0000-000000000001') $$,
    'l''auteur lie une source à son pin communautaire brouillon (I4)'
);
select throws_ok(
    $$ insert into pin_epoque (pin_id, epoque_id) values ('b3000000-0000-0000-0000-000000000003', 'f3000000-0000-0000-0000-000000000002') $$,
    '42501',
    null,
    'l''auteur ne modifie plus les époques d''un pin sorti du brouillon'
);
select throws_ok(
    $$ update commentaire set pin_id = 'b3000000-0000-0000-0000-000000000001' where id = '13000000-0000-0000-0000-000000000001' $$,
    '42501',
    null,
    'un commentaire ne peut pas être déplacé vers un pin invisible'
);
select throws_ok(
    $$ insert into etape (parcours_id, pin_id, position) values ('d3000000-0000-0000-0000-000000000003', 'b3000000-0000-0000-0000-000000000001', 1) $$,
    '42501',
    null,
    'une étape ne peut pas viser un pin invisible pour l''auteur'
);

-- Autre compte : n'écrit pas dans le pin d'autrui.
select set_config('request.jwt.claim.sub', 'a3000000-0000-0000-0000-000000000002', true);
select throws_ok(
    $$ insert into pin_epoque (pin_id, epoque_id) values ('b3000000-0000-0000-0000-000000000004', 'f3000000-0000-0000-0000-000000000002') $$,
    '42501',
    null,
    'un autre compte ne lie pas d''époque au pin d''autrui'
);
select is(
    (select count(*)::int from pin_epoque where pin_id = 'b3000000-0000-0000-0000-000000000004'),
    0,
    'un autre compte ne voit pas les époques d''un brouillon communautaire'
);

select * from finish();
rollback;
