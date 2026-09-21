# Polymorphisme (Signalement, Favori, Lien universel)

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Polymorphisme ». AD liée : AD-2 (le schéma SQL versionné est l'unique vérité du backend, invariants = contraintes SQL).

## Convention

Pour une entité qui peut cibler plusieurs types d'objets (Signalement, Favori, Lien universel), le schéma utilise une paire de colonnes `(type_de_cible enum, cible_id uuid)` accompagnée d'une contrainte `CHECK`. Pas de table de jointure par type (pas de `favori_pin`, `favori_parcours`, etc. en tables séparées).

## Pourquoi

AD-2 fixe que chaque invariant est porté par une contrainte SQL et/ou une policy RLS testée en pgTAP. Une paire `(type_de_cible, cible_id)` + `CHECK` garde l'invariant vérifiable dans le schéma lui-même (types valides énumérés, cohérence testable) sans multiplier les tables et les policies RLS à maintenir en parallèle à chaque nouveau type de cible.

## Exemple

`favori(id uuid, compte_id uuid, type_de_cible favori_cible_enum, cible_id uuid)` avec `CHECK (type_de_cible IN ('pin', 'parcours'))`, plutôt que deux tables `favori_pin` et `favori_parcours`. Le Lien universel (D11) suit le même schéma pour cibler indifféremment un Pin ou un Parcours partagé.
