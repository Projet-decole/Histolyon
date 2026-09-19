-- I1 — Identité civile jamais collectée.
-- Vérifie structurellement qu'aucune table du socle ne porte de colonne
-- d'identité civile (nom, prénom, date de naissance, adresse, téléphone).
begin;
select plan(4);

select hasnt_column('public', 'membre_equipe', 'nom', 'membre_equipe ne stocke pas de nom civil');
select hasnt_column('public', 'membre_equipe', 'prenom', 'membre_equipe ne stocke pas de prénom');
select hasnt_column('public', 'trace_validation', 'nom', 'trace_validation ne stocke pas de nom civil (I1, pseudonyme via auth.users uniquement)');
select hasnt_column('public', 'pin', 'auteur_nom', 'pin ne stocke pas de nom civil d''auteur');

select * from finish();
rollback;
