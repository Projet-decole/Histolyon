---
title: 'Templates de story et de PR'
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

**Problem:** Chaque story de ce projet a jusqu'ici été rédigée en réinventant sa structure (comparer les spec `docs/stories/spec-1-*.md` et `spec-2-*.md` : même esprit, jamais un gabarit partagé et versionné), et il n'existe aucun template de PR — rien ne garantit que chaque PR déclare l'assistance IA (AD-14, `docs/conventions/usage-de-lia.md`) ou l'ordre tests-d'abord (AD-14).

**Approach:** Un template de story unique `docs/stories/TEMPLATE.md` (format dev-story BMAD déjà en usage de facto dans ce dépôt : frontmatter + intent-contract + code map + tasks & acceptance + verification, cf. n'importe quel `docs/stories/spec-2-*.md` existant), copié tel quel vers `.github/ISSUE_TEMPLATE/story.md` (avec le frontmatter YAML attendu par GitHub pour qu'il apparaisse dans le sélecteur de template d'issue) ; et un template de PR `docs/PULL_REQUEST_TEMPLATE.md`, copié vers `.github/PULL_REQUEST_TEMPLATE.md`, avec les champs *issue liée*, *tests d'abord (commit)*, *assistance IA*.

## Boundaries & Constraints

**Always:** `docs/stories/TEMPLATE.md` et `.github/ISSUE_TEMPLATE/story.md` sont identiques en substance (même structure, même champs — le frontmatter GitHub `name`/`about`/`title`/`labels` peut différer, c'est une exigence de la plateforme, pas du contenu) ; `docs/PULL_REQUEST_TEMPLATE.md` et `.github/PULL_REQUEST_TEMPLATE.md` sont identiques en substance ; le template de PR porte explicitement les 3 champs cités par l'AC.

**Never:** ne jamais rendre le template de story incompatible avec le format déjà utilisé par les stories existantes (`docs/stories/spec-1-*.md`, `spec-2-*.md`) — c'est une extraction de ce qui existe déjà, pas une nouvelle convention ; ne jamais dupliquer le contenu de `docs/conventions/usage-de-lia.md` (Story 2.5, si déjà mergée sur cette branche) dans le template de PR — renvoyer par lien relatif si le fichier est présent.

</intent-contract>

## Code Map

- `docs/stories/spec-2-5-docs-spine-conventions-guides.md` (ou tout autre `spec-2-*.md`/`spec-1-*.md` existant) -- référence concrète du format dev-story BMAD à extraire en template : frontmatter (`title`, `type`, `created`, `status`, ...), `<intent-contract>` (Intent, Boundaries & Constraints, I/O Matrix optionnelle), `## Code Map`, `## Tasks & Acceptance`, `## Spec Change Log`, `## Review Triage Log`, `## Verification`. `TEMPLATE.md` reprend cette structure avec des placeholders, pas les sections propres à l'exécution (`## Implementation Notes`, `## Auto Run Result` restent des sections que l'agent ajoute lui-même en cours de story, le template peut les omettre ou les laisser vides).
- AD-12 (spine) -- « corps = `docs/stories/TEMPLATE.md` (format dev-story BMAD, aussi template d'issue) qui cite les extraits de conception par ID » -- confirme que `TEMPLATE.md` sert à la fois de gabarit de story et de template d'issue GitHub.
- Format legacy des templates d'issue GitHub (Markdown, pas YAML) : frontmatter `---\nname: ...\nabout: ...\ntitle: ...\nlabels: ...\n---` en tête de `.github/ISSUE_TEMPLATE/*.md` pour apparaître dans le sélecteur « New issue ».
- `docs/conventions/usage-de-lia.md`, `docs/conventions/commits.md` (Story 2.5, si déjà mergée sur cette branche ; sinon absents) -- si présents, le template de PR y renvoie par lien relatif pour le champ *assistance IA* plutôt que de répéter la règle.
- AD-14 (spine) -- « le relecteur ... coche le champ "tests d'abord" de la PR » -- confirme que le champ *tests d'abord (commit)* du template de PR doit permettre de citer/cocher le commit contenant les tests rouges initiaux.

## Tasks & Acceptance

**Execution:**
- `docs/stories/TEMPLATE.md` -- gabarit dev-story BMAD (frontmatter + intent-contract + code map + tasks & acceptance + verification, placeholders explicites, dérivé du format déjà utilisé par les stories existantes) -- cœur de l'AC
- `.github/ISSUE_TEMPLATE/story.md` -- copie de `docs/stories/TEMPLATE.md`, précédée du frontmatter GitHub (`name: Story`, `about: ...`, `title: "[Story] "`, `labels: ...`) -- cœur de l'AC
- `docs/PULL_REQUEST_TEMPLATE.md` -- gabarit de PR avec au minimum les 3 champs : *Issue liée* (`Closes #`), *Tests d'abord (commit)* (référence au commit de tests rouges), *Assistance IA* (outil, ce qui a été généré — renvoi à `docs/conventions/usage-de-lia.md` si présent) -- cœur de l'AC
- `.github/PULL_REQUEST_TEMPLATE.md` -- copie de `docs/PULL_REQUEST_TEMPLATE.md` -- cœur de l'AC
- `docs/stories/spec-2-6-templates-de-story-et-de-pr.md` -- consigner en Implementation Notes la preuve d'identité de substance entre chaque paire docs/.github -- preuve auditable

**Acceptance Criteria:**
- Given `docs/stories/TEMPLATE.md` écrit, when comparé à `.github/ISSUE_TEMPLATE/story.md`, then les deux sont identiques en substance (seul le frontmatter GitHub diffère).
- Given `docs/PULL_REQUEST_TEMPLATE.md` écrit, when comparé à `.github/PULL_REQUEST_TEMPLATE.md`, then les deux sont identiques.
- Given `.github/PULL_REQUEST_TEMPLATE.md`, when son contenu est inspecté, then les champs *issue liée*, *tests d'abord (commit)* et *assistance IA* y figurent explicitement.

## Implementation Notes

- `docs/stories/TEMPLATE.md` créé : gabarit dev-story BMAD extrait de la forme déjà en usage (cf. `docs/stories/spec-1-5-lint-d-imports-et-lints-de-base.md` pour le squelette Code Map/Tasks & Acceptance/Verification, et ce fichier lui-même pour la forme `<intent-contract>` avec Intent/Boundaries & Constraints/I/O Matrix optionnelle et le frontmatter complet). Sections `## Implementation Notes` et `## Auto Run Result` volontairement omises (sections que l'agent ajoute lui-même en cours de story, cf. Code Map de cette spec). `status` du frontmatter placeholder est `'draft'` (pas `'in-progress'`, corrigé après revue — une story tout juste créée depuis le gabarit n'a pas encore démarré).
- **Preuve d'identité de substance — paire story :** `diff docs/stories/TEMPLATE.md .github/ISSUE_TEMPLATE/story.md` produit deux hunks, tous deux localisés en tête de fichier et documentés par construction : (1) insertion du frontmatter GitHub (`name: Story`, `about`, `title: "[Story] "`, `labels: story`) suivi d'une ligne vide et de l'ouverture d'une clôture de code ```` ```yaml ````, (2) une fermeture ```` ``` ```` juste après le frontmatter YAML embarqué. Cette clôture de code (ajoutée après revue) entoure uniquement le frontmatter YAML de `TEMPLATE.md`, recopié sans autre changement : GitHub transforme les `---` nus en filets horizontaux dans le rendu d'une issue, ce qui rendait ce frontmatter illisible et non copiable tel quel une fois l'issue affichée ; la clôture le préserve lisible en YAML brut. Aucune autre différence : le reste du corps (`<intent-contract>` et sections suivantes) est un rendu Markdown normal, non affecté par ce problème, donc non entouré.
- **Preuve d'identité — paire PR :** `diff docs/PULL_REQUEST_TEMPLATE.md .github/PULL_REQUEST_TEMPLATE.md` produit une sortie vide (fichiers strictement identiques, copie conforme).
- `.github/PULL_REQUEST_TEMPLATE.md` porte les 3 champs de l'AC : *Issue liée* (`Closes #`), *Tests d'abord (commit)* (case à cocher + champ pour le sha du commit de tests rouges initial, cf. AD-14 « le relecteur ... coche le champ "tests d'abord" »), *Assistance IA* (case à cocher qui signifie sans ambiguïté « section renseignée » — la déclaration elle-même, IA utilisée ou non, vit dans les champs texte en dessous — outil/ce qui a été généré/ce qui a été relu, avec renvoi en texte visible, hors commentaire HTML, vers `/docs/conventions/usage-de-lia.md`).
- `docs/conventions/usage-de-lia.md` (Story 2.5) est **absent de cette branche** au moment de l'implémentation (`story/2-5-docs-spine-conventions-guides` existe mais n'est pas mergée) : le lien est tout de même posé (il résoudra dès que 2.5 sera mergée sur `main`, cf. Code Map de cette spec qui anticipe explicitement ce cas), et son contenu n'est pas dupliqué dans le template — seul un renvoi en texte visible et un court libellé des champs à remplir. Le renvoi a été déplacé hors d'un commentaire HTML après revue : GitHub supprime les commentaires HTML du rendu final d'une PR, ce qui rendait le renvoi invisible pour tout relecteur lisant la PR déjà ouverte.
- `melos run analyze` a bien été exécutée (via `fvm`, `/home/lunos/fvm/versions/3.47.4/bin` sur le `PATH`) : `dart analyze .` → « No issues found! », `tools/check_import_direction.dart` → « aucune violation. » Aucune régression — cohérent avec le fait que ce changement ne touche que des fichiers Markdown sous `docs/` et `.github/`.
- **Limite de vérification structurelle (AC, 4e clause) :** « créer une issue ou une PR sur GitHub affiche automatiquement le template correspondant » décrit un comportement live de la plateforme GitHub (sélecteur « New issue », pré-remplissage de la description de PR). Ce comportement lit la branche par défaut du dépôt (`main`) pour les templates de PR et d'issue — il ne peut donc être observé qu'une fois cette PR fusionnée, jamais depuis une branche de story. Cette clause n'a donc pas été vérifiée en direct sur GitHub ; la vérification s'arrête à la conformité structurelle des fichiers aux emplacements et formats documentés par GitHub (`.github/ISSUE_TEMPLATE/*.md` avec frontmatter `name`/`about`/`title`/`labels`, `.github/PULL_REQUEST_TEMPLATE.md` à la racine de `.github/`), qui sont les préconditions connues et documentées de ce comportement.

## Spec Change Log

## Review Triage Log

### 2026-09-18 — Review pass
- verdicts: 15 findings — high 0, medium 1, low 7, false 7, maybe-false 0
- findings:
  - `[medium]` `patch` (blind-hunter) le renvoi vers `docs/conventions/usage-de-lia.md` (champ Assistance IA du template de PR) est placé dans un commentaire HTML `<!-- ... -->` — GitHub supprime les commentaires HTML du rendu après soumission de la PR, donc ce renvoi reste invisible à tout relecteur qui lit la PR déjà ouverte (pas seulement pendant l'édition). Corrigé : renvoi déplacé en texte visible (hors commentaire).
  - `[low]` `patch` (blind-hunter) la case à cocher « Assistance IA » mélange deux faits distincts (IA utilisée / section renseignée) dans une seule case, peu clair pour un relecteur pressé. Corrigé : libellé clarifié.
  - `[low]` `patch` (blind-hunter) `docs/stories/TEMPLATE.md` (et sa copie `.github/ISSUE_TEMPLATE/story.md`) préremplit `status: 'in-progress'` alors qu'une story qui n'a pas encore démarré doit être `'draft'` — les autres champs placeholder utilisent des chevrons explicites, celui-ci préremplit silencieusement une valeur fausse au moment de la création. Corrigé : `status: 'draft'`.
  - `[low]` `patch` (blind-hunter) `.github/ISSUE_TEMPLATE/story.md` embarque le frontmatter YAML de `TEMPLATE.md` sans le clôturer dans un bloc de code — le rendu Markdown de GitHub transforme les `---` nus en filets horizontaux, donc ce frontmatter « à copier plus tard » ne se lit plus comme du YAML dans l'issue rendue. Corrigé : bloc englobé dans une clôture de code.
  - `[low]` `defer` (blind-hunter) aucune vérification automatisée ne détecte une désynchronisation future entre chaque paire `docs/`/`.github/`, ni ne force le remplissage des champs Tests d'abord/Assistance IA — même disposition que les stories précédentes (Epic 9, NFR1). Différé.
  - `[false]` reject (blind-hunter) absence de `.github/ISSUE_TEMPLATE/config.yml` — réfuté : hors périmètre de l'AC, qui ne demande que les deux templates nommés.
  - `[low]` `defer` (blind-hunter) même défaut que la 5e ligne, versant absence d'automatisation d'application des champs déclaratifs.
  - `[false]` reject (blind-hunter) absence de README pointant vers `TEMPLATE.md` -- réfuté : hors périmètre de l'AC.
  - `[false]` reject (blind-hunter) absence de lien croisé entre la taxonomie `type` de l'issue et le template de PR -- réfuté : aucun préjudice concret nommé, remarque impressionniste.
  - `[false]` reject (verification-gap) aucun gap de vérification trouvé (contenu statique, hors périmètre de son rubric) ; note complémentaire sur un glob BMAD (`sprint_plan.py`) qui liste `docs/stories/*.md` — vérifié sans conséquence (comparaison de noms exacts, jamais de correspondance possible avec `TEMPLATE.md`) ; note sur `step-01` de `bmad-build-auto` qui charge tout `stories/*.md` pour la continuité inter-story — réfuté comme défaut : `TEMPLATE.md` ne matche aucun motif `story_id-*.md` ni n'a de statut `done`, donc n'est jamais retenu par ce mécanisme de continuité.
  - `[false]` reject (intent-alignment) ambiguïté sur « format dev-story BMAD » (workflow BMAD externe vs convention interne du dépôt) — réfuté : AD-12 nomme explicitement ce format comme celui des `spec-*.md` déjà en usage dans ce dépôt, l'interprétation interne est la seule fondée pour ce projet.
  - `[false]` reject (intent-alignment) traitement asymétrique de « identiques en substance » (octet-pour-octet pour la paire PR, frontmatter GitHub en plus pour la paire story/issue) — réfuté : exigence de plateforme déjà explicitée dans les Boundaries de la spec, pas une incohérence.
  - `[low]` `patch` (intent-alignment) la clause finale de l'AC (« créer une issue ou une PR affiche automatiquement le template ») est un comportement live de GitHub, structurellement invérifiable avant la fusion sur `main` (le sélecteur d'issue et le pré-remplissage de PR lisent la branche par défaut / la branche de base, pas une branche de story) — corrigé : disclosure explicite ajoutée en Implementation Notes plutôt que de laisser croire que cette clause a été vérifiée.
  - `[medium]` `patch` (intent-alignment) même défaut que la 1re ligne (renvoi vers `usage-de-lia.md` invisible après rendu).

## Auto Run Result

**Résumé :** `docs/stories/TEMPLATE.md` (gabarit dev-story BMAD) copié dans `.github/ISSUE_TEMPLATE/story.md` avec frontmatter GitHub ; `docs/PULL_REQUEST_TEMPLATE.md` (champs Issue liée, Tests d'abord, Assistance IA) copié à l'identique dans `.github/PULL_REQUEST_TEMPLATE.md`.

**Fichiers modifiés :**
- `docs/stories/TEMPLATE.md`, `.github/ISSUE_TEMPLATE/story.md` -- gabarit de story + template d'issue GitHub.
- `docs/PULL_REQUEST_TEMPLATE.md`, `.github/PULL_REQUEST_TEMPLATE.md` -- template de PR (identiques).
- `docs/stories/spec-2-6-templates-de-story-et-de-pr.md` -- spec, Implementation Notes, Review Triage Log.

**Revue :** 4 lentilles, 15 findings.
- Patchés : 4 entrées (1 `medium` -- renvoi vers `usage-de-lia.md` invisible après rendu GitHub car placé dans un commentaire HTML, signalé indépendamment par 2 lentilles ; 3 `low` -- libellé de case à cocher ambigu, statut par défaut incorrect (`in-progress` au lieu de `draft`), frontmatter YAML embarqué non clôturé rendu illisible par GitHub). Tous corrigés, revérifiés (`diff` des deux paires, `grep` ciblés, `melos run analyze`).
- Différé (1, `low`, regroupant 2 lignes) : absence d'automatisation (détection de désynchronisation, application des champs déclaratifs) -- Epic 9, NFR1.
- Rejetés (`false`, 7) : absence de `config.yml`, absence de README pointant vers `TEMPLATE.md`, absence de lien croisé type/PR (tous hors périmètre de l'AC ou sans préjudice nommé), aucun gap de vérification (contenu statique) avec vérification que `TEMPLATE.md` n'interfère pas avec les mécanismes BMAD existants, ambiguïté sur « format dev-story BMAD » (tranchée par AD-12), traitement asymétrique de l'identité de substance (exigence de plateforme déjà documentée).
- Un correctif de disclosure sans changement de code (`low`, patch) : la clause finale de l'AC (affichage automatique GitHub) est structurellement invérifiable avant fusion -- documenté explicitement comme limite plutôt que présenté à tort comme vérifié.
- Aucun `intent_gap` ni `bad_spec`.

**Follow-up review recommended :** `false` -- une seule entrée `medium` patchée (sous le seuil de deux), aucune `high`.

**Vérification effectuée :** les commandes de la section `## Verification` rejouées après correctifs (`diff` des deux paires, `melos run analyze` propre) ; voir aussi la limite de vérification structurelle documentée en Implementation Notes pour la clause GitHub live.

**Risques résiduels :** le lien vers `docs/conventions/usage-de-lia.md` reste rompu tant que la PR de la Story 2.5 (#55) n'est pas fusionnée -- dépendance de séquencement entre PR, pas un défaut de cette story.

## Verification

**Commands:**
- `diff docs/stories/TEMPLATE.md .github/ISSUE_TEMPLATE/story.md` -- expected: aucune différence hors (1) le bloc frontmatter GitHub en tête de fichier et (2) la clôture de code (fence yaml) entourant le frontmatter YAML embarqué
- `diff docs/PULL_REQUEST_TEMPLATE.md .github/PULL_REQUEST_TEMPLATE.md` -- expected: sortie vide
- lecture de `.github/PULL_REQUEST_TEMPLATE.md` -- expected: les 3 champs de l'AC sont présents et libellés clairement
- `melos run analyze` -- expected: aucune régression
