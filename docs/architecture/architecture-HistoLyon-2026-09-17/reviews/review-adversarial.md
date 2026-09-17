---
type: review
lens: adversarial
target: ../ARCHITECTURE-SPINE.md
date: '2026-09-17'
verdict: "La spine tient pour l'outillage et le process, mais elle laisse ouverts trois trous structurels (propriété des entités partagées, état de session inter-features, stockage local) par lesquels deux équipes obéissantes construisent des choses incompatibles."
---

# Revue adversaire — Architecture Spine HistoLyon

## Méthode

Pour chaque AD, on a cherché **deux unités du niveau en dessous** (features D1…D11 de `apps/mobile`, features `catalogue/saisie/validation/moderation` de `apps/admin`, `supabase/`, `content/`, `tools/`, casquettes Découpeur / Intégrateur / Gardien des tests / Gardien du design) qui :

1. respectent chaque AD **à la lettre** ;
2. produisent pourtant du code, des schémas ou des règles **incompatibles** entre eux.

Chaque paire trouvée est décrite avec : les deux unités, ce que chacune construit en toute bonne foi, le point de collision, l'AD qui aurait dû l'empêcher, et l'AD nouvelle ou resserrée qui ferme le trou. Gravité : **S1** (bloque l'intégration ou viole un invariant I1–I10), **S2** (retravail lourd / dette), **S3** (friction de process).

Verdict en une phrase : **la spine fixe bien la stack, la direction des dépendances et le process, mais elle ne dit ni qui possède les entités que plusieurs domaines écrivent (Pin, Parcours, Signalement), ni où vit l'état que plusieurs features lisent (époque sélectionnée, parcours actif), ni combien de bases Drift il y a — et AD-5 (jamais feature→feature) rend ces trois trous non contournables sans tricher.**

---

## Synthèse des paires (par gravité)

