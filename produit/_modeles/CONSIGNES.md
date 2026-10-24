# Consignes communes aux rédacteurs de `produit/` (lot 1)

Ce fichier n’est pas une unité du corpus (dossier `_modeles/`, ignoré par `ctx`).
Tu es un sous-agent chargé d’un groupe d’unités. Réponds et écris en français.

## Règle d’or : ne rien inventer
- Tout fait renvoie à une source `conception/…:ligne` (frontmatter `sources`, une
  ligne par fichier source utile, ligne = début du bloc d’où vient le fait) ou à une
  décision DEC-01…DEC-15 (`produit/decisions/`).
- Si deux sources se contredisent : ne tranche pas seul. Écris une proposition dans
  `produit/decisions/` (fichier `DEC-nn.md`, numéro dans ta plage, statut `mvp`,
  corps « Décision proposée / Sources en conflit / Conséquence »), et applique dans
  l’unité la solution la plus prudente en le disant (« voir DEC-nn »).
- Question qui bloque encore : registre `QO` (voir plus bas), jamais dans le corps
  hors lien `QO-…`.
- Interdit de modifier quoi que ce soit hors `produit/` (`conception/` est gelé).
  Ne touche pas aux fichiers des autres groupes.

## Format et identifiants
Gabarits dans `produit/_modeles/` (CAP, ECR, COMP, FLX, ENT, DEC). Frontmatter YAML
complet, puis corps en français : phrases courtes, règles numérotées `R1…`, critères
de fin `CF1…` testables, section `Hors MVP` explicite.

Identifiants (nom de fichier = id + `.md`) :
- `CAP-D1.2` (capacité, ancien id `D1.2`) · `ECR-CARTE-PRINCIPALE` (ancien
  `E-CARTE-PRINCIPALE`, retirer `E-`) · `COMP-PIN` (ancien `comp-pin`, majuscules)
  · `FLX-A1` (ancien `A1`) · `ENT-PIN`, `ENT-MODELE-3D`, `ENT-HISTORIQUE-DE-VISITE`
  (ancien `historique_de_visite`, majuscules, `_` → `-`) · `INV-01` (ancien `I1`,
  deux chiffres) · `TOK-COLOR-…` (identique à l’ancien) · `TOK-MAP-…`, `TOK-CHO-…`,
  `TOK-TMP-…`, `TOK-DUR-…`, `TOK-CRV-…` (ancien préfixé par `TOK-`) · `ICN-CAT-…`,
  `ICN-UI-…` (ancien `ICON-…` sans `ICON-`) · `EPQ-ANTIQUITE-ROMAINE` (slug de
  `content/epoques/*.yaml`) · `MOD-M1…M9` · `SRF-S1…S3`, `SRF-P1…P3` · `DEC-nn` ·
  `QO-nnn` · `JAL-FU2`, `JAL-FU3`, `JAL-GEL`, `JAL-ORAL`, `JAL-RENDU`, `JAL-S2` ·
  `DOC-…` (documents transversaux).
- L’ancien id va dans `anciens_ids` (liste de chaînes). Les identifiants ambigus de
  `conception/` (D…, C…, E…, P…) ne doivent JAMAIS apparaître seuls dans le corps :
  écris l’identifiant neuf (ex. `CAP-D1.2`, `FLX-C5`).
- Tout identifiant neuf cité dans un corps (`CAP-…`, `ECR-…`, `INV-…`, `TOK-…`…)
  doit exister : `ctx check` le vérifie. Les TOK-, ICN-, EPQ-, MOD-, SRF-, INV- sont
  définis par d’autres groupes (sections `## TOK-…` de `design/`, `## INV-nn` de
  `donnees/INVARIANTS.md`, etc.) : cite-les avec les règles de nommage ci-dessus.
  Les manquants seront corrigés à l’intégration.
- Clés de `liens` : `ecrans`, `flux`, `entites`, `invariants`, `composants`,
  `decisions`, `capacites`, `questions`. Valeurs : identifiants neufs.
- `sources` : `conception/chemin/fichier.yaml:123` (le chemin et la ligne sont
  vérifiés), `content/…:ligne`, `packages/…`, ou `brief:lot1` pour une décision.
- `statut` : `mvp`, `s2` ou `hors-perimetre`. `derniere_verif: 2026-10-24`.
- Typographie : guillemets « », apostrophe ’ dans le corps français, points de
  suspension …, pas d’emoji. Interface au vouvoiement, récit au tutoiement (DEC-14).
