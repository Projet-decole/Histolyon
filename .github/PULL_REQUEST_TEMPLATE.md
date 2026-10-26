Closes #<numéro>

## Ce que ça fait

<!-- 1 à 3 phrases. Capture d'écran si c'est visible dans l'app. -->

## Vérifié

- [ ] Les critères de fin (CF…) du ticket sont atteints, et chacun a un test ou une capture
- [ ] Pour la logique : le premier commit contient les tests (rouges), le code vient après
- [ ] `dart run melos run analyze`, `... run test` et `... run format` verts (+ `supabase db reset && supabase test db` si `supabase/` touché, + `dart run tools/ctx.dart check` si `produit/` touché)
- [ ] Rien hors de la zone du ticket (sinon signalé ci-dessus) ; fichiers générés régénérés, jamais édités à la main
- [ ] La fiche de `produit/` est à jour si une règle du produit a changé (elle se modifie avant le code)
- [ ] Image de référence ré-exportée dans `produit/ecrans/img/` si un écran a changé dans Figma
- [ ] Testé dans l'app (téléphone / Chrome) si c'est visible

## Assistance IA

- Outil : <nom, ou « aucun »>
- Généré par l'IA : <quoi>
- Relu / modifié par moi : <quoi>
