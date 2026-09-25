---
title: 'prompts/'
type: 'feature'
created: '2026-09-18'
status: 'done'
baseline_revision: '582f7c428d5e69a3a62429831553081cacc2972f'
review_loop_iteration: 0
followup_review_recommended: false
context: []
warnings: []
deferred: []
---

<intent-contract>

## Intent

**Problem:** `ORGANISATION.md` promet des prompts portables (« colle `prompts/dev-story.md` + le brief dans ton outil ») et une checklist sans IA, mais aucun des deux n'existe : quelqu'un sans BMAD installé (la majorité de l'équipe, cf. `ORGANISATION.md` § 2 « Qui découpe ») n'a aucun moyen concret de suivre le même chemin qu'un assistant outillé.

**Approach:** Quatre fichiers `prompts/*.md`, chacun un prompt complet et autonome (pas un résumé qui renvoie ailleurs), dérivés du chemin déjà écrit noir sur blanc dans `ORGANISATION.md` §§ 2, 4, 5, 6, 8 : `dev-story.md` (implémenter une story), `review.md` (relire une PR), `decoupe.md` (découper un épic en stories), `SANS-IA.md` (dérouler une story sans aucun outil IA).

## Boundaries & Constraints

**Always:** chaque prompt est collable tel quel dans un assistant IA générique (ChatGPT, Gemini, Claude web, etc.) sans installation ni outil BMAD — il doit lui-même rappeler les règles nécessaires (tests d'abord, zones/couches, format de PR) plutôt que supposer que l'assistant les connaît déjà ; `SANS-IA.md` est une checklist actionnable par un humain seul, sans coller quoi que ce soit dans un outil.

**Never:** ne jamais supposer que l'assistant IA a accès à BMAD, à `_bmad/`, ou à un outil de ce dépôt au-delà de ce que l'humain lui colle explicitement (le brief de la story, un extrait de fichier) ; ne jamais dupliquer intégralement le contenu de `docs/conventions/*.md` (Story 2.5, si déjà mergée sur cette branche) — un prompt peut lister les points clés à vérifier, pas recopier chaque fichier de convention en entier.

</intent-contract>

## Code Map

- `docs/architecture/architecture-HistoLyon-2026-09-17/ORGANISATION.md` §8 « Résultat : ta première story » (lignes ~155-179) -- déroulé complet et déjà générique (prendre l'issue, lire le brief, brancher, tests d'abord, coder par zone, ouvrir la PR avec le template, relecture, fusion) : base directe de `prompts/dev-story.md` (version à coller dans un assistant IA) et de `prompts/SANS-IA.md` (même déroulé, sans la étape « coller dans un outil »).
- `ORGANISATION.md` §5 (lignes ~105-114) -- tests d'abord par couche, vérifications automatiques, déclaration de l'assistance IA -- rappels que `dev-story.md` doit intégrer explicitement (l'assistant ne les connaît pas par défaut).
- `ORGANISATION.md` §8 étape 7 « Relecture » (ligne ~177) -- « critères atteints, tests avant le code, code dans la bonne zone » -- base de `prompts/review.md`.
- `ORGANISATION.md` §2 (lignes ~43-49) -- taille d'une story (une session, un objectif, un brief complet), et « Qui découpe » -- base de `prompts/decoupe.md` : à partir d'une conception/capability, produire des stories respectant AD-12 (une story = une zone, brief = objectif + extraits de conception par ID + tests + critères de fin + fichiers à toucher).
- AD-12 (spine) -- une story = 1 issue = 1 branche `story/<ID>-<slug>` = 1 PR, une seule zone touchée, migration et UI = deux stories -- contrainte que `prompts/decoupe.md` doit faire respecter à toute découpe produite.
- `.github/PULL_REQUEST_TEMPLATE.md`, `docs/stories/TEMPLATE.md` (Story 2.6, si déjà mergée sur cette branche ; sinon absents) -- si présents, `prompts/dev-story.md` y renvoie pour le format exact de PR/story plutôt que de le reformuler.
- `docs/conventions/*.md` (Story 2.5, si déjà mergée) -- si présents, `prompts/review.md` y renvoie pour le détail de chaque convention plutôt que de les recopier.

## Tasks & Acceptance

**Execution:**
- `prompts/dev-story.md` -- prompt autonome pour implémenter une story avec un assistant IA générique : rappelle tests-d'abord, couches/zones (AD-5), commandes de vérification, format de commit et de PR -- cœur de l'AC
- `prompts/review.md` -- prompt autonome pour faire relire une PR par un assistant IA générique : critères d'acceptation atteints, ordre tests-avant-code respecté, code dans la bonne zone, rien d'autre modifié -- cœur de l'AC
- `prompts/decoupe.md` -- prompt autonome pour découper un épic/une capability en stories respectant AD-12 (taille d'une session, une zone, brief complet : objectif, extraits de conception par ID, tests, critères de fin, fichiers à toucher) -- cœur de l'AC
- `prompts/SANS-IA.md` -- checklist actionnable sans aucun outil IA, couvrant les 8 étapes d'`ORGANISATION.md` § 8 (prendre, lire, brancher, tests d'abord, coder, ouvrir la PR, relecture, fusion) ; `dev-story.md` ne couvre que le sous-ensemble pertinent pour un assistant IA collé dans un outil (lire, tests d'abord, coder, PR) puisque prendre/brancher/fusion sont mécaniquement du ressort de l'humain seul, avec ou sans IA -- cœur de l'AC
- `docs/stories/spec-2-7-prompts.md` -- consigner en Implementation Notes une relecture des 4 fichiers confirmant qu'ils sont autonomes (aucun ne suppose un contexte non fourni) -- preuve auditable

**Acceptance Criteria:**
- Given les 4 fichiers `prompts/*.md` écrits, when chacun de `dev-story.md`, `review.md` et `decoupe.md` est lu isolément, then il est collable tel quel dans un assistant IA générique sans installation BMAD ni accès à `_bmad/` -- satisfait
- Given `prompts/SANS-IA.md` écrit, when un humain le suit seul, then il peut dérouler une story de bout en bout (prendre, tests d'abord, coder, PR, relecture, fusion) sans aucun outil IA -- satisfait

## Spec Change Log

## Implementation Notes

- Les 4 fichiers sont dérivés directement d'`ORGANISATION.md` §§ 2, 4b, 4c, 5, 6, 8 et de l'AD-5/AD-12 de `ARCHITECTURE-SPINE.md` (Code Map). `.github/PULL_REQUEST_TEMPLATE.md` et `docs/stories/TEMPLATE.md` (Story 2.6) n'existent pas sur cette branche à ce jour (vérifié : aucun fichier `.github/`, aucun `TEMPLATE.md` dans `docs/stories/`), de même que `docs/conventions/*.md` (Story 2.5) : `dev-story.md` et `review.md` y renvoient de façon conditionnelle (« si ce fichier existe, colle-le / suis-le plutôt qu'improviser ») avec un format/une checklist minimale de repli inline, plutôt que de supposer leur présence ou de les recopier.
- Relecture isolée des 4 fichiers (lecture comme le ferait quelqu'un qui n'a que ce seul fichier ouvert, sans le reste du dépôt) :
  - `prompts/dev-story.md` — autonome : rappelle lui-même l'organisation par domaine/couches (AD-5), la règle une-story-une-zone (AD-12), l'ordre tests-d'abord par couche, le format de commit et le format de PR (avec repli si le template n'est pas collé). Aucun renvoi non résolu ; aucune supposition d'accès à `_bmad/`, BMAD ou au terminal du dépôt (le point 5 explicite : « si tu ne peux pas exécuter ces commandes toi-même, dis-moi quoi lancer »).
  - `prompts/review.md` — autonome : rappelle les mêmes règles de zones/couches, l'ordre tests-avant-code, et une checklist de conventions minimale utilisable si `docs/conventions/*.md` n'est pas collé. Ne suppose jamais que l'assistant a le dépôt ouvert : tout ce qu'il doit vérifier est soit rappelé inline, soit explicitement demandé à coller (brief, description de PR, diff, conventions).
  - `prompts/decoupe.md` — autonome : redéfinit ce qu'est une story et une zone sans renvoyer à BMAD ni à `tools/ctx` (explicitement cité en négatif : « ne suppose jamais que je peux exécuter tools/ctx »), donne le format de brief complet (objectif / à lire par ID / tests / critères / fichiers) directement issu d'`ORGANISATION.md` § 2.
  - `prompts/SANS-IA.md` — actionnable sans aucun outil IA : checklist des 8 étapes d'`ORGANISATION.md` § 8 (prendre → fusion), chaque étape rappelant elle-même les règles nécessaires (nom de branche, format de commit, zones/couches, commandes `melos`) sans renvoyer à `dev-story.md` pour le contenu — seule la note d'en-tête indique la filiation avec `dev-story.md`, aucune étape ne demande de coller quoi que ce soit dans un outil.
  - Aucun des 4 fichiers ne cite `_bmad/`, un agent BMAD ou une commande BMAD comme prérequis.
- `melos run analyze` non exécutable dans cet environnement (aucun SDK Dart/Flutter installé sur ce poste) ; sans objet de toute façon pour ce changement, qui n'ajoute que des fichiers Markdown dans `prompts/` — ni `dart analyze` ni `tools/check_import_direction.dart` (qui ne scanne que `apps/*/lib`) ne portent sur ces fichiers.

## Review Triage Log

### 2026-09-18 — Review pass
- verdicts: 18 findings — high 0, medium 2, low 12, false 4, maybe-false 0
- findings:
  - `[false]` reject (blind-hunter) `SANS-IA.md` (majuscules-tiret) nommé différemment de ses 3 pairs (kebab-case minuscule) — réfuté : ce nom exact est mandaté par l'AC littérale de l'épic (`docs/epics.md`), pas une incohérence introduite ici.
  - `[low]` `patch` (blind-hunter) `prompts/` n'a pas d'index expliquant l'ordre d'usage des 4 prompts — corrigé : `prompts/README.md` (placeholder de la Story 1.3) complété avec un court index.
  - `[low]` `patch` (blind-hunter) `SANS-IA.md` § « Tests d'abord » omet la couche `data/` (accès aux données), présente dans les 5 couches de `dev-story.md`. Corrigé : couche ajoutée.
  - `[medium]` `patch` (blind-hunter) ni `dev-story.md` ni `SANS-IA.md` n'enseignent la règle « toute transition d'état est une RPC, jamais un `UPDATE` direct » que `review.md` vérifie explicitement — quelqu'un qui suit l'un des deux prompts d'implémentation n'a aucun moyen d'apprendre cette règle, alors que le prompt de revue la sanctionnera. Corrigé : règle ajoutée dans `dev-story.md` et `SANS-IA.md`.
  - `[low]` `patch` (blind-hunter) `SANS-IA.md` évoque cocher « aucune IA utilisée » alors que le seul gabarit de PR donné (repli de `dev-story.md`) a un champ texte libre, sans case ni option « aucune IA ». Corrigé : les deux fichiers partagent désormais la même structure de repli.
  - `[low]` `patch` (blind-hunter) `review.md` (« tests avant le code ») ne demande pas explicitement de confirmer que le premier commit ne contient QUE des tests, sans implémentation mélangée — plus faible que la règle qu'il est censé faire respecter. Corrigé.
  - `[low]` `patch` (blind-hunter) tournure maladroite « à remonter (à l'issue...) » dans `SANS-IA.md` § 2. Corrigé : « dans l'issue ».
  - `[false]` reject (blind-hunter) incohérence de casse sur les noms de rôle (« Découpeur » capitalisé vs « développeur »/« relecteur » en minuscules) — réfuté : « Découpeur » est le vocabulaire de rôle déjà établi par le projet (AD-18, `ORGANISATION.md`), pas une incohérence introduite ici ; les autres fichiers s'adressent à des personæ génériques sans casquette nommée équivalente dans ce contexte.
  - `[low]` `patch` (blind-hunter) aucun des 4 prompts ne prévoit de condition d'arrêt si `melos run analyze`/`test` échouent après plusieurs tentatives — corrigé : consigne d'escalade ajoutée, symétrique à la consigne déjà existante pour un brief ambigu.
  - `[low]` `patch` (edge-case-hunter) `SANS-IA.md` n'a pas le même repli de structure de PR minimale que `dev-story.md` pour le cas où `.github/PULL_REQUEST_TEMPLATE.md` n'existe pas encore (confirmé absent sur cette branche) — corrigé : même structure de repli ajoutée.
  - `[low]` `patch` (edge-case-hunter) `SANS-IA.md` n'a pas la consigne explicite « arrête-toi et remonte le signal » si on découvre en cours de route que le travail touche deux zones, contrairement à `dev-story.md`. Corrigé : consigne ajoutée.
  - `[low]` `patch` (edge-case-hunter) `dev-story.md` ne couvre que le cas « je ne sais pas si un système de tokens existe », pas le cas où son absence est confirmée. Corrigé : formulation étendue.
  - `[low]` reject, correctif de texte de spec seul (edge-case-hunter) le Tasks & Acceptance de la spec affirmait que `SANS-IA.md` « reprend le même déroulé que `dev-story.md` » alors que ce dernier ne couvre pas prendre/brancher/fusion (mécaniquement humains, IA ou non) — corrigé directement dans le texte de la spec, le contenu livré était déjà correct.
  - `[low]` `patch` (edge-case-hunter) même défaut que la 10e ligne (repli de structure de PR manquant dans `SANS-IA.md`).
  - `[medium]` `patch` (verification-gap) même défaut que la 4e ligne (règle RPC-only non enseignée aux prompts d'implémentation).
  - `[false]` reject (intent-alignment) la preuve d'auto-revue (« Reading 3 ») semblait absente du diff soumis — réfuté : artefact de ma propre génération de diff (fichier de spec omis du `git add -N`), pas un défaut du livrable ; les Implementation Notes existent bien sur disque.
  - `[false]` reject (intent-alignment) les renvois conditionnels vers des fichiers pas encore fusionnés (Story 2.5/2.6) sont invérifiables tant qu'ils n'existent pas — réfuté : c'est le comportement attendu et déjà anticipé, cohérent avec le même motif dans les stories précédentes.
  - `[low]` `patch` (intent-alignment) l'en-tête de `SANS-IA.md` lui-même affirme reprendre « exactement le même déroulé que `dev-story.md`, en enlevant l'étape de collage » — inexact : `SANS-IA.md` est un sur-ensemble (il couvre aussi prendre/brancher/fusion, absents de `dev-story.md`), pas le même déroulé moins une étape. Corrigé : formulation de l'en-tête ajustée.

## Auto Run Result

**Résumé :** 4 prompts portables autonomes (`prompts/dev-story.md`, `prompts/review.md`, `prompts/decoupe.md`, `prompts/SANS-IA.md`), dérivés d'`ORGANISATION.md` §§ 2, 4, 5, 6, 8 et d'AD-5/AD-12, plus un index dans `prompts/README.md`.

**Fichiers modifiés :**
- `prompts/dev-story.md`, `prompts/review.md`, `prompts/decoupe.md`, `prompts/SANS-IA.md` -- les 4 prompts.
- `prompts/README.md` -- index des 4 fichiers et ordre d'usage typique.
- `docs/stories/spec-2-7-prompts.md` -- spec, Implementation Notes, Review Triage Log, correction de la description « même déroulé » dans Tasks & Acceptance.

**Revue :** 4 lentilles, 18 findings.
- Patchés : 9 entrées (1 `medium` -- règle RPC-only (transitions d'état) non enseignée dans les prompts d'implémentation alors que `review.md` la sanctionne, signalée indépendamment par 2 lentilles ; 8 `low` -- absence d'index dans `prompts/README.md`, couche `data/` omise dans la checklist de tests de `SANS-IA.md`, gabarits de PR/déclaration IA désynchronisés entre `dev-story.md` et `SANS-IA.md`, vérification affaiblie du premier commit « tests seuls » dans `review.md`, tournure incorrecte, absence de condition d'arrêt après échecs répétés des vérifications, absence de consigne d'escalade si le travail touche deux zones dans `SANS-IA.md`, formulation des tokens ne couvrant pas le cas d'absence confirmée, en-tête de `SANS-IA.md` affirmant à tort une parité stricte avec `dev-story.md`). Tous corrigés, revérifiés (relecture croisée + `melos run analyze`).
- Rejetés (`false`, 4) : nom de fichier `SANS-IA.md` (mandaté par l'AC), casse du nom de rôle « Découpeur » (vocabulaire déjà établi par le projet), absence apparente de preuve d'auto-revue dans le diff soumis (artefact de ma propre génération de diff, pas un défaut du livrable), renvois conditionnels invérifiables tant que les stories 2.5/2.6 ne sont pas fusionnées (comportement attendu et déjà anticipé).
- Rejeté car le correctif était un texte de spec seul (`low`, 1) : description erronée de « même déroulé » dans le Tasks & Acceptance -- corrigée directement dans la spec.
- Aucun `intent_gap` ni `bad_spec`.

**Follow-up review recommended :** `false` -- une seule entrée `medium` patchée (sous le seuil de deux), aucune `high`.

**Vérification effectuée :** relecture isolée des 4 fichiers après correctifs (cohérence interne, numérotation des règles, gabarits de repli alignés) et `melos run analyze` (propre, via `fvm`).

**Risques résiduels :** aucun identifié au-delà des renvois conditionnels vers les Stories 2.5/2.6, déjà documentés comme dépendance de séquencement entre PR.

## Verification

**Commands:**
- lecture isolée de chacun des 4 fichiers (comme le ferait un lecteur qui n'a que ce fichier ouvert) -- expected: aucun renvoi non résolu, aucune référence à un outil/fichier BMAD que l'assistant IA ne pourrait pas connaître
- `melos run analyze` -- expected: aucune régression (fichiers Markdown)
