# HistoLyon

Application mobile qui fait explorer Lyon à travers les époques : une carte avec un slider d'époques, des pins historiques sourcés, des parcours et des reconstitutions 3D/AR. Le code est en Flutter (Android, avec du code partagé prêt pour iOS), le backend est sur Supabase et le contenu éditorial est en YAML.

## Démarrer

**Seuls Docker et VS Code sont à installer**, quel que soit ton système (Windows, Mac ou Linux). Tout le reste (Flutter, Supabase, Android SDK, aux bonnes versions) est dans le devcontainer.

1. Installe [Docker Desktop](https://www.docker.com/products/docker-desktop/) (sous Linux, Docker Engine suffit), [VS Code](https://code.visualstudio.com/) et son extension **Dev Containers**.
   Dans Docker Desktop → *Settings → Resources*, donne **au moins 8 Go de mémoire** à Docker (Supabase + Flutter en ont besoin ; avec 4 Go, les tests se bloquent). Sous Windows (WSL 2), c'est la moitié de la RAM par défaut, ce qui suffit à partir de 16 Go.
2. Clone le dépôt et ouvre-le dans VS Code. Clique sur **« Reopen in Container »** : la première fois, le conteneur se construit en 10 à 15 minutes.
3. Dans le terminal de VS Code (qui est dans le conteneur) :

```bash
melos run local     # base Supabase locale : schéma, contenu, pins publiés (5-10 min la 1re fois)
melos run app       # l'app s'ouvre dans ton navigateur sur http://localhost:8080
```

C'est tout. À chaque séance suivante, `melos run local` puis `melos run app`. Dans le terminal de `melos run app`, `r` recharge l'app après une modification.

**Tester sur ton téléphone Android** (utile pour la 3D, l'AR, le GPS) : active le *débogage sans fil* du téléphone (Options pour les développeurs), puis, depuis le terminal du conteneur, `adb pair <ip:port>` et `adb connect <ip:port>` (les deux adresses sont affichées par le téléphone). Lance ensuite `cd apps/mobile && flutter run --dart-define-from-file=../../env/local.json`. Le téléphone et l'ordinateur doivent être sur le même Wi-Fi.

<details><summary>Sans devcontainer (installation native, déconseillée)</summary>

Il faut installer toi-même Flutter 3.47.4 (via [fvm](https://fvm.app/), voir `.fvmrc`), Docker, [Supabase CLI](https://supabase.com/docs/guides/cli) 2.117, JDK 21, l'Android SDK (ou Android Studio pour l'émulateur) et [lefthook](https://lefthook.dev), puis faire `flutter pub get && lefthook install` et les deux commandes ci-dessus.
</details>

Si quelque chose casse, écris un commentaire dans #86 avec le message d'erreur. C'est déjà une contribution utile.

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

Chaque média a sa licence et son crédit (`content/medias.yaml`, colonne `licence` en base) ; chaque source cite son auteur et, pour un texte réutilisé, sa licence (`content/sources/`). Le fond de carte OpenStreetMap (ODbL) et Protomaps impose une attribution visible en permanence. Aucun secret, aucune clé et aucun média n'est versionné dans ce dépôt.
