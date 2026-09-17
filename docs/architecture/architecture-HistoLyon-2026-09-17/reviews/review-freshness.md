# Revue « fraîcheur » — ARCHITECTURE-SPINE HistoLyon

- Date : 2026-09-17
- Lentille : chaque décision engagée a-t-elle été vérifiée contre le web / la réalité plutôt qu'affirmée de mémoire ? (versions courantes, existence et pertinence de chaque techno, défauts réels des starters)
- Méthode : chaque version de la table Stack a été confrontée à `https://pub.dev/api/packages/<name>`, aux releases GitHub, aux JSON de release Flutter et aux docs officielles le 2026-09-17. Les points (a)–(e) ont été creusés dans les docs et changelogs des projets concernés.

## Verdict

La table Stack est à jour à une exception près (riverpod_generator), mais trois décisions structurantes reposent sur des hypothèses non vérifiées qui ne tiennent pas telles quelles : `melos.yaml` n'existe plus depuis melos 7, le couple OpenFreeMap (en ligne) / Protomaps PMTiles (hors-ligne) ne partage pas le même schéma de couches (donc pas « un style JSON par Époque » unique), et supadart exige de recopier les enums à la main alors qu'AD-3 interdit toute écriture manuelle — et Supabase publie depuis septembre 2026 un générateur Dart officiel (`supabase_typegen`) qui rend le « Deferred » sur ce sujet caduc.

## 1. Table Stack — vérification version par version

| Techno | Spine | Réel (2026-09-17) | Source | Statut |
| --- | --- | --- | --- | --- |
| Flutter stable / Dart | 3.47.4 / 3.13.3 | 3.47.4 / 3.13.3 (2026-09-11) | `storage.googleapis.com/flutter_infra_release/releases/releases_linux.json` | OK |
| flutter_riverpod | 3.4.3 | 3.4.3 (2026-09-03), SDK ^3.12 | pub.dev API | OK |
| riverpod_generator | « 3.4.3 » | **4.0.9** (2026-09-03) ; dépend de `riverpod_annotation` 4.0.7 → `riverpod` 3.4.3 | pub.dev API | **Erreur de version** : le générateur n'a jamais été en 3.4.x. Compatible avec Riverpod 3.4.3 (point d) |
| go_router | 18.0.1 | 18.0.1 (2026-09-02), exige Flutter ≥ 3.44 | pub.dev API | OK |
| drift | 2.35.0 | 2.35.0 (2026-09-09) ; `drift_dev` 2.35.0, `drift_flutter` 0.3.1 | pub.dev API | OK (ajouter `drift_dev`, `drift_flutter`, `build_runner` 2.16.1 dans la liste, ils sont obligatoires) |
| supabase_flutter | 2.17.2 | 2.17.2 (2026-08-14) ; **3.0.0-dev.4** en cours | pub.dev API | OK, mais v3 imminente (voir §3c) |
| maplibre_gl | 0.27.1 | 0.27.1 (2026-09-10) ; embarque MapLibre Native Android 13.5.0 / iOS 6.28.0 | pub.dev + `flutter-maplibre-gl` release notes | OK. **Note** : 0.27.0 ne compile pas sur Android avec Flutter ≥ 3.44 (`Could not find method kotlin()`), corrigé en 0.27.1 → pinner `>=0.27.1`. |
| melos | 8.7.0 | 8.7.0 (2026-09-09), SDK ^3.9 | pub.dev API | Version OK, **usage obsolète** (§3b) |
| flutter_lints | 6.0.0 | 6.0.0 (2025-05-27) ; c'est ce que `flutter create` 3.47.4 met dans le template (`^6.0.0`) | pub.dev + `flutter/flutter@3.47.4` template | OK |
| Supabase CLI | 2.117.0 | v2.117.0 (2026-09-07) ; `supabase test db` = pg_prove/pgTAP sur `supabase/tests/*.sql|.pg`, chaque test dans sa transaction | GitHub releases + docs `reference/cli/supabase-test-db` | OK |
| supadart | 1.9.3 | 1.9.3 (2026-05-11) ; repo 107 étoiles, dernier push 2026-08-03, 14 issues ouvertes | pub.dev + GitHub API | Version OK, pertinence à revoir (§3c) |
| lefthook | 2.1.14 | v2.1.14 (2026-09-14) sur GitHub `evilmartians/lefthook` | GitHub releases | OK. Attention : le paquet pub.dev `lefthook` (0.6.5, 2019) n'a rien à voir ; installer le binaire (npm/brew/apt), pas via pub. |
| OpenFreeMap | en ligne, sans clé | Confirmé : « no limits… no registration… no API keys » ; styles `https://tiles.openfreemap.org/styles/{liberty,bright,positron,…}` ; schéma **OpenMapTiles** | openfreemap.org | OK, mais schéma de couches ≠ Protomaps (§3a) |
| Protomaps PMTiles | hors-ligne | `pmtiles` CLI v1.31.2 (2026-07-22), `pmtiles extract --bbox` existe ; schéma de couches **Protomaps basemaps** | docs.protomaps.com, GitHub | OK, mais voir §3a |
| PostGIS sur Supabase | `geography(Point,4326)` | Extension disponible (guide officiel `database/extensions/postgis`), incluse dans la stack locale CLI | supabase.com/docs | OK |
| `--dart-define-from-file` | conv. Config | Option toujours présente dans `flutter_tools` 3.47.4 (`kDartDefineFromFileOption`) | flutter/flutter@3.47.4 | OK |
| Conventional Commits, GitHub Environments | process | Standards stables, pas de version | — | OK |

