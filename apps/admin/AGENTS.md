# AGENTS.md — apps/admin

Back-office Flutter Web, utilisé par l'équipe éditoriale pour saisir, valider et publier les pins et parcours, et pour modérer la communauté. Les règles globales sont dans le `AGENTS.md` racine.

## État réel

C'est le squelette `flutter create` (`lib/main.dart`), **gelé jusqu'au second semestre** : le MVP n'a pas de back-office (le contenu passe par `content/`). Le premier ticket admin posera la structure, calquée sur `apps/mobile` : `lib/app/` (bootstrap, routeur, coquille), `lib/core/`, `lib/features/<slug>/{presentation,domain,data}`.

Slugs de feature admin : `catalogue`, `saisie`, `validation`, `moderation`. Les écrans de référence sont dans l'archive `conception/07-ecrans/admin/` ; ils seront repris dans `produit/` avant de démarrer ce chantier.

## Règles propres à l'admin

- **Connexion requise** : seuls les comptes présents dans `membre_equipe` voient quelque chose. La RLS serveur l'impose de toute façon, l'UI ne fait que le refléter.
- **Changements de statut** (soumettre, valider, publier, retirer) : toujours via les RPC (`supabase.rpc('pin_publier', params: {...})`), jamais par un `update` sur `statut`.
- Mêmes couches, mêmes `Result<T>`, même Riverpod que l'app mobile. Les types serveur viennent de `package:api_types`, et les valeurs visuelles de `package:design_tokens`.

## Commandes

- `flutter run -d chrome --dart-define-from-file=../../env/local.json` (depuis `apps/admin/`).
