---
title: 'Workspace Pub et scripts melos'
type: 'chore'
created: '2026-09-18'
status: 'done'
route: 'oneshot'
review_loop_iteration: 0
context:
  - '{project-root}/docs/architecture/architecture-HistoLyon-2026-09-17/BOOTSTRAP.md'
  - '{project-root}/docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Il n'existe encore aucun workspace Pub racine : aucun lanceur de scripts commun (`analyze`, `test`, `format`, `gen`) ne peut s'exécuter sur tout le dépôt, et rien n'existe pour rattacher les futurs `apps/*`/`packages/*` des stories suivantes (1.3–1.5).

**Approach:** Créer `pubspec.yaml` à la racine avec une section `workspace:` (liste vide pour l'instant — `apps/mobile`, `apps/admin` et `packages/*` n'existent pas encore, ils seront ajoutés par les stories 1.3–1.5 au fur et à mesure de leur création) et une section `melos:` déclarant les scripts `analyze`, `test`, `format`, `gen` ; `melos` 8.7 en `dev_dependency`. Pas de `melos.yaml` (supprimé depuis melos 7 — toute la config vit dans `pubspec.yaml`).

</frozen-after-approval>

## Implementation Notes

- `pubspec.yaml` racine créé : `workspace: []` (vide — `apps/mobile`, `apps/admin`, `packages/*` n'existent pas encore ; les stories 1.3–1.5 y ajouteront leurs entrées au fur et à mesure) ; `environment.sdk: ^3.13.3` (version Dart figée par la spine) ; `melos: ^8.7.0` en `dev_dependencies` ; section `melos.scripts` déclarant `analyze` (`dart analyze .`), `test` (`dart test`), `format` (`dart format --set-exit-if-changed .`), `gen` (`dart run build_runner build --delete-conflicting-outputs`). Pas de `melos.yaml`.
- Vérification non exécutable dans cet environnement au moment de l'implémentation : ni `dart` ni `flutter` ni `melos` n'étaient installés (`dart`/`flutter` absents du `PATH`). Tracé dans `sprint-status.yaml.action_items` (`verify-1-2-melos-toolchain`).
- **Mise à jour post-installation** : Flutter 3.47.4 installé via `fvm` (`fvm install 3.47.4` puis `fvm use 3.47.4`), `.fvmrc` et `.gitignore` (`.fvm/`) ajoutés par `fvm use`. AC vérifiées en exécution réelle : `fvm dart run melos run analyze` → `No issues found!` ; `melos.yaml` toujours absent. `pubspec.lock` généré (38 dépendances transitives, dont `melos 8.7.0`). `fvm install` a confirmé `Tools • Dart 3.13.3`, compatible avec `environment.sdk: ^3.13.3`. Action item `verify-1-2-melos-toolchain` clos.
- **Correctifs post-revue `bmad-code-review`** : `melos run format` vérifié OK (`Formatted no files`) ; `melos run test`/`melos run gen` échouent réellement en l'état (`Could not find package test` / `Could not find package build_runner` — aucun des deux n'est un `dev_dependency`), confirmé en exécution directe. Attendu à ce stade : aucun package ni test ni génération n'existe encore (stories 1.3–1.5, Epic 4 `tools/gen-types`) ; `resolution` de l'action item corrigée en conséquence plutôt que de le laisser clos sur une affirmation inexacte.

## Review Triage Log