Non listés mais implicites et à ajouter à la Stack : `riverpod_annotation` 4.0.7, `riverpod_lint` 3.1.9 + `custom_lint` 0.8.1 (le lint d'imports d'AD-5 passera vraisemblablement par `custom_lint` ou `dart_code_linter`), `build_runner` 2.16.1, `geobase` 1.5.0 si supadart+PostGIS est conservé.

## 2. Réponses aux points spécifiques

### (a) maplibre_gl 0.27.1 : PMTiles hors-ligne sur Android et style JSON à chaud — OUI, avec conditions

- **PMTiles** : « Starting MapLibre Android 11.7.0, PMTiles archives are supported as tile sources » (docs MapLibre Native Android, exemple *PMTiles*). maplibre_gl 0.27.1 embarque MapLibre Native Android **13.5.0** (changelog 0.26.x). Formats acceptés : `pmtiles://https://…` (distant, range requests) et **`pmtiles://file:///chemin/absolu.pmtiles`** (fichier sur le terminal, `filesDir`/`getExternalFilesDir`). L'URL interne doit être complète (« not `pmtiles://tiles.pmtiles` »).
- **Limites réelles** :
  - `pmtiles://asset://` **ne marche pas** sur Android (« AssetManagerFileSource does not implement byte-range reads »). Le doc Flutter parle de « bundle as a Flutter asset » mais en pratique il faut copier sur disque et référencer en `file://` — ce qui est de toute façon le cas d'AD-9 (paquet téléchargé par Parcours, stocké via `core/offline`).
  - « PMTiles sources do not support offline pack downloads or caching » : les *Offline Regions* de MapLibre ne s'appliquent pas aux sources PMTiles. AD-9 est cohérent avec ça (le paquet est géré par l'app, pas par MapLibre), mais il faut le dire explicitement : **l'extrait par emprise n'est pas produit par MapLibre** ; il doit être découpé côté serveur/outil (`pmtiles extract INPUT OUTPUT --bbox=… --maxzoom=…`) et servi comme un fichier (Supabase Storage). Ce n'est écrit nulle part dans la spine.
  - Sprites/glyphes : un style chargé depuis les assets ne peut pas pointer `sprite`/`glyphs` vers `asset://` ; il faut copier sur disque et référencer en `file://` (guide « local sprites and glyphs », 0.27.1). Hors-ligne, cela signifie que **chaque paquet Parcours (ou l'app) doit embarquer les glyphes/sprites** des styles d'Époque, sinon les libellés disparaissent hors connexion.
- **Style à chaud** : `controller.setStyle(...)` existe depuis la release alignée sur MapLibre Native 11.9.0 (« Runtime style switching via controller without tearing down the map », #444/#603) et accepte une chaîne JSON brute sur les 3 plateformes (0.27.1, #1026). Contrainte : « Style reload clears layers — Calling `setStyle()` removes all sources and layers you added programmatically » → les pins ajoutés par code doivent être ré-ajoutés dans `onStyleLoadedCallback` à chaque mouvement du slider. AD-8 (« le slider ne fait que sélectionner un style ») est réalisable mais cette re-injection doit être prévue dans `features/carte`.

### (b) melos 8 vs Pub workspaces — melos reste pertinent, mais PAS sous la forme décrite

- melos **7.0.0** : « **BREAKING** Migrate to use the Pub workspaces feature (#816) » et « **BREAKING** Remove `melos.yaml` in favor of the root `pubspec.yaml` (#832) ». Le guide *Getting started* actuel demande : un `pubspec.yaml` racine avec `workspace:` listant les paquets, `resolution: workspace` dans chaque `pubspec.yaml` de paquet, et une section `melos:` optionnelle dans le pubspec racine pour les scripts.
- La spine (arbre `histolyon/`) affiche **`melos.yaml # workspace Dart`** : ce fichier n'est plus lu par melos 8.7.0. À corriger en `pubspec.yaml` racine (`workspace:` + `melos:`), et à noter que les globs dans `workspace:` sont supportés à partir de Dart 3.11 (OK avec 3.13.3).
- Recommandation actuelle : Pub workspaces natifs pour la résolution (obligatoire), melos par-dessus pour `melos run`/`exec`/versionnement. Pour un monorepo de 2 apps + 4 paquets, melos est justifiable pour les scripts (`melos run test`, `melos exec`), mais il n'est plus « le » workspace : la spine doit le présenter comme un lanceur de scripts sur des Pub workspaces.

### (c) supadart : enums et PostGIS geography — partiellement, avec de la saisie manuelle

- **Enums** : « You need to specify your enums on supadart.yaml config file » ; les noms sont convertis en `UPPERCASE` (`enum MOOD {…}`). Issues ouvertes : #165 *Auto-generate enums* (2025-09), #164 *Nullable enum column* (le `fromJson` retombe sur `values.first` au lieu de `null`). Conséquences pour la spine : (1) AD-3 « jamais écrits à la main » est violé — les enums `statut`/`provenance` (convention *Statut & provenance*) devront être recopiés dans `supadart.yaml` à chaque migration ; (2) la convention « `lowerCamelCase` en Dart » est contredite par les noms `STATUT`, `PROVENANCE` générés ; (3) les colonnes enum nullables sont mal désérialisées.
- **PostGIS** : supporté depuis 1.8.1 via le paquet `geobase` (`postGIS: true` dans `supadart.yaml`, décodage WKB hex). Issue #166 ouverte (2025-09, 0 commentaire) : « PostgREST provides it already decoded » (GeoJSON) alors que le code généré attend du WKB hex ; un « Bugfix/geospacial » est passé en 1.9.2 sans fermer l'issue. À valider par un test réel sur `geography(Point,4326)` avant d'engager.
- **Clés API** : supadart introspecte via l'OpenAPI de PostgREST (`/rest/v1/`), qui **n'est plus accessible avec la clé anon/publishable** (changelog Supabase 42949) ; il faut la clé `sb_secret_…` (1.9.3 documente le 401). En local, `supabase status` la fournit ; en CI, c'est un secret de plus.
- **Fait nouveau non pris en compte** : le monorepo officiel `supabase/supabase-flutter` publie **`supabase_typegen`** (0.1.4, 2026-09-15) : introspection du catalogue Postgres via `supabase db query --local` (le SQL de `supabase/` reste la source de vérité), enums Postgres générés automatiquement avec mapping de nom, nullabilité/defaults/identity exacts, relations FK typées ; annoncé comme futur `supabase gen types --lang dart`. Contrepartie : les types `PostgrestTable`/`PostgrestColumn` n'existent que dans **postgrest 3.0.0-dev** (donc `supabase_flutter` 3.0.0-dev.x, prérelease). Le « Deferred : supadart vs OpenAPI PostgREST » est donc mal posé — l'alternative réelle est `supadart` (stable, communautaire, enums manuels) vs `supabase_typegen` (officiel, auto, client prérelease). Note : ni l'un ni l'autre ne documente un type Dart pour `geography` ; avec typegen, une colonne PostGIS sort vraisemblablement en `String`/`dynamic` — à vérifier par essai.

### (d) riverpod_generator est-il compatible Riverpod 3.4.3 — OUI

Chaîne de dépendances vérifiée sur pub.dev : `riverpod_generator` 4.0.9 → `riverpod_annotation` 4.0.7 → `riverpod` 3.4.3 ; `flutter_riverpod` 3.4.3 → `riverpod` 3.4.3. Tous exigent Dart ^3.12 (OK avec 3.13.3) et `build_runner` 2.16.1 / `analyzer` 13–14. Seule la ligne Stack est fausse : « flutter_riverpod + riverpod_generator | 3.4.3 » doit devenir « flutter_riverpod 3.4.3 · riverpod_annotation 4.0.7 · riverpod_generator 4.0.9 · riverpod_lint 3.1.9 ».

### (e) Flutter Web pour un back-office desktop en 2026 — raisonnable, avec trois conditions à écrire

- **Renderers** : le renderer HTML a été supprimé (Flutter 3.29) ; il reste CanvasKit (JS, défaut) et Skwasm (`flutter build web --wasm`). Wasm n'est multi-thread que si l'hébergeur envoie `Cross-Origin-Embedder-Policy: credentialless|require-corp` et `Cross-Origin-Opener-Policy: same-origin` ; sinon repli JS automatique. **GitHub Pages ne permet pas de définir ces en-têtes**, Cloudflare Pages oui (`_headers`). Le « Deferred : Hébergeur de apps/admin (GitHub Pages / Cloudflare Pages) » n'est donc pas indifférent si l'on veut Wasm ; en mode CanvasKit/JS les deux conviennent.
- **Navigateurs** : Wasm requiert WasmGC — Chrome ≥ 119 OK ; Firefox et Safari listés avec limitations dans la doc officielle. Pour un back-office interne, imposer Chrome/Edge est acceptable ; à écrire.
- **Accessibilité** : « For performance reasons, Flutter's web accessibility is not on by default » ; il faut `SemanticsBinding.instance.ensureSemantics()` au démarrage (ou le bouton invisible « Enable accessibility »). Pour un outil de saisie utilisé par des étudiants/enseignants, l'appel doit être inconditionnel dans `apps/admin/main.dart` — à inscrire dans les conventions.
- **Taille** : CanvasKit ≈ 1,5 Mo de wasm + le JS de l'app ; acceptable en intranet, non optimisé pour le mobile web (hors périmètre ici).
- **Compatibilité des dépendances web** : `supabase_flutter` 2.17.2 est compatible web/wasm ; `maplibre_gl` 0.27.1 supporte le web (PMTiles nécessite l'enregistrement du protocole au démarrage sur web) ; `drift` sur web exige sqlite3.wasm + worker, mais l'admin n'a pas de Drift (AD-4 : Profil local = mobile seulement). Aucun bloqueur.
- Verdict : choix défendable pour un back-office desktop interne à condition de fixer (1) renderer CanvasKit par défaut, Wasm en option, (2) Chrome/Edge comme navigateurs supportés, (3) `ensureSemantics()` obligatoire.

## 3. Findings (classés par impact)

### F1 — AD-8 : OpenFreeMap (OpenMapTiles) et Protomaps (schéma Protomaps) n'ont pas les mêmes couches → « un style JSON par Époque » est irréalisable tel quel

- Fait : OpenFreeMap sert des tuiles au schéma **OpenMapTiles** (couches `transportation`, `place`, `water`, `building`…) ; Protomaps sert le schéma **Protomaps basemaps** (`roads`, `places`, `water`, `buildings`…). Un style MapLibre référence des `source-layer` par nom ; un même fichier ne peut pas cibler les deux.
- Impact : soit deux styles par Époque (en ligne / hors-ligne) à maintenir en double, soit des couches vides hors-ligne.
- Correction : **une seule chaîne de tuiles**. Option A (recommandée) : OpenFreeMap publie des dumps planète MBTiles (schéma OpenMapTiles) ; `pmtiles convert` puis `pmtiles extract --bbox` (CLI v1.31.2) produisent les extraits Lyon/Parcours au **même schéma** que le service en ligne. Option B : Protomaps partout (auto-hébergement d'un `.pmtiles` Lyon sur Supabase Storage/R2 pour le mode en ligne ; l'API hébergée protomaps.com nécessite une clé). Dans les deux cas, réécrire AD-8 pour nommer un schéma de couches unique et le vérifier par un test qui charge chaque style d'Époque contre un extrait local.

### F2 — Arbre du repo : `melos.yaml` n'existe plus (melos ≥ 7)

- Fait : changelog melos 7.0.0 « Remove melos.yaml in favor of the root pubspec.yaml » ; melos 8.7.0 s'appuie sur les Pub workspaces.
- Correction : remplacer `melos.yaml` par `pubspec.yaml` racine (`workspace: [apps/mobile, apps/admin, packages/*]`, `melos:` pour les scripts) ; `resolution: workspace` dans chaque paquet ; noter Dart ≥ 3.11 pour les globs. Reformuler AD-1 : « workspace Pub natif, melos comme lanceur de scripts ».

### F3 — AD-3 / supadart : enums recopiés à la main, noms en UPPERCASE, générateur officiel ignoré

- Fait : supadart 1.9.3 exige `enums:` dans `supadart.yaml` (issues #165, #164 ouvertes), génère `enum STATUT {…}`, requiert la clé `sb_secret_` pour l'OpenAPI, et l'issue PostGIS #166 est ouverte. `supabase_typegen` 0.1.4 (officiel, 2026-09-15) introspecte le catalogue et génère les enums, mais cible `supabase_flutter` 3.0.0-dev.
- Correction : (1) amender AD-3 pour admettre que `supadart.yaml` est une source manuelle et ajouter un test CI qui compare `enums:` au catalogue (`select enum_range(null::statut)`) ; (2) réécrire le Deferred en « supadart 1.9.3 (stable) vs supabase_typegen 0.1.x (officiel, exige supabase_flutter 3.0.0-dev) », condition de revisite = sortie stable de `supabase_flutter` 3.0 / `supabase gen types --lang dart` ; (3) spike obligatoire avant la première migration : générer une table avec `geography(Point,4326)` + enum nullable et vérifier la désérialisation réelle.

### F4 — Stack : version de riverpod_generator fausse et paquets de génération absents

- Fait : riverpod_generator est en 4.0.9 (jamais 3.4.x). `riverpod_annotation`, `riverpod_lint`, `custom_lint`, `build_runner`, `drift_dev`, `drift_flutter` ne figurent pas dans la table alors qu'ils sont indispensables.
- Correction : ligne « flutter_riverpod 3.4.3 · riverpod_annotation 4.0.7 · riverpod_generator 4.0.9 · riverpod_lint 3.1.9 · custom_lint 0.8.1 » ; ligne « drift 2.35.0 · drift_dev 2.35.0 · drift_flutter 0.3.1 · build_runner 2.16.1 ».

### F5 — AD-9 / AD-8 : ce que MapLibre fait et ne fait pas hors-ligne n'est pas écrit

- Fait : `pmtiles://file://` fonctionne sur Android (MapLibre Native ≥ 11.7.0, 13.5.0 embarqué), mais (i) les Offline Regions MapLibre ne couvrent pas PMTiles, (ii) `asset://` est refusé pour PMTiles, sprites et glyphes, (iii) `setStyle()` efface les couches ajoutées par code, (iv) 0.27.0 est cassé sur Android avec Flutter ≥ 3.44.
- Correction : dans AD-9, préciser « l'extrait PMTiles est produit hors app (`pmtiles extract --bbox`) et servi par Storage ; `core/offline` le copie sur disque et le style le référence en `pmtiles://file://` ; glyphes et sprites des styles d'Époque sont copiés sur disque au premier lancement et référencés en `file://` ». Dans AD-8, ajouter « après `setStyle`, `features/carte` ré-injecte ses couches dans `onStyleLoadedCallback` ». Pinner `maplibre_gl >=0.27.1`.

### F6 — Config Supabase : clés `anon`/`service_role` dépréciées fin 2026

- Fait : docs Supabase *API keys* — « deprecating the `anon` and `service_role` keys by the end of 2026 » ; `supabase start` émet déjà `sb_publishable_…`/`sb_secret_…`.
- Correction : dans AD-16 / convention Config, nommer les clés `SUPABASE_PUBLISHABLE_KEY` (client) et `SUPABASE_SECRET_KEY` (CI : migrations, supadart) dans `env/*.json` et les GitHub Environments ; ne jamais introduire `anon`.

### F7 — Flutter Web : conditions d'exploitation non fixées (renderer, navigateurs, a11y, en-têtes)

- Fait : voir §2(e).
- Correction : ajouter aux conventions « `apps/admin` : CanvasKit par défaut ; Chrome/Edge supportés ; `SemanticsBinding.instance.ensureSemantics()` au démarrage ; si `--wasm`, l'hébergeur doit servir COOP/COEP (Cloudflare Pages `_headers`) — GitHub Pages ne le peut pas ».

### F8 — `supabase_flutter` 3.0.0-dev en cours

- Fait : `supabase_flutter`/`supabase`/`postgrest` 3.0.0-dev.4 publiés ; API typée (`PostgrestTable`) uniquement en v3.
- Correction : figer `^2.17.2` pour la phase 1, ajouter au Deferred « migration supabase_flutter 3 » avec condition « release stable + supabase_typegen ≥ 1.0 ».

## 4. Ce qui est confirmé sans réserve

Flutter 3.47.4 / Dart 3.13.3 ; go_router 18.0.1 ; drift 2.35.0 ; supabase_flutter 2.17.2 ; maplibre_gl 0.27.1 (avec PMTiles `file://` et `setStyle` JSON) ; melos 8.7.0 ; flutter_lints 6.0.0 (= template `flutter create` 3.47.4) ; Supabase CLI 2.117.0 avec `supabase test db` pgTAP ; lefthook 2.1.14 (binaire GitHub) ; OpenFreeMap sans clé ni quota ; `pmtiles extract` ; PostGIS sur Supabase ; `--dart-define-from-file`.

## 5. Sources consultées

- pub.dev API : flutter_riverpod, riverpod, riverpod_annotation, riverpod_generator, riverpod_lint, custom_lint, go_router, drift, drift_dev, drift_flutter, supabase_flutter, supabase, postgrest, supabase_typegen, maplibre_gl, melos, flutter_lints, supadart, lefthook, build_runner, geobase, pmtiles
- https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json
- https://github.com/supabase/cli/releases/latest · https://github.com/evilmartians/lefthook/releases/latest · https://github.com/maplibre/flutter-maplibre-gl/releases/latest · https://github.com/protomaps/go-pmtiles/releases/latest
- https://maplibre.org/flutter-maplibre-gl/concepts/styles/ · https://maplibre.org/flutter-maplibre-gl/advanced/pmtiles/ · https://maplibre.org/maplibre-native/android/examples/data/PMTiles/ · CHANGELOG et `android/build.gradle` de flutter-maplibre-gl v0.27.1
- https://melos.invertase.dev/getting-started · CHANGELOG melos (7.0.0)
- https://github.com/mmvergara/supadart (README.MD, PostGIS-types.md, cli/CHANGELOG.md, issues #164 #165 #166 #185)
- https://github.com/supabase/supabase-flutter/tree/main/packages/supabase_typegen (README) · CHANGELOG postgrest
- https://supabase.com/docs/reference/cli/supabase-test-db · https://supabase.com/docs/guides/api/api-keys · https://supabase.com/docs/guides/database/extensions/postgis
- https://openfreemap.org/ · https://openfreemap.org/quick_start/ · https://docs.protomaps.com/pmtiles/cli · https://docs.protomaps.com/basemaps/layers
- https://docs.flutter.dev/platform-integration/web/wasm · https://docs.flutter.dev/ui/accessibility/web-accessibility · https://docs.flutter.dev/release/release-notes/release-notes-3.47.0
- https://riverpod.dev/docs/introduction/getting_started
- flutter/flutter@3.47.4 : `packages/flutter_tools/templates/app/pubspec.yaml.tmpl`, `lib/src/runner/flutter_command.dart`
