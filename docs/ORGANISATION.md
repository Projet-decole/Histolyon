# HistoLyon — Comment on en est arrivés à cette organisation

> **Mis à jour le 2026-09-25.** Ce guide raconte comment l'organisation est née. Depuis, deux ajustements (voir `docs/DECISIONS.md`, phases 2 et 3) : BMAD n'est plus utilisé pour produire des stories, remplacées par des **issues courtes** (`.github/ISSUE_TEMPLATE/tache.md`) ; le code est écrit pour Android **et** iOS. Les étapes pratiques (§ 8, Annexe A) sont à jour ; pour le détail des règles, `AGENTS.md` fait foi.

*Guide de l'équipe. Il se lit dans l'ordre, une fois, en 25 minutes : chaque partie découle de la précédente, et à la fin le dépôt, la façon de travailler et les rôles n'ont plus besoin d'être expliqués — ils sont la conséquence de ce qui précède. Les règles techniques détaillées sont dans `docs/ARCHITECTURE-SPINE.md` ; ce guide raconte pourquoi elles existent.*

---

## 0. D'où on part

**Ce qu'on a déjà.** L'année dernière, on a décidé *quoi* construire : une application Android qui fait explorer Lyon à travers les époques — une carte, un slider pour changer d'époque, des pins (points d'intérêt) avec leur histoire, des parcours, un peu de 3D. Tout ça est écrit dans `conception/` : 15 paliers, 41 écrans, une maquette Figma. On ne rediscute pas le quoi. Cette année, on construit.

**Ce que l'école attend.** Le jury ne notera pas l'application : il notera **la manière dont on l'a construite**. Trois choses, précisément : savoir à tout moment où on en est (un état des lieux à chaque rendez-vous, sans qu'on passe une soirée à le rédiger), des indicateurs d'avancement mesurables, et la preuve qu'on regarde ce qui ne marche pas et qu'on s'ajuste. L'usage de l'IA est autorisé, à condition qu'on sache expliquer ce qu'elle a fait.

**Ce qu'on est.** Environ sept personnes. Chacun a, en gros, une demi-journée toutes les deux semaines pour ce projet — parfois rien pendant trois semaines, parfois un week-end entier. On ne sera presque jamais tous disponibles en même temps. La composition de l'équipe peut bouger. Personne n'a jamais fait de Flutter ni de cartographie. Chacun a son éditeur et son assistant IA préférés. Et le budget est de zéro euro.

**Le problème, donc.** Comment sept personnes qui ne se croisent presque jamais, qui débutent sur la techno, qui n'ont que quelques heures d'affilée, construisent-elles ensemble une application — sans se marcher dessus, sans dépendre d'une seule personne, et en laissant derrière elles une trace que le jury peut lire ?

Tout ce qui suit répond à cette question, une contrainte à la fois.

---

## 1. Puisqu'on est peu et débutants : le moins de technologies possible

**Le constat.** Sept personnes à temps partiel ne peuvent pas apprendre trois technologies, ni entretenir un serveur, ni écrire une API. Chaque techno en plus, c'est une personne qui devient indispensable.

**Donc.** On choisit tout pour qu'il y ait **une seule chose à apprendre**, et pour que le reste soit fourni.

- **Un seul langage : Dart, avec Flutter.** L'app Android est en Flutter. Le back-office (l'outil web où on saisit et valide les pins) est *aussi* en Flutter, version web. Celui qui a appris à faire un écran de l'app sait faire un écran du back-office. Les composants de la maquette sont codés une fois et partagés.
- **Pas de backend à écrire : Supabase.** C'est une base Postgres hébergée, avec l'authentification, le stockage de fichiers et les règles d'accès fournis. Notre « backend », c'est le schéma de la base et quelques fonctions SQL. Gratuit, dans des limites qu'on gère (deux projets maximum, on y revient).
- **Une carte sans clé d'API : MapLibre**, avec un fond de carte de Lyon dans un seul fichier (`lyon.pmtiles`) qu'on héberge nous-mêmes. Un style de carte par époque : le slider ne fait que changer de style.
- **Le contenu commence en fichiers.** Les premiers pins, parcours et époques sont des fichiers YAML dans le dépôt, chargés en base par un script. Ça évite de devoir finir huit écrans de back-office avant de voir le premier pin sur la carte. Le back-office prendra le relais plus tard.
- **Android d'abord** : pas de Mac ni de licence Apple, donc ni build ni test iOS pour l'instant. Le code est quand même écrit pour les deux (toute API Android-only se marque `// DETTE-IOS:`).

