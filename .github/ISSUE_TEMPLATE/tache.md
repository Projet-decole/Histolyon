---
name: Tâche
about: Une tâche d'une demi-journée, prête à confier à une IA (format dans prompts/ecrire-une-issue.md)
title: ''
labels: ''
---

## Objectif

<!-- Ce que l'utilisateur (ou l'équipe) voit / peut faire à la fin. 1 à 3 phrases. -->

## À lire avant de coder

- `dart run tools/ctx.dart <ID>` — <pourquoi>
- `<chemin/du/fichier>` — <pourquoi>

## Zone

`<un seul dossier : apps/mobile/lib/features/<slug>/ | supabase/ | content/ | apps/admin/… | packages/<nom>/>`
Rien d'autre n'est modifié, sauf : <exception explicite, ou « aucune » — ex. `core/router/route_names.dart` pour une route, `app/router.dart` pour une nouvelle feature, `schema.drift`>.

## À faire

- [ ] …

## Tests attendus (premier commit, rouges)

- …

## Terminé quand

- [ ] …
- [ ] `melos run analyze`, `melos run test` et `melos run format` verts (+ `supabase db reset && supabase test db` si `supabase/`)

## Hors périmètre

- …

---
Domaine : <D1…D11 ou socle> · Dépend de : <#n ou « rien »> · Taille : ½ journée avec une IA
