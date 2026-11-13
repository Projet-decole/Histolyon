# Suivi client

Ce dossier rassemble ce que le client et la pédagogie lisent du projet HistoLyon :

- `rapport-suivi-AAAA-MM-JJ.pdf` : le rapport de suivi du jour (jalons, alertes, avancement, fin prévue du MVP, flux, qualité, contenu, série semaine par semaine, limites connues). Il ne contient que la vue client : aucun détail par personne.
- `feuille-de-route.md` et `feuille-de-route.pdf` : la feuille de route client, avec l'objectif démontrable et le critère « atteint quand » de chaque jalon, et la ligne de coupe.

## Régénérer

```bash
dart run tools/suivi.dart
```

La commande recalcule le suivi depuis GitHub, écrit le rapport du jour et régénère la feuille de route PDF depuis `feuille-de-route.md`. Elle exige `gh` connecté et `weasyprint` (`sudo apt-get install weasyprint`) ; sans `weasyprint`, le suivi est calculé sans PDF. Pour une couverture à jour, lancer d'abord `flutter test --coverage` dans `apps/mobile`.

On modifie `feuille-de-route.md` à la main quand un jalon change ; la version de travail de l'équipe reste `produit/FEUILLE-DE-ROUTE.md`, qui prime.

## Publication

Les PDF de ce dossier entrent dans `main` par une PR à chaque follow-up, puis le dépôt est poussé sur celui de l'école. Chaque vendredi, le workflow `suivi` publie aussi le rapport PDF de la semaine sur la branche `suivi`.
