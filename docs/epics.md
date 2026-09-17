---
stepsCompleted: [1, 2, 3, 4]
inputDocuments:
  - docs/specs/spec-histolyon-socle/SPEC.md
  - docs/architecture/architecture-HistoLyon-2026-09-17/BOOTSTRAP.md
  - docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md
  - docs/architecture/architecture-HistoLyon-2026-09-17/ORGANISATION.md
---

# HistoLyon Socle - Epic Breakdown

## Overview

Ce document décompose le socle de développement HistoLyon (`docs/specs/spec-histolyon-socle/SPEC.md`) en épics et stories. Il n'existe pas de PRD ni de document Architecture classiques pour ce projet : `SPEC.md` (11 Capabilities `CAP-n`) tient lieu de PRD, et `ARCHITECTURE-SPINE.md` (20 `AD-n`) + `BOOTSTRAP.md` (le « comment » de chaque étape) tiennent lieu d'Architecture. `ORGANISATION.md` porte le process que les stories doivent incarner. Aucun document UX dédié n'existe ; AD-10 (fidélité Figma) couvre ce terrain en Additional Requirements.

Le mapping `CAP-n` ↔ `socle-NN` est stable et imposé par la SPEC : chaque Capability est un épic.

## Requirements Inventory

### Functional Requirements

- FR1 (CAP-1 — `socle-01`) : Un dépôt GitHub `main`-protégé porte un workspace Pub (`apps/mobile`, `apps/admin`, `packages/*`), melos comme lanceur, l'arbre de dossiers de la spine et le lint d'imports d'AD-5. `melos run analyze` et `melos run test` passent sur les squelettes vides ; un push direct sur `main` est refusé.
- FR2 (CAP-2 — `socle-02`) : `conception/` est importée et adressable par ID (`tools/ctx`, `INDEX.md` généré) ; `AGENTS.md` unique est généré vers les fichiers d'instructions IDE (`tools/sync-agents`) ; `docs/` (spine, conventions, guides), templates de story/PR et `prompts/` existent. Un arrivant lit `AGENTS.md`, lance `tools/ctx D1.2`, obtient l'extrait YAML et sait dans quel dossier va une feature ; `tools/sync-agents` régénéré ne produit aucun diff.
- FR3 (CAP-3 — `socle-03`) : Le schéma minimal du cluster C1 (enums, `membre_equipe`, `epoque`, `categorie`, `pin`, `source_documentaire`, `trace_validation`), ses RLS, ses RPC de transition `pin_*` avec Trace et ses tests pgTAP existent en une migration `0001_socle.sql` rejouable. `supabase db reset` puis `supabase test db` passent depuis une base vide ; chaque invariant déjà porté (I1, I4, I7, I8, I9) et chaque RPC a son test pgTAP vert ; une migration à horodatage antérieur au dernier de `main` est refusée par le check.
- FR4 (CAP-4 — `socle-04`) : Les types Dart (`packages/api_types`) et les JSON Schema (`content/schema/`) sont produits par `tools/gen-types` depuis le schéma local, jamais écrits à la main. `packages/api_types` compile ; un `select` typé sur `pin` réussit dans un test contre Supabase local ; le spike `geography` nullable + enum nullable est conclu et noté ; régénérer sans migration ne produit aucun diff.
- FR5 (CAP-5 — `socle-05`) : Les 10 époques, les catégories et un pin réel (sourcé, avec audio) vivent en YAML validés contre `content/schema/` ; `tools/media push` téléverse les binaires depuis le dossier partagé sous budget ; `tools/seed` les charge en base par `slug`, branché sur `db reset`. Après `supabase db reset`, un pin réel sourcé avec son audio existe en base locale ; deux exécutions du seed donnent le même état ; un média hors format ou hors taille est refusé.
- FR6 (CAP-6 — `socle-06`) : L'app Android démarre sur la composition root d'AD-5, avec `core/` (router, session AD-20, models, log, db Drift, profile) et les packages `design_tokens` (tokens Figma verbatim) et `ui_kit` (`FIGMA-MAP.md`, `comp-*` de la carte). L'app démarre sur un écran vide ; le Profil local existe en base Drift au premier lancement ; `tools/check-tokens` passe contre l'export Figma.
- FR7 (CAP-7 — `socle-07`) : Un seul `lyon.pmtiles` (schéma Protomaps, emprise de l'agglomération) est extrait par `tools/tiles` et hébergé dans le bucket `tiles` ; un premier style de fond (« aujourd'hui ») existe dans `packages/map_styles` avec attribution OSM/Protomaps. `lyon.pmtiles` est dans le bucket `tiles`, sa taille est notée dans le memlog de la spine, le style se charge dans un viewer MapLibre.
- FR8 (CAP-8 — `socle-08`) : L'utilisateur voit sur la carte de Lyon les pins `publie` autour de l'emprise visible, hors de tout parcours, via `features/carte/{data,domain,presentation}` sur MapLibre (`pmtiles://`), couche `pins` ré-ajoutée après `setStyle`. L'APK affiche la carte de Lyon avec le pin seedé sur un téléphone Android ; test unitaire du domaine, test de widget avec repository factice et test `data` contre Supabase local sont verts et ont été committés avant l'implémentation.
- FR9 (CAP-9 — `socle-09`) : Les garanties d'AD-13/14/16 sont automatiques : lefthook (pre-commit format + analyze + validation `content/`, pre-push tests du package touché), workflows filtrés par chemin (`ci-mobile`, `ci-admin`, `ci-supabase`, `ci-content`, `ci-docs` « diff = échec »), cliquet de couverture, branche à jour requise, `nightly-e2e`. Une PR de test passe toute la chaîne ; un push avec un test rouge est bloqué par lefthook ; une PR dont la branche n'est pas à jour avec `main` ne peut pas fusionner.
- FR10 (CAP-10 — `socle-10`) : `main` déploie `dev` (migrations + seed + médias, APK debug en artefact) ; un tag `demo-*` déploie `demo` après approbation manuelle avec APK signé ; keep-alive et export hebdomadaires tiennent l'enveloppe Supabase Free (AD-19). `dev` contient le pin seedé ; l'APK d'artefact affiche la carte depuis `dev` ; le premier export hebdo a produit un artefact conservé.
- FR11 (CAP-11 — `socle-11`) : L'avancement se lit depuis GitHub : labels de domaine, Projects « HistoLyon » (vues *par domaine*, *en vol*), `tools/report` v0 (indicateurs AD-17), `docs/team/ROLES.md` et `retros/`, `sprint-status.yaml` initialisé, issue « rétro du bootstrap » ouverte. `tools/report` produit `docs/sprint/reports/<date>.md` listant les stories `socle` fermées, par domaine, avec délai médian story → fusion et taux de CI verte.

