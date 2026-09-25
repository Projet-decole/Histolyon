---
id: SPEC-histolyon-socle
companions:
  - ../../architecture/architecture-HistoLyon-2026-09-17/BOOTSTRAP.md
  - ../../architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md
  - ../../architecture/architecture-HistoLyon-2026-09-17/ORGANISATION.md
sources: []
---

> **Canonical contract.** This SPEC and the files in `companions:` are the complete, preservation-validated contract for what to build, test, and validate. Source documents listed in frontmatter are for traceability — consult them only if you need narrative rationale or prose color this contract intentionally omits.

# Socle de développement HistoLyon

Rôle des companions : `BOOTSTRAP.md` = le *comment* de chaque étape (liste d'actions, § cités ci-dessous) ; `ARCHITECTURE-SPINE.md` = les règles `AD-n`, les conventions, la stack figée et l'arbre du dépôt ; `ORGANISATION.md` = le process (story, casquettes, rythme) que les templates, prompts et `ROLES.md` doivent incarner.

## Why

Mandat et vision. Projet de fin d'études Epitech (T-ESP-800) : le jury note la gestion de projet — état des lieux calculé, indicateurs mesurables, ajustement documenté — pas le produit. L'équipe (~7 personnes, ½ journée / 2 semaines chacune, jamais ensemble, aucune expérience Flutter ni carto, IDE et IA hétérogènes, budget zéro) doit pouvoir travailler en parallèle sans se croiser. Le dépôt `Projet-decole/Histolyon` est vierge (0 commit) ; la conception (`conception/`, 15 paliers) et l'architecture (spine, 20 AD) sont finales. Le socle est ce qui manque entre les deux : l'état où **n'importe quel membre prend une story et la livre en suivant le process, sans poser de question au porteur**. Le bootstrap est la première itération, faite avec le process qu'il installe.

## Capabilities

Mapping stable `CAP-n` ↔ étape `socle-NN` de `BOOTSTRAP.md`. Chaque étape est un **épic** du domaine `socle`, à découper en stories d'une seule zone (AD-12) ; le *success* de la capability est le « Fini quand » de l'épic, sa DoD.

- **CAP-1** — Dépôt et workspace (`socle-01`, BOOTSTRAP § 1)
  - **intent:** Un dépôt GitHub `main`-protégé porte un workspace Pub (`apps/mobile`, `apps/admin`, `packages/*`), melos comme lanceur, l'arbre de dossiers de la spine et le lint d'imports d'AD-5.
  - **success:** `melos run analyze` et `melos run test` passent sur les squelettes vides ; un push direct sur `main` est refusé.

- **CAP-2** — Documentation avant le code (`socle-02`, BOOTSTRAP § 2)
  - **intent:** Un arrivant ou un agent reçoit exactement le contexte de sa tâche : `conception/` importée et adressable par ID (`tools/ctx`, `INDEX.md` généré), `AGENTS.md` unique généré vers les fichiers d'instructions des IDE (`tools/sync-agents`), `docs/` (spine, conventions, guides), templates de story et de PR, `prompts/`.
  - **success:** Un arrivant lit `AGENTS.md`, lance `tools/ctx D1.2`, obtient l'extrait YAML et sait dans quel dossier va une feature ; `tools/sync-agents` régénéré ne produit aucun diff.

- **CAP-3** — Supabase local et migration socle (`socle-03`, BOOTSTRAP § 3)
  - **intent:** Le schéma minimal du cluster C1 (enums, `membre_equipe`, `epoque`, `categorie`, `pin`, `source_documentaire`, `trace_validation`), ses RLS, ses RPC de transition `pin_*` avec Trace et ses tests pgTAP existent en une migration `0001_socle.sql` rejouable.
  - **success:** `supabase db reset` puis `supabase test db` passent depuis une base vide ; chaque invariant déjà porté (I1, I4, I7, I8, I9) et chaque RPC a son fichier pgTAP vert ; une migration à horodatage antérieur au dernier de `main` est refusée par le check.

- **CAP-4** — Génération de types (`socle-04`, BOOTSTRAP § 4)
  - **intent:** Les types Dart (`packages/api_types`) et les JSON Schema (`content/schema/`) sont produits par `tools/gen-types` depuis le schéma local, jamais écrits à la main.
  - **success:** `packages/api_types` compile ; un `select` typé sur `pin` réussit dans un test contre Supabase local ; le spike `geography` nullable + enum nullable est conclu et noté ; régénérer sans migration ne produit aucun diff.

- **CAP-5** — Contenu en fichiers et seed (`socle-05`, BOOTSTRAP § 5)
  - **intent:** Les 10 époques, les catégories et un pin réel (sourcé, avec audio) vivent en YAML validés contre `content/schema/` ; `tools/media push` téléverse les binaires depuis le dossier partagé sous budget ; `tools/seed` les charge en base par `slug`, branché sur `db reset`.
  - **success:** Après `supabase db reset`, un pin réel sourcé avec son audio existe en base locale ; deux exécutions du seed donnent le même état ; un média hors format ou hors taille est refusé.

- **CAP-6** — Squelette de l'app mobile (`socle-06`, BOOTSTRAP § 6)
  - **intent:** L'app Android démarre sur la composition root d'AD-5, avec `core/` (router, session AD-20, models, log, db Drift, profile) et les packages `design_tokens` (tokens Figma verbatim) et `ui_kit` (`FIGMA-MAP.md`, `comp-*` de la carte).
  - **success:** L'app démarre sur un écran vide ; le Profil local existe en base Drift au premier lancement ; `tools/check-tokens` passe contre l'export Figma.

- **CAP-7** — Tuiles et styles (`socle-07`, BOOTSTRAP § 6)
  - **intent:** Un seul `lyon.pmtiles` (schéma Protomaps, emprise de l'agglomération) est extrait par `tools/tiles` et hébergé dans le bucket `tiles` ; un premier style de fond (« aujourd'hui ») existe dans `packages/map_styles` avec attribution OSM/Protomaps.
  - **success:** `lyon.pmtiles` est dans le bucket `tiles`, sa taille est notée dans le memlog de la spine, le style se charge dans un viewer MapLibre.

- **CAP-8** — Feature `carte`, tranche verticale (`socle-08`, BOOTSTRAP § 6)
  - **intent:** L'utilisateur voit sur la carte de Lyon les pins `publie` autour de l'emprise visible, hors de tout parcours, via `features/carte/{data,domain,presentation}` sur MapLibre (`pmtiles://`), couche `pins` ré-ajoutée après `setStyle`.
  - **success:** L'APK affiche la carte de Lyon avec le pin seedé sur un téléphone Android ; test unitaire du domaine, test de widget avec repository factice et test `data` contre Supabase local sont verts et ont été committés avant l'implémentation.

- **CAP-9** — Hooks et CI (`socle-09`, BOOTSTRAP § 7)
  - **intent:** Les garanties d'AD-13/14/16 sont automatiques : lefthook (pre-commit format + analyze + validation `content/`, pre-push tests du package touché), workflows filtrés par chemin (`ci-mobile`, `ci-admin`, `ci-supabase`, `ci-content`, `ci-docs` « diff = échec »), cliquet de couverture, branche à jour requise, `nightly-e2e`.
  - **success:** Une PR de test passe toute la chaîne ; un push avec un test rouge est bloqué par lefthook ; une PR dont la branche n'est pas à jour avec `main` ne peut pas fusionner.

- **CAP-10** — Environnements `dev`, `demo`, enveloppe (`socle-10`, BOOTSTRAP § 7)
  - **intent:** `main` déploie `dev` (migrations + seed + médias, APK debug en artefact) ; un tag `demo-*` déploie `demo` après approbation manuelle avec APK signé ; keep-alive et export hebdomadaires tiennent l'enveloppe Supabase Free (AD-19).
  - **success:** `dev` contient le pin seedé ; l'APK d'artefact affiche la carte depuis `dev` ; le premier export hebdo a produit un artefact conservé.

- **CAP-11** — Suivi et organisation (`socle-11`, BOOTSTRAP § 8)
  - **intent:** L'avancement se lit depuis GitHub : labels de domaine, Projects « HistoLyon » (vues *par domaine*, *en vol*), `tools/report` v0 (indicateurs AD-17), `docs/team/ROLES.md` et `retros/`, `sprint-status.yaml` initialisé, issue « rétro du bootstrap » ouverte.
  - **success:** `tools/report` produit `docs/sprint/reports/<date>.md` listant les stories `socle` fermées, par domaine, avec délai médian story → fusion et taux de CI verte.

## Constraints

- Ordre imposé `socle-01 → 11` (chemin de BOOTSTRAP) ; les checks CI cités en 02–05 sont câblés en 09 et s'exécutent en local d'ici là.
- Chaque story du socle est livrée avec le process qu'elle installe : issue label `socle` → branche `story/socle-NN-<slug>` → PR → squash ; `main` protégé (PR, CI, branche à jour, squash) dès le premier push (AD-12, AD-13).
- Relecture différée : pendant le socle, les PR fusionnent sans relecture préalable ; un coéquipier relit toutes les PR `socle` en une fois à la fin, ses constats deviennent des issues `socle` ; l'approbation obligatoire n'est activée qu'après, avant la première session.
- Sorties BMAD dans `docs/` : `docs/specs/` (specs), `docs/` (épics, `docs/architecture/` pour le run d'architecture), `docs/stories/` (stories, `sprint-status.yaml`) — config `_bmad/config.toml`.
- Stack et versions figées par la spine (vérifiées 2026-09-17) ; toute autre techno ou version passe par amendement ; Android seulement ; Supabase Free = `dev` + `demo`, budgets Storage AD-19 ; zéro euro.
- Tests d'abord (AD-14) : le premier commit d'une branche `socle` contient ses tests rouges dès qu'il y a du code testable ; politique par couche ; couverture publiée à cliquet.
- Une migration par PR, horodatage postérieur au dernier de `main` (AD-16) ; migration et UI = deux stories ; le spike supadart (CAP-4) précède toute génération réelle, le repli OpenAPI est noté au memlog de la spine.
- Jamais dans Git : médias, secrets, `env/demo.json` ; `conception/` importée telle quelle, jamais éditée, adressée par ID ; `api_types`, `content/schema/`, `INDEX.md`, `CLAUDE.md`/`.cursor`/`copilot-instructions` générés, jamais édités (AD-3, AD-7, AD-15).
- Les prérequis hors dépôt (BOOTSTRAP § 0 : org GitHub, org Supabase, dossier médias partagé, Flutter 3.47.4 / Docker / Supabase CLI 2.117 / lefthook 2.1 / Android SDK, accès Figma) précèdent `socle-01`. Sur le poste du porteur au 2026-09-17, seul `uv` est installé.

## Non-goals

- Aucune feature D1–D11 au-delà de la tranche `carte` de CAP-8 : ni slider d'époques (première story D1 après le socle), ni parcours, ni auth/Compte, ni écrans admin au-delà de `flutter create`.
- Ni iOS, ni choix du moteur 3D (spike laissé aux spécialistes à la première session), ni page web publique, ni Edge Functions, ni plan payant (Deferred de la spine).
- Ni golden tests, ni analytics, ni thème sombre.
- Un seul pin de contenu ; le deuxième arrive à la première session.
- `ROLES.md` reste sans noms jusqu'à la première session ; la découpe des épics D1/D2 se fait en séance, pas dans le socle.

## Success signal

La définition « bootstrap terminé » de BOOTSTRAP § 10 : un arrivant clone, lit `AGENTS.md`, lance `supabase start` + `melos run test` et tout est vert ; une story prise dans Projects se livre en suivant le template sans question au porteur ; `main` ne déploie que `dev`, `demo` se tague à la main ; le pin seedé s'affiche sur la carte d'un APK construit par la CI ; `tools/report` produit l'état des lieux du bootstrap ; chaque casquette a deux noms dans `ROLES.md` ou est explicitement vacante ; la rétro du bootstrap est écrite ; la relecture groupée des PR `socle` est faite et l'approbation obligatoire activée sur `main`. ROLES.md et la rétro sont produits par la première session d'équipe (BOOTSTRAP § 9).

## Assumptions

- `ORGANISATION.md` est copié dans `docs/ORGANISATION.md` en CAP-2, à côté de la spine : BOOTSTRAP § 0 et § 9 le présupposent dans le dépôt, l'arbre de la spine ne le place pas.
- Pour les étapes sans code testable (CAP-1, 2, 9, 10, 11), « tests d'abord » est satisfait par le check CI/hook correspondant ou par la vérification du « Fini quand » ; aucun commit de tests rouges n'est attendu.
- Le dépôt cible est le répertoire courant (remote `Projet-decole/Histolyon`, 0 commit) ; `_bmad/` et `docs/` (specs, architecture) y sont committés.
