---
title: 'Arbre de dossiers de la spine'
type: 'chore'
created: '2026-09-18'
status: 'done'
route: 'oneshot'
review_loop_iteration: 0
context:
  - '{project-root}/docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Seuls `docs/` et `conception/` existent dans le dépôt (Story 1.1) ; le workspace Pub n'a pas encore d'arbre de dossiers (Story 1.2 ne crée que `pubspec.yaml`). Rien n'indique où va chaque type de fichier avant que du code n'y arrive (Stories 1.4+, Epics 2-11).

**Approach:** Créer les dossiers racine de l'arbre de la spine encore absents — `apps/`, `packages/`, `supabase/`, `prompts/`, `tools/`, `env/` — chacun avec un `README.md` d'une ligne décrivant ce qui y vivra (seul moyen de versionner un dossier vide avec Git). `conception/` et `docs/` existent déjà (non vides, pas de README à ajouter). Ne pas créer les sous-arbres internes de `apps/mobile`/`apps/admin` (généré par `flutter create` en Story 1.4) ni de sous-dossiers propres à des epics ultérieurs (`supabase/migrations/`, `content/schema/`, `packages/design_tokens/`, etc.) — chaque epic crée son propre sous-dossier avec son premier fichier réel, évitant le anti-pattern déjà rencontré en Story 1.1 (dossier pré-créé par une story qui rend caduque l'AC d'une story suivante). `.github/` n'est pas créé maintenant : GitHub traite `.github/README.md` comme README affiché du dépôt en l'absence de README racine, ce qui produirait un README trompeur d'une ligne — laissé à la Story 2.6/9.1 qui y ajoutera du contenu réel (template de PR, workflows) directement.

`content/` **est** créé (listé explicitement dans l'AC de Story 1.3, contrairement aux sous-dossiers d'`apps/`/`supabase/` dont la présence est implicite via `packages/`/`supabase/`) : dossier racine avec `README.md`, sans sous-dossiers (`content/schema/`, `content/pins/`, etc. restent aux Epics 4-5 qui les peupleront directement).

</frozen-after-approval>

## Implementation Notes

- Dossiers créés avec `README.md` d'une ligne : `apps/`, `packages/`, `supabase/`, `prompts/`, `tools/`, `env/`, `content/`. `conception/` et `docs/` existent déjà (non vides), aucun README ajouté. `.github/` volontairement non créé (voir Intent — collision avec le README affiché de GitHub).
- AC vérifiée : chaque dossier listé par la Story 1.3 (sauf `.github/`, exception documentée et `conception/`/`docs/` déjà peuplés) contient exactement un `README.md` décrivant son contenu futur ; aucun sous-dossier prématuré créé.

## Review Triage Log

- `low`, patché — `content/README.md` promettait `parcours`/`modèles 3D` alors qu'aucune story du socle ne les peuple (Epic 5 ne crée que `epoques`/`categories`/`pins`) — corrigé.
- `low`, patché — `supabase/README.md` disait « peuplé à partir de l'Epic 3 » alors que Story 2.3 (Epic 2) écrit `supabase/AGENTS.md` avant — corrigé.
- `low`, patché — `tools/README.md` seul à écrire « epics » en minuscule (incohérence de style avec les 6 autres README) — corrigé.
- `low`, patché — absence de `.github/` non tracée pour les stories 2.6/9.1 qui devront le créer elles-mêmes — action item `github-dir-not-created-story-1-3` ajouté à `sprint-status.yaml`.
- `low`, différé — bloc gelé (Intent) internement incohérent : sa première liste de dossiers omet `content/`, présent seulement dans une phrase séparée — non corrigible ici (texte gelé) ; entrée ajoutée à `deferred-work.md` pour une éventuelle renégociation humaine.
