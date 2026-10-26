---
name: Ticket (par apport)
about: Une tranche démontrable rattachée à une capacité du produit, avec sa charge (voir docs/PROCESS.md et prompts/ecrire-un-ticket.md)
title: ''
labels: ''
---

## Apport

<!-- Une phrase : ce qu'on peut voir ou faire à la fin, et qu'on peut montrer. -->

## Capacité

`CAP-…` — fiche : `produit/capacites/CAP-….md`

## Contexte à charger

- `dart run tools/ctx.dart pack CAP-…`
- <autre fichier ou commande précise, et pourquoi — ou « rien d'autre »>

## Critères de fin

<!-- Reprendre les CF… de la capacité que ce ticket couvre. -->
- [ ] CF… : …
- [ ] `dart run melos run analyze`, `... run test` et `... run format` verts (+ `dart run tools/ctx.dart check` si `produit/` est touché, + `supabase db reset && supabase test db` si `supabase/` est touché)

## Zone et fichiers autorisés

`<un seul dossier : apps/mobile/lib/features/<slug>/ | content/ | produit/ | tools/ | packages/<nom>/ | supabase/>`
Rien d'autre n'est modifié, sauf : <exception explicite, ou « aucune » — ex. `core/router/route_names.dart` pour une route>.

## Tests attendus (premiers commits, rouges)

- …

## Hors périmètre

- …

---
Charge : <1 | 2 | 3 | 5> · Dépend de : <#n ou « rien »> · Jalon : <J1 | J2 | J3 | J4 | S2>
<!-- Étiquettes à poser : `charge:N`, `cap:D…`, la zone, et le jalon (milestone). -->
