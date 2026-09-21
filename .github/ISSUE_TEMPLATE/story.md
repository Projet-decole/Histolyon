---
name: Story
about: 'Nouvelle story dev-story BMAD (format docs/stories/TEMPLATE.md)'
title: '[Story] '
labels: 'story'
---

```yaml
---
title: '<Titre de la story>'
type: '<feature|chore|fix|docs>'
created: '<AAAA-MM-JJ>'
status: 'draft'
baseline_revision: '<sha du commit sur lequel la story est basée>'
review_loop_iteration: 0
followup_review_recommended: false
context:
  - '<chemin vers un document de contexte à charger avant de commencer, ex. {project-root}/docs/...>'
warnings: []
deferred: []
---
```

<intent-contract>

## Intent

**Problem:** <Quel problème concret cette story résout-elle ? Citer les preuves (fichiers existants, ADs, comportement observé) qui montrent que le problème est réel, pas supposé.>

**Approach:** <Quelle solution est retenue, et pourquoi celle-ci plutôt qu'une alternative envisageable ?>

## Boundaries & Constraints

**Always:** <Ce que l'implémentation doit toujours respecter — contraintes non négociables, ADs applicables, format ou convention existants à préserver.>

**Never:** <Ce que l'implémentation ne doit jamais faire — régressions à éviter, contenu à ne pas dupliquer, conventions à ne pas casser.>

<!-- Section optionnelle : à inclure seulement si la story contractualise des entrées/sorties explicites (API, CLI, fichier de config, schéma). La retirer sinon. -->
<!--
## I/O Matrix

| Entrée | Source | Sortie | Destination |
| --- | --- | --- | --- |
| <entrée> | <source> | <sortie> | <destination> |
-->

</intent-contract>

## Code Map

- `<chemin/vers/fichier>` -- <ce que ce fichier apporte comme contexte, ou ce qu'il faut y modifier, et pourquoi>

## Tasks & Acceptance

**Execution:**
- `<chemin/vers/livrable>` -- <ce qui doit être fait> -- <pourquoi c'est au cœur de l'AC, ou une preuve auditable>

**Acceptance Criteria:**
- Given <contexte>, when <action>, then <résultat attendu>.

## Spec Change Log

## Review Triage Log

## Verification

**Commands:**
- `<commande>` -- expected: <résultat attendu>
