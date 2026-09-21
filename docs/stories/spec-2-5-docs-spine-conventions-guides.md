---
title: 'docs/ — spine, conventions, guides'
type: 'feature'
created: '2026-09-18'
status: 'done'
baseline_revision: '582f7c428d5e69a3a62429831553081cacc2972f'
review_loop_iteration: 0
followup_review_recommended: true
context: []
warnings: []
deferred:
  - summary: >-
      Aucune vérification automatisée (CI/lint) ne détecte quand `docs/conventions/` ou
      `docs/ARCHITECTURE-SPINE.md` deviennent périmés après une modification de la spine
      source (`docs/architecture/.../ARCHITECTURE-SPINE.md`).
    evidence: |-
      Même raisonnement que pour `conception/INDEX.md` (Story 2.2) et `tools/sync_agents.dart`
      (Story 2.4) : les checks CI par domaine sont explicitement câblés en Epic 9
      (`docs/epics.md` NFR1), pas en Epic 2.
    location: >-
      docs/ARCHITECTURE-SPINE.md, docs/conventions/
    severity: low
---

<intent-contract>

## Intent

**Problem:** `ARCHITECTURE-SPINE.md` (334 lignes, 20 AD) n'a de copie de référence nulle part sous `docs/` (L1 d'AD-15) ; ses 18 conventions transverses (table `Consistency Conventions`) ne sont citables individuellement par aucune story ; et personne ne peut « ajouter une feature », « écrire une migration » ou « écrire un test de widget » sans relire toute la spine.

**Approach:** Copier `ARCHITECTURE-SPINE.md` telle quelle sous `docs/` (copie de référence, pas régénérée) ; éclater sa table `Consistency Conventions` en un fichier par ligne sous `docs/conventions/` ; écrire trois guides-recettes actionnables sous `docs/guides/`, chacun un sujet, chacun utilisable sans avoir lu la spine en entier.

## Boundaries & Constraints