| # | Unités en collision | Conflit | AD à ajouter / resserrer | Gravité |
| --- | --- | --- | --- | --- |
| P1 | `mobile/features/pins` ↔ `mobile/features/communaute` ↔ `admin/features/saisie·validation` ↔ `supabase/seed` | Quatre chemins d'écriture de la table `pin`, quatre idées du cycle de vie `statut`/`provenance` (I3, I4, I10) | **AD-6 resserrée + nouvelle AD-19 « ownership & transitions »** : table d'ownership par entité ; toute transition d'état = fonction SQL (RPC) ; colonnes de cycle de vie non-updatables par les clients | S1 |
| P2 | `mobile/core/profile` ↔ `mobile/features/parcours` ↔ `supabase/` | Parcours `provenance=personnel` : AD-4 le donne au serveur (C2), I6 le donne au terminal ; deux schémas d'Étape, deux espaces d'identifiants, pas de chemin de publication | **AD-4 amendée** (C2 sauf `personnel`) **+ AD-22 « une seule base Drift, tables miroir générées, uuid client »** | S1 |
| P3 | `mobile/features/carte` (slider D1.2) ↔ `mobile/features/parcours` (D3.5) ↔ `proximite`, `audio` | L'époque sélectionnée, le parcours actif, le pin courant sont lus/écrits par plusieurs features ; AD-5 interdit l'import ; chacune duplique l'état | **Nouvelle AD-20 « état de session »** : `core/session` possède la liste fermée des états transverses ; interaction inter-features uniquement par `core/router` et `core/session` | S1 |
| P4 | `supabase/seed` (`tools/seed`) ↔ `admin/features/validation` ↔ `mobile/features/communaute` | Le seed « rend » `content/` : il écrase les validations faites en admin et supprime (ou pas) les pins communautaires absents de `content/` | **AD-7 resserrée** : seed upsert-only, restreint à `provenance=editorial`, n'écrit jamais `statut` ni les traces ; liste exhaustive des dossiers `content/` | S1 |
| P5 | Story A ↔ Story B (deux migrations, deux régénérations d'`api_types`) sous squash merge | Ordre des timestamps inversé entre `local` (`db reset`) et `dev` (`db push`) ; conflit Git sur le fichier généré résolu à la main | **AD-16/AD-3 resserrées** : une migration par PR, branche à jour obligatoire, CI rejoue `db reset` sur le résultat de fusion, refus d'un timestamp antérieur au dernier de `main`, conflit sur généré = régénérer | S2 |
| P6 | `mobile/core/offline` (AD-9) ↔ `mobile/features/parcours` ↔ `pins`, `audio`, `carte` (lecteurs) | Qui définit la forme du paquet et qui le lit ? Trois DAO Drift possibles (AD-4 `core/profile`, AD-9 `core/offline`, AD-6 `features/*/data`) ; politique réseau/cache non fixée ; D4.1/D4.2 ont besoin de pins hors parcours | **AD-9 resserrée** : `core/offline` propriétaire unique du paquet, API de lecture par entité, politique de lecture unique, second cache éphémère « viewport » assumé | S2 |
| P7 | `core/profile/sync` ↔ table `favori`/`historique` serveur | Pas de modèle de fusion (deux appareils, suppression vs ajout), pas de tombstones, dépendance favori→parcours personnel non synchronisé | **Nouvelle AD-21 « modèle de sync »** : uuid client, `updated_at`, `deleted_at`, LWW par ligne, pull-then-push par catégorie, dépendances explicites | S2 |
| P8 | `supabase/` (deux équipes) pour Signalement / Favori / Lien universel polymorphes | Table à FK nullables + CHECK vs `type_cible + cible_id` sans FK ; formes Dart générées différentes ; « signaler » déclenché depuis `pins` mais possédé par `communaute` | **Convention SQL « référence polymorphe »** unique + règle de déclenchement inter-features via `core/router` | S2 |
| P9 | `packages/ui_kit` ↔ `features/*/presentation` | Le graphe AD-5 n'autorise pas `presentation → packages/` ; règle de placement d'un widget non-`comp-*` absente ; `ui_kit` importe-t-il `api_types` ? ; deux stories modifient le même `comp-*` | **AD-5 corrigée** (P → `ui_kit`, `design_tokens`) **+ AD-10 resserrée** (placement, `ui_kit` sans type métier, modification = story `socle`) | S2 |
| P10 | `admin/features/catalogue` (I7 : Époque ouverte) ↔ `packages/map_styles` (AD-8 : un style par slug, dans l'app) | Une Époque ajoutée en base n'a pas de style embarqué ; comportement indéfini | **AD-8 resserrée** : catalogue d'Époques fermé par release, test CI slug↔style, fallback nommé, admin en lecture seule sur `epoque` | S2 |
| P11 | Gardien des tests (AD-14) ↔ Intégrateur (AD-13 squash, lefthook pre-push) ↔ `tools/report` (AD-17) | La preuve « tests d'abord » disparaît au squash ; un pre-push qui lance les tests interdit le premier commit rouge ; `report` ne peut pas mesurer | **AD-14 resserrée** : preuve = check CI sur `refs/pull/N/commits` + label ; lefthook n'exécute pas les tests | S3 |
| P12 | Découpeur A ↔ Découpeur B (AD-12 « plus d'une couche non triviale ») | Une story « ajouter un champ au Pin » touche `supabase/`, `api_types`, `content/schema` (dérivé par personne), `pins`, `admin/saisie` : 1 ou 5 stories ? | **AD-12 resserrée** : découpe verticale, `supabase + api_types + content/schema` comptent pour une couche générée ensemble, `content/schema` produit par `tools/gen-types` | S3 |
| P13 | Convention Auth (`auth.uid()` seul) ↔ `admin/features/moderation` (I5 : « seuls les modérateurs ») ↔ mobile anonyme (I6, pas d'`auth.uid()`) | Pas de notion de rôle ; deux implémentations (claims JWT vs table) ; lecture publique par `anon` non écrite | **Convention Auth resserrée** : rôles en table, fonction `has_role()`, matrice RLS par rôle | S2 |

---

## P1 — Pin : quatre écrivains pour un « seul chemin de mutation » — S1

**Unités.** (a) `mobile/features/pins` — propriétaire déclaré par la Capability Map (« D2 → `mobile/features/pins`, tables `pin`, `media`, `source_documentaire` »). (b) `mobile/features/communaute` — D9.2 soumission d'un Pin communautaire. (c) `admin/features/saisie` et `admin/features/validation` — D10, Trace de validation, I4, I10. (d) `supabase/seed` + `tools/seed` — AD-7.

**Ce que chacune construit en obéissant.**
- (a) lit AD-6 « toute écriture passe par le repository de la feature propriétaire » → `pins/data/pin_repository.dart` expose `lire`, `rechercher`, et, faute d'écriture côté D2, aucun `ecrire`.
- (b) lit AD-5 « une feature n'importe jamais une autre feature » → ne peut pas appeler `pins/data`. Lit AD-6 « repository de la feature propriétaire dans `data/` » et conclut qu'elle est propriétaire *de la soumission* → `communaute/data/soumission_repository.dart` fait `supabase.from('pin').insert({provenance: 'communautaire', statut: 'publie', marque_verification: true})` (I3 : visibilité immédiate avec marque).
- (c) AD-6 s'applique à `apps/*` ; dans l'admin la feature propriétaire est `saisie` → `saisie/data/pin_repository.dart` fait `update({statut: 'valide'})` après contrôle des sources ; `validation/data` fait de même pour poser la Trace ; `moderation/data` fait `update({provenance: 'editorial'})` pour I10.
- (d) fait `upsert` par `slug` sur toute la ligne, `statut` compris.

**Collision.** Quatre repositories, quatre machines d'état implicites pour `statut`/`provenance`, aucune fonction SQL qui les arbitre. AD-2 exige un test pgTAP par invariant, mais I3/I4/I10 sont des *transitions*, pas des contraintes de ligne : « un Pin ne peut passer `valide` sans Source » (I4) se code en trigger ou en RPC, jamais en CHECK. Rien dans la spine n'impose l'un ou l'autre, donc l'équipe `supabase/` peut livrer une table nue avec RLS `update` ouvert au propriétaire et laisser les clients écrire `statut` — et chacun l'écrit avec ses propres valeurs d'enum.

**AD manquante.** AD-6 ne parle que du *client* ; AD-2 ne parle que des *invariants*. Personne ne possède la transition.

**Proposition — AD-19 « Ownership des entités et transitions d'état ».**
- `docs/conventions/ownership.md` : pour chaque table, la feature propriétaire *par app* (mobile, admin) et la liste des RPC de transition. Une feature non listée n'écrit jamais la table.
- Toute transition de `statut` ou `provenance` (Pin, Parcours, Commentaire, Retour, Signalement) est une fonction SQL `security definer` nommée `<entite>_<verbe>` (`pin_soumettre`, `pin_valider`, `pin_promouvoir`, `pin_retirer`), qui pose la Trace correspondante dans la même transaction. Les policies RLS refusent tout `UPDATE` sur `statut`, `provenance`, `auteur_communautaire`.
- Un pgTAP par RPC (transition légale, transition illégale, I4 sans source refusée).
- AD-6 resserrée : « le chemin unique d'une mutation serveur est la RPC ; le repository client n'est que son appelant typé ».

---

## P2 — Parcours personnel : deux propriétaires, deux schémas — S1

**Unités.** (a) `mobile/core/profile` (AD-4 : « le terminal possède le Profil local (C3 sans Compte) dans Drift »). (b) `mobile/features/parcours` (Capability Map D3 → `features/parcours`, `core/offline`). (c) `supabase/` (AD-4 : « le serveur possède C1, C2, C4, C5, C6 » — C2 = Parcours).

**Ce que chacune construit.**
- (c) lit AD-4 à la lettre : C2 est au serveur → table `parcours` avec `provenance enum(editorial, communautaire, personnel)` et RLS `auth.uid() = auteur_id` pour `personnel`. Mais un Profil sans Compte n'a pas d'`auth.uid()` (I6) : un utilisateur anonyme ne peut pas créer de parcours personnel — D3.7 est cassé.
- (a) lit I6 (« favoris, historique, préférences … strictement locales ») et `granularité_synchronisation` ⊇ `{parcours_personnels_créés}` → range `parcours_personnel` dans Drift à côté de `favori`, avec `etapes` en colonne JSON `[{pin_slug, note}]`, `id` entier autoincrement.
- (b) lit AD-6 « DAO Drift injectés dans `data/` » → crée `parcours/data/parcours_local_dao.dart` avec table `etape_locale(position, pin_id uuid, note)` — une deuxième table pour la même chose, dans une deuxième base Drift.

**Collision.** Trois formes d'Étape (ligne SQL `etape`, JSON dans `core/profile`, table `etape_locale` dans `parcours/data`), deux espaces d'identifiants (int local vs uuid serveur), et le passage personnel → communautaire (D3.7 « partager à la communauté », I2) n'a pas de chemin : `communaute` ne peut importer ni `parcours` ni `core/profile`… si, `core/` est autorisé — mais pas la table de `parcours/data`. Le Favori polymorphe (C3) pointant sur un parcours personnel local puis synchronisé change d'identifiant.

**Proposition.**
- **AD-4 amendée** : « le serveur possède C1, C2 *hors `provenance = personnel`*, C4, C5, C6 ; le terminal possède C3 et les Parcours personnels ; `features/parcours/data` en est le propriétaire (pas `core/profile`) ».
- **AD-22 « Une seule base Drift, schéma miroir »** : une base Drift unique dans `core/db`, versionnée ; les tables miroir des tables serveur (`parcours`, `etape`, `pin`, `favori`, `historique`) sont **générées** par `tools/gen-types` depuis le schéma SQL (supadart → drift), mêmes colonnes, mêmes enums ; `id uuid` généré côté client (v4) pour toute ligne née localement, jamais d'autoincrement ; les DAO sont possédés par la feature propriétaire, la base par `core/db`.
- La publication est une RPC `parcours_publier(parcours jsonb)` qui insère parcours + étapes dans une transaction avec `provenance = communautaire` et conserve l'`id` client.

---

## P3 — Slider d'époque, parcours actif, pin courant : l'état inter-features n'a pas de maison — S1

**Unités.** (a) `mobile/features/carte` — D1.2 slider continu, D1.3 apparence par époque, AD-8. (b) `mobile/features/parcours` — D3.5 « le slider peut être positionné automatiquement par un parcours en cours ». (c) `mobile/features/proximite` — D4.3 « En parcours, limité au parcours actif ». (d) `mobile/features/audio` — D7 lecture en arrière-plan liée au pin courant. (e) `mobile/features/pins` — D2.4 aperçu ouvert au tap sur la carte.

**Ce que chacune construit.**
- (a) `carte/presentation/epoque_slider_provider.dart` : état `double position` (continu) + `EpoqueSlug courante` ; AD-8 : sélectionne un style. Convention État : « un provider par cas d'usage » — donc dans la feature.
- (b) doit changer l'époque à chaque Étape. AD-5 interdit d'importer `carte`. Elle crée donc `parcours/presentation/epoque_parcours_provider.dart` (`EpoqueId uuid`) et espère qu'un jour la carte l'écoute. Ou bien elle navigue via `core/router` vers `/carte?epoque=…` à chaque étape — la carte reconstruit son état depuis l'URL, et le geste utilisateur en cours est perdu (question ouverte D1.2 « priorité utilisateur ou parcours » n'est tranchée nulle part).
- (c) a besoin du « parcours actif » → crée son propre `parcoursActifProvider` alimenté… par quoi ? Elle ne peut pas lire (b).
- (d) a besoin du « pin courant » ; (e) doit ouvrir un aperçu depuis (a).

**Collision.** L'arbre du Structural Seed liste `core/session` mais aucune AD ne dit ce qu'il contient, ni que c'est *le* lieu de l'état transverse. Chaque feature reconstruit sa copie ; les types diffèrent (slug vs uuid, `double` continu vs enum) ; la règle de priorité slider n'a pas de propriétaire. AD-5 est respectée à la lettre et le produit ne fonctionne pas : le parcours ne pilote jamais la carte.

**Proposition — AD-20 « État de session partagé ».**
- `core/session` possède une **liste fermée** d'états transverses, chacun un provider Riverpod avec types de `packages/api_types` : `epoqueSelectionnee {slug, source: utilisateur|parcours, positionContinue}`, `parcoursActif {id, etapeCourante}`, `pinCourant {id}`, `lectureAudio {mediaId, etat}`, `modePresentation bool`, `etatReseau`.
- Règle de priorité fixée ici, pas dans une feature : « une écriture `source = parcours` est ignorée pendant N s après une écriture `source = utilisateur` » (valeur dans `design_tokens`, durée = token de motion).
- **AD-5 resserrée** : les seules interactions entre features sont (1) les routes typées de `core/router`, (2) la lecture/écriture de `core/session`. Ajouter un état à `core/session` = story `socle`, relue par le Gardien du design.
- Réponse à la question ouverte D1.2 tracée comme décision de la spine.

---

## P4 — `content/` seedé « comme un rendu » contre l'admin et la communauté qui écrivent la même table — S1

**Unités.** (a) `tools/seed` + `supabase/seed/` (AD-7 phase 1 : « la base est un rendu de `content/` », « seed idempotent par `slug` »). (b) `admin/features/validation` (D10 workflow scientifique, Trace de validation, existe *avant* la bascule phase 2 car la bascule est déclenchée par la *saisie*, pas par la validation). (c) `mobile/features/communaute` (D9.2 : pins communautaires en base, jamais dans `content/`). (d) `.github/workflows/ci-content` qui reseed `dev` à chaque fusion (AD-16 : « seedé depuis `content/` »).

**Ce que chacune construit.**
- (a1) une équipe lit « rendu » → seed = miroir : `upsert` de tout ce qui est dans `content/`, `delete` de ce qui n'y est pas. Les pins communautaires de (c) disparaissent à chaque fusion sur `main`.
- (a2) l'autre équipe lit « idempotent par slug » → `upsert` seul. Mais la ligne YAML porte `statut: brouillon` (ou rien) et le seed écrase le `statut = valide` posé par (b) ; la Trace de validation pointe alors sur un Pin redevenu brouillon — I4 est respecté par le schéma mais l'historique ment.
- (b) écrit `statut` en base (voir P1) en supposant que la base est la vérité pour le *cycle de vie* et `content/` la vérité pour le *contenu* — distinction que l'AD-7 ne fait pas.

**Collision supplémentaire.** L'arbre `content/` liste `pins/ parcours/ epoques/ categories/` ; or I4 exige une Source documentaire pour valider, C1 a `media`, `modele_3d`, `fragment_musical`, `badge`, `couche_cartographique`, `source`. Où vivent-ils en phase 1 ? Deux équipes de contenu inventeront `content/sources/` d'un côté et des sources inlinées dans `pins/<slug>.yaml` de l'autre ; le JSON Schema « dérivé du schéma SQL » n'a pas d'outil désigné pour le dériver (voir P12).

**Proposition — AD-7 resserrée.**
- Le seed est **upsert-only**, jamais de delete ; il ne touche que les lignes `provenance = editorial` ; il n'écrit jamais `statut`, `provenance`, ni les tables de traces ; une ligne existante dont `statut ≠ brouillon` n'est mise à jour que sur ses colonnes de contenu, et le seed pose une Trace `reimport` pour I4/I10.
- `content/` est défini exhaustivement : `pins/ parcours/ epoques/ categories/ sources/ medias/ modeles3d/ fragments/ badges/ couches/`, avec un fichier par slug et les binaires référencés par chemin relatif + sha256.
- `content/schema/*.json` est **généré** par `tools/gen-types` (même commande que `api_types`), jamais édité.
- Le seed s'exécute sur `local` (chaque poste), sur `dev` (CI à chaque fusion), jamais deux fois sur `demo` sans tag.

---

## P5 — Deux stories, deux migrations, deux régénérations, un squash — S2

**Unités.** Story A (`story/42-pin-badge`) et Story B (`story/43-parcours-teaser`), chacune avec une migration `supabase/migrations/<ts>_*.sql` et un `packages/api_types` régénéré (AD-3 « dans la même PR »). Intégrateur appliquant AD-13 (squash).

**Scénario.** B crée sa migration lundi (ts 20260921…), A la sienne mardi (ts 20260922…). A fusionne d'abord ; `dev` est migré à A (AD-16). B rebase, régénère `api_types` → conflit Git sur un fichier « GÉNÉRÉ — ne pas éditer » ; le dev le résout à la main (AD-3 violée dans les faits, la CI ne le voit que si elle tourne sur le résultat de fusion, ce que la spine n'exige pas). B fusionne ; `dev` reçoit B *après* A (`db push` applique les migrations absentes de `schema_migrations`), mais chaque poste local en `db reset` rejoue B *avant* A (ordre des timestamps). Si B référence une colonne de A (fréquent : deux stories sur `pin`), `local` casse et `dev` marche — ou l'inverse. Les pgTAP passent sur `dev` et échouent sur les postes.

**Proposition — AD-16 et AD-3 resserrées.**
- Une migration par PR ; `main` protégé avec « branches à jour » obligatoire (`strict status checks`) ; la CI rejoue `supabase db reset` **depuis zéro** + pgTAP + génération sur le commit de fusion.
- Check CI `migration-order` : refus de toute migration dont le timestamp est antérieur au dernier fusionné sur `main` ; le correctif est un renommage, jamais un `db push` manuel.
- Conflit Git sur `packages/api_types` ou `content/schema` : la seule résolution acceptée est `melos run gen` ; un hook lefthook `pre-commit` refuse un commit qui modifie ces dossiers sans passer par la commande.
- L'Intégrateur sérialise les PR portant le label `migration` (une seule en file à la fois).

---

## P6 — Cache hors-ligne : trois DAO Drift, aucune API de lecture — S2

**Unités.** (a) `mobile/core/offline` (AD-9 : « stockés via `core/offline` (Drift + fichiers) »). (b) `mobile/features/parcours` (Capability Map : D3 → `features/parcours`, `core/offline`). (c) `mobile/features/pins`, `audio`, `carte` — consommateurs. (d) `mobile/core/profile` (AD-4 : Drift aussi). (e) `mobile/features/proximite` (convention : « géofencing local à partir des pins préchargés »).

**Ce que chacune construit.**
- (a) AD-5 : `core/` n'importe aucune feature → construit un paquet générique `PaquetHorsLigne{parcoursId, fichiers[], lignes: Map<table, List<Json>>}` et un `Directory`.
- (b) AD-6 : « les DAO Drift ne sont injectés que dans `data/` » → construit ses propres tables Drift `parcours_telecharge`, `etape_locale`, `pin_local` dans `parcours/data`, et considère `core/offline` comme un simple gestionnaire de fichiers.
- (c) `pins/data/pin_repository.dart` en mode hors-ligne : lit où ? Pas `parcours/data` (AD-5). `core/offline` n'expose qu'un blob. `audio` cherche le chemin d'un fichier audio : idem. `carte` doit donner à MapLibre l'URL du PMTiles de l'emprise : idem.
- (d) ouvre sa propre base Drift `profil.db` ; (b) `parcours.db` ; (a) `offline.db` → trois bases, trois migrations Drift non gouvernées par AD-2 (qui ne parle que de `supabase/migrations/`).
- (e) « pins préchargés » : AD-9 dit que la *seule* unité est le Parcours ; D4.1 « balade libre par défaut » et D4.2 « Surprenez-moi » ont besoin des pins autour de l'utilisateur sans parcours. Équipe (e1) va chercher les pins en ligne et les met dans sa propre table Drift (viole « rien d'autre ») ; équipe (e2) limite la proximité à D4.3 (D4.1/D4.2 disparaissent).

**Politique de lecture.** La spine ne dit pas si un repository lit « réseau d'abord, cache si échec » ou « cache d'abord, rafraîchir ensuite ». `pins` prend l'un, `parcours` l'autre ; un Parcours mis à jour par l'admin apparaît dans le catalogue mais ses étapes restent anciennes.

**Proposition — AD-9 resserrée (+ AD-22 de P2).**
- `core/offline` est le **propriétaire unique** du paquet et de ses tables (dans la base Drift unique) ; il expose une API par entité : `pinLocal(id)`, `parcoursLocal(id)`, `fichierMedia(mediaId) → File?`, `pmtiles(parcoursId) → File?`, et une commande `telecharger(parcoursId)`, `supprimer(parcoursId)`.
- Les repositories de `pins`, `parcours`, `audio`, `carte` appliquent **une seule** politique, fixée ici : réseau d'abord avec délai court, repli sur `core/offline`, jamais de fusion silencieuse ; `etatReseau` vient de `core/session`.
- Version de paquet = `max(updated_at)` des lignes ; à l'ouverture d'un parcours en ligne, `core/offline` compare et propose la mise à jour.
- Second cache **assumé et nommé** : `core/offline.viewportCache` (dernier lot de pins chargé par la carte, TTL, sans médias), utilisé par `proximite` pour D4.1/D4.2 ; il n'est jamais présenté à l'utilisateur comme « hors-ligne » (bandeau palier 7 inchangé).

---

## P7 — Favori / Historique : la sync opt-in sans modèle de fusion — S2

**Unités.** (a) `mobile/core/profile/sync/` (AD-4). (b) `supabase/` tables `favori`, `historique_de_visite` avec RLS `compte_id = auth.uid()`. (c) Deux appareils du même Compte.

**Ce que chacune construit.**
- (a) Drift `favori(id int, type_cible, cible_slug, date_ajout)` ; sync = « push de tout ce qui est local », puis « pull de tout ce qui est serveur », union.
- (b) `favori(id uuid, compte_id, type_cible enum, cible_id uuid, date_ajout, unique(compte_id, type_cible, cible_id))`.
- (c) appareil 1 supprime le favori X, appareil 2 le consulte : au prochain pull, X revient sur l'appareil 1 (pas de tombstone). Historique : `enregistrement_historique_actif = false` sur un appareil et `true` sur l'autre : que fait le serveur ? Favori d'un parcours personnel local (P2) alors que la catégorie `parcours_personnels_créés` n'est pas activée : le serveur reçoit un `cible_id` orphelin — FK refusée ou ligne fantôme selon l'équipe.
- Deux Profils locaux (deux appareils, deux `identifiant_local`) rattachés au même Compte : fusion des préférences non définie.

**Proposition — AD-21 « Modèle de synchronisation ».**
- Toute table synchronisable a la même forme Drift/SQL (générée, AD-22) avec `id uuid` client, `updated_at timestamptz`, `deleted_at timestamptz` (tombstone, purge après 90 j).
- Fusion **LWW par ligne** sur `updated_at` ; pull-then-push par catégorie ; le serveur est l'arbitre, jamais le terminal.
- Dépendances entre catégories explicites : un favori dont la cible est locale et non synchronisée est **retenu** côté terminal (`sync_bloquee_par = parcours_personnels`) ; les préférences ne se synchronisent pas (elles restent par appareil).
- Un test `data` contre Supabase local avec deux profils Drift simulant deux appareils ; un pgTAP sur la policy `favori`.

---

## P8 — Signalement, Favori, Lien universel : trois polymorphismes, deux patrons SQL — S2

**Unités.** (a) équipe `supabase/` story « Signalement » ; (b) équipe `supabase/` story « Favori » ; (c) `mobile/features/pins` (le bouton « signaler » est sur l'écran du Pin, D2.5) ; (d) `mobile/features/communaute` (propriétaire du Signalement, C4).

**Ce que chacune construit.**
- (a) `signalement(type_cible enum, cible_id uuid)` sans FK (polymorphisme « à la Rails ») + trigger d'existence.
- (b) `favori(type_cible enum, pin_id uuid null, parcours_id uuid null, check(num_nonnulls(pin_id, parcours_id) = 1))`.
- Les deux respectent les conventions (uuid, enums, pas de booléen). `api_types` génère deux formes Dart différentes pour le même concept « cible polymorphe » ; `ui_kit` reçoit deux ViewModels ; l'admin `moderation` écrit deux fois la résolution de cible.
- (c) ne peut pas importer (d) : le bouton « signaler » de `pins/presentation` navigue vers une route… que (d) doit déclarer dans `core/router` — non dit.
- I5 (anonymat du signaleur) : (a) le code en RLS `select` pour les modérateurs seulement — qui est « modérateur » ? Voir P13.

**Proposition — Convention SQL « référence polymorphe » (Consistency Conventions).**
- Patron unique : `type_cible enum` + **une colonne FK nullable par type** + `CHECK (num_nonnulls(...) = 1)` + index partiel par type ; jamais de `cible_id` sans FK. Appliqué à Favori, Signalement, Lien universel, Historique.
- **AD-5 resserrée** (déjà en P3) : une action déclenchée depuis une feature mais possédée par une autre est une route typée `core/router` (`SignalerRoute(typeCible, id)`) déclarée par la feature propriétaire.

---

## P9 — `ui_kit` : le graphe AD-5 interdit `presentation → packages/` — S2

**Unités.** (a) Gardien du design / `packages/ui_kit` (AD-10). (b) `features/carte/presentation` (bandeau hors-ligne du palier 7, slider). (c) deux stories parallèles touchant `comp-pin-card`.

**Ce que chacune construit.**
- Le mermaid d'AD-5 autorise `P → D`, `P → C`, `D → C`, `DA → C`, `C → PK`, `DA → PK`. **Pas `P → PK`.** Le lint d'imports, écrit à la lettre, refuse `import 'package:ui_kit/...'` depuis `presentation/`. L'équipe (b) contourne via `core/theme` qui ré-exporte `ui_kit` (bricolage), ou copie le composant localement (AD-10 violée par nécessité).
- Un widget qui n'a pas d'id `comp-*` dans la maquette (ex. assemblage d'écran, état vide) : (a) dit « tout le visuel vit dans `ui_kit` », (b) dit « seulement les `comp-*` ». Les deux lisent AD-10 à la lettre.
- `ui_kit` importe-t-il `api_types` (un `PinCard(Pin pin)`) ? Si oui, chaque migration casse `ui_kit` et ses widget tests ; si non, chaque feature écrit un mapper. Non tranché.
- (c) deux PR modifient `comp-pin-card` pour deux features → conflit sur un paquet partagé, et AD-14 « widget tests des composants `ui_kit` touchés » est la *seule* politique de test pour `presentation` : un écran qui ne touche aucun `comp-*` n'a **aucun** test exigé.

**Proposition — AD-5 corrigée + AD-10 resserrée.**
- Graphe : ajouter `P → packages/ui_kit`, `P → packages/design_tokens` ; interdire `P → packages/api_types` (la présentation ne voit que des ViewModels de `domain`).
- Placement : un widget vit dans `ui_kit` **ssi** il porte un id `comp-*` ; sinon il vit dans la feature et ne compose que des `comp-*` et des tokens. `ui_kit` n'importe jamais `api_types` : ses composants prennent des primitives et des `sealed` de présentation.
- Modifier un `comp-*` = story `socle` séparée (AD-12 : elle touche plus d'une feature), relue par le Gardien du design.
- AD-14 : `presentation` = widget test par **écran** (golden ou pump) en plus des `comp-*`.

---

## P10 — Époque : catalogue ouvert en base (I7), fermé dans l'app (AD-8) — S2

**Unités.** (a) `admin/features/catalogue` ou `content/epoques/` (I7 : « l'équipe éditoriale peut en ajouter à tout moment »). (b) `packages/map_styles` + `features/carte` (AD-8 : « un fichier de style JSON par Époque, nommé par le slug »).

**Collision.** (a) ajoute `epoque(slug = 'renaissance')` un mardi ; l'app installée le lundi n'a pas `map_styles/renaissance.json` ; le slider (continu, D1.2) atteint cette époque : (b1) plante, (b2) garde le style précédent, (b3) affiche le style « aujourd'hui » — trois comportements légitimes, aucun spécifié. `content/epoques/` seedé et `admin/catalogue` peuvent en plus diverger sur l'`ordre` (I7 ne prévoit pas de réordonnancement).

**Proposition — AD-8 resserrée.**
- Le catalogue d'Époques est **fermé par release** : la migration ou le fichier `content/epoques/<slug>.yaml` et `map_styles/<slug>.json` sont dans la même PR ; check CI `epoque-style` : chaque slug d'époque en base locale a son style et réciproquement.
- L'admin ne crée pas d'Époque (lecture seule sur `epoque` et `categorie`, phases 1 et 2) ; I7 reste vrai par PR de contenu, pas par saisie.
- Fallback nommé : style de l'époque de rang `ordre − 1`, journalisé.

---

## P11 — « Tests d'abord » : la preuve disparaît au squash, le hook l'interdit — S3

**Unités.** (a) Gardien des tests (AD-14 : « le premier commit … contient ses tests (rouges) ; l'ordre est visible dans l'historique de la PR »). (b) Intégrateur (AD-13 squash ; `lefthook.yml` pre-push). (c) `tools/report` (AD-17 : uniquement issues, PR, labels, artefacts CI).

**Collision.**
- (b) configure `pre-push: flutter test` (réflexe naturel) : le premier commit rouge ne peut pas être poussé ; les devs marquent les tests `skip` ou les écrivent verts avec le code — AD-14 vidée.
- Après squash, l'historique de branche n'existe plus dans le clone ; (c) ne peut pas calculer « taux de stories test-first ». GitHub garde `refs/pull/N/head` mais `tools/report` n'y accède que s'il le sait.
- « Couverture ne baisse jamais » (cliquet) : une story qui supprime du code mort couvert à 100 % fait baisser le ratio → PR bloquée sans issue.

**Proposition — AD-14 resserrée.**
- La preuve est un check CI `tests-first` : sur `refs/pull/N/commits`, le premier commit ne modifie que `**/*_test.dart`, `supabase/tests/**`, `content/schema/**` ; il pose le label `tests-first:ok|ko` ; c'est **le label** que `tools/report` consomme.
- `lefthook` : `pre-commit` = format + lint + `gen-check` ; `pre-push` = rien qui exige des tests verts.
- Cliquet sur la couverture **absolue en lignes couvertes** ou avec tolérance de 0,5 pt, jamais sur le ratio brut.

---

## P12 — Découpe : « plus d'une couche non triviale » a deux lectures — S3

**Unités.** Découpeur A et Découpeur B (AD-18 : deux titulaires), sur la story « ajouter `badge` au Pin ».

**Collision.** La story touche `supabase/migrations` + `supabase/tests` + `packages/api_types` (AD-3 même PR) + `content/schema` (dérivé — par qui ?) + `content/pins/*.yaml` + `mobile/features/pins/{data,domain,presentation}` + `admin/features/saisie`. A découpe en 5 stories horizontales (schéma, contenu, mobile data, mobile UI, admin) : `main` porte une colonne sans lecteur pendant une itération, 5 PR sérialisées, 5 relectures. B garde une story verticale (« chaque couche est triviale »). Les deux obéissent à AD-12. `tools/report` compte 5 stories fermées contre 1 : les KPIs d'AD-17 ne sont pas comparables entre les deux Découpeurs.

**Proposition — AD-12 resserrée.**
- Découpe **verticale** par défaut : une story = un incrément observable par un utilisateur ou par un test.
- `supabase/` + `packages/api_types` + `content/schema` comptent pour **une** couche, car générés par une seule commande (`melos run gen`) ; une story peut y toucher plus UNE feature d'UNE app.
- Elle est découpée si elle touche deux features ou deux apps (mobile + admin = deux stories liées par une issue « épique »).
- `content/schema` est produit par `tools/gen-types` (jamais édité) — fermeture du trou de P4.

---

## P13 — Auth : `auth.uid()` ne dit pas qui est modérateur, ni qui est anonyme — S2

**Unités.** (a) `supabase/` policies (convention Auth : « RLS par `auth.uid()` »). (b) `admin/features/moderation` (I5 : « seuls les modérateurs ») et `validation` (validateur scientifique, Trace de validation). (c) `mobile` anonyme (I6 : pas de Compte) qui lit le contenu public.

**Collision.**
- (a1) code les rôles en claims JWT custom (hook Auth) ; (a2) en table `compte_role` ; (b) écrit ses gardes UI sur l'un ou l'autre ; les pgTAP par policy testent des choses différentes.
- (c) le mobile anonyme utilise le rôle Postgres `anon` : la spine ne dit pas que `select` sur `pin` publié est ouvert à `anon`, ni que `insert` sur `signalement` (I5 : `0..1 Compte signaleur` → un anonyme peut signaler) l'est. Une équipe ouvre tout à `anon`, l'autre exige `authenticated` partout et casse D6 « app fonctionnelle sans compte ».
- « `auth.users.id = compte.id` » : la création du Compte par trigger sur `auth.users` ou par RPC après inscription ? Deux équipes, deux réponses, et le pseudonyme obligatoire (I2) n'est garanti que dans l'une.

**Proposition — Convention Auth resserrée.**
- Rôles en table `compte_role(compte_id, role enum(lecteur, contributeur, validateur, moderateur, admin))`, fonction SQL `has_role(role)` utilisée par toutes les policies ; jamais de claims custom.
- Matrice RLS par rôle × table dans `docs/conventions/rls.md`, un pgTAP par cellule non triviale ; `anon` = lecture des contenus `statut in (publie, valide)` et `insert` de Signalement.
- `compte` créé par trigger sur `auth.users` avec `pseudonyme` nul ; I2 est une policy « `pseudonyme is not null` pour publier », testée.

---

## Ce que la spine fait bien (pour ne pas surcorriger)

- AD-1, AD-2, AD-3, AD-16 forment un socle cohérent ; les paires trouvées autour d'elles (P5) sont de la mécanique CI, pas des choix contestés.
- AD-11 est un bon exemple de contrat étanche : aucune paire trouvée sur `features/immersion`.
- AD-15 et AD-17 tiennent ; P11 ne demande qu'une source de vérité (le label) pour le reporting.

## Liste des amendements à porter dans la spine

| Action | Cible |
| --- | --- |
| Ajouter | **AD-19** Ownership des entités et transitions d'état (RPC SQL, table d'ownership, colonnes de cycle de vie non-updatables) |
| Ajouter | **AD-20** État de session partagé dans `core/session` ; interaction inter-features = routes + session uniquement |
| Ajouter | **AD-21** Modèle de synchronisation (uuid client, `updated_at`/`deleted_at`, LWW, dépendances entre catégories) |
| Ajouter | **AD-22** Une seule base Drift, tables miroir générées, uuid client partout |
| Amender | **AD-4** : C2 hors `provenance = personnel` ; propriétaire = `features/parcours/data` |
| Resserrer | **AD-5** : graphe `P → ui_kit/design_tokens` ; `P ↛ api_types` ; interactions inter-features nommées |
| Resserrer | **AD-6** : le chemin unique serveur est la RPC ; le repository est son appelant |
| Resserrer | **AD-7** : seed upsert-only, `editorial` seulement, jamais `statut` ; `content/` exhaustif ; `content/schema` généré |
| Resserrer | **AD-8** : catalogue d'Époques fermé par release ; check slug↔style ; fallback nommé |
| Resserrer | **AD-9** : `core/offline` propriétaire unique, API par entité, politique de lecture unique, `viewportCache` assumé |
| Resserrer | **AD-10** : règle de placement `comp-*`, `ui_kit` sans type métier, modification = story `socle` |
| Resserrer | **AD-12** : découpe verticale, couche « générée » unique, deux features/apps = découpe |
| Resserrer | **AD-14** : preuve test-first = check CI + label ; lefthook sans tests ; cliquet en lignes absolues ; test par écran |
| Resserrer | **AD-16 / AD-3** : une migration par PR, branche à jour, `db reset` sur fusion, check d'ordre, conflit généré = régénérer |
| Convention | Référence polymorphe : enum + FK nullables + `num_nonnulls = 1` |
| Convention | Auth : rôles en table, `has_role()`, matrice RLS, `anon` défini, création de `compte` par trigger |
| Convention | Storage : buckets `images/audio/models/tiles/uploads`, clé `<entite>/<slug>/<sha16>.<ext>`, `media(bucket, object_key)` jamais d'URL |
| Trancher | Question ouverte D1.2 (priorité utilisateur vs parcours) — dans AD-20 |
