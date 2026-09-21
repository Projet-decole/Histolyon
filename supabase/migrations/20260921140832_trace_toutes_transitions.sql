-- 20260921140832_trace_toutes_transitions.sql
-- Corrige un écart AD-6 relevé en revue de code : seule pin_valider écrivait
-- une trace_validation ; pin_soumettre, pin_publier et pin_retirer changeaient
-- pin.statut sans laisser de piste d'audit, contrairement à l'AC de la Story
-- 3.2 (« chaque RPC de transition écrit sa trace_validation »).
--
-- decision/type_de_validation étaient restreints au vocabulaire de la seule
-- étape de validation (approuve/demande_complement/refuse,
-- auto_validation/validation_par_tiers) : élargis pour couvrir les 3 autres
-- transitions. type_de_validation devient nullable (n'a de sens que pour
-- pin_valider ; les 3 autres transitions n'ont qu'un seul type d'exécution,
-- pas de distinction auto/tiers).

alter table trace_validation drop constraint trace_validation_decision_check;
alter table trace_validation add constraint trace_validation_decision_check
    check (decision in ('approuve', 'demande_complement', 'refuse', 'soumis', 'publie', 'retire'));

alter table trace_validation alter column type_de_validation drop not null;
alter table trace_validation drop constraint trace_validation_type_de_validation_check;
alter table trace_validation add constraint trace_validation_type_de_validation_check
    check (type_de_validation is null or type_de_validation in ('auto_validation', 'validation_par_tiers'));

-- brouillon -> en_revue : écrit désormais sa Trace (AD-6).
create or replace function pin_soumettre(p_pin_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
    v_statut statut_pin;
begin
    perform verifier_membre_equipe();

    select statut into v_statut from pin where id = p_pin_id for update;
    if not found then
        raise exception 'pin % introuvable', p_pin_id;
    end if;
    if v_statut <> 'brouillon' then
        raise exception 'pin_soumettre exige le statut brouillon (statut actuel : %)', v_statut;
    end if;

    perform set_config('histolyon.transition_autorisee', 'on', true);
    update pin set statut = 'en_revue' where id = p_pin_id;
    perform set_config('histolyon.transition_autorisee', 'off', true);

    insert into trace_validation (pin_id, validateur, decision)
    values (p_pin_id, auth.uid(), 'soumis');
end;
$$;

-- valide -> publie : écrit désormais sa Trace (AD-6).
create or replace function pin_publier(p_pin_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
    v_statut statut_pin;
begin
    perform verifier_membre_equipe();

    select statut into v_statut from pin where id = p_pin_id for update;
    if not found then
        raise exception 'pin % introuvable', p_pin_id;
    end if;
    if v_statut <> 'valide' then
        raise exception 'pin_publier exige le statut valide (statut actuel : %)', v_statut;
    end if;

    perform set_config('histolyon.transition_autorisee', 'on', true);
    update pin set statut = 'publie' where id = p_pin_id;
    perform set_config('histolyon.transition_autorisee', 'off', true);

    insert into trace_validation (pin_id, validateur, decision)
    values (p_pin_id, auth.uid(), 'publie');
end;
$$;

-- publie -> retire : écrit désormais sa Trace (AD-6).
create or replace function pin_retirer(p_pin_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
    v_statut statut_pin;
begin
    perform verifier_membre_equipe();

    select statut into v_statut from pin where id = p_pin_id for update;
    if not found then
        raise exception 'pin % introuvable', p_pin_id;
    end if;
    if v_statut <> 'publie' then
        raise exception 'pin_retirer exige le statut publie (statut actuel : %)', v_statut;
    end if;

    perform set_config('histolyon.transition_autorisee', 'on', true);
    update pin set statut = 'retire' where id = p_pin_id;
    perform set_config('histolyon.transition_autorisee', 'off', true);

    insert into trace_validation (pin_id, validateur, decision)
    values (p_pin_id, auth.uid(), 'retire');
end;
$$;