*Ce que ça implique pour toi : il y a une chose à apprendre, Flutter, et le dépôt contient des guides-recettes pour ça. Tu n'auras jamais à écrire un serveur.*

---

## 2. Puisqu'on ne se croise pas : le travail doit être en petits morceaux autonomes

**Le constat.** Si une tâche demande de se parler pour être comprise, elle attend deux semaines. Si elle demande plus d'une session pour être finie, elle reste à moitié faite quand la personne est prise ailleurs, et personne ne peut la reprendre.

**Donc.** L'unité de travail doit être **la plus petite tâche qui a un sens toute seule**, et son brief doit contenir tout ce qu'il faut pour la faire sans poser de question. On l'appelle une **story**.

Une story, c'est : « afficher le pin sur la carte », « ajouter la colonne `epoques` à la table `pin` », « écrire le guide *ajouter une feature* ». Pas « faire le slider d'époques » (ça, c'est un épic, qui se découpe en plusieurs stories). Son brief dit : l'objectif, quels extraits de `conception/` lire (par leur identifiant, jamais tout), quels tests écrire, ce qui doit être vrai à la fin, quels fichiers toucher. Elle se prend, se fait et se termine en une session. Si ce n'est pas possible, ce n'est pas toi le problème : c'est la story qui est mal découpée, et on la renvoie.

**Comment on découpe.** On suit la conception, qui est déjà organisée en onze domaines (D1 Carte, D2 Pins, D3 Parcours… D11 Surfaces hors-app) et en sous-domaines (D1.2 Slider d'époques). Un domaine = un domaine de travail. Un sous-domaine = un **épic**. Un épic = quelques stories. Le jury peut suivre une ligne continue de la conception au code.

**Qui découpe.** Découper bien, c'est un vrai travail : c'est une **casquette** — le Découpeur — tenue par le porteur, qui écrit les briefs (issues courtes, `prompts/ecrire-une-issue.md`) à partir de la conception. Les autres n'ont pas besoin de cette méthode : pour eux, une story est juste une tâche bien écrite.

*Ce que ça implique pour toi : tu ne prends jamais « une fonctionnalité », tu prends une story. Tu n'as jamais à deviner : si le brief ne suffit pas, tu le dis au Découpeur.*

---

## 3. Puisque le jury note l'organisation : chaque morceau doit laisser une trace, sans effort

**Le constat.** Rédiger un état des lieux à la main avant chaque rendez-vous, c'est une soirée perdue, et c'est faux dès le lendemain. Le seul état des lieux fiable, c'est celui qu'on **calcule** à partir du travail réel.

**Donc.** Le travail doit vivre dans un outil qui peut être interrogé par un script. C'est **GitHub** :

- une story = **une issue** GitHub (le brief est le corps de l'issue) ;
- on y travaille dans **une branche** qui porte son nom ;
- on la termine par **une PR** (demande de fusion) qui ferme l'issue.

Chaque issue porte l'étiquette de son domaine (`D1`, `D2`…). Ce n'est pas de la bureaucratie : c'est ce qui permet au script `tools/report` de produire, à la demande, l'état des lieux — ce qui est fait, en cours, à faire, par domaine — et quelques indicateurs : la part des sous-domaines terminés, le délai entre la prise d'une story et sa fusion, le taux de vérifications automatiques réussies, la couverture de tests. Ce rapport est collé tel quel dans le compte rendu de réunion.

**Ce qu'on ne fait pas.** On ne compte pas les stories et on ne se fixe pas d'objectif en nombre de stories : ça pousserait à les grossir ou à courir après un chiffre, alors que nos disponibilités varient trop pour que ce chiffre veuille dire quelque chose. Ce n'est pas grave si tout n'est pas fini en fin d'année ; ce qui compte, c'est qu'on sache exactement où on en est.

**SharePoint**, imposé par l'école, garde les comptes rendus de réunion — et reçoit le rapport. Il n'est plus l'endroit où on suit le travail.

*Ce que ça implique pour toi : si ce n'est pas dans une issue, ça n'existe pas. Un travail sans issue, sans étiquette de domaine ou sans PR liée est invisible — pour le rapport, et pour le jury.*

---

## 4. Puisqu'on travaille en parallèle sans se voir : personne ne doit pouvoir casser le travail des autres

**Le constat.** Deux personnes qui modifient le même fichier le même week-end sans se parler, ça finit en conflit que personne ne sait résoudre. Une personne qui pousse du code cassé sur la branche principale bloque tout le monde jusqu'à sa prochaine session — dans deux semaines.

**Donc, deux choses.**

### 4a. La branche principale est toujours propre

`main` est protégée. Rien n'y arrive directement : tout passe par une PR, qui n'est fusionnée que si les vérifications automatiques sont vertes, si la branche est à jour avec `main`, et si **une autre personne a relu**. Une branche ne vit jamais plus de deux semaines (la durée d'une itération) : au-delà, on fusionne ce qui est prêt ou on redécoupe. Chaque fusion sur `main` déploie automatiquement sur un environnement `dev` où on peut voir le résultat. L'environnement `demo`, celui qu'on montre au jury, n'est mis à jour que sur décision, avec un tag daté.

### 4b. Le code est découpé en zones qui ne se touchent pas

C'est ici que l'architecture du code découle directement de l'organisation. Dans l'app, il y a **un dossier par domaine** de la conception — `features/carte`, `features/pins`, `features/parcours`… — et une story ne touche qu'**un seul** de ces dossiers. Deux personnes sur deux domaines ne partagent aucun fichier : pas de conflit possible.

Pour que ça tienne, une règle : **une feature n'importe jamais une autre feature**. Ce dont deux features ont besoin descend dans un dossier commun, `core/` (par exemple : l'époque sélectionnée, le parcours en cours — ce que plusieurs écrans doivent connaître). Ce dont les deux apps ont besoin (composants de la maquette, couleurs, types de données) descend encore plus bas, dans `packages/`. Et à l'intérieur d'une feature, trois couches qui ne s'appellent que vers le bas : `presentation` (les écrans) → `domain` (la logique) → `data` (l'accès à la base). Un écran ne parle jamais directement à Supabase.

```
app/  ──►  features/<domaine>/  ──►  core/  ──►  packages/
                 │
     presentation ──► domain ──► data
```

Une vérification automatique refuse une PR qui viole ce sens. Tu n'as pas à le retenir : si tu te trompes, c'est rouge, et le message dit pourquoi.

### 4c. La base a un seul propriétaire

Il reste un endroit que tout le monde partage : la base de données. Là, on ne peut pas faire des zones. Alors on **sérialise** : le schéma n'est modifié que par des fichiers de migration SQL versionnés, **une migration par PR**, dans un ordre fixé par une casquette — l'Intégrateur — qui relit et fusionne. Jamais de modification de la base à la main. Les types de données utilisés par l'app sont **générés** depuis ce schéma, jamais écrits à la main : quand la base change, on régénère, et tout le monde a la même vision. Une story qui a besoin d'une migration *et* d'un écran, ce sont deux stories, la migration d'abord.

*Ce que ça implique pour toi : tu travailles dans ta feature, tu ne modifies rien dans celle d'un autre, et tout ce qui touche à la base passe par l'Intégrateur.*

---

## 5. Puisque personne n'est expert et qu'on utilise des IA : la qualité doit être garantie par la machine, pas par l'expérience

**Le constat.** Dans une équipe expérimentée, la qualité repose sur le regard des seniors. On n'en a pas. Et l'IA produit vite du code qui a l'air juste — ce qui est pire que du code visiblement faux.

**Donc.** Les garanties sont automatiques, et le point de départ de toute story, c'est ce qu'elle doit **prouver**.

- **Les tests s'écrivent avant le code.** Pas « on teste », mais dans cet ordre : le premier commit d'une story, ce sont ses tests, rouges ; le code vient après, jusqu'à ce qu'ils passent. Un test écrit après coup s'adapte au code qu'on a sous les yeux ; un test écrit avant dit ce que le code doit faire — et donne à une IA une cible plutôt qu'un code à justifier. La personne qui relit vérifie l'ordre des commits.
- **Chaque couche a sa façon de tester** : la logique par des tests unitaires, les écrans par des tests de composants, la base par des tests SQL (un par règle métier : « un pin publié a au moins une source »), le contenu par une validation de format. La couverture est publiée et **ne peut que monter**.
- **Les vérifications tournent avant même que quelqu'un voie ton code** : à chaque commit, le formatage et le lint ; à chaque push, les tests de ce que tu as touché (c'est l'outil `lefthook`). Puis la CI rejoue tout sur la PR.
- **L'IA est déclarée.** Chaque PR dit si une IA a aidé, laquelle, pour quoi. Ce n'est pas un aveu : c'est ce que l'école demande, et ça oblige à relire. Les prompts qui marchent sont partagés dans le dépôt (`prompts/`), et il y a une checklist pour faire le même chemin sans IA.

*Ce que ça implique pour toi : ta story commence par un commit de tests. Et tu peux pousser sans peur : si c'est cassé, la machine te le dit avant les autres.*

---

## 6. Puisque tout ça repose sur des règles : les règles doivent être trouvables, pas apprises par cœur

**Le constat.** Ce guide fait déjà plusieurs pages. Personne ne retiendra tout, un arrivant encore moins, et une IA n'a qu'une mémoire de travail limitée : si on lui donne toute la conception, elle se noie ; si on ne lui donne rien, elle invente.

**Donc.** Chaque personne — et chaque IA — doit recevoir **exactement** le contexte de sa tâche, en quatre niveaux :

1. **`AGENTS.md`**, à la racine : les règles de la maison en une page — commandes, conventions, où chercher, ce qu'on ne fait jamais. Tout le monde le lit, toujours. C'est aussi le fichier que lisent les assistants IA, quel que soit l'outil : `CLAUDE.md`, `.cursor/rules`, `copilot-instructions.md` en sont des copies générées automatiquement, pour que personne ne maintienne deux versions des règles.
2. **`docs/`** : les règles d'architecture, les conventions, les guides-recettes (« ajouter une feature », « écrire une migration ») — un sujet par fichier, lu quand la story le cite.
3. **`conception/`** : le quoi, jamais lu en entier. Un script, `tools/ctx D1.2`, affiche juste l'extrait demandé.
4. **La story** : elle dit précisément quoi lire dans les niveaux au-dessus.

*Ce que ça implique pour toi : tu lis `AGENTS.md` une fois, puis tu lis ce que ta story te dit de lire, rien de plus. Le dépôt forme les arrivants tout seul — c'est voulu.*

---

## 7. Résultat : le dépôt

Maintenant, chaque dossier a une raison d'être que tu viens de lire.

| Dossier | Il existe parce que… (§) | Ce que c'est | Tu y touches quand… |
| --- | --- | --- | --- |
| `AGENTS.md` | § 6 | Les règles en une page, pour humains et IA. | Toujours en premier. Ses copies (`CLAUDE.md`, `.cursor/`, `.github/copilot-instructions.md`) ne s'éditent jamais. |
| `conception/` | § 0, § 6 | Le quoi. | Par extrait, via `tools/ctx`, quand ta story le cite. |
| `docs/` | § 6 | Règles d'architecture (`ARCHITECTURE-SPINE.md`), journal des décisions, guides, suivi de sprint, rétros (`team/retros/`) ; l'historique du bootstrap dans `archive/`. | Quand ta story cite un guide ; le Découpeur et le Pilote y écrivent. |
| `apps/mobile/` | § 1, § 4b | L'app Android. `lib/features/<domaine>/` = ta zone, en trois couches ; `lib/core/` = le partagé ; `lib/app/` = l'assemblage. | Presque toutes les stories D1–D9, D11. |
| `apps/admin/` | § 1 | Le back-office, en Flutter Web, même structure. | Les stories D10, après le premier pin. |
| `packages/` | § 1, § 4b | Partagé par les deux apps : `design_tokens` (couleurs, typos de la maquette, mêmes noms que Figma), `ui_kit` (les composants de la maquette), `api_types` (**généré** depuis la base), `map_styles` (un fond de carte par époque). | Rarement ; avec le Gardien du design. `api_types` se régénère, ne s'édite pas. |
| `supabase/` | § 1, § 4c | La base : `migrations/` (le schéma), `functions_sql/` (les changements d'état : soumettre, valider, publier), `tests/` (un test SQL par règle métier). | Stories qui touchent les données ; une migration par PR, via l'Intégrateur. |
| `content/` | § 1 | Pins, parcours, époques, catégories en YAML, relus en PR comme du code. Les images et sons ne sont pas là (ils vont dans le stockage Supabase via `tools/media`). | Tu écris ou corriges du contenu. |
| `prompts/` | § 5 | Les prompts à coller dans une IA, et la checklist sans IA. | À chaque story. |
| `tools/` | § 3, § 4c, § 6 | Les scripts : `ctx`, `gen-types`, `seed`, `media`, `report`, `check-tokens`… | Quand la story le dit. |
| `.github/` | § 3, § 4a, § 5 | La CI et les modèles d'issue (= le brief) et de PR. | Jamais, sauf story `socle`. |
| `env/` | § 4a | URL et clés publiques par environnement. Jamais de secret. | Jamais. |

---

## 8. Résultat : ta première story

Chaque étape vient d'un paragraphe ci-dessus.

1. **Prendre** (§ 2, § 3). Dans les issues GitHub, choisis une issue ouverte, non assignée et marquée `prête`, dans une zone ou un domaine que tu veux apprendre. Assigne-toi. Pas besoin de demander.
2. **Lire** (§ 2, § 6). L'issue est le brief. Lis ce qu'elle cite — `dart run tools/ctx.dart D2.4` pour la conception — rien de plus. Si quelque chose manque : commente l'issue, mentionne le Découpeur, ne devine pas.
3. **Brancher** (§ 3, § 4a) :
   ```bash
   git switch main && git pull
   git switch -c 42-apercu-rapide                # <n°issue>-<slug>
   ```
4. **Tests d'abord** (§ 5). Écris les tests listés dans le brief. Ils sont rouges. C'est ton premier commit :
   ```bash
   git commit -m "test(pins): aperçu rapide d'un pin #42"
   ```
5. **Coder** (§ 4b, § 5). Dans ta feature, jusqu'au vert. Commits `type(zone): sujet #issue`. lefthook formate, linte et teste au passage.
6. **Ouvrir la PR** (§ 3, § 5). Le modèle demande : l'issue liée (`Closes #42`), le commit des tests, l'assistance IA. La CI lance tout ; la branche doit être à jour.
7. **Relecture** (§ 4a, § 5). Quelqu'un d'autre vérifie : critères atteints, tests avant le code, code dans la bonne zone. Une relecture prend 15 minutes ; sinon la story était trop grosse, on le note pour la rétro.
8. **Fusion** (§ 4a). Squash sur `main`, déploiement automatique sur `dev`, l'issue se ferme, le rapport la voit.

**Pas fini à la fin de ta session ?** Pousse ta branche, écris dans l'issue où tu en es. Toi ou quelqu'un d'autre reprendra : c'est exactement pour ça que la story est petite et que le brief est complet (§ 2).

**Avec une IA** (§ 5) : donne-lui le numéro de l'issue et `prompts/implementer-une-issue.md` (les agents lisent `AGENTS.md` d'eux-mêmes) ; relis tout ; déclare-le dans la PR. Sans IA : suis `AGENTS.md`, « Ta mission type ».

---

## 9. Résultat : l'équipe

### Les casquettes

Au fil des paragraphes, des responsabilités sont apparues. Ce ne sont pas des postes : ce sont des **casquettes**, qui tournent, idéalement à deux pour que personne ne soit indispensable (§ 0). Personne n'est chef de personne ; la casquette dit juste à qui tu t'adresses. Seul le Découpeur est attribué formellement pour l'instant ; les autres se prennent selon les besoins, et un changement se note dans `docs/DECISIONS.md` ou la rétro, jamais un nom ici.

| Née au § | Casquette | Tu t'adresses à elle quand… | Elle s'occupe de… |
| --- | --- | --- | --- |
| 3 | **Pilote** | tu ne sais pas quoi prendre, ou quoi prioriser | l'ordre des épics, la réunion, le rapport au rendez-vous école |
| 2 | **Découpeur** | une story est floue ou trop grosse | transformer un épic en stories complètes, tenir le modèle de brief |
| 4 | **Intégrateur** | tu as une migration à faire, ou une PR qui attend | relire et fusionner, sérialiser les migrations, garder `main` livrable |
| 5 | **Gardien des tests** | tu ne sais pas quel test écrire ni où | l'ordre tests-d'abord, la politique par couche, la couverture |
| 4b | **Gardien du design** | il te manque un composant ou une couleur de la maquette | Figma ↔ `design_tokens` / `ui_kit`, les écarts à la maquette |
| 1 | **Spécialiste 3D** | tu touches à la 3D ou à l'AR | le premier bâtiment reconstitué, derrière une interface isolée |
| 1 | **Éditeur de contenu** | tu écris un pin ou un parcours | `content/`, les médias et leurs licences |

### Le rythme

- **En continu** : chacun prend, fait et relit des stories quand il peut (§ 2). Aucune présence simultanée n'est requise.
- **Toutes les deux semaines, une heure** : la réunion. On *lit* le rapport généré (§ 3), on ne le rédige pas. On choisit les épics suivants, on redistribue les casquettes si besoin, on débloque. Compte rendu sur SharePoint.
- **Avant chaque rendez-vous école** : la rétrospective — ce qui marche, ce qui ne marche pas, ce qu'on change (§ 0 : le jury veut voir qu'on s'ajuste). Chaque changement devient une issue étiquetée `organisation`, traitée comme une story.
- **Sur décision** : un tag `demo-AAAA-MM-JJ` met à jour l'environnement `demo` (§ 4a).

### Où on parle de quoi

| Sujet | Endroit |
| --- | --- |
| Une story (question, blocage, avancement) | dans l'issue |
| Le code | dans la PR |
| Les décisions de réunion | compte rendu SharePoint |
| Une règle d'architecture à changer | `docs/ARCHITECTURE-SPINE.md`, par amendement — chaque règle a un identifiant stable (`AD-n`), et on note pourquoi elle change |
| La coordination rapide (dispos, « qui prend quoi ») | le canal de discussion de l'équipe |

### Comment l'organisation change

Rien de tout ça n'est figé. Une règle qui gêne se change — mais par écrit, en rétro ou par amendement, jamais en silence. C'est ce qui permet de montrer au jury non seulement une organisation, mais une organisation qui apprend.

---

## Annexe A — Installer ton poste

| Outil | Version | Pour (§) |
| --- | --- | --- |
| Flutter (stable) | 3.47.4 | l'app et le back-office (§ 1) |
| Android Studio ou SDK Android | API 21+, JDK 21 | construire l'APK |
| Docker | — | Supabase en local (§ 1) |
| Supabase CLI | 2.117 | base locale, migrations, tests SQL (§ 4c, § 5) |
| lefthook | 2.1 | vérifications avant commit et push (§ 5) |
| melos | 8.7 | lancer les scripts sur tout le dépôt |
| gh (GitHub CLI) | — | créer des PR depuis le terminal (optionnel) |

Le plus simple : ouvrir le dépôt dans le **devcontainer** (`.devcontainer/`), qui a déjà tous ces outils — voir `README.md`. Sinon, en natif :

```bash
git clone git@github.com:Projet-decole/Histolyon.git && cd Histolyon
flutter pub get            # les dépendances de tout le workspace
lefthook install           # active les hooks git
melos run local            # Supabase local : migrations, content/ chargé et publié
melos run test             # tout doit être vert
melos run app              # l'app dans le navigateur, http://localhost:8080
```

Si tout est vert, tu es prêt. Sinon, ouvre une issue `socle` avec ce qui a cassé : c'est déjà une contribution.

## Annexe B — Les règles qu'on ne discute pas en PR

- `main` est protégé : PR, CI verte, une relecture, branche à jour, squash (§ 4a).
- Une migration par PR, dans l'ordre de l'Intégrateur ; jamais de modification de la base à la main (§ 4c).
- `packages/api_types` et `content/schema/` sont générés : on régénère, on n'édite pas (§ 4c).
- Aucune valeur visuelle en dur dans une feature : tout vient de `design_tokens` (§ 4b).
- Aucun secret dans le dépôt ; aucun média dans Git (§ 4a, § 1).
- Identifiants en français sans accent : `pin`, `epoque`, `parcours` — `snake_case` en SQL, `lowerCamelCase` en Dart.
- Chaque changement d'état (soumettre, valider, publier, retirer) est une fonction SQL ; l'app l'appelle, elle ne le réimplémente pas (§ 4c).
- Pas d'analytics, pas de tracking, pas d'identité civile collectée ; pas de thème sombre, pas de guidage pas-à-pas : c'est dans l'essence du projet (§ 0).

## Annexe C — Glossaire

| Mot | Ce que ça veut dire ici |
| --- | --- |
| **Domaine / Épic / Story** | Les trois niveaux de découpe (§ 2) : un chapitre de la conception / un sous-chapitre / une tâche élémentaire, qui est une issue. |
| **Brief** | Le corps d'une issue : objectif, à lire, tests, critères, fichiers (§ 2). |
| **Feature** | Un dossier `lib/features/<domaine>/`, avec ses couches `presentation`, `domain`, `data` (§ 4b). |
| **PR, squash, CI** | Demande de fusion ; fusion en un seul commit ; vérifications automatiques sur chaque PR (§ 4a). |
| **lefthook** | Les vérifications qui tournent sur ta machine avant chaque commit et push (§ 5). |
| **Migration** | Un fichier SQL qui modifie le schéma de la base, rejoué dans l'ordre partout (§ 4c). |
| **Supabase** | Le backend fourni : Postgres, authentification, stockage, règles d'accès. Trois environnements : `local`, `dev`, `demo` (§ 1, § 4a). |
| **pgTAP** | Les tests SQL de la base, un par règle métier (§ 5). |
| **Riverpod, go_router, Drift** | Gestion d'état, navigation, base locale de l'app Flutter. |
| **MapLibre, PMTiles** | Le moteur de carte, et le format du fond de carte de Lyon en un fichier (§ 1). |
| **Tokens, `ui_kit`** | Les variables et composants de la maquette Figma, portés en Dart avec les mêmes noms (§ 4b). |
| **Spine** | `docs/ARCHITECTURE-SPINE.md` : les règles d'architecture, chacune avec un identifiant `AD-n` stable (§ 9). |
| **AGENTS.md** | Le fichier d'instructions unique, humains et IA (§ 6). |
| **Casquette** | Une responsabilité tenue à deux pour une itération (§ 9). |
| **BMAD** | La méthode outillée qui a servi à construire le socle (`docs/archive/`). Abandonnée ensuite pour les issues courtes ; personne n'a besoin de l'installer. |
| **Rétro** | La rétrospective d'organisation, à chaque rendez-vous école (§ 9). |
