# Epic 1 Context: Dépôt et workspace

<!-- Compiled from planning artifacts. Edit freely. Regenerate with compile-epic-context if planning docs change. -->

## Goal

Epic 1 met en place le socle technique sur lequel toute story ultérieure du projet s'appuie : un dépôt GitHub avec `main` protégée dès le premier push, un workspace Pub racine (melos comme lanceur de scripts), l'arbre de dossiers complet de la spine d'architecture, les deux apps Flutter (`apps/mobile` pour Android, `apps/admin` pour le web) et un lint d'imports qui fait échouer la CI dès qu'une dépendance viole la direction imposée entre couches. Rien de fonctionnel n'est livré ici — l'épic est un starter template : sans lui, aucune autre story (documentation, schéma, contenu, app, carte, CI, environnements, suivi) ne peut démarrer.

## Stories

- Story 1.1: Initialiser le dépôt et protéger `main`
- Story 1.2: Workspace Pub et scripts melos
- Story 1.3: Arbre de dossiers de la spine
- Story 1.4: Apps Flutter du workspace
- Story 1.5: Lint d'imports et lints de base

## Requirements & Constraints

- Critère de réussite global de l'épic : `melos run analyze` et `melos run test` passent sur les squelettes vides, et un push direct sur `main` reste refusé.
- Un push direct sur `main` doit être refusé par GitHub dès le tout premier commit (avant même que du code existe).
- L'ordre des stories est imposé et séquentiel (chaque story dépend de l'état laissé par la précédente) ; ne pas paralléliser leur implémentation.
- Aucun `melos.yaml` : la configuration melos vit uniquement dans la section `melos:` du `pubspec.yaml` racine (melos 7+ a supprimé ce fichier). Version imposée : melos 8.7 en dev dependency.
- Chaque dossier encore vide de l'arbre de la spine doit contenir un `README.md` d'une ligne décrivant ce qui y vivra.
- Versions figées à vérifier : `flutter_lints` 6, `riverpod_lint`. Toute autre techno/version passe par amendement d'architecture.
- Cible Android uniquement pour `apps/mobile` ; `apps/admin` cible le web. Pas d'iOS (pas de Mac/licence Apple — hors périmètre pour l'instant).
- Pour cet épic (pas de code testable), la règle « tests d'abord » est satisfaite par la vérification du critère « Fini quand »/les checks CI, pas par un commit de tests rouges.
- Le process complet s'applique dès la Story 1.1 : issue labellisée `socle` → branche `story/socle-01-<slug>` → PR → squash merge, mais l'approbation obligatoire de PR n'est activée qu'après la relecture groupée de fin de socle (les PR de cet épic peuvent fusionner sans relecture préalable pendant cette période).
- Prérequis hors dépôt à avoir avant de commencer : org GitHub, Flutter 3.47.4, Docker, Supabase CLI 2.117, lefthook 2.1, Android SDK.

## Technical Decisions

- Un seul langage applicatif : Dart/Flutter pour mobile et admin. `apps/mobile` (Android) et `apps/admin` (Flutter Web, renderer CanvasKit, appelle `SemanticsBinding.ensureSemantics()` au démarrage) sont deux apps du même workspace Pub. Tout code partagé vit dans `packages/`. Aucune app non-Dart n'entre dans le dépôt sans amendement.
- Direction des dépendances stricte dans une feature : `presentation → domain → data`, sans inversion. Une feature n'importe jamais une autre feature ; le partagé descend dans `core/` (niveau app) ou `packages/` (niveau workspace) ; `core/` et `packages/` n'importent jamais une feature. `app/` est l'unique composition root (assemble le routeur à partir des `GoRoute` exportées par chaque feature, fait le bootstrap et le `ProviderScope`). Cette règle est vérifiée par un lint d'imports en CI (Story 1.5), pas seulement documentée.
- Trunk-based development : `main` protégée, toute modification passe par PR liée à une issue, fusion seulement si CI verte sur une branche à jour avec `main`, squash merge uniquement, itération de deux semaines.
- Arbre de dossiers imposé par la spine (à créer tel quel en Story 1.3) : `apps/`, `packages/`, `supabase/`, `content/`, `conception/`, `docs/`, `prompts/`, `tools/`, `env/`, `.github/`.

## Cross-Story Dependencies

- Strictement séquentiel en interne : 1.1 (dépôt + protection `main`) → 1.2 (workspace Pub + melos) → 1.3 (arbre de dossiers) → 1.4 (apps Flutter) → 1.5 (lints + lint d'imports). Chaque story part explicitement de l'état livré par la précédente.
- Epic 1 est un prérequis dur pour tous les épics suivants (2 à 11) : documentation, migration Supabase, génération de types, contenu/seed, squelette app, tuiles/carte, CI, environnements et suivi s'appuient tous sur le dépôt, le workspace et l'arbre de dossiers posés ici.
