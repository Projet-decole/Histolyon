-- I1 — Identité civile jamais collectée.
-- Vérifie structurellement qu'aucune table du schéma public (présente ou
-- future) ne porte de colonne d'identité civile. L'email reste dans auth.users.
begin;
select plan(1);

select is(
    (
        select coalesce(string_agg(table_name || '.' || column_name, ', '), '')
        from information_schema.columns
        where table_schema = 'public'
          and column_name ~ '^(auteur_)?(nom|prenom|nom_civil|email|telephone|adresse|date_naissance|date_de_naissance)$'
    ),
    '',
    'aucune colonne d''identité civile dans le schéma public (I1)'
);

select * from finish();
rollback;
