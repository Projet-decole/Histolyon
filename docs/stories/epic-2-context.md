# Epic 2 Context: Documentation avant le code

<!-- Generated from planning artifacts. Regenerate with compile-epic-context if planning docs change. -->

## Goal

Epic 2 met en place la documentation avant tout code applicatif : `conception/` importée telle quelle et adressable par ID, un `AGENTS.md` unique qui génère les fichiers d'instructions de chaque IDE, `docs/` (copie de la spine, conventions, guides), des templates de story et de PR, et des prompts portables. L'objectif est qu'un arrivant — humain ou agent — reçoive exactement le contexte de sa tâche sans jamais charger `conception/` en entier ni maintenir des instructions dupliquées entre IDE. C'est un épic de documentation pur (aucun code applicatif livré), mais un prérequis dur pour que toute story ultérieure dispose d'un contexte fiable.

## Stories

- Story 2.1: Importer `conception/` telle quelle
- Story 2.2: `tools/ctx` et `conception/INDEX.md`
- Story 2.3: `AGENTS.md` racine et locaux
- Story 2.4: `tools/sync-agents`
- Story 2.5: `docs/` — spine, conventions, guides
- Story 2.6: Templates de story et de PR
- Story 2.7: `prompts/`

## Requirements & Constraints

- Critère de réussite global de l'épic : un arrivant lit `AGENTS.md`, lance `tools/ctx D1.2`, obtient l'extrait YAML correspondant et comprend dans quel dossier va une feature ; relancer `tools/sync-agents` ne produit aucun diff.
- `conception/` doit être importée à l'identique depuis l'ancien dépôt, jamais éditée ensuite, et toujours adressée par ID — jamais chargée en entier (ni par un humain, ni par un agent).
- `AGENTS.md` racine et les `AGENTS.md` locaux (`apps/mobile`, `supabase`) doivent chacun rester sous 150 lignes et ne pas dupliquer le contenu des deux autres.
- `CLAUDE.md`, `.cursor/rules/histolyon.mdc` et `.github/copilot-instructions.md` sont toujours générés depuis `AGENTS.md` par `tools/sync-agents`, jamais édités à la main ; un diff après régénération doit faire échouer la CI (câblage effectif en Epic 9, `ci-docs`).
- `docs/conventions/` doit compter un fichier par ligne de la table *Consistency Conventions* de la spine (langue des identifiants, identifiants de données, dates & géo, statut & provenance, polymorphisme, erreurs, état).
- `docs/guides/` doit couvrir au minimum trois recettes actionnables : ajouter une feature, écrire une migration, écrire un test de widget.
- Le template de story suit le format dev-story BMAD, en français, et doit être dupliqué dans `.github/ISSUE_TEMPLATE/story.md` ; le template de PR doit porter les champs *issue liée*, *tests d'abord (commit)*, *assistance IA*.
- `prompts/` doit contenir `dev-story.md`, `review.md`, `decoupe.md` et une checklist `SANS-IA.md` permettant de dérouler une story sans aucun outil IA.
- `docs/ORGANISATION.md` (copie du guide de process) est présupposé committé aux côtés de la spine dans cet épic, bien que l'arbre de dossiers de BOOTSTRAP ne le liste pas explicitement — les étapes d'onboarding ultérieures s'appuient dessus.
- Comme pour l'Epic 1, aucun code testable n'existe ici : la règle « tests d'abord » est satisfaite par la vérification du critère « Fini quand », pas par un commit de tests rouges.

## Technical Decisions

- Architecture documentaire à quatre niveaux : L0 `AGENTS.md` (racine + `apps/mobile` + `supabase`), source unique d'instructions qui génère les fichiers propres à chaque IDE ; L1 `docs/` (copie de la spine, conventions, guides — un sujet par fichier) ; L2 `conception/`, importée telle quelle, jamais lue entière, adressée par ID via `conception/INDEX.md` généré et `tools/ctx <ID>` ; L3 la story elle-même, qui liste précisément les fichiers L1/L2 à lire.
- Cette architecture documentaire est un prérequis transverse : chaque épic suivant s'appuie sur `AGENTS.md` et l'adressage par ID de `conception/` pour fournir son propre contexte de story, sans redéfinir de mécanisme équivalent.

## Cross-Story Dependencies

- Story 2.1 (import de `conception/`) précède Story 2.2 (`tools/ctx` et `INDEX.md`, qui adressent ce contenu).
- Story 2.3 (`AGENTS.md`) précède Story 2.4 (`tools/sync-agents`, qui génère depuis `AGENTS.md`).
- Toutes les stories de cet épic s'appuient sur l'arbre de dossiers posé en Epic 1.
- Epic 2 est un prérequis dur pour l'exploitation efficace des épics suivants : chaque story ultérieure suppose que son exécutant (humain ou agent) lit `AGENTS.md` et utilise `tools/ctx` pour le contexte de `conception/`.
- L'application CI de AD-15 (« diff = échec » sur `sync-agents`/`gen-types`/`check-tokens`) est câblée en Epic 9 (`ci-docs`), pas dans cet épic.
