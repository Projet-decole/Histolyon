# Licences

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Licences ». AD liée : AD-8 (« Attribution OpenStreetMap (ODbL) et Protomaps visible en permanence ») et AD-11 (Modèle 3D référencé « avec sa licence »).

## Convention

- L'attribution OpenStreetMap (licence ODbL) et Protomaps est affichée en permanence dans l'app (carte, D1).
- Le champ `licence` est **obligatoire** sur toute entité Média, Fragment musical et Modèle 3D récupérés sur internet (pas de valeur par défaut vide).

## Pourquoi

AD-8 fixe l'attribution OSM/Protomaps comme visible en permanence — condition de la licence ODbL des données cartographiques, pas une option d'habillage. AD-11 exige qu'un Modèle 3D référence sa licence dès sa création dans le bucket `models` ; étendre cette exigence aux médias et fragments musicaux récupérés sur internet évite qu'un asset sans licence documentée se retrouve publié sans que personne ne puisse vérifier le droit de l'utiliser.

## Exemple

Le composant de carte affiche en permanence un bandeau « © OpenStreetMap contributors (ODbL) · © Protomaps », non masquable. Un enregistrement `media` créé depuis une photo trouvée en ligne a sa colonne `licence` renseignée (ex. `CC-BY-SA 4.0 — Wikimedia Commons`) avant validation, sinon la RPC de publication le refuse.