**Always:** `docs/ARCHITECTURE-SPINE.md` est un copier-coller exact du contenu de `docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md` (même texte, aucune paraphrase) ; chacune des 18 lignes de la table `Consistency Conventions` a exactement un fichier dédié sous `docs/conventions/` ; chaque guide sous `docs/guides/` est actionnable seul (étapes concrètes, chemins de fichiers réels ou conventionnels, sans renvoyer le lecteur à « lire la spine d'abord »).

**Never:** ne jamais éditer `docs/architecture/` (source du BMAD run, déjà figée) ni `conception/` pour produire ce contenu ; ne jamais inventer une convention ou une étape de guide qui ne découle pas de la spine — citer la source dans chaque fichier de convention et dans chaque guide (un AD numéroté quand il existe ; à défaut, pour les deux conventions sans AD dédié — « Langue », « Refus hérités de l'essence » —, la source de conception citée en frontmatter de la spine).

</intent-contract>

## Code Map

- `docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md` -- source à copier telle quelle vers `docs/ARCHITECTURE-SPINE.md` (copie de référence, cf. `ARCHITECTURE-SPINE.md:283` : `docs/ ARCHITECTURE-SPINE.md`, distinct de `docs/architecture/` qui reste le run BMAD complet).
- Table `## Consistency Conventions` (spine, lignes 187-208) -- 18 lignes, un fichier `docs/conventions/<slug>.md` par ligne : langue-des-identifiants, identifiants-de-donnees, dates-et-geo, statut-et-provenance, polymorphisme, erreurs, etat, auth, vie-privee, langue, refus-herites-de-lessence, usage-de-lia, config-et-secrets, dependances, release-mobile, licences, observabilite, commits. Chaque fichier : la convention (texte de la cellule "Convention", développé si trop condensé), pourquoi (déduit du contexte spine/AD lié), un exemple concret si utile.
- AD-5 (spine, lignes 60-79) -- couches `presentation → domain → data`, `app/` composition root unique, `core/router`, jamais de feature-à-feature -- base du guide « ajouter une feature ».
- AD-2, AD-6, AD-16 (spine) -- migrations dans `supabase/migrations/`, une par PR, horodatage postérieur au dernier de `main`, invariants = contrainte SQL/RLS + test pgTAP, transitions = RPC qui écrit une Trace, jamais `UPDATE` direct -- base du guide « écrire une migration ».
- AD-14 (spine, lignes 149-151) -- tests d'abord par couche : `presentation` = widget tests des composants `ui_kit` touchés ; premier commit = tests rouges -- base du guide « écrire un test de widget ».
- `apps/mobile/lib/main.dart`, `apps/mobile/test/widget_test.dart` -- état réel actuel du seul test de widget existant (squelette `flutter create`), à citer comme point de départ concret dans le guide widget.
- `supabase/README.md` -- confirme qu'aucune migration réelle n'existe encore ; le guide migration décrit donc la convention cible, pas un exemple déjà exécuté.
- `AGENTS.md`, `apps/mobile/AGENTS.md`, `supabase/AGENTS.md` (Story 2.3, si déjà mergée sur `main` au moment de l'implémentation ; sinon absents sur cette branche) -- si présents, les guides et fichiers de convention ne doivent pas dupliquer leur contenu (renvoi par lien relatif plutôt que répétition), même logique anti-duplication que la Story 2.3.

## Tasks & Acceptance

**Execution:**
- `docs/ARCHITECTURE-SPINE.md` -- copie exacte du contenu de `docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md` -- cœur de l'AC (copie de référence)
- `docs/conventions/*.md` (18 fichiers) -- un fichier par ligne de la table `Consistency Conventions`, slug kebab-case du "Concern", contenu = convention + pourquoi + AD source cité -- cœur de l'AC
- `docs/guides/ajouter-une-feature.md` -- recette actionnable pour créer une feature respectant AD-5 (arborescence `presentation/domain/data`, où poser les providers Riverpod, comment l'assembler depuis `app/`, ce qu'on ne fait jamais) -- cœur de l'AC
- `docs/guides/ecrire-une-migration.md` -- recette actionnable pour écrire une migration `supabase/migrations/` (nommage/horodatage, RLS + test pgTAP par invariant touché, RPC de transition avec Trace, une migration par PR) -- cœur de l'AC
- `docs/guides/ecrire-un-test-de-widget.md` -- recette actionnable pour écrire un widget test (où le placer, quoi couvrir en priorité — composants `ui_kit` touchés —, structure Arrange/Act/Assert, exemple à partir du squelette existant) -- cœur de l'AC
- `docs/stories/spec-2-5-docs-spine-conventions-guides.md` -- consigner en Implementation Notes la liste des 18 fichiers de conventions produits et la vérification de couverture (une ligne de la table = un fichier, aucune omise, aucune en trop) -- preuve auditable

**Acceptance Criteria:**
- Given la table `Consistency Conventions` de la spine (18 lignes), when `docs/conventions/` est listé, then il contient exactement 18 fichiers, chacun correspondant à une ligne distincte de la table.
- Given `docs/ARCHITECTURE-SPINE.md`, when son contenu est comparé à `docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md`, then il est identique (`diff` vide).
- Given les trois guides de `docs/guides/`, when un lecteur qui n'a lu que le guide (pas la spine) suit ses étapes, then il peut les exécuter sans information manquante (chemins de fichiers, commandes, critères explicites).

## Spec Change Log

## Review Triage Log

### 2026-09-18 — Review pass
- verdicts: 16 findings — high 0, medium 2, low 6, false 8, maybe-false 0
- findings:
  - `[false]` reject (blind-hunter) `docs/ARCHITECTURE-SPINE.md` absent du diff soumis à la revue — réfuté : exclusion délibérée d'une copie déjà vérifiée octet-pour-octet hors revue (`diff` vide, confirmé indépendamment), pas un défaut du livrable.
  - `[false]` reject (blind-hunter) la table domaine → slug (mobile) saute de D9 à D11 sans D10 — réfuté : fidèle à la table source de la spine elle-même, où D10 (Production de contenu) n'a pas de dossier de feature mobile, ses slugs (`catalogue`, `saisie`, `validation`, `moderation`) étant déjà listés séparément côté admin sans numéro Dx.
  - `[low]` `patch` (blind-hunter) `docs/guides/ajouter-une-feature.md` renvoie, pour le cas d'un slug non listé, à « vérifier d'abord la table Capability → Architecture Map de la spine » — contredit littéralement le Never de la spec (jamais renvoyer à lire la spine). Corrigé : reformulé en règle autonome.
  - `[low]` reject, correctif de texte de spec seul (blind-hunter) 2 fichiers de convention (« Langue », « Refus hérités de l'essence ») citent une source `conception/*.yaml` plutôt qu'un AD numéroté — réfuté comme défaut de contenu : ces deux lignes de la table n'ont réellement aucun AD dédié (ce sont des décisions d'essence produit, pas d'architecture) ; corrigé directement dans le texte de la spec (Never assoupli pour refléter cette réalité), le contenu était déjà correctement sourcé.
  - `[false]` reject (blind-hunter) absence de guide pour les tests unitaires domain/data — réfuté : l'AC nomme explicitement exactement 3 guides (feature, migration, widget), un 4e guide serait hors périmètre de l'intention.
  - `[false]` reject (blind-hunter) slugs admin sans traçabilité Dx/AD, contrairement aux slugs mobile — réfuté : fidèle à la table source, qui liste déjà les slugs admin sans numéro Dx.
  - `[low]` `defer` (blind-hunter) aucune détection automatisée de péremption de `docs/conventions/`/`docs/ARCHITECTURE-SPINE.md` face à la spine source — même disposition que Stories 2.2/2.4 (Epic 9, NFR1). Différé.
  - `[low]` `patch` (blind-hunter) la vérification n'a jamais contrôlé que les nouveaux liens relatifs (guides ↔ conventions ↔ spine) résolvent réellement. Vérifié directement : voir Implementation Notes.
  - `[false]` reject (blind-hunter) le Code Map de la spec cite des numéros de ligne de la spine qui deviendront obsolètes — réfuté : c'est un artefact de planification interne à la spec, pas le contenu livré sous `docs/`.
  - `[false]` reject (blind-hunter) `docs/conventions/auth.md` utilise le mot anglais « Auth » alors que la convention « langue des identifiants » impose le français — réfuté : « Auth » est le libellé exact de la colonne "Concern" de la table source ; cette convention porte sur les identifiants de code (tables, colonnes, dossiers de feature), pas sur les titres de fiches de documentation qui reprennent le vocabulaire de la spine.
  - `[low]` `patch` (edge-case-hunter) `docs/conventions/erreurs.md`, l'exemple de couche `data` n'intercepte que `PostgrestException` ; une erreur de désérialisation JSON (`fromJson`) fuiterait brute, contredisant la propre règle du fichier (« jamais fuiter une exception brute »). Corrigé : `catch` générique ajouté après le `catch` spécifique.
  - `[medium]` `patch` (edge-case-hunter) `docs/guides/ecrire-une-migration.md`, l'exemple de RPC `pin_publier` insère inconditionnellement une ligne dans `trace_validation` même si l'`UPDATE` n'a affecté aucune ligne (pin déjà publié ou introuvable) — corromprait la piste d'audit si cet exemple est copié tel quel dans une vraie migration future (Epic 3). Corrigé : vérification du nombre de lignes affectées avant l'insertion de la Trace.
  - `[low]` reject, correctif de texte de spec seul (edge-case-hunter) même défaut que la 4e ligne (citation de source pour « Langue »/« Refus hérités »).
  - `[false]` reject (verification-gap) même constat que la 1re ligne (`docs/ARCHITECTURE-SPINE.md` absent du diff soumis).
  - `[medium]` `patch` (intent-alignment) `docs/guides/ecrire-un-test-de-widget.md`, l'exemple de squelette de test utilise `ProviderScope` sans importer `package:flutter_riverpod/flutter_riverpod.dart` — un lecteur qui copie l'exemple tel quel obtient une erreur de compilation, contredisant directement l'AC (« actionnable sans information manquante »). Corrigé : import ajouté.
  - `[false]` reject (intent-alignment) les guides « ajouter une feature » et « écrire un test de widget » référencent une arborescence (`app/`, `core/router`, `packages/ui_kit`) pas encore peuplée — réfuté comme défaut : déjà explicitement divulgué dans la spec (Risques/limites) et dans le corps des guides eux-mêmes, même logique que Story 2.3 (état réel vs cible).

## Implementation Notes

**Fichiers produits :**
- `docs/ARCHITECTURE-SPINE.md` -- copie exacte de `docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md` (`diff` vide, vérifié).
- `docs/guides/ajouter-une-feature.md`, `docs/guides/ecrire-une-migration.md`, `docs/guides/ecrire-un-test-de-widget.md`.
- `docs/conventions/` -- 18 fichiers, un par ligne de la table `Consistency Conventions` (spine, lignes 187-208 du fichier source) :

| # | Ligne de la table (`Concern`) | Fichier |
| --- | --- | --- |
| 1 | Langue des identifiants | `docs/conventions/langue-des-identifiants.md` |
| 2 | Identifiants de données | `docs/conventions/identifiants-de-donnees.md` |
| 3 | Dates & géo | `docs/conventions/dates-et-geo.md` |
| 4 | Statut & provenance | `docs/conventions/statut-et-provenance.md` |
| 5 | Polymorphisme (Signalement, Favori, Lien universel) | `docs/conventions/polymorphisme.md` |
| 6 | Erreurs | `docs/conventions/erreurs.md` |
| 7 | État | `docs/conventions/etat.md` |
| 8 | Auth | `docs/conventions/auth.md` |
| 9 | Vie privée | `docs/conventions/vie-privee.md` |
| 10 | Langue | `docs/conventions/langue.md` |
| 11 | Refus hérités de l'essence | `docs/conventions/refus-herites-de-lessence.md` |
| 12 | Usage de l'IA | `docs/conventions/usage-de-lia.md` |
| 13 | Config & secrets | `docs/conventions/config-et-secrets.md` |
| 14 | Dépendances | `docs/conventions/dependances.md` |
| 15 | Release mobile | `docs/conventions/release-mobile.md` |
| 16 | Licences | `docs/conventions/licences.md` |
| 17 | Observabilité | `docs/conventions/observabilite.md` |
| 18 | Commits | `docs/conventions/commits.md` |

**Vérification de couverture :** les 18 lignes de la table `Consistency Conventions` (spine) ont été listées par extraction (`grep` sur les lignes du tableau Markdown) puis rapprochées une à une des 18 fichiers ci-dessus : couverture 1:1 confirmée, aucune ligne omise, aucun fichier en trop (`ls docs/conventions | wc -l` = 18).

**AGENTS.md (Story 2.3) :** absents sur cette branche au moment de l'implémentation (`ls AGENTS.md apps/mobile/AGENTS.md supabase/AGENTS.md` -- aucun résultat) ; aucun renvoi par lien relatif n'a donc été nécessaire.

**Vérifications exécutées :**
- `diff docs/ARCHITECTURE-SPINE.md docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md` -- sortie vide.
- `ls docs/conventions | wc -l` -- `18`.
- `dart run melos run analyze` (via `fvm`, `dart analyze .` + `tools/check_import_direction.dart`) -- `No issues found!` / `aucune violation` : aucune régression, aucun effet de bord des fichiers Markdown ajoutés.
- Relecture manuelle croisée table ↔ fichiers de conventions (ci-dessus) et relecture des 3 guides pour vérifier qu'ils sont actionnables seuls (chemins réels : `apps/mobile/lib/main.dart`, `apps/mobile/test/widget_test.dart`, `supabase/README.md`, `supabase/migrations/`, `supabase/tests/`, `supabase/functions_sql/`, `packages/ui_kit`).

**Risques / limites connues :**
- Les guides « ajouter une feature » et « écrire un test de widget » décrivent une arborescence (`app/`, `core/router`, `packages/ui_kit`) qui n'est pas encore intégralement peuplée sur cette branche (le seul code réel est le squelette `flutter create` de `apps/mobile`) ; ils décrivent la convention cible, pas un exemple déjà exécuté -- même logique que le guide migration vis-à-vis de `supabase/`.
- Le rattachement de chaque convention à un AD a été déduit du contexte de la spine quand la table `Consistency Conventions` ne cite pas explicitement un AD (aucune invention de règle : la déduction s'appuie sur le texte des AD ou, pour « Langue » et « Refus hérités de l'essence », sur les sources listées en frontmatter de la spine, faute d'AD numéroté dédié).

## Auto Run Result

**Résumé :** `docs/ARCHITECTURE-SPINE.md` (copie de référence exacte), 18 fichiers `docs/conventions/*.md` (couverture 1:1 avec la table Consistency Conventions), 3 guides actionnables `docs/guides/*.md` (ajouter une feature, écrire une migration, écrire un test de widget).

**Fichiers modifiés :**
- `docs/ARCHITECTURE-SPINE.md` -- copie exacte, `diff` vide confirmé.
- `docs/conventions/*.md` (18 fichiers) -- un par ligne de la table Consistency Conventions.
- `docs/guides/ajouter-une-feature.md`, `docs/guides/ecrire-une-migration.md`, `docs/guides/ecrire-un-test-de-widget.md`.
- `docs/stories/spec-2-5-docs-spine-conventions-guides.md` -- spec, Implementation Notes, Review Triage Log, assouplissement du Never sur la citation de source.

**Revue :** 4 lentilles, 16 findings.
- Patchés : 5 entrées (2 `medium` -- exemple RPC de migration insérant une Trace même sans transition réelle, import Riverpod manquant rendant l'exemple de test de widget non compilable ; 3 `low` -- guide renvoyant à la spine pour un cas limite, exemple d'erreur data ne gérant pas les exceptions génériques, plus un `const` erroné trouvé lors du balayage complet demandé en revue). Tous corrigés, revérifiés (grep ciblés + `dart format` sur les extraits + `melos run analyze`).
- Différé (1, `low`) : détection automatisée de péremption de `docs/conventions/`/`docs/ARCHITECTURE-SPINE.md` face à la spine source -- Epic 9, NFR1, même disposition que Stories 2.2/2.4.
- Rejetés (`false`, 8) : absence de `docs/ARCHITECTURE-SPINE.md` dans le diff soumis (déjà vérifiée hors revue, ×2), saut D9→D11 dans la table domaine/slug (fidèle à la source), absence de guide domain/data (hors périmètre de l'AC), slugs admin sans traçabilité Dx (fidèle à la source), numéros de ligne du Code Map obsolètes (artefact de planification, pas le livrable), titre anglais « Auth » (vocabulaire de la table source), arborescence cible pas encore peuplée (déjà divulgué, cohérent avec Story 2.3).
- Rejetés car le correctif était un texte de spec seul (`low`, 2) : citation de source pour « Langue »/« Refus hérités de l'essence » -- corrigé directement dans le Never de la spec, le contenu était déjà correctement sourcé.
- Aucun `intent_gap` ni `bad_spec`.

**Follow-up review recommended :** `true` -- deux entrées `medium` patchées lors de cette première passe (seuil atteint). Risque nommé : les correctifs de code d'exemple (RPC de migration, import Riverpod) n'ont pas eux-mêmes été repassés par les 4 lentilles ; seuls `dart format` (syntaxe) et une relecture manuelle les couvrent.

**Vérification effectuée :** les commandes de la section `## Verification` rejouées après correctifs (`diff` spine vide, 18 fichiers, `melos run analyze` propre), plus une vérification indépendante de résolution de tous les liens relatifs entre `docs/conventions/`, `docs/guides/` et la spine (aucun lien cassé).

**Risques résiduels :** voir Follow-up review recommended ci-dessus.

## Verification

**Commands:**
- `diff docs/ARCHITECTURE-SPINE.md docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md` -- expected: sortie vide
- `ls docs/conventions/ | wc -l` -- expected: 18
- lecture manuelle croisée : chaque ligne de la table `Consistency Conventions` retrouvée dans exactement un fichier -- expected: couverture 1:1, aucune omission ni doublon
- lecture manuelle des 3 guides -- expected: chacun actionnable sans autre document ouvert
- `melos run analyze` -- expected: aucune régression (fichiers Markdown, vérifie l'absence d'effet de bord)
