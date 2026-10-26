---
id: DOC-CYCLES-DE-VIE
type: document
titre: "Cycles de vie des entités du MVP"
statut: mvp
anciens_ids: []
sources:
  - conception/04-donnees/01-contenu.yaml:113
  - conception/04-donnees/02-parcours.yaml:211
  - supabase/migrations/0001_socle.sql:204
  - supabase/migrations/20260921140832_trace_toutes_transitions.sql:24
derniere_verif: 2026-10-24
---

## Principe
Au MVP, le contenu est un instantané embarqué (DEC-04) : l’app ne lit que des objets `publie`. Les statuts décrits ici sont ceux de l’équipe éditoriale, côté Supabase. Un `statut` ne change jamais par `UPDATE` : un trigger le bloque, chaque transition est une RPC qui écrit sa trace (`supabase/AGENTS.md`).

## Pin (ENT-PIN)
Statuts : `brouillon`, `en_revue`, `valide`, `publie`, `retire`.

| transition | RPC | état |
|---|---|---|
| brouillon → en_revue | `pin_soumettre` | existe |
| en_revue → valide | `pin_valider` (exige ≥ 1 source, INV-04) | existe |
| valide → publie | `pin_publier` | existe |
| publie → retire | `pin_retirer` | existe |
| en_revue → brouillon (demande de complément) | | n’existe pas encore |
| retire → publie (réouverture) | | n’existe pas encore |

Visibilité éditoriale : publique à partir de `publie` uniquement. Voir `supabase/AGENTS.md` pour le patron des RPC.
Hors MVP : visibilité d’un pin communautaire dès `en_revue` avec marque distinctive, promotion en éditorial.

## Parcours (ENT-PARCOURS)
Mêmes statuts et mêmes six transitions que le pin pour la provenance éditoriale. Aucune RPC de transition de parcours n’existe encore. Visible à partir de `publie`. Pas d’état « en cours » ni « complété » : la progression de l’utilisateur est dans l’historique (ENT-HISTORIQUE-DE-VISITE).
Hors MVP : cycle communautaire (brouillon → publie → retire, modération après coup) et cycle personnel (brouillon, prêt à utiliser, archivé).

## Étape (ENT-ETAPE)
Pas de cycle propre : elle suit son parcours. L’ordre des étapes ne se change qu’en `brouillon`.

## Catégorie, époque, source, modèle 3D
Aucun statut. Catalogues ouverts, additions seulement (INV-07).

## Profil et historique
Pas de statut. Le profil est créé au premier lancement ; l’historique est append-only, effaçable (ENT-HISTORIQUE-DE-VISITE).

## Hors MVP
Commentaire, retour de parcours, signalement, compte : enums déjà présents dans `supabase/migrations/20260925120000_schema_complet.sql`, transitions non écrites. Aucune transition inventée ici.
