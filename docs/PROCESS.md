# Comment on travaille

Ce document décrit la façon de travailler **aujourd'hui**. Il remplace `docs/archive/ORGANISATION.md` (l'organisation d'origine, gardée comme historique). Les changements de méthode s'inscrivent dans `docs/DECISIONS.md`.

## Le cap

- **MVP** : une carte avec slider d'époques ; un parcours de 7 à 10 pins sur plusieurs époques, dont un avec une vue 3D ; démo sur téléphone. Tout le reste est du second semestre.
- **Dates** : follow-up 2 le 13/11/2026 · follow-up 3 le 18/12/2026 · gel des fonctionnalités le 21/01/2027 · oral le 05/02/2027 · rendu du MVP le 07/02/2027. Pause pendant les vacances de Noël.
- **Jalons** (milestones GitHub) : `J1` = follow-up 2, `J2` = follow-up 3, `J3` = gel du MVP, `J4` = oral et rendu, `S2` = après le MVP. Chaque jalon a une phrase qu'on doit pouvoir démontrer (voir `produit/FEUILLE-DE-ROUTE.md`).
- Chaque jalon est aussi un « sprint » au sens du follow-up : la période entre deux rendez-vous.

## Où est la vérité

| Question | Où |
| --- | --- |
| Qu'est-ce qu'on construit, et comment ça doit se comporter ? | `produit/` (capacités, écrans, composants, flux, entités). On la lit avec `dart run tools/ctx.dart`. |
| À quoi ça ressemble ? | `produit/ecrans/img/` (captures de référence), `produit/design/`, et le fichier Figma pour la personne qui conçoit. |
| Dans quel ordre, pour quand ? | `produit/FEUILLE-DE-ROUTE.md` et les jalons GitHub. |
| Qui fait quoi ? | Les tickets GitHub. |
| Où en est-on ? | Le suivi hebdomadaire (voir plus bas), jamais un statut saisi à la main. |
| Pourquoi a-t-on décidé ça ? | `docs/DECISIONS.md` (journal) et `produit/decisions/`. |

Règle : **on modifie `produit/` d'abord, puis le code.** Un fait n'existe qu'à un seul endroit ; ailleurs, on met un lien (un identifiant).

## Les tickets : une tranche démontrable, avec une charge

- Un ticket décrit un **apport** (« on voit les pins d'une époque »), pas une couche technique. Il est rattaché à **une capacité** (`CAP-…`) et à **un jalon**. Modèle : `.github/ISSUE_TEMPLATE/tache.md` ; aide à la rédaction : `prompts/ecrire-un-ticket.md`.
- Chaque ticket a une **charge** : 1, 2, 3 ou 5. 1 = un petit ticket réalisable par une session d'agent IA et relisible en un quart d'heure. Au-delà de 3, on découpe. La charge se fixe avant de commencer ; elle ne se retouche pas en silence (un changement de périmètre se consigne).
- Pourquoi une charge plutôt qu'un nombre de tickets : on peut couper gros ou fin, la somme des charges reste la même, donc l'avancement ne se truque pas.
- Étiquettes : `charge:N`, `cap:D…` (capacité), la zone (`mobile`, `content`, `3d`, `tools`, `docs`, `supabase`), `contenu:redige|relu|publie` pour un pin, `3d:trouve|droits|optimise|integre` pour le modèle 3D, `bloque`.
- États, déduits de la réalité : **à faire** ; **en cours** (une branche `<n>-<slug>` existe) ; **fait** (PR fusionnée).

## Un ticket de bout en bout

1. Choisir un ticket du jalon courant, dont les dépendances sont levées, et le prendre.
2. Charger le contexte : `dart run tools/ctx.dart pack CAP-…`. Lancer un agent IA dans le dépôt : « Réalise le ticket #N » (voir `AGENTS.md`).
3. Branche `<n°ticket>-<slug>`, tests d'abord pour la logique, code ensuite. Rester dans la zone du ticket.
4. Vérifier : `dart run melos run analyze`, `... run test`, `... run format`, et regarder l'app tourner sur un téléphone.
5. Ouvrir la PR (`Closes #N`, déclaration de l'assistance IA). **Une autre personne la relit** (liste dans `prompts/relire-une-pr.md`), puis squash merge.
6. Si une règle du produit a changé : la fiche de `produit/` est modifiée dans la même PR. Si un écran a changé dans Figma : la capture est ré-exportée.

Ticket flou, contradictoire ou trop gros : on n'invente pas. On écrit une question précise sur le ticket et on s'arrête.

## Les rendez-vous

- **Créneau hebdomadaire** : dix minutes pour lire le suivi, puis le ticket du haut de la liste.
- **Point de périmètre** (15 minutes, avant chaque follow-up) : la phrase du jalon, le suivi, les arbitrages, les idées nouvelles. Une idée nouvelle est notée, estimée en charge, puis tranchée ici ; elle n'entre jamais dans le jalon en cours sans arbitrage. Ce qui ne rentre pas va dans `S2`.
- **Rétrospective** de dix lignes après chaque follow-up (`docs/team/retros/`).
- **Dépôt de l'école** : on y pousse à chaque follow-up, au moment de l'oral et pour le rendu.

## Le suivi

Les indicateurs sont **calculés** depuis GitHub (tickets, PR, CI) et le contenu, et conservés chaque semaine, pour voir une **courbe** et non un chiffre isolé : un plateau signale un blocage.

- **Avancement** : progression du jalon (charge terminée sur charge du jalon, avec la charge ajoutée visible), reste à faire et date prévue (charge restante divisée par le débit des trois dernières semaines), capacités du MVP démontrées.
- **Qualité** : nombre de tests par type, couverture du code de l'app, CI sur `main`, répétitions de démo réussies.
- **Flux** : temps de cycle (premier commit à fusion), âge des tickets en cours, délai avant la première relecture, part de PR relues par une autre personne, tickets sans mouvement depuis 14 jours.
- **Contenu et produit** : pins rédigés, relus, publiés (cible 7 à 10, au moins une source archivistique ou académique chacun), parcours complet, état du modèle 3D, personnes extérieures ayant testé l'app.

Seuils qui déclenchent une action : date prévue après la date du jalon, plateau de deux semaines, ajouts de périmètre au-delà de 10 % de la charge du jalon, PR sans relecture depuis plus de 5 jours, ticket sans commit depuis plus de 14 jours. Deux vues : une **vue client** (agrégée, pour les follow-ups) et une **vue interne** (détail par personne, générée en local, jamais publiée).

*État : `dart run tools/suivi.dart` calcule l'instantané du jour et l'écrit dans `build/suivi/` (vue publique `instantane-AAAA-MM-JJ.json`, vue interne `interne-AAAA-MM-JJ.json`, jamais commitée). L'historique, les graphiques et la publication de la vue client sur la branche `suivi` sont le ticket suivant (#126). Le script `tools/report.dart` est l'ancien rapport : ses chiffres ne sont pas fiables.*

## Revue et qualité

- `main` est protégé : tout passe par une PR liée à un ticket, vérifiée par la CI et relue par une autre personne.
- Les hooks git (`lefthook.yml`) sont le premier filet : analyse des fichiers du commit, tests du package touché avant le push. La CI refait tout sur chaque PR.
- Les tests protègent la logique ; les critères de fin (`CF…`) d'une capacité sont ses tests d'acceptation.
- Les agents IA font le gros du travail de rédaction et de code, **l'humain cadre, relit et fusionne** : on reste responsable de ce qu'on fusionne.
