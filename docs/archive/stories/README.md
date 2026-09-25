# `docs/stories/`

`sprint-status.yaml` est la source de vérité de l'avancement (AD-17) — c'est le seul fichier de ce dossier à tenir à jour à chaque story.

`TEMPLATE.md` est le gabarit de story (format dev-story BMAD), dupliqué dans `.github/ISSUE_TEMPLATE/story.md`.

**Pourquoi seuls les épics 1 et 2 ont un fichier détaillé par story (`spec-1-1-*.md` … `spec-2-7-*.md`, plus `epic-1-context.md`/`epic-2-context.md`) :** c'est ainsi que le bootstrap a démarré avec BMAD (`bmad-build` produit un fichier de spec par story, gelé après revue). À partir de l'épic 3, le détail d'une story vit uniquement dans son issue GitHub et sa PR — jamais dans un second fichier local à maintenir en double. Si tu cherches le détail d'une story de l'épic 3 ou au-delà, elle n'est pas ici : elle est sur GitHub (issue fermée, PR liée). C'est un choix délibéré (moins de duplication à maintenir), pas un oubli.

`deferred-work.md` et `epic-1-retro-2026-09-18.md` sont des artefacts de revue de l'épic 1, gardés comme référence historique.

Pour le « pourquoi » des décisions prises pendant le bootstrap : [`docs/DECISIONS.md`](../DECISIONS.md).
