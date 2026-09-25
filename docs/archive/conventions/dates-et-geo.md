# Dates & géo

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Dates & géo ». AD liée : AD-2 (le schéma SQL versionné est l'unique vérité du backend) et AD-8 (cartographie MapLibre / PostGIS).

## Convention

- Toute date/heure est stockée en `timestamptz`, en UTC.
- Toute position est stockée en `geography(Point, 4326)` (PostGIS, WGS84).
- Jamais de colonnes `latitude`/`longitude` séparées.

## Pourquoi

`timestamptz` en UTC évite les bugs de fuseau horaire entre le serveur Supabase, les terminaux mobiles et l'admin web — une seule conversion à faire, à l'affichage. `geography(Point, 4326)` est le type que consomme directement PostGIS pour les calculs de distance et les requêtes spatiales utilisées par la proximité (D4) et la carte (D1, AD-8) ; des colonnes lat/lon séparées empêcheraient ces requêtes et introduiraient un risque d'inversion des deux valeurs.

## Exemple

La table `pin` a une colonne `position geography(Point, 4326)`, pas `latitude double precision` + `longitude double precision`. Une requête de proximité (D4) utilise `ST_DWithin(pin.position, ...)` directement sur cette colonne.
