# Auth

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Auth ». AD liée : AD-2 (table `membre_equipe`, RLS portée par les policies ; invariant I1 « un fournisseur tiers n'est admis que s'il n'importe aucune identité civile »).

## Convention

- L'authentification passe par Supabase Auth.
- `auth.users.id` **est** `compte.id` (même valeur, pas de table de correspondance).
- Les policies RLS s'appuient sur `auth.uid()` et sur `membre_equipe.role` (enum `editeur | validateur | moderateur`, AD-2) pour les permissions d'équipe.
- Un fournisseur d'authentification tiers n'est admis que s'il n'importe aucune identité civile (I1).

## Pourquoi

Faire de `compte.id` le même identifiant que `auth.users.id` évite une jointure et une source de désynchronisation supplémentaires ; c'est ce que présuppose AD-2 en posant `membre_equipe(compte_id, role)` comme table portée par les policies RLS. La contrainte sur les fournisseurs tiers découle de l'invariant I1 cité explicitement dans la règle d'AD-2 : le projet ne collecte pas d'identité civile, donc un fournisseur d'auth qui l'imposerait (pièce d'identité, numéro de téléphone vérifié par un tiers non neutre, etc.) est exclu par défaut.

## Exemple

Une policy RLS type sur `pin` en écriture communautaire : `USING (EXISTS (SELECT 1 FROM membre_equipe WHERE compte_id = auth.uid() AND role IN ('validateur', 'moderateur')))`. Choisir « Se connecter avec » un fournisseur qui exigerait une pièce d'identité (ex. certains KYC bancaires) est un cas à traiter comme un amendement, pas une décision d'implémentation locale.
