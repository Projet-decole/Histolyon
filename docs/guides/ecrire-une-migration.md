# Guide — Écrire une migration

**AD source :** AD-2 (le schéma SQL versionné est l'unique vérité du backend), AD-6 (un seul écrivain par entité, transitions uniquement par RPC), AD-16 (trois environnements, migrations sérialisées et poussées par la CI) — [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md).

Exemple réel à lire avant celui-ci : `supabase/migrations/0001_socle.sql` (schéma, RLS, RPC de transition) et `supabase/functions_sql/pin_transitions.sql`.

## 1. Nommage et emplacement

- Le fichier vit dans `supabase/migrations/`.
- Nom du fichier : horodatage Supabase CLI standard + slug (`supabase migration new <slug>` génère `<timestamp>_<slug>.sql`).
- L'horodatage doit être **postérieur au dernier horodatage présent sur `main`** — la CI rejoue `db reset` from scratch sur le commit de fusion et **refuse** un horodatage plus ancien que le dernier de `main`. Si `main` a avancé pendant que tu travaillais, régénère ta migration avec un nouvel horodatage avant de pousser.

## 2. Une migration par PR

- **Une seule migration par PR**, étiquetée `label:migration`.
- Si ta story a besoin à la fois d'une migration et d'une UI qui la consomme, découpe en deux stories : la migration d'abord (AD-12). Ne mélange pas plusieurs migrations indépendantes dans la même PR — l'intégrateur les sérialise une par une.

## 3. Pour chaque invariant touché : contrainte/RLS + test pgTAP

Pour chaque invariant Ix concerné par ta migration :

1. Écris la contrainte SQL et/ou la policy RLS qui le fait respecter (`CHECK`, `UNIQUE`, `FOREIGN KEY`, `CREATE POLICY ...`).
2. Écris le test pgTAP correspondant dans `supabase/tests/`, un fichier par invariant ou par policy (convention déjà en place : « pgTAP par invariant Ix, par policy, par RPC », AD-14). Le test doit échouer si la contrainte/policy est retirée.
3. Le premier commit de ta branche contient ce test **rouge** (avant que la contrainte n'existe) — voir AD-14, tests d'abord.

Exemple minimal (nommage illustratif, à adapter au schéma réel au moment de l'implémentation) :

```sql
-- supabase/migrations/<timestamp>_ajoute_statut_pin.sql
alter table pin add column statut statut_pin_enum not null default 'brouillon';

create policy pin_lecture_publique
  on pin for select
  using (statut = 'publie');
```

```sql
-- supabase/tests/pin_statut_lecture_publique.sql
begin;
select plan(1);
-- ... insère un pin non publié, vérifie qu'il n'est pas visible en lecture anonyme
select results_eq(
  $$ select count(*) from pin where statut != 'publie' $$,
  $$ ... $$,
  'un pin non publié n''est pas lisible par une session anonyme'
);
select * from finish();
rollback;
```

## 4. Toute transition d'état passe par une RPC qui écrit une Trace

Si ta migration touche une colonne de cycle de vie (`statut`, `provenance` — voir [`docs/conventions/statut-et-provenance.md`](../conventions/statut-et-provenance.md)) :

- N'autorise **jamais** de `UPDATE` direct sur ces colonnes (RLS + trigger qui bloque l'`UPDATE` hors RPC).
- Écris une fonction SQL/plpgsql exposée en RPC pour chaque transition (ex. `pin_valider`, `pin_publier`) dans `supabase/functions_sql/`, incluse par la migration.
- Cette RPC écrit une ligne dans la table de Trace (validation ou modération) dans la même transaction que le changement d'état.
- Ajoute un test pgTAP qui appelle la RPC et vérifie à la fois le nouveau `statut` et la présence de la Trace créée, **et** un test qui vérifie le rejet quand l'appelant n'est pas dans `membre_equipe` (`throws_ok`).
- Le pattern réel du dépôt protège la colonne par un trigger qui exige un paramètre de session (`set_config('histolyon.transition_autorisee', 'on', true)`) posé par la RPC elle-même autour de l'`UPDATE`, pas par un simple `GET DIAGNOSTICS` — voir `pin_soumettre`/`pin_valider`/`pin_publier`/`pin_retirer` dans `supabase/migrations/0001_socle.sql` pour le pattern exact à reproduire (l'exemple ci-dessous reste volontairement simplifié pour l'explication).

```sql
-- supabase/functions_sql/pin_publier.sql
create or replace function pin_publier(p_pin_id uuid)
returns void
language plpgsql
security definer
as $$
declare
  v_lignes_modifiees int;
begin
  update pin set statut = 'publie' where id = p_pin_id and statut = 'valide';
  get diagnostics v_lignes_modifiees = row_count;

  if v_lignes_modifiees = 0 then
    raise exception 'pin_publier: pin % introuvable ou pas au statut valide', p_pin_id;
  end if;

  insert into trace_validation (pin_id, action, compte_id)
  values (p_pin_id, 'publication', auth.uid());
end;
$$;
```

La Trace n'est écrite **que si** l'`UPDATE` a effectivement modifié une ligne (`GET DIAGNOSTICS ... row_count`). Si l'`UPDATE` n'a rien changé (id introuvable, ou pin pas au bon statut de départ), la fonction lève une exception explicite au lieu d'insérer une Trace pour une transition qui n'a pas eu lieu — sinon la piste d'audit mentirait.

## 5. Régénérer les types générés dans la même PR

Toute migration qui change le schéma doit inclure, dans la **même PR**, la régénération de `packages/api_types` et `content/schema/*.json` via `tools/gen-types` (AD-3). La CI échoue si la génération committée diffère de ce que produirait `tools/gen-types` sur le schéma final.

## 6. Vérifier avant de pousser

- `supabase db reset` en local rejoue toutes les migrations depuis zéro sans erreur.
- `supabase test db` (pgTAP) passe, y compris les nouveaux tests.
- `tools/gen-types` ne produit aucun diff après avoir été lancé une deuxième fois.
- Aucune ligne de `UPDATE` directe sur une colonne `statut`/`provenance` en dehors d'une fonction RPC.
