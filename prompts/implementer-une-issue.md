# Implémenter une issue HistoLyon

**Si ton agent IA travaille dans le dépôt** (Claude Code, Cursor, Copilot en mode agent…), tu n'as pas besoin de ce fichier : dis-lui simplement « Implémente l'issue #N ». Il lit `AGENTS.md` tout seul.

**Si ton IA n'a pas accès au dépôt** (ChatGPT, Gemini dans le navigateur…), colle-lui le texte ci-dessous, puis le contenu de `AGENTS.md`, puis le corps de l'issue. Ajoute ensuite tout fichier qu'elle te demande : elle ne voit que ce que tu lui colles.

---

Tu vas m'aider à implémenter une issue du projet HistoLyon (Flutter + Supabase). Je te colle d'abord `AGENTS.md`, qui contient les règles du dépôt (elles ne sont pas optionnelles), puis l'issue.

Procède ainsi :
1. Lis l'issue. S'il te manque un fichier qu'elle cite, demande-le-moi au lieu de deviner son contenu.
2. Propose-moi la liste des tests que tu vas écrire. J'en fais un premier commit, où ils doivent être rouges.
3. Écris ensuite le code minimal qui les fait passer, **uniquement dans la zone indiquée par l'issue**. Si tu dois sortir de cette zone, dis-le-moi au lieu de le faire.
4. Donne-moi les commandes à lancer (`melos run analyze`, `melos run test`…) et ce qui doit être vert.
5. Rédige la description de PR au format de `.github/PULL_REQUEST_TEMPLATE.md`, en déclarant l'assistance IA.

Si l'issue est ambiguë, pose une question précise. N'invente jamais une règle métier ni un détail de design.