- `false` — pas de `baseline_commit` en frontmatter : ce champ n'est pas requis par le template de spec ; `spec-1-1` l'utilisait pour un besoin propre à son diff (import massif depuis l'arbre vide), pas une exigence générale. Le code-review peut résoudre le diff de cette story par un simple diff de branche vs `main`.
- `false` — sections *Boundaries & Constraints*, *I/O & Edge-Case Matrix*, *Code Map*, *Tasks & Acceptance*, *Verification* absentes : suppression intentionnelle prescrite par la route `oneshot` (step-02, faits propres : pas de zone d'ombre, rien d'irréversible, changement petit) — pas une troncature accidentelle.
- `false` — pas de section *Review Findings*/*Rejected* : ces sections ne font pas partie du template de base, elles n'apparaissent que lorsqu'une revue produit des constats à tracer (ce que fait cette section même).
- `false` — `route: 'oneshot'` non expliqué : gouverné par la porte de route de step-02 (changement petit, sans zone d'ombre ni irréversible), pas une incohérence propre à cette story.
- `medium`, patché — l'AC « `melos run analyze` s'exécute sans erreur » n'a jamais pu être vérifiée en exécution réelle (toolchain absente ici), et rien ne le traçait avant de clore la story → item ajouté à `sprint-status.yaml.action_items` (`verify-1-2-melos-toolchain`).
- `low`/rejeté — absence de mécanisme de fixation de version Flutter (`.fvmrc`/`.tool-versions`) : hors périmètre explicite de cette story (ni BOOTSTRAP.md ni l'AC de Story 1.2 dans `epics.md` ne le demandent), aucun dommage nommé actuel (porteur unique, phase bootstrap). **Superseded** (voir revue `bmad-code-review` ci-dessous) : l'humain a ensuite explicitement demandé l'installation de Flutter ; `.fvmrc` a été ajouté à cette occasion pour fixer la version côté équipe — ce rejet ne tient plus, gardé ici pour la trace.

### Review Findings

- [x] [Review][Patch] Action item `verify-1-2-melos-toolchain` clos `status: done` en prétendant `analyze`/`test`/`format`/`gen` vérifiés, mais seuls `analyze` et `format` passent réellement — `melos run test` échoue (`Could not find package test`, aucun `dev_dependency` `test`) et `melos run gen` échoue (`Could not find package build_runner`), confirmé en exécution directe — résolu : `resolution` corrigée dans `sprint-status.yaml`. [`docs/stories/sprint-status.yaml`, `pubspec.yaml:17-25`]
- [x] [Review][Patch] Le rejet `.fvmrc` du Review Triage Log ci-dessus contredit l'ajout réel de `.fvmrc` dans les Implementation Notes qui suivent, sans réconciliation explicite au moment des faits — résolu : entrée annotée « Superseded ». [`docs/stories/spec-1-2-workspace-pub-et-scripts-melos.md`]
- [x] [Review][Patch] `.fvmrc` et le bloc ajouté à `.gitignore` n'ont pas de retour à la ligne final — résolu. [`.fvmrc`, `.gitignore:29-31`]
- [x] [Review][Patch] Compatibilité Dart 3.13.3 (bundled par Flutter 3.47.4) avec `environment.sdk: ^3.13.3` jamais consignée dans les Implementation Notes, alors qu'observée dans la sortie de `fvm install` — résolu : ajoutée aux Implementation Notes. [`docs/stories/spec-1-2-workspace-pub-et-scripts-melos.md`]

**Rejected**

- `false` — `status: 'done'` (spec) vs `1-2-...: review` (sprint-status.yaml) : cycle de vie voulu par `step-oneshot.md` et documenté dans l'en-tête de `sprint-status.yaml` (« Dev moves story to review, then runs code-review ») — deux signaux distincts, pas une seule valeur qui doit concorder.
- `false` — claim `melos run analyze` non étayée par un artefact dans le diff : exécutée directement par l'agent dans cette session, sortie observée (« No issues found! »), pas une simple affirmation non vérifiée.
- `false` — comptage « 1 finding réel, 9 rejetés » contesté (le triage log n'affiche que 6 lignes) : mal compté — une ligne du triage regroupe 5 findings originaux du blind-hunter (Boundaries & Constraints/I-O Matrix/Code Map/Tasks & Acceptance/Verification, tous rejetés pour la même cause : suppression intentionnelle par la route oneshot). 1+5+1+1+1+1 = 10 findings, 9 rejetés, 1 patché — cohérent avec le message de commit.
- `false` — `pubspec.lock` absent du diff revu : exclusion volontaire (fichier généré par `dart pub get`, 309 lignes), pas un diff tronqué — le commit `aaca1e8` le contient intégralement dans l'historique.
- `false` — absence de CI qui exécute les scripts melos sur push/PR : différée explicitement à l'épic 9 par BOOTSTRAP.md (« les checks tournent en local jusque-là »), pas un oubli de cette story.
