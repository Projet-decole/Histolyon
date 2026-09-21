# Statut & provenance

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Statut & provenance ». AD liée : AD-6 (« Un seul écrivain par entité, transitions uniquement par RPC »).

## Convention

`statut` et `provenance` sont deux colonnes **distinctes**, chacune un **enum Postgres**, dont les valeurs viennent du palier 4 de la conception. Jamais un booléen `publie` (ou équivalent) pour représenter un état du cycle de vie.

## Pourquoi

AD-6 fixe que toute transition de `statut` ou de `provenance` est une RPC dédiée qui écrit une Trace et est testée en pgTAP ; un enum rend l'ensemble des états et des transitions valides explicite et vérifiable par une contrainte, alors qu'un booléen ne peut représenter que deux états et interdit toute machine d'états plus riche (brouillon → soumis → validé → publié → retiré, par exemple) sans migration de type de colonne.

## Exemple

Le Pin a `statut` (`brouillon | soumis | valide | publie | retire`) et `provenance` (`editorial | communautaire`) comme deux colonnes enum séparées. La RPC `pin_publier` est la seule à faire passer `statut` de `valide` à `publie` ; aucun code n'écrit directement `UPDATE pin SET statut = 'publie'`.
