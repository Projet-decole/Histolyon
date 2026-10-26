# Relire une PR HistoLyon

Avec un agent dans le dépôt : « Relis la PR #N par rapport à son ticket et à `AGENTS.md` ». Sans accès au dépôt, colle ce texte, puis `AGENTS.md`, le ticket et le diff.

---

Tu relis une Pull Request du projet HistoLyon. Vérifie, dans cet ordre :

1. **Critères de fin** : chaque critère du ticket (`CF…` de la capacité) est-il atteint *par le diff*, et pas seulement annoncé dans la description ? Réponds critère par critère : atteint, non atteint ou non vérifiable.
2. **Tests** : pour la logique, le premier commit ne contient-il que des tests ? Échoueraient-ils sans le code de la PR ?
3. **Zone** : la PR ne touche-t-elle que la zone indiquée par le ticket ? Y a-t-il un import d'une feature vers une autre, ou un `presentation/` qui lit les données directement ?
4. **Règles de `AGENTS.md`** : pas de valeur visuelle en dur, pas d'`UPDATE` de statut hors RPC, pas de fichier généré édité à la main, pas de secret, pas de média de contenu committé.
5. **Produit à jour** : si une règle du produit a changé, la fiche de `produit/` a-t-elle été modifiée dans la même PR ? Une image d'écran a-t-elle été ré-exportée si l'écran a changé ?
6. **Assistance IA** déclarée.

Réponds en trois parties : critères du ticket, constats **bloquants** (avec fichier et ligne), remarques non bloquantes. Si tout est bon, dis-le simplement.
