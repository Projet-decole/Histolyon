# Écrire un ticket HistoLyon

Un bon ticket permet à quelqu'un qui n'a pas suivi le projet de le terminer **avec une IA, sans poser de question**. Colle ce texte à ton agent IA (dans le dépôt, de préférence) avec ton idée de tâche.

---

Rédige un ticket GitHub pour le projet HistoLyon au format de `.github/ISSUE_TEMPLATE/tache.md`, en respectant ces règles :

- **Un apport** : le ticket décrit une tranche démontrable (« on voit les pins d'une époque »), pas une couche technique (« écrire le repository »). Si l'apport demande deux zones, fais deux tickets, le second dépendant du premier.
- **Une capacité** : cite la capacité visée (`CAP-…`, liste : `dart run tools/ctx.dart liste --type capacite`) et reprends les critères de fin (`CF…`) de sa fiche. Ne recopie pas la fiche : renvoie-y.
- **Une charge** : 1, 2, 3 ou 5. 1 = un petit ticket réalisable par une session d'agent et relisible en un quart d'heure. Au-delà de 3, découpe. La charge se fixe avant de commencer et ne se retouche pas en silence (un changement de périmètre se consigne).
- **Contexte** : la commande `dart run tools/ctx.dart pack CAP-…` et des chemins de fichiers précis. Jamais « lis la conception ».
- **Critères de fin** : observables (ce qu'on voit dans l'app, ce qu'un test vérifie).
- **Hors périmètre** : ce qu'on serait tenté de faire mais qui relève d'un autre ticket.
- **Étiquettes** : `charge:N`, `cap:D…`, la zone (`mobile`, `content`, `3d`, `tools`, `docs`, `supabase`), et le jalon (milestone).

Avant d'écrire, lis `AGENTS.md` et vérifie dans le dépôt que ce que le ticket suppose existe vraiment (fichiers, routes, providers).
