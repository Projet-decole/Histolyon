# HistoLyon — Bootstrap du dépôt

*Public : la personne (ou le binôme) qui monte le socle. Objectif : partir d'un dépôt vierge et arriver à l'état où **n'importe quel membre peut prendre une story et la livrer** en suivant le process. Chaque étape est un épic `socle`, découpé en stories d'une seule zone (AD-12) — le bootstrap est la première itération, faite avec le process qu'il installe.*

Trois sources sont supposées connues : les règles `AD-n` et les sections *Stack*, *Consistency Conventions* et *Structural Seed* sont dans `ARCHITECTURE-SPINE.md` ; le process (casquettes, itération, story) est dans `ORGANISATION.md` (le guide de l'équipe) ; les « paliers » renvoient à `conception/`. Le « memlog » (`.memlog.md`) est le journal des décisions de la spine. Les versions sont celles vérifiées le 2026-09-17.

**Chemin** : dépôt → documentation → base → types → contenu → app mobile → hooks, CI et environnements → suivi → première session. Les checks CI cités dans `socle-02` à `socle-05` sont câblés dans `socle-09` ; d'ici là, ils s'exécutent en local.

---

## 0. Prérequis (hors dépôt, une fois)

| Quoi | Détail |
| --- | --- |
| Organisation GitHub | Une org (gratuite) ; tous les membres invités ; dépôt `histolyon` privé ou public (au choix de l'équipe) |
| Organisation Supabase | Un compte d'équipe ; seuls deux projets seront créés (`dev`, `demo`) — AD-19 |
| Dossier de médias partagé | Un dossier SharePoint/OneDrive `HistoLyon-medias/` : c'est de là que `tools/media` téléverse ; les médias ne vont jamais dans Git — AD-7 |
| Poste de chaque dev | Flutter 3.47.4 (stable), Docker (pour Supabase local), Supabase CLI 2.117, lefthook 2.1, Android Studio ou SDK Android (API 21+, JDK 21) |
| Figma | Accès lecture au fichier `Histo-Lyon` pour le Gardien du design ; export des variables pour `tools/check-tokens` |

## 1. Le dépôt et le workspace — `socle-01`

1. `git init`, `main` protégé dès le premier push (PR obligatoire, branche à jour, squash uniquement) — AD-13 ; l'approbation obligatoire est activée après la relecture groupée de fin de socle, avant la première session.
2. `pubspec.yaml` racine avec `workspace:` listant `apps/mobile`, `apps/admin`, `packages/*` ; section `melos:` pour les scripts (`analyze`, `test`, `format`, `gen`) ; melos 8.7 en dev dependency. Pas de `melos.yaml` (supprimé depuis melos 7).
3. Arbre de dossiers de la spine (§ *Structural Seed*), avec un `README.md` d'une ligne dans chaque dossier encore vide pour dire ce qui y vivra.
4. `apps/mobile` et `apps/admin` créés par `flutter create` (`--platforms=android` et `--platforms=web` respectivement), `resolution: workspace` dans chaque `pubspec.yaml`.
5. `flutter_lints` 6 + une règle de lint d'imports (interdiction `features/* → features/*`, `core/* → features/*`) — AD-5. `riverpod_lint` **différé à l'Epic 6** (Story 6.1+, quand Riverpod est réellement utilisé) : `custom_lint` (dont dépend `riverpod_lint`) exige `cli_util ^0.4.2` quelle que soit sa version, incompatible avec `melos` (`cli_util >=0.5.0 <0.7.0`) dans la résolution unifiée d'un workspace Pub natif — conflit vérifié empiriquement en Story 1.5, aucune version ne le résout. La règle de lint d'imports est implémentée sans dépendance tierce (`tools/check_import_direction.dart`, `dart:io` seul), branchée dans `melos run analyze`, pour la même raison.

**Fini quand** : `melos run analyze` et `melos run test` passent sur les squelettes vides.

## 2. La documentation, avant le code — `socle-02`

1. `conception/` importée telle quelle depuis l'ancien dépôt.
2. `tools/ctx` : script qui, pour un ID (`D1.2`, `I6`, `07-ecrans/carte/01`), imprime l'extrait YAML correspondant ; il génère aussi `conception/INDEX.md` (id → fichier#ancre) — AD-15.
3. `AGENTS.md` racine (< 150 lignes) : commandes, conventions de nommage, où chercher, ce qu'on ne fait jamais ; plus un `apps/mobile/AGENTS.md` et un `supabase/AGENTS.md` locaux.
4. `tools/sync-agents` : génère `CLAUDE.md`, `.cursor/rules/histolyon.mdc`, `.github/copilot-instructions.md` depuis `AGENTS.md` ; vérifié en CI (un diff après régénération fait échouer le job — « diff = échec » ci-après).
5. `docs/` :
   - `ARCHITECTURE-SPINE.md` (copie de référence) ;
   - `conventions/` : un fichier par ligne de la table *Consistency Conventions* ;
   - `guides/` : trois recettes initiales — *ajouter une feature*, *écrire une migration*, *écrire un test de widget*.
6. Templates :
   - `docs/stories/TEMPLATE.md` (format dev-story BMAD, en français), copié dans `.github/ISSUE_TEMPLATE/story.md` ;
   - `.github/PULL_REQUEST_TEMPLATE.md` avec les champs *issue liée*, *tests d'abord (commit)*, *assistance IA* — AD-12, AD-14, convention IA.
7. `prompts/` : `dev-story.md`, `review.md`, `decoupe.md`, `SANS-IA.md` (checklist).

**Fini quand** : un arrivant peut lire `AGENTS.md`, lancer `tools/ctx D1.2` et comprendre où va une feature.

## 3. Supabase local et la migration socle — `socle-03`

1. `supabase init` ; `supabase start` (Docker) ; `env/local.json` avec URL et clé publiable locales.
2. **Migration socle** `0001_socle.sql` — AD-2, AD-6 :
   - extensions : `postgis`, `pgtap` ;
   - enums : `statut`, `provenance`, `type_de_cible`, `role_equipe` ;
   - tables : `membre_equipe`, `epoque`, `categorie`, `pin` (attributs minimaux du cluster C1 : `id`, `slug`, `titre`, `position geography`, `statut`, `provenance`, `epoques` n-n, `categorie`), `source_documentaire`, `trace_validation` ;
   - RLS activée partout ; policies de lecture publique des pins `publie` ;
   - colonnes de cycle de vie protégées par trigger.
3. `supabase/functions_sql/pin_transitions.sql` : RPC `pin_soumettre`, `pin_valider`, `pin_publier`, `pin_retirer`, chacune écrivant sa `trace_validation` et vérifiant I4 (au moins une source) — AD-6.
4. `supabase/tests/` : un fichier pgTAP par invariant déjà porté (I1, I4, I7, I8, I9) et un par RPC ; `supabase test db` vert.
5. Convention de nommage des migrations et check CI « horodatage postérieur au dernier de `main` » — AD-16.

**Fini quand** : `supabase db reset` + `supabase test db` passent depuis une base vide.

## 4. La génération de types — `socle-04`

1. **Spike obligatoire**, sur une table jetable : vérifier qu'une colonne `geography` nullable et un enum nullable traversent bien la génération supadart et le SDK ; sinon, basculer sur la génération OpenAPI (PostgREST) et le noter dans le memlog.
2. `tools/gen-types` : lance supadart (`supadart.yaml` avec les enums déclarés, PostGIS via `geobase`) vers `packages/api_types`, et exporte le JSON Schema de `pin`, `parcours`, `epoque`, `categorie` vers `content/schema/` — AD-3.
3. Check CI : régénérer et comparer ; diff = échec.

**Fini quand** : `packages/api_types` compile et une requête `select` typée sur `pin` fonctionne dans un test contre Supabase local.

## 5. Le contenu en fichiers et le seed — `socle-05`

1. `content/epoques/*.yaml` : les 10 époques du calibrage Figma (slug, libellé, bornes) ; `content/categories/*.yaml` ; **un** `content/pins/<slug>.yaml` conforme au template du palier 8 (`08-contenu/02-template-pin.yaml`), avec sa source et son média audio référencé.
2. `content/medias.yaml` : manifeste `bucket/slug/fichier → licence`.
3. `tools/media push` : téléverse depuis le dossier partagé vers les buckets `images | audio | models | tiles` ; vérifie formats et tailles (`webp` ≤ 500 Ko, `m4a` ≤ 5 Mo, `glb` ≤ 20 Mo) et les budgets par bucket — AD-7, AD-19.
4. `tools/seed` : validation contre `content/schema/`, upsert par `slug`, limité aux pins `provenance = editorial`, sans jamais écrire `statut` — AD-7. Branché dans `supabase db reset` local.
5. Test : le seed est idempotent (deux exécutions = même état).

**Fini quand** : un pin réel, sourcé, avec audio, existe en base locale après `db reset`.

## 6. L'app mobile : squelette et première carte

### `socle-06` — squelette

1. `lib/app/` : `bootstrap.dart` (Supabase init depuis `--dart-define-from-file`, `ProviderScope`), `router.dart` (assemble les `GoRoute` exportées par les features) — AD-5.
2. `lib/core/router` (noms de routes), `lib/core/session` (les six providers, vides mais typés — AD-20), `lib/core/models/failure.dart`, `lib/core/log`.
3. `lib/core/db` : base Drift unique, `schema.drift` v1 avec `profil`, `preference` ; `lib/core/profile` : Profil local créé au premier lancement — AD-4.
4. `packages/design_tokens` : export Figma → constantes verbatim (`TOK_COLOR_PRIMARY`…), `tools/check-tokens` ; `packages/ui_kit` avec `FIGMA-MAP.md` et les deux ou trois `comp-*` de la carte — AD-10.

**Fini quand** : l'app démarre sur un écran vide, le Profil local existe en base Drift, `tools/check-tokens` passe.

### `socle-07` — tuiles et styles

1. `tools/tiles` : `pmtiles extract` de l'agglomération depuis le build Protomaps → `lyon.pmtiles` ; mesure de la taille (cf. § *Deferred* de la spine) ; téléversement dans `tiles` — AD-8.
2. `packages/map_styles/` : un premier style de fond (époque « aujourd'hui ») sur le schéma Protomaps ; attribution OSM/Protomaps.

**Fini quand** : `lyon.pmtiles` est dans le bucket `tiles`, sa taille est notée dans le memlog, le style se charge dans un viewer MapLibre.

### `socle-08` — feature `carte`, tranche verticale

1. `features/carte/{data,domain,presentation}` : lecture des pins `publie` autour d'une emprise (repository → provider → écran) ; carte MapLibre (`maplibre_gl` ≥ 0.27.1) sur `pmtiles://https://…`, couche `pins` ajoutée par code, ré-ajoutée après `setStyle` — AD-8.
2. Tests d'abord : test unitaire du domaine, test de widget de l'écran avec repository factice, test `data` contre Supabase local — AD-14.
3. Le slider n'est **pas** dans cette tranche : il sera la première story du domaine D1 après le bootstrap.

**Fini quand** : l'APK affiche la carte de Lyon avec le pin seedé, hors de tout parcours, sur un téléphone Android.

## 7. Hooks, CI, environnements

### `socle-09` — local et PR

1. `lefthook.yml` : pre-commit = `dart format`, `dart analyze` sur les fichiers stagés, validation `content/` ; pre-push = tests du package touché — AD-14.
2. Workflows GitHub Actions, filtrés par chemin — AD-13, AD-14, AD-16 :
   - `ci-mobile`, `ci-admin` : analyze, tests, couverture publiée par package avec cliquet ;
   - `ci-supabase` : `db reset` + `test db` depuis une base vide ; check d'horodatage des migrations ;
   - `ci-content` : schéma + seed à blanc ;
   - `ci-docs` : `sync-agents`, `gen-types`, `check-tokens` — diff = échec ;
   - règle de branche : **branche à jour requise** avant fusion.
3. `nightly-e2e` : `integration_test` du parcours démo (vide au début, mais le job existe).

**Fini quand** : une PR de test passe toute la chaîne ; un push avec un test rouge est bloqué par lefthook.

### `socle-10` — dev, demo, enveloppe

1. Projets Supabase `dev` et `demo` créés ; GitHub Environments `dev` et `demo` avec `SUPABASE_ACCESS_TOKEN`, `SUPABASE_DB_PASSWORD`, `sb_secret_*` ; `env/dev.json` committé (clé publiable seulement), `env/demo.json` hors dépôt — AD-16.
2. Workflow `deploy-dev` : sur `main`, `supabase db push` + `tools/seed` + `tools/media push` vers `dev` ; APK debug en artefact.
3. Workflow `deploy-demo` : sur tag `demo-*`, migration manuelle approuvée dans l'Environment, APK signé (clé en secret).
4. Workflows `keep-alive` (hebdo, requête sur `dev` et `demo`) et `export` (hebdo, `db dump` + buckets en artefact conservé 90 jours) — AD-19.

**Fini quand** : `dev` contient le pin seedé ; l'APK d'artefact affiche la carte depuis `dev` ; le premier export hebdo a produit un artefact.

## 8. Suivi et organisation — `socle-11`

1. Labels GitHub : `D1`…`D11`, `socle`, `organisation`, `migration`, `deps` ; GitHub Projects « HistoLyon » avec les vues *par domaine* et *en vol* — AD-12, AD-17.
2. `tools/report` v0 : lit issues/PR via l'API, produit `docs/sprint/reports/<date>.md` avec les indicateurs d'AD-17, sauf les actions de rétro (il n'y en a pas encore).
3. `docs/team/ROLES.md` (casquettes, deux titulaires chacune, à remplir seulement une fois les noms réellement attribués), `docs/team/retros/README.md` (format de rétro), première issue `organisation` : « rétro du bootstrap » — AD-18.
4. `docs/stories/sprint-status.yaml` initialisé avec BMAD (`bmad-sprint-planning`) sur les premiers épics.

**Fini quand** : `tools/report` produit un rapport qui liste les stories `socle` fermées.

## 9. La première session d'équipe

**Réunion (1 h)**

1. **Lire ensemble** `AGENTS.md`, `ORGANISATION.md` en entier — § 0–6 le raisonnement, § 7–9 le résultat — et le template de story (40 min).
2. **Distribuer les casquettes** pour l'itération, en binômes, sans engagement au-delà — AD-18.

**Session (3–4 h)**

3. **Découper le premier épic** en séance avec le Découpeur : `D1.2 Slider d'époques` (le mécanisme signature) ou `D2.4 Aperçu rapide d'un pin` — deux ou trois stories, mises en Projects.
4. **Chacun prend une story** — y compris une story de doc (`guides/`) pour ceux qui découvrent Flutter — et va jusqu'à la PR.
5. **Spécialistes 3D** : story de spike « afficher un `.glb` dans `features/immersion` », sans autre contrainte — AD-11.
6. **Éditeur de contenu** : deuxième pin dans `content/`, avec sa source.

## 10. Définition de « bootstrap terminé »

- [ ] Un arrivant clone, lit `AGENTS.md`, lance `supabase start` + `melos run test` et tout est vert.
- [ ] Une story prise dans Projects se livre en suivant le template, sans poser de question au porteur du socle.
- [ ] `main` ne déploie que `dev` ; `demo` se tague à la main.
- [ ] Le pin seedé s'affiche sur la carte d'un APK construit par la CI.
- [ ] `tools/report` produit l'état des lieux du bootstrap.
- [ ] Chaque casquette a deux noms dans `ROLES.md` — ou est explicitement vacante.
- [ ] La rétro du bootstrap est écrite.
