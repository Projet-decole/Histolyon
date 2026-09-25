# Config & secrets

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Config & secrets ». AD liée : AD-16 (« Secrets et URLs dans les GitHub Environments et `--dart-define-from-file`, jamais dans le dépôt ; clés nommées `sb_publishable_*` / `sb_secret_*` ») et AD-2 (« la clé secrète ne vit qu'en CI et dans `tools/` »).

## Convention

- Toute config d'environnement passe par `--dart-define-from-file=env/<env>.json` — jamais de constante d'URL ou de clé écrite en dur dans le code Dart.
- `env/demo.json` (et tout fichier contenant un secret réel) reste **hors dépôt** ; seuls `env/local.json` et `env/dev.json` (valeurs non sensibles ou de dev local) sont committés.
- Les clés Supabase sont nommées `sb_publishable_*` (embarquée dans les apps) et `sb_secret_*` (jamais dans une app, uniquement CI/`tools/`).

## Pourquoi

AD-16 place les secrets dans les GitHub Environments précisément pour que ni `demo` ni `dev` n'exposent leurs clés dans l'historique Git ; AD-2 renforce que la clé secrète Supabase ne doit jamais atteindre un client (mobile ou admin), seulement la CI et les outils serveur (`tools/`). `--dart-define-from-file` permet de changer d'environnement (local/dev/demo) sans recompiler de constantes en dur ni risquer qu'un `git blame` révèle une ancienne clé.

## Exemple

`flutter run --dart-define-from-file=env/local.json` pour le développement local ; en CI, le job de build démo utilise un fichier `env/demo.json` généré à la volée depuis les secrets du GitHub Environment `demo`, jamais committé.