- Motifs interdits partout dans `produit/` (hors `decisions/`) : `design/conception`,
  `palier 16`, `persona_check`. Pas de références mortes (« palier 7 », « cluster 03 »…) :
  remplace par l’unité neuve ou supprime.

## Budgets (tokens ≈ caractères ÷ 3,5, frontmatter compris)
CAP ≤ 2 500 (vise 1 500–2 000) · ECR ≤ 2 000 (vise 1 000–1 500) · COMP ≤ 800
(vise 400–600) · FLX ≤ 500 (vise 300–400) · ENT ≤ 1 500. Le `ctx pack` d’une capacité
MVP doit rester ≤ 8 000 : vérifie avec `dart run tools/ctx.dart pack CAP-D1.2`.
Reste sous les plafonds en gardant l’essentiel (règles, états, critères de fin).
`budget_tokens` du frontmatter = plafond du type (2500, 2000, 800, 500, 1500).

## Tri bloc par bloc (source → unité)
- Garder : comportement, `regles_fonctionnelles`, états, `definition_of_done`,
  dépendances utiles. « Raison d’être » en ≤ 3 lignes.
- Retirer : `persona_check`, `perimetre`, `test_de_purete`, `heritage_*`,
  `articulation_paliers_*`, `prerequis_de_lecture`, blocs `document:`.
- Déplacer les `questions_ouvertes` encore bloquantes vers le registre QO.
- Un seul foyer pour un fait dupliqué (renvoie par identifiant).
- **Chaque règle** de `regles_fonctionnelles` et chaque ligne de
  `definition_of_done` des capacités MVP est soit reprise (adaptée au MVP), soit
  listée dans ton fichier `decisions/_tri-<GROUPE>.md` avec la raison du rejet
  (hors MVP + DEC, contradiction, doublon…). Reporte pour chaque règle : source
  (`fichier:ligne`) → `reprise dans <ID>/R<n>` ou `rejetée : <raison>`.

## Fichiers annexes obligatoires de ton groupe
- `produit/decisions/_tri-<GROUPE>.md` (frontmatter : `id: DOC-TRI-<GROUPE>`,
  `type: document`, `titre`, `statut: mvp`, `sources: [brief:lot1]`,
  `derniere_verif`) : table de recouvrement des règles + ce qui n’est pas repris.
- `produit/decisions/QO-<GROUPE>.md` (`id: DOC-QO-<GROUPE>`) : sections
  `## QO-nnn — question` (plage de numéros dans ta mission) avec : pourquoi elle
  bloque, unité concernée, source. Peut être vide (« Aucune question ouverte »).
- Contradictions et défauts de source : `DEC-nn.md` dans ta plage.

## Outils (légers uniquement)
`dart run tools/ctx.dart lire|pack|chercher|refs|liste|chemin|check` (corpus
`produit/`), et `dart run tools/ctx.dart <ID>` (ancien usage : extrait de
`conception/`). Lecture des sources avec Read/Grep sur `conception/`. Interdit :
Docker, flutter, melos, supabase, build_runner, `git push`, accès réseau, ajout de
dépendance. `ctx check` signale aussi les fichiers des autres groupes en cours
d’écriture : ne regarde que les erreurs de tes fichiers (filtre sur leurs noms).
Ne lance pas `git commit` : l’intégrateur s’en charge. Termine par un rapport
court : fichiers écrits, tokens par unité, règles rejetées, contradictions
(DEC-nn), QO, ce que tu n’as pas pu faire.

## Décisions déjà tranchées (lire `produit/decisions/DEC-01.md` … `DEC-15.md`)
DEC-02 D2.3 reporté · DEC-03 D2.6 minimal (récit + encarts texte) · DEC-04 contenu
embarqué (instantané) · DEC-05 parcours pas à pas manuel, ni géoloc ni proximité ni
choix terrain/canapé · DEC-06 carte sans géoloc, emprise des tuiles, un style ·
DEC-07 l’utilisateur prime sur le slider · DEC-08 10 époques de
`content/epoques/*.yaml` « à valider par l’historienne » · DEC-09 étape sautée non
complétée, « X étapes vues sur Y » · DEC-13 tranche verticale complète · DEC-14
tutoiement narratif / vouvoiement interface.

Composants hors MVP « neutralisés » (cités dans « Hors MVP » de l’écran, pas
écrits) : audio, commentaires, post-narratif, favori, partage, signalement, quiz,
énigme, avant/après, puzzle, frise, vidéo, carrousel d’archives, permission,
proximité, onboarding.
