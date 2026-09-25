# Checklist — dérouler une story HistoLyon sans aucun outil IA

Cette checklist te permet de prendre une story de bout en bout, seul, sans coller quoi que ce soit dans un assistant IA. Elle couvre les mêmes règles que `prompts/dev-story.md` (tests d'abord, zones/couches, format de commit et de PR) sans l'étape « coller dans un outil » — et, en plus, les étapes mécaniques (prendre l'issue, brancher, fusionner) qui restent implicites dans `dev-story.md` puisqu'elles ne concernent que toi, pas l'assistant IA. Coche au fur et à mesure ; si une case ne peut pas être cochée, c'est un signal à remonter dans l'issue, pas un blocage à contourner seul.

## 1. Prendre

- [ ] J'ai choisi une issue GitHub ouverte et non assignée, dans un domaine qui m'intéresse.
- [ ] Je me suis assigné l'issue. (Pas besoin de demander la permission à personne.)

## 2. Lire

- [ ] J'ai lu le corps de l'issue en entier : c'est le brief complet (objectif, extraits de conception à lire, tests attendus, critères de fin, fichiers à toucher).
- [ ] J'ai lu les extraits de conception qu'elle cite — rien de plus (pas besoin de lire toute la conception).
- [ ] Si quelque chose manque pour comprendre ce qu'il faut faire (information absente, extrait introuvable) : j'ai commenté l'issue en mentionnant la personne qui découpe les stories, **je n'ai pas deviné**.

## 3. Brancher

- [ ] Je suis parti d'une copie à jour de `main` :
  ```bash
  git switch main && git pull
  ```
- [ ] J'ai créé ma branche avec le nom de la story :
  ```bash
  git switch -c story/<ID>-<slug>     # ex. story/D2.4-02-apercu-rapide
  ```

## 4. Tests d'abord

- [ ] J'ai écrit les tests décrits par le brief **avant tout code**, et ils sont rouges (le comportement qu'ils vérifient n'existe pas encore).
- [ ] J'ai utilisé le bon type de test pour la couche touchée : tests unitaires pour la logique, tests contre une base Supabase locale (ou un double explicite) pour l'accès aux données, tests de composants pour un écran, tests SQL (pgTAP) pour une règle de base de données, validation de format pour du contenu.
- [ ] Mon premier commit ne contient que ces tests :
  ```bash
  git commit -m "test(<zone>): <sujet> #<issue>"
  ```

## 5. Coder

- [ ] Je code uniquement dans la zone de ma story : une seule feature (`features/<domaine>/`), ou uniquement `supabase/`, ou uniquement `content/`, ou un seul package de `packages/` — jamais deux zones dans la même story. Si je découvre en cours de route que le travail touche en réalité deux zones, je m'arrête et je remonte le signal dans l'issue plutôt que de continuer à coder.
- [ ] Je respecte le sens des couches à l'intérieur d'une feature : les écrans (`presentation/`) ne parlent jamais directement à la base, ils passent par la logique (`domain/`) puis l'accès aux données (`data/`).
- [ ] Je n'importe jamais une autre feature depuis la mienne. Ce dont j'ai besoin et qui est déjà partagé, je le prends dans `core/` (pour l'app) ou `packages/` (pour les deux apps) — je ne le duplique pas.
- [ ] Toute écriture en base passe par le repository de ma feature ; toute transition d'état (valider, publier, retirer, modérer, etc.) est une fonction SQL exposée en RPC — jamais un `UPDATE` direct depuis l'app.
- [ ] Je n'écris aucune couleur ni taille en dur : si le projet a déjà des tokens de design, je les utilise ; sinon je remonte le manque plutôt que d'improviser une valeur.
- [ ] Je commite au format `type(zone): sujet #<issue>`, en avançant jusqu'à ce que mes tests passent.
- [ ] J'ai lancé les vérifications avant de pousser :
  ```bash
  melos run analyze
  melos run test
  ```
  Si `lefthook` est installé, il les lance en partie automatiquement à chaque commit/push — mais je vérifie quand même avant d'ouvrir la PR. Si ça échoue encore après plusieurs tentatives de correction, je n'itère pas indéfiniment seul : je note où je bloque dans l'issue.

## 6. Ouvrir la PR

- [ ] La PR référence l'issue pour la fermer automatiquement : `Closes #<issue>`.
- [ ] La description rappelle que le premier commit est bien celui des tests.
- [ ] La description déclare l'assistance IA en texte libre : `Outil utilisé : aucune IA utilisée` (ou, si j'ai quand même utilisé un outil ponctuellement, je le déclare précisément — outil, ce qu'il a produit).
- [ ] Si le dépôt a un modèle de PR (`.github/PULL_REQUEST_TEMPLATE.md`), je l'ai suivi tel quel plutôt qu'improvisé un format différent. S'il n'existe pas encore, j'utilise cette structure minimale :
  ```
  ## Résumé
  <ce que fait la story, en 2-3 lignes>

  ## Tests
  - Premier commit : <liste des tests ajoutés, rouges puis verts>

  ## Vérifications
  - [ ] melos run analyze
  - [ ] melos run test

  ## Assistance IA
  Outil utilisé : aucune IA utilisée.

  Closes #<numéro>
  ```
- [ ] Ma branche est à jour avec `main` avant de demander la fusion.

## 7. Relecture

- [ ] Une autre personne que moi relit la PR et vérifie : les critères d'acceptation sont atteints, les tests précèdent le code dans l'historique des commits, le code est dans la bonne zone, rien d'autre n'a été modifié.
- [ ] Si la relecture prend plus de 15 minutes, je le note pour la rétro : c'est le signe que la story était trop grosse, pas un problème personnel.

## 8. Fusion

- [ ] La PR est fusionnée en squash sur `main` une fois la CI verte et la relecture faite.
- [ ] L'issue se ferme automatiquement (grâce au `Closes #<issue>` de l'étape 6).

---

**Je n'ai pas fini dans ma session ?** Je pousse ma branche en l'état et j'écris dans l'issue où j'en suis (ce qui est fait, ce qui reste). N'importe qui — moi plus tard, ou quelqu'un d'autre — peut reprendre à partir de là : c'est pour ça que le brief est complet et que la story est petite.
