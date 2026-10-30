# Scripts d'outillage

Petits programmes Dart du projet, lancés depuis la racine avec `dart run tools/<nom>.dart`. Leurs tests sont dans `test/tools/`. Le rôle de chacun est aussi décrit en tête de son fichier.

## Ceux qu'on utilise tous les jours

| Script | À quoi il sert | Exemple |
| --- | --- | --- |
| `ctx.dart` | **Lire et chercher dans `produit/`** : c'est l'outil de contexte des personnes et des agents IA. Le code est réparti dans `ctx_v2.dart`, `ctx_corpus.dart` et `ctx_check.dart`. | `dart run tools/ctx.dart pack CAP-D1.2` · `chercher "slider"` · `lire ECR-CARTE-PRINCIPALE` · `refs COMP-PIN` · `liste --statut mvp` · `check` |
| `check_tokens.dart` | Vérifie que `packages/design_tokens` est identique à l'export Figma (34 variables) et à `figma_export.json`. | `dart run tools/check_tokens.dart` |
| `check_import_direction.dart` | Vérifie la règle d'architecture AD-5 (une feature n'importe pas une autre feature, etc.). Lancé par `melos run analyze`. | `dart run tools/check_import_direction.dart` |
| `validate_content.dart` | Valide les fichiers YAML de `content/` contre leurs schémas. | `dart run tools/validate_content.dart` |
| `gen_contenu_embarque.dart` | Génère `apps/mobile/assets/contenu/contenu.json` (contenu embarqué, DEC-04) depuis `content/`. `--verifier` échoue s'il est périmé (CI). | `dart run tools/gen_contenu_embarque.dart` |

## Ceux qui servent quand on touche la base ou le contenu (Docker requis)

| Script | À quoi il sert |
| --- | --- |
| `seed.dart` | Charge `content/` dans la base locale Supabase. |
| `publier_local.dart` | En local seulement : publie les pins et parcours chargés (sinon les règles d'accès les masquent). |
| `gen_types.dart` | Régénère `packages/api_types` et `content/schema/` depuis le schéma SQL, après une migration. |
| `check_migration_order.dart` | Vérifie l'ordre et l'immutabilité des migrations (lancé par la CI). |
| `src/connexion_supabase.dart` | Aide partagée : trouve l'URL et la clé de la base locale. |

## Gelés ou à remplacer

| Script | Statut |
| --- | --- |
| `media_push.dart` | Gelé : envoie des médias vers Supabase Storage ; aucun média n'existe encore et le MVP n'utilise pas Supabase. |
| `report.dart` | À remplacer : c'est l'ancien rapport d'avancement, dont les indicateurs ne sont pas fiables (voir `docs/PROCESS.md`). |
| `projet_sync.dart` | Signale ce qui est incohérent dans le tableau de projet GitHub (charge, priorité, nature, assigné, statut, semaine). `--appliquer` corrige la charge d'après l'étiquette `charge:N`. Voir `docs/PROCESS.md`, « Le tableau de projet ». |
| `ctx.dart --index` | Obsolète : génère `conception/INDEX.md`, qui n'est plus versionné. |
| `ctx_correspondance.dart` | Sert à reconstruire `produit/_correspondance.csv` (ancien identifiant, nouvel identifiant, source). Rarement utile. |

## Le lanceur `melos`

`melos` n'est pas un outil du produit : c'est un raccourci pour lancer une même commande sur plusieurs packages du dépôt. Il est installé avec le projet, donc on l'appelle par `dart run melos run <nom>`. Les noms sont définis dans `pubspec.yaml` (clé `melos:`).

| Commande | Ce qu'elle fait | Poids |
| --- | --- | --- |
| `dart run melos run analyze` | Analyse Dart de tout le workspace + vérifications AD-5 et tokens | Moyen (1 à 2 Go de mémoire) |
| `dart run melos run test` | Tests de tous les packages et des scripts de `tools/` | Lourd : à réserver à la CI ou à une machine libre |
| `dart run melos run format` | Vérifie le formatage (`dart format .` le corrige) | Léger |
| `dart run melos run gen` | Génération de code (Riverpod, Drift) après un `@riverpod` ou un `schema.drift` | Lourd : à lancer seul |
| `dart run melos run local` | Base locale prête (Supabase, migrations, contenu) | Lourd : Docker |
| `dart run melos run app` | App dans le navigateur sur http://localhost:8080 (pour le devcontainer) | Lourd |

Sur une machine modeste, on évite de lancer plusieurs commandes lourdes à la fois, et on teste seulement le package touché (`cd apps/mobile && flutter analyze && flutter test`).
