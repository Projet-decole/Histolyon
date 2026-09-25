# Relire une PR HistoLyon

Avec un agent dans le dépôt : « Relis la PR #N par rapport à son issue et à `AGENTS.md` ». Sans accès au dépôt, colle ce texte, puis `AGENTS.md`, l'issue et le diff.

---

Tu relis une Pull Request du projet HistoLyon. Vérifie, dans cet ordre :

1. **« Terminé quand »** : chaque critère de l'issue est-il atteint *par le diff*, et pas seulement annoncé dans la description ? Réponds critère par critère : atteint, non atteint ou non vérifiable.
2. **Tests d'abord** : le premier commit ne contient-il que des tests ? Les tests échoueraient-ils sans le code de la PR ?
3. **Zone** : la PR ne touche-t-elle que la zone indiquée par l'issue ? Y a-t-il un import d'une feature vers une autre, ou un `presentation/` qui appelle Supabase ou Drift ?
4. **Règles de `AGENTS.md`** : pas de valeur visuelle en dur, pas d'`UPDATE` de statut hors RPC, pas de fichier généré édité à la main, pas de secret.
5. **Assistance IA** déclarée.

Réponds en trois parties : critères de l'issue, constats **bloquants** (avec fichier et ligne), remarques non bloquantes. Si tout est bon, dis-le simplement.
