# Review — Réconciliation contexte du porteur ↔ ARCHITECTURE-SPINE

- Spine : `ARCHITECTURE-SPINE.md` (draft, 2026-09-17)
- Input : `.memlog.md` (entrées `constraint` / `direction` / `decision` / `question` / `version`)
- Méthode : chaque entrée du memlog est prise dans l'ordre ; pour chacune, on note où elle atterrit dans la spine (AD, convention, Deferred, Stack, arbre) et ce qui manque ou contredit.

## Verdict

La spine reprend fidèlement toutes les décisions techniques du memlog (stack, ownership, carto, hors-ligne, 3D, tests, environnements) et respecte la correction majeure du porteur sur la story « plus petite unité, sans calibrage » (AD-12). Ce qui n'a pas atterri, ce sont les exigences **humaines et de process** : l'attente école « IA maîtrisée et explicable » est absente, la cadence (itération 2 semaines, réunion 1 h) n'est écrite nulle part, la « colonne vertébrale BMAD consommable sans l'installer » n'existe que comme annotation d'arborescence, et AD-17 réintroduit en KPI un comptage de stories que le porteur a explicitement refusé.

## Tableau de réconciliation

Légende : ✅ couvert · ⚠️ partiel · ❌ absent · ✖ contradiction

| # | Memlog (ligne) | Type | Où ça atterrit dans la spine | Statut |
| --- | --- | --- | --- | --- |
| 1 | L9 Cadre Epitech : jury évalue la gestion de projet (organisation, avancement quantifié, KPIs, ajustement) | constraint 3.1 | AD-17 (KPIs), AD-18 (rétro/ajustement, « rien à montrer au jury ») | ✅ pour KPIs/rétro ; ⚠️ le frontmatter `purpose: build-substrate` omet les « livrables humains » du memlog (`purpose: build-substrate + livrables humains`), et `companions: []` alors que L19 annonce doc organisation + plan de bootstrap |
| 2 | L10 Équipe ~7 temps partiel, instable, rôles flous ; cheffe de projet (pilotage, 1er parcours, admin/légal) ; 2 spé 3D ; IDE/IA hétérogènes ; pas d'abonnement/BMAD garanti | constraint 3.1 | AD-15 (fichiers d'instructions générés par IDE), AD-18 (casquettes en binôme), arbre `prompts/` « collables dans toute IA + checklist sans IA » | ⚠️ l'hétérogénéité IA/BMAD n'est traitée que par une annotation de l'arbre, aucune règle ; la cheffe de projet qui rédige le 1er parcours devra écrire du YAML validé par JSON Schema via PR (AD-7) — aucun guide/recette ne la vise (`docs/guides/` ne cite que ajouter-une-feature, ecrire-une-migration) |
| 3 | L11 SharePoint imposé (page liste de suivi de progression comme ticketing) | constraint 3.1 | AD-17 : rapport `.md` collé dans SharePoint ; « SharePoint garde les CR de réunion, rien d'autre » | ✖ tension : la contrainte impose une **liste de suivi** ; L20 la transforme en « VUE alimentée (export script / jalons) » ; la spine dit « rien d'autre » et ne dit pas si la liste imposée est alimentée (export) ou abandonnée. « Rien d'autre » contredit aussi la phrase précédente (le rapport y est collé) |
| 4 | L12 Input = conception/, cité par ID, jamais re-documenté | constraint 3.1 | AD-15 (L2 jamais lue entière, `INDEX.md`, `tools/ctx`), AD-12 (la story cite par ID), frontmatter `sources` | ✅ |
| 5 | L13 [ADOPTED] Flutter mobile | constraint 3.2 | AD-1 [ADOPTED] | ✅ |
| 6 | L14 [ADOPTED] App sans compte, Profil local, Compte opt-in (I2, I6) ; I1 identité civile ; I3/I4 modération ; **pas de dark mode** ; **pas de turn-by-turn** | constraint 3.2 | AD-4 (Profil local/sync opt-in), AD-2 (I1–I10 en pgTAP), convention Vie privée, Deferred « outillage de modération » | ⚠️ « pas de dark mode » absent (AD-10 tokens ne fixe pas un thème unique) ; « pas de turn-by-turn » absent (implicitement cohérent : aucun moteur de routage dans la Stack, convention Proximité = géofencing local). Ce sont des [ADOPTED] du porteur : ils devraient au moins figurer en Prevents ou en convention pour qu'un dev ne les rouvre pas |
| 7 | L15 Orientation : BMAD colonne vertébrale consommable sans l'installer (principes + prompts + stories dans le repo) | direction 3.3 | AD-12 (template = format dev-story BMAD), arbre `prompts/` | ❌ pas d'AD ni de convention : rien ne dit qui produit avec BMAD, que les sorties sont committées, que `prompts/` est la version portable, ni qu'un membre sans BMAD/IA suit la checklist. C'est l'orientation « colonne vertébrale » et elle n'a pas de colonne |
| 8 | L15 Architecture documentaire « juste ce qu'il faut » par tâche | direction 3.3 | AD-15 (L3 la story liste les fichiers à lire) | ✅ |
| 9 | L15 CI/CD avec hooks pre-commit / pre-push | direction 3.3 | Stack lefthook, arbre `lefthook.yml` | ⚠️ le **contenu** décidé en L41 (pre-commit format+lint+schéma contenu ; pre-push tests unitaires de l'app touchée ; Actions filtrées par chemin) n'est dans aucune AD/convention |
| 10 | L15 Tests d'abord, vérifiés à chaque commit | direction 3.3 | AD-14 (1er commit = tests rouges, ordre relu, cliquet) | ✅ pour l'ordre ; ⚠️ « vérifiés à chaque commit » = hook pre-push, absent (cf. #9) |
| 11 | L15 Découpe en unités élémentaires, reprise en une session courte | direction 3.3 | AD-12 | ✅ (voir #24 pour le résidu « session ») |
| 12 | L16 Attente école : état des lieux quasi automatique | direction 2.1 | AD-17 `tools/report` | ✅ |
| 13 | L16 Attente école : KPIs mesurables par construction | direction 2.2 | AD-17, prérequis label domaine (AD-12) + issue liée (AD-13) | ✅ (mais voir #25 sur la nature des KPIs) |
| 14 | L16 Attente école : rétro/ajustement périodique documenté | direction 2.3 | AD-18 (`docs/team/retros/<date>.md`, issues `label:organisation`) | ✅ |
| 15 | L16 Attente école : **usage IA autorisé si maîtrisé et explicable** | direction 2.4 | — | ❌ aucune AD, convention ni Deferred : rien sur la traçabilité de l'usage IA (mention dans la PR, prompts versionnés et cités, relecture humaine obligatoire comme garde). AD-13 « relecture par un autre membre » y contribue sans le dire. Attente jury non adressée |
| 16 | L17 Porteur = goulet → rôles répartis, découpe autonome | direction 3.3 | AD-18 (6 casquettes × 2 titulaires), AD-12 Prevents « découpe que seul le porteur sait faire », arbre `prompts/decoupe` | ✅ ; ⚠️ la casquette « Dev » listée par le porteur n'apparaît pas (acceptable : c'est tout le monde) ; L37 « Découpeur = porteur + binôme utilise bmad-spec / bmad-create-epics-and-stories » n'est pas écrit |
| 17 | L18 Questions ouvertes : moteur carto / étendue hors-ligne / auth / templates contenu + CMS / médias lourds / stack back-office / moteur 3D / lien universel / state management | question | AD-8 / AD-9 / Deferred auth / AD-7 / Structural seed Storage `audio · images · models` + AD-11 bucket `models` / AD-1 / Deferred + AD-11 / Deferred / convention État | ✅ toutes tranchées ou différées ; ⚠️ « stockage médias lourds » n'a qu'un diagramme et un bucket `models`, pas de convention (buckets, tailles, formats audio/images) |
| 18 | L19 Livrables = spine + doc organisation + plan de bootstrap (public : équipe + jury) | event | `companions: []` | ❌ les deux compagnons n'existent pas dans le dossier et la spine ne les annonce pas ; plusieurs manques ci-dessous (cadence, rôles BMAD, IA) trouveraient naturellement leur place dans la doc organisation — mais la spine devrait alors les référencer |
| 19 | L20 GitHub = vérité du travail, SharePoint = vue alimentée | decision | AD-17, AD-12 | ✅ (nuance #3) |
| 20 | L21 Supabase | decision | AD-2, Stack, Structural seed | ✅ |
| 21 | L22 Contenu-en-fichiers dès le bootstrap, admin le plus tôt possible | decision | AD-7 (phase 1/2), Capability map D10 | ✅ |
| 22 | L23 Monorepo (apps, supabase, content, docs, conception, prompts) | decision | Paradigm, arbre | ✅ |
| 23 | L24 Spécialistes 3D : pas graphistes, assets récupérés sur internet, s'adaptent ; objectif 1 bâtiment dans le 1er parcours ; **contrat** (format, stockage, déclenchement) | constraint 3.1 | AD-11 (glTF/GLB, bucket `models`, `ImmersionViewer(modelRef)`) | ✅ format + stockage ; ⚠️ « déclenchement » réduit à une signature (depuis quel écran / quelle entité ? le Pin ?) ; ⚠️ assets récupérés sur internet → provenance/licence du Modèle 3D non couverte (la convention Statut & provenance vise le contenu éditorial) |
| 24 | L25 Personne n'a fait Flutter ni carto → courant dominant, chemins pavés ; onboarding par la doc du repo | constraint 3.1 | AD-1 Prevents, AD-15, `docs/guides/` | ⚠️ le principe « chemins pavés » n'est pas une convention (ex. : packages Flutter Favorite / officiels d'abord, pas de fork) ; aucun guide d'onboarding « premier jour » n'est nommé |
| 25 | L26 Feature-first × couches strictes, Riverpod codegen, go_router, tokens 1:1 | decision | AD-5, AD-6, convention État, AD-10 | ✅ |
| 26 | L27 MapLibre, style par époque, tuiles vectorielles, PMTiles | decision | AD-8, Stack | ✅ |
| 27 | L28 Ownership (schéma SQL, types générés, serveur/terminal, contenu-fichiers) | decision | AD-2, AD-3, AD-4, AD-7 | ✅ (« Dart/TS » → Dart seul, cohérent avec L43) |
| 28 | L29 Hors-ligne = paquet par parcours | decision | AD-9 | ✅ |
| 29 | L30 Contrat 3D, moteur différé | decision | AD-11, Deferred | ✅ |
| 30 | L31 Drift ; Hive/Isar écartés | version | Stack | ✅ |
| 31 | L32 Capacité réelle : ~3–4 h dev + 1 h réunion / 2 semaines ; CR de réunion sur SharePoint | constraint 3.1 | AD-17 (CR SharePoint) | ⚠️ la capacité n'est nulle part — c'est volontaire (L38) — mais la **cadence** qui en découle (L35) n'y est pas non plus (voir #34) |
| 32 | L33 Story ≤ 3 h, auto-suffisante ; 1 issue = 1 branche = 1 PR ; **arbre Domaine → Épic → Story** ; IDs conception = labels | decision (amendée par L38) | AD-12 | ✅ « ≤ 3 h » correctement retiré (respect de L38) ; ❌ le niveau **Épic** n'existe pas dans la spine (ni label, ni milestone, ni `docs/spec`) alors que L37 en fait la sortie de bmad-create-epics-and-stories |
| 33 | L34 Trunk-based, main protégé, CI verte + 1 relecture, squash, `story/<ID>-<slug>` | decision | AD-13 | ✅ |
| 34 | L35 Cadence : **itération 2 semaines**, synchro asynchrone, réunion 1 h / 2 sem, rétro à chaque rendez-vous école | decision | AD-18 (rétro) ; AD-13 et AD-17 utilisent le mot « itération » sans le définir | ❌ « itération = 2 semaines » et « réunion 1 h / 2 semaines » ne sont écrits nulle part ; AD-13 « pas de branche de plus d'une itération » et AD-17 « stories fermées par itération » reposent sur une définition absente |
| 35 | L36 Doc 4 niveaux | decision | AD-15 | ✅ |
| 36 | L37 BMAD produit, le repo distribue : Découpeur utilise bmad-spec / bmad-create-epics-and-stories ; sorties committées **docs/spec**, docs/stories, docs/sprint/sprint-status.yaml ; format story = template d'issue ; prompts/ portables + checklist sans IA ; ROLES.md vivant | decision | AD-12 (template), AD-18 (ROLES.md), arbre (`docs/stories`, `docs/sprint/sprint-status.yaml`, `prompts/`) | ⚠️ `docs/spec` absent de l'arbre ; le rôle de BMAD dans la chaîne de production (qui, quel skill, quelle sortie) n'est écrit dans aucune règle ; « checklist sans IA » = annotation d'arbre seulement (cf. #7) |
| 37 | L38 **Correction porteur : NE PAS compter les stories ni calibrer sur la capacité ; pas grave si tout n'est pas fini ; story = plus petite unité, point** | constraint (correction) | AD-12 (« plus petite unité de travail ») | ✅ AD-12 respecte la correction ; ✖ AD-17 la contredit partiellement : ses KPIs incluent « **stories fermées par itération** » et « fait / en cours / **reste** par domaine » — un comptage de stories de tailles inégales, lu par un jury comme une vélocité, et un « reste » qui présuppose un périmètre total à finir, ce que le porteur a explicitement relativisé. Résidu mineur dans AD-12 Prevents : « trop larges pour une session » réintroduit la session comme étalon |
| 38 | L39 Tests d'abord, ordre strict ; mécanismes : section Tests avant Implémentation dans la story, 1er commit = tests, checklist PR, Gardien des tests relit ; cliquet | decision | AD-14, arbre `PULL_REQUEST_TEMPLATE.md`, AD-18 (Gardien des tests) | ✅ ; ⚠️ AD-14 dit « relu » sans nommer le Gardien des tests ; la section « Tests avant Implémentation » du template n'est pas exigée par AD-12 |
| 39 | L40 Politique de tests par couche (pas de golden au début) | decision | AD-14 | ✅ (« pas de golden au début » omis, mineur) |
| 40 | L41 CI/CD : lefthook (contenu des hooks), Actions filtrées par chemin, 3 environnements, secrets | decision | AD-16 (environnements, secrets), Stack lefthook, arbre workflows | ⚠️ hooks et filtrage par chemin sans règle (cf. #9) |
| 41 | L42 Android seulement, APK artefact CI ; iOS différé | decision | AD-1 (Android), Structural seed (APK), Deferred iOS | ✅ |
| 42 | L43 Back-office Flutter Web, hébergé statique | decision | AD-1, Deferred hébergeur | ✅ |
| 43 | L44 Page publique différée | decision | Deferred | ✅ |
| 44 | L45 KPIs par construction, prérequis label + issue liée | decision | AD-17, AD-12, AD-13 | ✅ |
| 45 | L47–L49 Versions vérifiées, supadart, tuiles | version / constraint | Stack, AD-3, Deferred supadart | ✅ |

## Contradictions relevées

1. **AD-17 vs correction L38** — « stories fermées par itération » et « reste par domaine » comptent des stories et supposent un périmètre à finir ; le porteur a dit de ne pas compter les stories et que ne pas tout finir n'est pas grave. À reformuler en KPIs indépendants de la taille : domaines couverts (Dx avec ≥ 1 story fusionnée sur le parcours démo), délai story→fusion, taux de CI verte, couverture, actions de rétro closes ; si les stories sont comptées, l'écrire comme mesure descriptive, jamais comme objectif.
2. **AD-17 vs contrainte L11 / décision L20** — « SharePoint garde les CR de réunion, rien d'autre » contredit à la fois la contrainte imposée (liste de suivi de progression) et la décision (SharePoint = vue **alimentée**). Il faut dire ce que devient la liste imposée : alimentée par `tools/report` (export), ou remplacée par le rapport collé avec l'accord de l'école.
3. **Frontmatter** — `purpose: build-substrate` vs memlog `build-substrate + livrables humains` ; `companions: []` vs L19 (doc organisation + plan de bootstrap). Pas une contradiction de fond, mais la spine se présente comme le seul livrable alors que le memlog en promet trois.

## Manques (par ordre d'importance)

1. **Usage IA maîtrisé et explicable (attente école 2.4)** — absent. Proposition : convention « IA » (la PR déclare l'assistance IA et le prompt utilisé ; `prompts/` versionné est la seule source de prompts ; toute contribution IA est relue par un humain — AD-13 le garantit déjà, il faut le dire).
2. **Cadence** — « itération = 2 semaines ; réunion 1 h / 2 semaines ; synchro asynchrone par rapport généré » absent, alors que AD-13 et AD-17 s'y réfèrent.
3. **BMAD colonne vertébrale consommable sans l'installer (orientation 3.3)** — seulement une annotation d'arbre. Manque une AD ou convention « Production des stories » : Découpeur (binôme) produit avec bmad-spec / bmad-create-epics-and-stories, sorties committées (`docs/spec`, `docs/stories`, `docs/sprint/sprint-status.yaml`), `prompts/` = équivalent portable + checklist sans IA.
4. **Niveau Épic** — l'arbre Domaine → Épic → Story (L33, L37) n'a pas de représentation (milestone GitHub ? label ? `docs/spec`) ; `docs/spec` absent de l'arborescence.
5. **Contenu des hooks et filtrage CI par chemin (L41)** — lefthook est dans la Stack mais ce que font pre-commit / pre-push n'est écrit nulle part ; « tests vérifiés à chaque commit » (L15) n'a donc pas de garde.
6. **[ADOPTED] produit** : « pas de dark mode », « pas de turn-by-turn » — à porter en Prevents (AD-10, convention Proximité) pour qu'ils ne soient pas rouverts.
7. **Contrat 3D** — « déclenchement » sous-spécifié ; provenance/licence des assets récupérés sur internet non couverte.
8. **Onboarding d'une équipe qui n'a jamais fait Flutter/carto** — principe « chemins pavés » et guide d'onboarding non nommés ; la cheffe de projet qui rédige le 1er parcours en YAML n'a pas de recette.
9. **Médias lourds** — pas de convention buckets/formats au-delà du diagramme.

## Ce qui est bien atterri (pour mémoire)

Toutes les décisions techniques (L21, L23, L26–L31, L34, L36, L39–L45, L47–L49) sont reprises sans dérive, avec leurs Prevents. La correction L38 est respectée dans AD-12 (le « ≤ 3 h » a bien disparu). Les questions ouvertes de L18 sont toutes tranchées ou différées avec une condition de revisite.
