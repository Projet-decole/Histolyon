# Écrire une issue HistoLyon

Une bonne issue permet à quelqu'un qui n'a pas suivi le projet de la terminer **en une demi-journée avec une IA, sans poser de question**. Colle ce texte à ton agent IA (dans le dépôt, de préférence) avec ton idée de tâche.

---

Rédige une issue GitHub pour le projet HistoLyon au format de `.github/ISSUE_TEMPLATE/tache.md`, en respectant ces règles :

- **Une seule zone** : une feature mobile, `supabase/`, `content/`, une feature admin ou un package. Si la tâche demande à la fois une RPC et un écran, fais deux issues, l'écran dépendant de la RPC.
- **Taille** : une demi-journée avec une IA. Si c'est plus, découpe.
- **« À lire »** : des IDs de `conception/` (`dart run tools/ctx.dart --index` donne la liste) et des chemins de fichiers précis. Jamais « lis la conception ».
- **« Terminé quand »** : des critères observables (ce qu'on voit dans l'app, ce qu'un test vérifie).
- **« Hors périmètre »** : ce qu'on serait tenté de faire mais qui relève d'une autre issue.
- **Labels** : la zone (`mobile`, `admin`, `supabase`, `content`, `3d`), plus `prête` quand l'issue est complète et que ses dépendances sont fusionnées.

Avant d'écrire, lis `AGENTS.md` et vérifie dans le dépôt que ce que l'issue suppose existe vraiment (tables, routes, providers).
