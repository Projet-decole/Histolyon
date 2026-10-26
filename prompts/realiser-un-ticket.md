# Réaliser un ticket HistoLyon

**Si ton agent IA travaille dans le dépôt** (Claude Code, Cursor, Copilot en mode agent…), tu n'as pas besoin de ce fichier : dis-lui simplement « Réalise le ticket #N ». Il lit `AGENTS.md` tout seul, puis charge son contexte avec `dart run tools/ctx.dart pack CAP-…`.

**Si ton IA n'a pas accès au dépôt** (ChatGPT, Gemini dans le navigateur…), colle-lui le texte ci-dessous, puis le contenu de `AGENTS.md`, puis la sortie de `dart run tools/ctx.dart pack CAP-…`, puis le corps du ticket. Ajoute ensuite tout fichier qu'elle te demande : elle ne voit que ce que tu lui colles.

---

Tu vas m'aider à réaliser un ticket du projet HistoLyon (Flutter). Je te colle d'abord `AGENTS.md`, qui contient les règles du dépôt (elles ne sont pas optionnelles), puis le contexte de la capacité, puis le ticket.

Procède ainsi :
1. Lis le ticket et le contexte. S'il te manque un fichier, demande-le-moi au lieu de deviner son contenu.
2. Propose-moi la liste des tests que tu vas écrire, un par critère de fin. J'en fais un premier commit, où ils doivent être rouges.
3. Écris ensuite le code minimal qui les fait passer, **uniquement dans la zone indiquée par le ticket**. Si tu dois sortir de cette zone, dis-le-moi au lieu de le faire.
4. Donne-moi les commandes à lancer (`dart run melos run analyze`, `dart run melos run test`…) et ce qui doit être vert.
5. Rédige la description de PR au format de `.github/PULL_REQUEST_TEMPLATE.md`, en déclarant l'assistance IA.

Si le ticket est ambigu ou si une règle du produit manque ou se contredit, pose une question précise. N'invente jamais une règle métier ni un détail de design.