### NonFunctional Requirements

- NFR1 : Ordre imposé `socle-01 → 11` (chemin de BOOTSTRAP) ; les checks CI cités en 02–05 sont câblés en 09 et s'exécutent en local d'ici là.
- NFR2 : Chaque story du socle est livrée avec le process qu'elle installe : issue label `socle` → branche `story/socle-NN-<slug>` → PR → squash ; `main` protégé (PR, CI, branche à jour, squash) dès le premier push (AD-12, AD-13).
- NFR3 : Relecture différée : pendant le socle, les PR fusionnent sans relecture préalable ; un coéquipier relit toutes les PR `socle` en une fois à la fin, ses constats deviennent des issues `socle` ; l'approbation obligatoire n'est activée qu'après, avant la première session.
- NFR4 : Sorties BMAD dans `docs/` : `docs/specs/` (specs), `docs/` (épics, `docs/architecture/` pour le run d'architecture), `docs/stories/` (stories, `sprint-status.yaml`).
- NFR5 : Stack et versions figées par la spine (vérifiées 2026-09-17) ; toute autre techno ou version passe par amendement ; Android seulement ; Supabase Free = `dev` + `demo`, budgets Storage AD-19 ; zéro euro.
- NFR6 : Tests d'abord (AD-14) : le premier commit d'une branche `socle` contient ses tests rouges dès qu'il y a du code testable ; politique par couche ; couverture publiée à cliquet.
- NFR7 : Une migration par PR, horodatage postérieur au dernier de `main` (AD-16) ; migration et UI = deux stories ; le spike supadart (CAP-4) précède toute génération réelle, le repli OpenAPI est noté au memlog de la spine.
- NFR8 : Jamais dans Git : médias, secrets, `env/demo.json` ; `conception/` importée telle quelle, jamais éditée, adressée par ID ; `api_types`, `content/schema/`, `INDEX.md`, `CLAUDE.md`/`.cursor`/`copilot-instructions` générés, jamais édités (AD-3, AD-7, AD-15).
- NFR9 : Les prérequis hors dépôt (org GitHub, org Supabase, dossier médias partagé, Flutter 3.47.4 / Docker / Supabase CLI 2.117 / lefthook 2.1 / Android SDK, accès Figma) précèdent `socle-01`.

### Additional Requirements

Depuis `ARCHITECTURE-SPINE.md` (AD-1 → AD-20), toutes contraignantes puisque le socle est la mise en place de ces règles :

- AD-1 — Un seul langage applicatif (Dart/Flutter, mobile + admin), workspace Pub, melos comme lanceur de scripts.
- AD-2 — Le schéma SQL versionné est l'unique vérité du backend ; chaque invariant I1–I10 est une contrainte SQL et/ou une policy RLS avec test pgTAP ; logique serveur en fonctions SQL/plpgsql exposées en RPC ; rôles d'équipe via table `membre_equipe`.
- AD-3 — Types clients générés (supadart → `packages/api_types` ; JSON Schema → `content/schema/`), jamais écrits à la main, régénérés et committés à chaque migration ; CI échoue si diff.
- AD-4 — Ownership par provenance : serveur possède l'éditorial/communautaire, terminal possède Profil + Parcours personnels dans une seule base Drift ; uuid générés côté client.
- AD-5 — Dépendances strictes `presentation → domain → data` dans une feature ; `app/` est l'unique composition root ; une feature n'importe jamais une autre feature ; lint d'imports vérifié en CI.
- AD-6 — Un seul écrivain par entité (le repository de la feature propriétaire) ; toute transition de `statut`/`provenance` est une RPC qui écrit sa Trace et est testée en pgTAP ; colonnes de cycle de vie non modifiables par `UPDATE` direct.
- AD-7 — Le contenu éditorial vit en fichiers YAML validés contre `content/schema/` ; `tools/seed` est upsert-only par `slug` ; les binaires ne sont jamais dans Git, `tools/media push` les téléverse vers Storage avec vérification format/taille.
- AD-8 — MapLibre ≥ 0.27.1 ; un seul `lyon.pmtiles` (Protomaps) servi en ligne (`pmtiles://https://…`) et copié pour le hors-ligne (`pmtiles://file://…`) ; un style JSON de fond par Époque ; couches de données ré-ajoutées après chaque `setStyle`.
- AD-9 — Hors-ligne = paquet par Parcours, propriétaire unique `core/offline` — hors périmètre du socle (Non-goal) mais la structure ne doit pas y contrevenir.
- AD-10 — Tokens et composants 1:1 avec Figma : identifiants Figma verbatim dans `packages/design_tokens`, composants `comp-*` dans `packages/ui_kit` avec `FIGMA-MAP.md` tenu à la main, `tools/check-tokens` en CI.
- AD-11 — Viewer 3D isolé derrière `features/immersion` — hors périmètre du socle (Deferred, spike laissé à la première session).
- AD-12 — La story est la plus petite unité de travail : 1 issue GitHub = 1 branche `story/<ID>-<slug>` = 1 PR, label de domaine obligatoire, une story touche une seule zone (une feature, ou un seul de `supabase/`, `content/`, `packages/<x>`) ; migration et UI = deux stories.
- AD-13 — Trunk-based : `main` protégé, fusion uniquement si CI verte sur branche à jour, squash merge, itération de deux semaines.
- AD-14 — Tests d'abord par couche : premier commit d'une branche = tests rouges ; `domain` unitaires, `data` contre Supabase local, `presentation` widget tests, `supabase/` pgTAP, `content/` validation de schéma ; hooks lefthook pre-commit/pre-push ; couverture à cliquet.
- AD-15 — Documentation en quatre niveaux (`AGENTS.md` L0 unique généré, `docs/` L1, `conception/` L2 par ID, story L3) ; `CLAUDE.md`/`.cursor/rules`/`copilot-instructions.md` générés par `tools/sync-agents`, jamais édités.
- AD-16 — Trois environnements (`local` → `dev` → `demo`), une migration par PR sérialisée par l'Intégrateur, CI refuse un horodatage antérieur au dernier de `main`, secrets en GitHub Environments.
- AD-17 — L'avancement est calculé uniquement depuis GitHub (issues, PR, labels, artefacts CI) par `tools/report`, indicateurs indépendants de la taille des stories.
- AD-18 — Rôles = casquettes tournantes en binôme (Pilote, Découpeur, Intégrateur, Gardien des tests, Gardien du design, Spécialiste 3D), documentées a posteriori dans `docs/team/ROLES.md`, jamais nommées dans le socle.
- AD-19 — Enveloppe Supabase Free : keep-alive hebdo, export hebdo (`db dump` + buckets, 90 jours), budgets Storage par bucket (`tiles` 150 Mo, `audio` 400 Mo, `images` 200 Mo, `models` 200 Mo), base ≤ 500 Mo.
- AD-20 — État de session = liste fermée de providers dans `core/session` (`epoqueSelectionnee`, `parcoursActif`, `etapeCourante`, `pinCourant`, `modePresentation`, `lectureAudio`) ; comportements transverses en services de `core/`.

**Starter template** : oui — CAP-1/`socle-01` est le greenfield setup (git init, workspace Pub, `flutter create`, arbre de dossiers de la spine) ; c'est l'Épic 1, Story 1.

### UX Design Requirements

Aucune — pas de document UX dédié (`DESIGN.md`/`EXPERIENCE.md`) pour ce projet. La fidélité aux tokens et composants Figma est couverte par AD-10 en Additional Requirements ci-dessus.

### FR Coverage Map

FR1: Epic 1 - Dépôt et workspace
FR2: Epic 2 - Documentation avant le code
FR3: Epic 3 - Supabase local et migration socle
FR4: Epic 4 - Génération de types
FR5: Epic 5 - Contenu en fichiers et seed
FR6: Epic 6 - Squelette de l'app mobile
FR7: Epic 7 - Tuiles et styles
FR8: Epic 8 - Feature carte, tranche verticale
FR9: Epic 9 - Hooks et CI
FR10: Epic 10 - Environnements dev, demo, enveloppe
FR11: Epic 11 - Suivi et organisation

## Epic List

### Epic 1: Dépôt et workspace
Un dépôt GitHub `main`-protégé porte le workspace Pub, melos, l'arbre de la spine et le lint d'imports — la base sur laquelle toute story ultérieure s'appuie.
**FRs covered:** FR1

### Epic 2: Documentation avant le code
Un arrivant (humain ou agent) reçoit exactement le contexte de sa tâche : `conception/` adressable, `AGENTS.md` unique généré, `docs/`, templates de story/PR, `prompts/`.
**FRs covered:** FR2

### Epic 3: Supabase local et migration socle
Le schéma minimal, ses RLS, ses RPC de transition et leurs tests pgTAP existent en une migration rejouable — la vérité du backend.
**FRs covered:** FR3

### Epic 4: Génération de types
Les types Dart et JSON Schema sont générés depuis le schéma local, jamais écrits à la main.
**FRs covered:** FR4

### Epic 5: Contenu en fichiers et seed
Un premier pin réel, sourcé, avec audio, existe en base locale, chargé de façon idempotente depuis des fichiers YAML validés.
**FRs covered:** FR5

### Epic 6: Squelette de l'app mobile
L'app Android démarre sur la composition root, avec `core/` et les packages de design tokens/`ui_kit` fidèles à Figma.
**FRs covered:** FR6

### Epic 7: Tuiles et styles
Un fond de carte unique de Lyon et un premier style d'époque sont extraits, hébergés et chargeables dans MapLibre.
**FRs covered:** FR7

### Epic 8: Feature carte, tranche verticale
L'utilisateur voit les pins publiés sur la carte de Lyon — première tranche verticale complète (data/domain/presentation), tests d'abord.
**FRs covered:** FR8

### Epic 9: Hooks et CI
Les garanties de tests, migrations et process sont automatiques : lefthook, workflows par chemin, cliquet de couverture, branche à jour.
**FRs covered:** FR9

### Epic 10: Environnements dev, demo, enveloppe
`main` déploie `dev` en continu, `demo` se tague manuellement, l'enveloppe Supabase Free tient dans la durée.
**FRs covered:** FR10

### Epic 11: Suivi et organisation
L'avancement se lit depuis GitHub : labels, Projects, `tools/report`, rôles et rétro, prêts pour la première session d'équipe.
**FRs covered:** FR11

---

## Epic 1: Dépôt et workspace

Un dépôt GitHub `main`-protégé porte le workspace Pub, melos, l'arbre de la spine et le lint d'imports — la base sur laquelle toute story ultérieure s'appuie. **FRs :** FR1 · **AD :** AD-1, AD-5, AD-13.

### Story 1.1: Initialiser le dépôt et protéger `main`

En tant que porteur du socle,
Je veux un dépôt Git initialisé avec `main` protégée dès le premier push,
Afin que toute contribution ultérieure passe obligatoirement par PR (AD-13).

**Acceptance Criteria:**

**Given** un dépôt vide sans commit
**When** `git init` est exécuté et le premier commit poussé vers `origin main`
**Then** la branche `main` est protégée sur GitHub (PR obligatoire, statut CI requis, branche à jour requise, squash uniquement)
**And** un push direct sur `main` est refusé par GitHub

### Story 1.2: Workspace Pub et scripts melos

En tant que dev de l'équipe,
Je veux un workspace Pub racine avec melos comme lanceur de scripts,
Afin de lancer `analyze`/`test`/`format`/`gen` sur tout le dépôt en une commande (AD-1).

**Acceptance Criteria:**

**Given** `main` protégée (Story 1.1)
**When** `pubspec.yaml` racine est créé avec une section `workspace:` et melos 8.7 en dev dependency, plus une section `melos:` déclarant `analyze`, `test`, `format`, `gen`
**Then** `melos run analyze` s'exécute sans erreur
**And** aucun `melos.yaml` n'est présent (config uniquement dans `pubspec.yaml`, melos 7+)

### Story 1.3: Arbre de dossiers de la spine

En tant que dev de l'équipe,
Je veux l'arbre de dossiers défini par `ARCHITECTURE-SPINE.md` (§ Structural Seed) présent dans le dépôt,
Afin que chacun sache où va chaque type de fichier avant même d'écrire du code.

**Acceptance Criteria:**

**Given** le workspace Pub initialisé (Story 1.2)
**When** l'arbre de dossiers de la spine est créé (`apps/`, `packages/`, `supabase/`, `content/`, `conception/`, `docs/`, `prompts/`, `tools/`, `env/`, `.github/`)
**Then** chaque dossier encore vide contient un `README.md` d'une ligne décrivant ce qui y vivra
**And** la structure correspond exactement à l'arbre publié dans `ARCHITECTURE-SPINE.md`

### Story 1.4: Apps Flutter du workspace

En tant que dev de l'équipe,
Je veux `apps/mobile` et `apps/admin` créés comme apps Flutter du workspace,
Afin de développer l'app Android et le back-office web dans la même stack (AD-1).

**Acceptance Criteria:**

**Given** l'arbre de dossiers en place (Story 1.3)
**When** `apps/mobile` est créé par `flutter create --platforms=android` et `apps/admin` par `flutter create --platforms=web`
**Then** chaque `pubspec.yaml` d'app déclare `resolution: workspace`
**And** les deux apps apparaissent dans le `workspace:` du `pubspec.yaml` racine

### Story 1.5: Lint d'imports et lints de base

En tant que dev de l'équipe,
Je veux `flutter_lints`, `riverpod_lint` et une règle de lint d'imports actifs,
Afin qu'une violation de la direction des dépendances (AD-5) soit visible immédiatement, pas découverte en relecture.

**Acceptance Criteria:**

**Given** les apps du workspace créées (Story 1.4)
**When** `flutter_lints` 6, `riverpod_lint` et une règle interdisant `features/* → features/*` et `core/* → features/*` sont configurés
**Then** `melos run analyze` passe sur les squelettes vides sans avertissement de lint
**And** un import volontairement fautif (`features/x` important `features/y`) fait échouer `melos run analyze`

**Given** l'Epic 1 terminé
**When** `melos run analyze` et `melos run test` sont lancés à la racine
**Then** les deux passent sur les squelettes vides (Fini quand de CAP-1)
**And** un push direct sur `main` reste refusé

---

## Epic 2: Documentation avant le code

Un arrivant (humain ou agent) reçoit exactement le contexte de sa tâche : `conception/` adressable, `AGENTS.md` unique généré, `docs/`, templates de story/PR, `prompts/`. **FRs :** FR2 · **AD :** AD-15.

### Story 2.1: Importer `conception/` telle quelle

En tant que dev de l'équipe,
Je veux `conception/` importée telle quelle depuis l'ancien dépôt,
Afin de disposer du « quoi » (15 paliers) sans le réécrire (AD-15).

**Acceptance Criteria:**

**Given** l'Epic 1 terminé
**When** `conception/` est copiée telle quelle dans le dépôt
**Then** son contenu est identique à la source, aucun fichier n'est édité
**And** `conception/` est committée en un seul commit dédié, sans mélange avec du code

### Story 2.2: `tools/ctx` et `conception/INDEX.md`

En tant que dev de l'équipe,
Je veux un script qui affiche l'extrait YAML d'un ID de conception, et un index généré,
Afin de lire un extrait précis sans jamais charger `conception/` en entier (AD-15).

**Acceptance Criteria:**

**Given** `conception/` importée (Story 2.1)
**When** `tools/ctx D1.2` est exécuté
**Then** l'extrait YAML correspondant à `D1.2` s'affiche
**And** `conception/INDEX.md` est généré (id → fichier#ancre) et couvre tous les ID adressables de `conception/`

### Story 2.3: `AGENTS.md` racine et locaux

En tant que dev de l'équipe,
Je veux un `AGENTS.md` racine de moins de 150 lignes, plus des `AGENTS.md` locaux pour `apps/mobile` et `supabase`,
Afin que quiconque (humain ou IA) reçoive les règles de la maison en une page (AD-15).

**Acceptance Criteria:**

**Given** l'arbre de dossiers en place (Epic 1)
**When** `AGENTS.md` racine, `apps/mobile/AGENTS.md` et `supabase/AGENTS.md` sont écrits
**Then** chacun fait moins de 150 lignes et couvre commandes, conventions de nommage, où chercher, ce qu'on ne fait jamais
**And** aucun des trois ne duplique le contenu des deux autres

### Story 2.4: `tools/sync-agents`

En tant que dev de l'équipe,
Je veux un script qui génère `CLAUDE.md`, `.cursor/rules/histolyon.mdc` et `.github/copilot-instructions.md` depuis `AGENTS.md`,
Afin que les instructions ne soient maintenues qu'à un seul endroit (AD-15).

**Acceptance Criteria:**

**Given** `AGENTS.md` écrits (Story 2.3)
**When** `tools/sync-agents` est exécuté
**Then** `CLAUDE.md`, `.cursor/rules/histolyon.mdc` et `.github/copilot-instructions.md` sont générés depuis `AGENTS.md`
**And** relancer `tools/sync-agents` sans changer `AGENTS.md` ne produit aucun diff

### Story 2.5: `docs/` — spine, conventions, guides

En tant que dev de l'équipe,
Je veux la spine, les conventions et des guides-recettes dans `docs/`,
Afin de trouver une règle sans l'avoir apprise par cœur (AD-15).

**Acceptance Criteria:**

**Given** l'arbre de dossiers en place (Epic 1)
**When** `docs/ARCHITECTURE-SPINE.md` (copie de référence), `docs/conventions/` (un fichier par ligne de la table *Consistency Conventions*) et `docs/guides/` (*ajouter une feature*, *écrire une migration*, *écrire un test de widget*) sont écrits
**Then** chaque convention de la table a son fichier dédié
**And** les trois guides existent et sont actionnables sans contexte supplémentaire

### Story 2.6: Templates de story et de PR

En tant que dev de l'équipe,
Je veux un template de story au format dev-story BMAD et un template de PR,
Afin que chaque issue et chaque PR porte les mêmes champs sans effort (AD-12, AD-14).

**Acceptance Criteria:**

**Given** l'arbre de dossiers en place (Epic 1)
**When** `docs/stories/TEMPLATE.md` est écrit et copié dans `.github/ISSUE_TEMPLATE/story.md`, et `.github/PULL_REQUEST_TEMPLATE.md` est écrit avec les champs *issue liée*, *tests d'abord (commit)*, *assistance IA*
**Then** les deux fichiers `.github/` sont identiques en substance à leurs sources `docs/`
**And** créer une issue ou une PR sur GitHub affiche automatiquement le template correspondant

### Story 2.7: `prompts/`

En tant que dev de l'équipe,
Je veux les prompts portables de l'équipe et une checklist sans IA,
Afin que chacun suive le même chemin, avec ou sans assistant IA (AD-15, convention Usage de l'IA).

**Acceptance Criteria:**

**Given** l'arbre de dossiers en place (Epic 1)
**When** `prompts/dev-story.md`, `prompts/review.md`, `prompts/decoupe.md` et `prompts/SANS-IA.md` sont écrits
**Then** chaque prompt est collable tel quel dans un assistant IA générique
**And** `SANS-IA.md` permet de dérouler une story sans aucun outil IA

**Given** l'Epic 2 terminé
**When** un arrivant lit `AGENTS.md`, lance `tools/ctx D1.2` et relance `tools/sync-agents`
**Then** il obtient l'extrait YAML, comprend dans quel dossier va une feature, et `tools/sync-agents` ne produit aucun diff (Fini quand de CAP-2)

---

## Epic 3: Supabase local et migration socle

Le schéma minimal, ses RLS, ses RPC de transition et leurs tests pgTAP existent en une migration rejouable — la vérité du backend. **FRs :** FR3 · **AD :** AD-2, AD-6, AD-14, AD-16.

*Note de découpe : AD-16 impose une seule migration par PR, et BOOTSTRAP fixe cette migration comme unique (`0001_socle.sql`). Le schéma, les RLS, les RPC de transition et leurs tests pgTAP forment donc une seule story/PR indivisible plutôt que plusieurs petites — c'est la story la plus grosse du socle, et c'est voulu par la contrainte, pas un défaut de découpe.*

### Story 3.1: Bootstrap Supabase local

En tant que dev de l'équipe,
Je veux Supabase local démarré avec ses identifiants dans `env/local.json`,
Afin de développer et tester contre une base réelle sans dépendance à un projet distant.

**Acceptance Criteria:**

**Given** l'arbre de dossiers en place (Epic 1)
**When** `supabase init` puis `supabase start` (Docker) sont exécutés
**Then** les services Supabase locaux démarrent
**And** `env/local.json` contient l'URL et la clé publiable locales, sans secret

### Story 3.2: Migration socle `0001_socle.sql` — schéma, RLS, RPC, tests pgTAP

En tant que dev de l'équipe,
Je veux le schéma minimal du cluster C1, ses RLS, ses RPC de transition et leurs tests pgTAP en une migration rejouable,
Afin que la base soit l'unique vérité du backend dès le premier commit de schéma (AD-2, AD-6).

**Acceptance Criteria:**

**Given** Supabase local démarré (Story 3.1)
**When** les tests pgTAP (rouges) sont committés en premier, puis `supabase/migrations/0001_socle.sql` (extensions `postgis`/`pgtap`, enums `statut`/`provenance`/`type_de_cible`/`role_equipe`, tables `membre_equipe`/`epoque`/`categorie`/`pin`/`source_documentaire`/`trace_validation`, RLS activée partout avec policy de lecture publique des pins `publie`, triggers protégeant les colonnes de cycle de vie) et `supabase/functions_sql/pin_transitions.sql` (RPC `pin_soumettre`, `pin_valider`, `pin_publier`, `pin_retirer`, chacune écrivant sa `trace_validation` et vérifiant I4)
**Then** `supabase db reset` puis `supabase test db` passent depuis une base vide
**And** chaque invariant déjà porté (I1, I4, I7, I8, I9) a son fichier pgTAP vert, et chaque RPC a le sien
**And** le nom de fichier suit la convention de nommage et une migration à horodatage antérieur au dernier de `main` serait refusée par le check (vérifié localement ; câblage CI en Epic 9)

---

## Epic 4: Génération de types

Les types Dart et JSON Schema sont générés depuis le schéma local, jamais écrits à la main. **FRs :** FR4 · **AD :** AD-3.

### Story 4.1: Spike supadart — geography et enum nullables

En tant que dev de l'équipe,
Je veux vérifier que supadart traverse correctement une colonne `geography` nullable et un enum nullable,
Afin de choisir l'outil de génération avant tout usage réel (NFR7).

**Acceptance Criteria:**

**Given** la migration socle en place (Story 3.2)
**When** une table jetable avec une colonne `geography` nullable et un enum nullable est générée via supadart
**Then** le résultat Dart est correct pour les deux cas, ou l'échec est constaté
**And** la conclusion (supadart retenu, ou repli sur génération OpenAPI/PostgREST) est notée dans `.memlog.md` de la spine
**And** la table jetable est supprimée après le spike (pas de migration supplémentaire laissée derrière)

### Story 4.2: `tools/gen-types`

En tant que dev de l'équipe,
Je veux les types Dart et JSON Schema générés depuis le schéma local par un seul outil,
Afin de ne jamais écrire de modèle à la main (AD-3).

**Acceptance Criteria:**

**Given** le spike conclu (Story 4.1)
**When** `tools/gen-types` est exécuté (supadart vers `packages/api_types` avec `supadart.yaml`, ou repli OpenAPI si retenu ; export JSON Schema de `pin`, `parcours`, `epoque`, `categorie` vers `content/schema/`)
**Then** `packages/api_types` compile
**And** un `select` typé sur `pin` réussit dans un test contre Supabase local
**And** relancer `tools/gen-types` sans nouvelle migration ne produit aucun diff

---

## Epic 5: Contenu en fichiers et seed

Un premier pin réel, sourcé, avec audio, existe en base locale, chargé de façon idempotente depuis des fichiers YAML validés. **FRs :** FR5 · **AD :** AD-7.

### Story 5.1: Époques et catégories en YAML

En tant qu'éditeur de contenu,
Je veux les 10 époques et les catégories en YAML validés contre `content/schema/`,
Afin que le contenu éditorial de base existe en fichiers avant tout écran (AD-7).

**Acceptance Criteria:**

**Given** `content/schema/` généré (Story 4.2)
**When** `content/epoques/*.yaml` (10 époques du calibrage Figma : slug, libellé, bornes) et `content/categories/*.yaml` sont écrits
**Then** chaque fichier valide contre son schéma JSON
**And** les 10 époques et toutes les catégories du calibrage sont présentes

### Story 5.2: Premier pin réel sourcé

En tant qu'éditeur de contenu,
Je veux un pin réel conforme au template du palier 8, avec sa source et son média audio référencé,
Afin d'avoir un contenu réel à afficher, pas un jeu de test (AD-7).

**Acceptance Criteria:**

**Given** les époques et catégories en place (Story 5.1)
**When** `content/pins/<slug>.yaml` est écrit conforme à `08-contenu/02-template-pin.yaml`, avec sa source documentaire et son fichier audio référencé, et `content/medias.yaml` (manifeste bucket/slug/fichier → licence) déclare ce média
**Then** le pin valide contre `content/schema/`
**And** la licence du média audio est renseignée dans `content/medias.yaml`

### Story 5.3: `tools/media push`

En tant qu'éditeur de contenu,
Je veux téléverser les binaires depuis le dossier partagé vers Storage, avec vérification de format et de taille,
Afin que les médias ne polluent jamais Git (AD-7, AD-19).

**Acceptance Criteria:**

**Given** le pin référencé et son média déclaré dans `content/medias.yaml` (Story 5.2)
**When** `tools/media push` est exécuté
**Then** le fichier audio est téléversé vers le bucket `audio` au chemin `<bucket>/<slug>/<fichier>`
**And** un média hors format (`webp` > 500 Ko, `m4a`/AAC > 5 Mo, `glb` > 20 Mo) ou dépassant le budget de son bucket est refusé avec une erreur explicite

### Story 5.4: `tools/seed`

En tant que dev de l'équipe,
Je veux charger le contenu YAML en base par `slug`, de façon idempotente, branché sur `db reset`,
Afin qu'un pin réel existe en base locale dès l'initialisation (AD-7).

**Acceptance Criteria:**

**Given** les médias téléversés (Story 5.3)
**When** `tools/seed` est exécuté après `supabase db reset`
**Then** un pin réel, sourcé, avec son audio, existe en base locale
**And** `tools/seed` valide contre `content/schema/`, upsert uniquement par `slug`, ne touche que `provenance = editorial`, et n'écrit jamais `statut`
**And** exécuter `tools/seed` deux fois de suite laisse la base dans le même état (idempotence)

---

## Epic 6: Squelette de l'app mobile

L'app Android démarre sur la composition root, avec `core/` et les packages de design tokens/`ui_kit` fidèles à Figma. **FRs :** FR6 · **AD :** AD-4, AD-5, AD-10, AD-20.

### Story 6.1: Composition root

En tant que dev de l'équipe,
Je veux `lib/app/bootstrap.dart` et `lib/app/router.dart` comme unique point d'assemblage,
Afin que l'app démarre sur un écran vide sans qu'aucune feature n'assemble elle-même quoi que ce soit (AD-5).

**Acceptance Criteria:**

**Given** l'Epic 4 (types générés) et l'Epic 1 (workspace) terminés
**When** `lib/app/bootstrap.dart` (Supabase init depuis `--dart-define-from-file`, `ProviderScope`) et `lib/app/router.dart` (assemble les `GoRoute` exportées par les features, vide pour l'instant) sont écrits
**Then** l'app démarre sur un écran vide sur un émulateur/téléphone Android
**And** aucune feature n'est importée directement en dehors de `app/`

### Story 6.2: `core/router`, `core/session`, `core/models`, `core/log`

En tant que dev de l'équipe,
Je veux les noms de routes, la liste fermée de providers de session, le modèle d'erreur et le logger dans `core/`,
Afin que les futures features aient un socle partagé sans le réinventer (AD-20).

**Acceptance Criteria:**

**Given** la composition root en place (Story 6.1)
**When** `core/router` (noms de routes), `core/session` (les six providers `epoqueSelectionnee`, `parcoursActif`, `etapeCourante`, `pinCourant`, `modePresentation`, `lectureAudio`, vides mais typés), `core/models/failure.dart` (`Failure` sealed) et `core/log` sont écrits
**Then** `melos run analyze` passe sur ces fichiers
**And** `core/session` n'expose que ces six providers, aucun de plus

### Story 6.3: `core/db` (Drift) et `core/profile`

En tant que dev de l'équipe,
Je veux une base Drift unique avec `profil` et `preference`, et un Profil local créé au premier lancement,
Afin que le terminal possède son Profil sans Compte dès le squelette (AD-4).

**Acceptance Criteria:**

**Given** `core/models` et `core/log` en place (Story 6.2)
**When** `core/db/schema.drift` v1 (`profil`, `preference`) est écrit et `core/profile` crée le Profil local au premier lancement
**Then** au premier démarrage de l'app, une ligne `profil` existe en base Drift
**And** relancer l'app ne crée pas de second `profil`

### Story 6.4: `packages/design_tokens` et `tools/check-tokens`

En tant que Gardien du design,
Je veux les variables Figma portées en constantes Dart nommées verbatim, vérifiées en CI,
Afin qu'aucune valeur visuelle ne soit inventée dans une feature (AD-10).

**Acceptance Criteria:**

**Given** l'export des variables Figma disponible
**When** `packages/design_tokens` déclare une constante par variable/style Figma (identifiant verbatim, `-` → `_`, ex. `TOK_COLOR_PRIMARY`) et `tools/check-tokens` compare l'export Figma au package
**Then** `tools/check-tokens` passe contre l'export Figma courant
**And** aucun alias ne fusionne deux tokens différents

### Story 6.5: `packages/ui_kit` — composants de la carte

En tant que Gardien du design,
Je veux les deux ou trois composants `comp-*` de la maquette utiles à la carte, avec leur mapping tenu à la main,
Afin qu'une feature ne réimplémente jamais un composant qui existe déjà (AD-10).

**Acceptance Criteria:**

**Given** `packages/design_tokens` en place (Story 6.4)
**When** `packages/ui_kit` implémente les `comp-*` de la maquette nécessaires à la carte et `packages/ui_kit/FIGMA-MAP.md` documente le mapping Figma ↔ composant
**Then** chaque composant n'utilise que des constantes de `design_tokens`, aucune valeur visuelle littérale
**And** `FIGMA-MAP.md` liste tous les `comp-*` implémentés

**Given** l'Epic 6 terminé
**When** l'app est lancée et `tools/check-tokens` exécuté
**Then** l'app démarre sur un écran vide, le Profil local existe en base Drift, `tools/check-tokens` passe (Fini quand de CAP-6)

---

## Epic 7: Tuiles et styles

Un fond de carte unique de Lyon et un premier style d'époque sont extraits, hébergés et chargeables dans MapLibre. **FRs :** FR7 · **AD :** AD-8.

### Story 7.1: `tools/tiles` — `lyon.pmtiles`

En tant que dev de l'équipe,
Je veux une unique archive `lyon.pmtiles` extraite du build Protomaps sur l'emprise de l'agglomération et hébergée dans le bucket `tiles`,
Afin d'avoir un seul fond de carte, en ligne et hors-ligne, sans clé d'API (AD-8).

**Acceptance Criteria:**

**Given** l'Epic 1 (buckets/outillage) en place
**When** `tools/tiles` exécute `pmtiles extract` sur l'emprise de l'agglomération lyonnaise depuis le build Protomaps, puis téléverse `lyon.pmtiles` dans le bucket `tiles`
**Then** `lyon.pmtiles` est présent dans le bucket `tiles`
**And** sa taille est notée dans `.memlog.md` de la spine (Deferred « Taille réelle de `lyon.pmtiles` »)

### Story 7.2: Premier style de fond

En tant que dev de l'équipe,
Je veux un style JSON de fond pour l'époque « aujourd'hui » sur le schéma Protomaps,
Afin que le slider d'époques (hors socle) n'ait plus qu'à faire `setStyle` plus tard (AD-8).

**Acceptance Criteria:**

**Given** `lyon.pmtiles` hébergé (Story 7.1)
**When** `packages/map_styles/aujourdhui.json` est écrit sur le schéma Protomaps basemap, avec attribution OpenStreetMap (ODbL) et Protomaps visible
**Then** le style se charge dans un viewer MapLibre et affiche Lyon
**And** l'attribution est visible en permanence sur le viewer

---

## Epic 8: Feature carte, tranche verticale

L'utilisateur voit les pins publiés sur la carte de Lyon — première tranche verticale complète (data/domain/presentation), tests d'abord. **FRs :** FR8 · **AD :** AD-5, AD-8, AD-14.

*Note de découpe : c'est une tranche verticale au sens strict de BOOTSTRAP — une seule feature, livrée en un seul mouvement data→domain→presentation, tests d'abord dans les commits. La séparer en stories par couche casserait l'intention de la SPEC (« tranche verticale ») sans bénéfice, la feature entière tenant dans une session.*

### Story 8.1: Pins publiés sur la carte de Lyon

En tant qu'utilisateur de l'app,
Je veux voir sur la carte de Lyon les pins publiés autour de l'emprise visible,
Afin de découvrir du contenu réel dès le premier écran, hors de tout parcours.

**Acceptance Criteria:**

**Given** le squelette mobile (Epic 6), le style de carte (Epic 7) et le pin seedé (Epic 5) en place
**When** le test unitaire du domaine, le test de widget de l'écran avec repository factice, et le test `data` contre Supabase local sont committés en premier (rouges), puis `features/carte/{data,domain,presentation}` est implémenté (repository → provider → écran, MapLibre sur `pmtiles://`, couche `pins` ajoutée par code)
**Then** l'APK affiche la carte de Lyon avec le pin seedé sur un téléphone Android, hors de tout parcours
**And** la couche `pins` est ré-ajoutée après chaque `setStyle`
**And** les trois tests (domain, widget, data) sont verts et leur commit précède celui de l'implémentation

---

## Epic 9: Hooks et CI

Les garanties de tests, migrations et process sont automatiques : lefthook, workflows par chemin, cliquet de couverture, branche à jour. **FRs :** FR9 · **AD :** AD-13, AD-14, AD-16.

### Story 9.1: lefthook

En tant que dev de l'équipe,
Je veux le formatage, le lint et la validation de contenu avant chaque commit, et les tests du package touché avant chaque push,
Afin qu'une erreur soit visible avant même qu'un autre membre la voie (AD-14).

**Acceptance Criteria:**

**Given** les epics 1 à 8 en place (au moins un package testable existe)
**When** `lefthook.yml` déclare pre-commit = `dart format` + `dart analyze` sur les fichiers stagés + validation `content/`, et pre-push = tests du package touché
**Then** un commit avec un fichier mal formaté est reformaté ou rejeté automatiquement
**And** un push avec un test rouge dans le package touché est bloqué par lefthook

### Story 9.2: `ci-mobile` et `ci-admin`

En tant que dev de l'équipe,
Je veux l'analyse, les tests et la couverture publiée à cliquet pour `apps/mobile` et `apps/admin`,
Afin qu'une PR touchant l'app soit vérifiée automatiquement (AD-14).

**Acceptance Criteria:**

**Given** lefthook en place (Story 9.1)
**When** les workflows `ci-mobile` et `ci-admin`, filtrés par chemin, exécutent `analyze` + `test` + publication de couverture par package
**Then** une PR touchant uniquement `apps/mobile` déclenche `ci-mobile` mais pas `ci-admin`
**And** la couverture publiée ne peut pas baisser par rapport au dernier `main` (cliquet)

### Story 9.3: `ci-supabase`

En tant que dev de l'équipe,
Je veux `db reset` + `test db` rejoués depuis une base vide sur chaque PR touchant `supabase/`, avec le check d'horodatage des migrations,
Afin qu'une migration cassée ou mal ordonnée n'atteigne jamais `main` (AD-16).

**Acceptance Criteria:**

**Given** la migration socle en place (Epic 3)
**When** le workflow `ci-supabase`, filtré par chemin `supabase/`, exécute `supabase db reset` puis `supabase test db`, et vérifie l'horodatage de toute nouvelle migration
**Then** une PR qui casse `test db` échoue en CI
**And** une PR avec une migration à horodatage antérieur au dernier de `main` est refusée par le check

### Story 9.4: `ci-content` et `ci-docs`

En tant que dev de l'équipe,
Je veux la validation du contenu à blanc et la vérification que la doc générée n'a pas divergé,
Afin qu'un contenu invalide ou une doc générée éditée à la main n'atteignent jamais `main` (AD-3, AD-15).

**Acceptance Criteria:**

**Given** `tools/seed`, `tools/gen-types` et `tools/sync-agents` en place (Epics 2, 4, 5)
**When** le workflow `ci-content`, filtré par chemin `content/`, valide le schéma et exécute un seed à blanc, et le workflow `ci-docs` relance `sync-agents`, `gen-types` et `check-tokens`
**Then** un contenu YAML invalide fait échouer `ci-content`
**And** tout diff après régénération (`sync-agents`, `gen-types`, `check-tokens`) fait échouer `ci-docs`

### Story 9.5: Règle de branche à jour et `nightly-e2e`

En tant que dev de l'équipe,
Je veux qu'une PR ne puisse fusionner que si elle est à jour avec `main`, et un job nightly prêt à accueillir le parcours démo,
Afin qu'aucune fusion ne se base sur un état obsolète (AD-13).

**Acceptance Criteria:**

**Given** les workflows CI en place (Stories 9.2 à 9.4)
**When** la règle de protection de branche exige que la branche source soit à jour avec `main` avant fusion, et le workflow `nightly-e2e` exécute `integration_test` (vide au début) chaque nuit
**Then** une PR dont la branche n'est pas à jour ne peut pas fusionner, même CI verte
**And** `nightly-e2e` s'exécute et se termine sans erreur, même sans scénario réel encore écrit

**Given** l'Epic 9 terminé
**When** une PR de test est ouverte
**Then** elle passe toute la chaîne CI, et un push avec un test rouge est bloqué par lefthook (Fini quand de CAP-9)

---

## Epic 10: Environnements dev, demo, enveloppe

`main` déploie `dev` en continu, `demo` se tague manuellement, l'enveloppe Supabase Free tient dans la durée. **FRs :** FR10 · **AD :** AD-16, AD-19.

### Story 10.1: Projets Supabase et GitHub Environments

En tant que dev de l'équipe,
Je veux les projets Supabase `dev` et `demo`, avec les secrets correspondants dans des GitHub Environments,
Afin que les déploiements automatiques aient une cible et des identifiants sans secret dans le dépôt (AD-16).

**Acceptance Criteria:**

**Given** l'organisation Supabase créée (prérequis hors dépôt)
**When** les projets Supabase `dev` et `demo` sont créés, les GitHub Environments `dev` et `demo` sont configurés avec `SUPABASE_ACCESS_TOKEN`, `SUPABASE_DB_PASSWORD`, `sb_secret_*`, et `env/dev.json` (clé publiable seulement) est committé
**Then** `env/dev.json` ne contient aucun secret
**And** `env/demo.json` n'est pas versionné (hors dépôt)

### Story 10.2: Workflow `deploy-dev`

En tant que dev de l'équipe,
Je veux que chaque fusion sur `main` migre, seed et téléverse les médias vers `dev`, et produise un APK debug,
Afin de voir en continu le résultat de ce qui est fusionné (AD-16).

**Acceptance Criteria:**

**Given** les Environments configurés (Story 10.1) et `tools/seed`/`tools/media` en place (Epic 5)
**When** une PR est fusionnée sur `main`
**Then** le workflow `deploy-dev` exécute `supabase db push` puis `tools/seed` et `tools/media push` vers `dev`, et publie un APK debug en artefact
**And** `dev` contient le pin seedé après ce déploiement

### Story 10.3: Workflow `deploy-demo`

En tant que dev de l'équipe,
Je veux qu'un tag `demo-*` déclenche une migration manuelle approuvée et un APK signé,
Afin que l'environnement vu par le jury ne change que sur décision (AD-16).

**Acceptance Criteria:**

**Given** `deploy-dev` fonctionnel (Story 10.2) et une clé de signature Android en secret d'Environment
**When** un tag `demo-YYYY-MM-DD` est poussé
**Then** le workflow `deploy-demo` attend une approbation manuelle dans l'Environment `demo` avant de migrer
**And** l'APK produit est signé avec la clé de secret, pas la clé debug

### Story 10.4: `keep-alive` et `export` hebdomadaires

En tant que dev de l'équipe,
Je veux une requête hebdomadaire sur `dev` et `demo`, et un export hebdomadaire de la base et des buckets,
Afin que `demo` ne se mette jamais en pause avant le jury, et qu'il existe une sauvegarde (AD-19).

**Acceptance Criteria:**

**Given** `dev` et `demo` déployés (Stories 10.2, 10.3)
**When** le workflow `keep-alive` interroge `dev` et `demo` chaque semaine, et le workflow `export` exécute `supabase db dump` + export des buckets en artefact conservé 90 jours
**Then** aucun des deux projets ne passe en pause pour inactivité
**And** le premier export hebdomadaire produit un artefact conservé

**Given** l'Epic 10 terminé
**When** l'APK d'artefact de `deploy-dev` est installé et le premier `export` s'est exécuté
**Then** il affiche la carte depuis `dev` avec le pin seedé, et un artefact d'export existe (Fini quand de CAP-10)

---

## Epic 11: Suivi et organisation

L'avancement se lit depuis GitHub : labels, Projects, `tools/report`, rôles et rétro, prêts pour la première session d'équipe. **FRs :** FR11 · **AD :** AD-12, AD-17, AD-18.

### Story 11.1: Labels et GitHub Projects

En tant que Pilote,
Je veux les labels de domaine et un Projects « HistoLyon » avec des vues par domaine et en vol,
Afin que l'avancement soit lisible sans reporting manuel (AD-17).

**Acceptance Criteria:**

**Given** le dépôt et les premières issues `socle` existantes
**When** les labels `D1`…`D11`, `socle`, `organisation`, `migration`, `deps` sont créés et le Projects « HistoLyon » est configuré avec les vues *par domaine* et *en vol*
**Then** chaque issue `socle` déjà ouverte porte son label de domaine
**And** les deux vues affichent correctement les issues existantes

### Story 11.2: `tools/report` v0

En tant que Pilote,
Je veux un rapport calculé depuis GitHub listant les stories `socle` fermées par domaine, avec délai médian et taux de CI verte,
Afin de coller un état des lieux au compte rendu sans le rédiger à la main (AD-17).

**Acceptance Criteria:**

**Given** les labels en place (Story 11.1) et au moins une PR `socle` fusionnée
**When** `tools/report` est exécuté
**Then** `docs/sprint/reports/<date>.md` liste les stories `socle` fermées, par domaine
**And** le rapport inclut le délai médian story → fusion et le taux de CI verte

### Story 11.3: `ROLES.md`, `retros/` et rétro du bootstrap

En tant que Pilote,
Je veux un fichier de casquettes vacantes, un format de rétro, et une issue « rétro du bootstrap »,
Afin que l'équipe puisse se répartir les casquettes et consigner son premier ajustement (AD-18).

**Acceptance Criteria:**

**Given** l'Epic 11 en cours
**When** `docs/team/ROLES.md` (casquettes du § 9 d'ORGANISATION.md, sans titulaire) et `docs/team/retros/README.md` (format de rétro) sont écrits, et une issue `organisation` « rétro du bootstrap » est ouverte
**Then** `ROLES.md` ne nomme aucune personne
**And** l'issue « rétro du bootstrap » est ouverte et étiquetée `organisation`

### Story 11.4: `sprint-status.yaml`

En tant que Découpeur,
Je veux `docs/stories/sprint-status.yaml` initialisé sur les premiers épics avec BMAD,
Afin que le suivi de sprint démarre en même temps que le socle (AD-12).

**Acceptance Criteria:**

**Given** ce document d'épics et de stories approuvé
**When** `bmad-sprint-planning` est exécuté sur les épics du socle
**Then** `docs/stories/sprint-status.yaml` existe et référence les épics `socle-01` à `socle-11`
**And** son statut reflète les stories déjà fusionnées à ce stade

**Given** l'Epic 11 terminé
**When** `tools/report` est exécuté
**Then** il produit un rapport listant les stories `socle` fermées (Fini quand de CAP-11)
