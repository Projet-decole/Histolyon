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
- Vérification non exécutable dans cet environnement : ni `dart` ni `flutter` ni `melos` ne sont installés ici (`dart`/`flutter` absents du `PATH`). `melos run analyze` n'a donc pas pu être lancé pour confirmer l'AC — le fichier est écrit selon les conventions Dart workspace/melos 8.x connues, mais reste à vérifier sur un poste avec Flutter 3.47.4 installé (prérequis NFR9). Tracé dans `sprint-status.yaml.action_items` (`verify-1-2-melos-toolchain`).

## Review Triage Log

- `false` — pas de `baseline_commit` en frontmatter : ce champ n'est pas requis par le template de spec ; `spec-1-1` l'utilisait pour un besoin propre à son diff (import massif depuis l'arbre vide), pas une exigence générale. Le code-review peut résoudre le diff de cette story par un simple diff de branche vs `main`.
- `false` — sections *Boundaries & Constraints*, *I/O & Edge-Case Matrix*, *Code Map*, *Tasks & Acceptance*, *Verification* absentes : suppression intentionnelle prescrite par la route `oneshot` (step-02, faits propres : pas de zone d'ombre, rien d'irréversible, changement petit) — pas une troncature accidentelle.
- `false` — pas de section *Review Findings*/*Rejected* : ces sections ne font pas partie du template de base, elles n'apparaissent que lorsqu'une revue produit des constats à tracer (ce que fait cette section même).
- `false` — `route: 'oneshot'` non expliqué : gouverné par la porte de route de step-02 (changement petit, sans zone d'ombre ni irréversible), pas une incohérence propre à cette story.
- `medium`, patché — l'AC « `melos run analyze` s'exécute sans erreur » n'a jamais pu être vérifiée en exécution réelle (toolchain absente ici), et rien ne le traçait avant de clore la story → item ajouté à `sprint-status.yaml.action_items` (`verify-1-2-melos-toolchain`).
- `low`/rejeté — absence de mécanisme de fixation de version Flutter (`.fvmrc`/`.tool-versions`) : hors périmètre explicite de cette story (ni BOOTSTRAP.md ni l'AC de Story 1.2 dans `epics.md` ne le demandent), aucun dommage nommé actuel (porteur unique, phase bootstrap).
