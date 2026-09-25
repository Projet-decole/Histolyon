# HistoLyon

Application mobile qui fait explorer Lyon à travers les époques : une carte avec un slider d'époques, des pins historiques sourcés, des parcours et des reconstitutions 3D/AR. Le code est en Flutter (Android, avec du code partagé prêt pour iOS), le backend est sur Supabase et le contenu éditorial est en YAML.

## Démarrer (une fois)

**Le plus simple : le devcontainer.** Ouvre le dépôt dans VS Code avec l'extension *Dev Containers*, ou dans GitHub Codespaces : tout est préinstallé.

**En natif**, il faut Flutter 3.47.4 (via [fvm](https://fvm.app/), voir `.fvmrc`), Docker, [Supabase CLI](https://supabase.com/docs/guides/cli) 2.117, Android SDK et JDK 21, et [lefthook](https://lefthook.dev). Ensuite :

```bash
git clone <url-du-depot> && cd Histolyon
flutter pub get && lefthook install
supabase start && supabase db reset          # base locale avec le schéma complet
eval "$(supabase status -o env | sed -n 's/^API_URL=/export SUPABASE_URL=/p; s/^SERVICE_ROLE_KEY=/export SUPABASE_SERVICE_ROLE_KEY=/p')"
dart run tools/seed.dart                     # charge époques, catégories, pins
dart run tools/publier_local.dart            # publie tout en local pour que l'app le voie
melos run test                               # tout doit être vert
cd apps/mobile && flutter run --dart-define-from-file=../../env/local.json
```

Si quelque chose casse, ouvre une issue avec le message d'erreur. C'est déjà une contribution utile.

## Travailler (à chaque session)

1. **Choisis une issue** [avec le label `prête`](../../issues?q=is%3Aopen+label%3Apr%C3%AAte+no%3Aassignee) qui n'est assignée à personne, puis **assigne-la-toi**. Chaque issue est faite pour tenir en une demi-journée.
2. **Ouvre ton agent IA dans le dépôt** (Claude Code, Cursor, Copilot…) et dis-lui : **« Implémente l'issue #N »**. Il charge `AGENTS.md` tout seul, et ce fichier lui explique quoi lire, où coder et comment vérifier. Si ton outil n'a pas accès au dépôt, colle-lui le contenu de [`prompts/implementer-une-issue.md`](prompts/implementer-une-issue.md).
3. **Relis ce qu'il a fait et lance l'app** pour vérifier le résultat. Tu restes responsable du code.
4. **Ouvre la PR.** Un autre membre la relit (il peut s'aider de [`prompts/relire-une-pr.md`](prompts/relire-une-pr.md)), puis on fait un squash merge.

Tu bloques ou l'issue n'est pas claire ? Écris un commentaire sur l'issue. Ne devine pas.

**Pour créer une nouvelle issue**, utilise le template « Tâche » de GitHub ou le prompt [`prompts/ecrire-une-issue.md`](prompts/ecrire-une-issue.md).

## Où est quoi

| Besoin | Où |
| --- | --- |
| Règles du code, structure du dépôt, commandes | [`AGENTS.md`](AGENTS.md), plus le `AGENTS.md` de chaque zone (`apps/mobile`, `apps/admin`, `supabase`) |
| Recettes pas à pas | [`docs/guides/`](docs/guides/) |
| Ce que fait le produit (fonctionnalités, données, écrans) | `conception/`, lu par ID : `dart run tools/ctx.dart D1.2` |
| La maquette Figma | [`conception/15-maquette.md`](conception/15-maquette.md) |
| Pourquoi on a fait ces choix | [`docs/DECISIONS.md`](docs/DECISIONS.md) (journal), [`docs/ARCHITECTURE-SPINE.md`](docs/ARCHITECTURE-SPINE.md) (les règles AD-n) |
| Pourquoi on travaille comme ça (pour le jury) | [`docs/ORGANISATION.md`](docs/ORGANISATION.md) |
| État d'avancement pour un compte rendu | `dart run tools/report.dart` → `docs/sprint/reports/<date>.md` |

## Licences et données

Chaque source a sa licence, documentée dans `content/sources/` et dans la colonne `licence` des médias. Le fond de carte OpenStreetMap (ODbL) et Protomaps impose une attribution visible en permanence. Aucun secret, aucune clé et aucun média n'est versionné dans ce dépôt.
