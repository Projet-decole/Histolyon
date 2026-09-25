---
title: 'tools/ctx et conception/INDEX.md'
type: 'feature'
created: '2026-09-18'
status: 'done'
baseline_revision: '582f7c428d5e69a3a62429831553081cacc2972f'
review_loop_iteration: 0
followup_review_recommended: true
context: []
warnings: []
deferred:
  - summary: >-
      Aucune vérification automatisée (CI/pre-commit/melos) ne détecte un `conception/INDEX.md`
      devenu périmé après une modification de `conception/*.yaml`.
    evidence: |-
      L'index n'est régénéré que sur invocation manuelle de `dart run tools/ctx.dart --index`.
      `docs/epics.md` (NFR1) : "les checks CI cités en 02–05 sont câblés en 09 et s'exécutent
      en local d'ici là" — la vérification automatisée de fraîcheur de `conception/INDEX.md`
      relève explicitement de l'Epic 9, pas de l'Epic 2.
    location: >-
      tools/ctx.dart (mode --index), conception/INDEX.md
    severity: medium
---

<intent-contract>

## Intent

**Problem:** `conception/` (144 fichiers YAML/Markdown, jamais lue en entier par convention AD-15) n'a aucun moyen d'être adressée par extrait : ni script pour afficher le bloc correspondant à un ID cité dans une story, ni index recensant les ID existants.

**Approach:** Un script Dart `tools/ctx.dart` (convention déjà établie par `tools/check_import_direction.dart`, invoqué via `dart run tools/ctx.dart <arg>`) qui, pour un ID donné, imprime le ou les extraits YAML correspondants ; et, en mode index (`dart run tools/ctx.dart --index`), régénère `conception/INDEX.md`.

## Boundaries & Constraints

**Always:** `conception/` reste strictement en lecture seule (le script ne lit jamais que pour extraire, n'écrit jamais dedans) ; un ID introuvable produit une erreur claire sur stderr et un code de sortie non nul ; `conception/INDEX.md` est entièrement régénéré à chaque exécution (idempotent : rejouer sans changement de `conception/` ne produit aucun diff).

**Never:** Ne jamais modifier un fichier sous `conception/` ; ne pas exiger de dépendance pub externe (le script utilise uniquement `dart:io`/`dart:core`, comme `check_import_direction.dart`) ; ne pas tenter de désambiguïser silencieusement un ID dupliqué en n'en gardant qu'un — un ID qui apparaît à plusieurs endroits doit toutes les montrer.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| ID structuré unique | `D1.2` (une seule occurrence `- id: D1.2` dans `conception/`) | Imprime l'extrait YAML de ce bloc, précédé d'un en-tête `# <fichier>:<ligne>` | — |
| ID dupliqué | `comp-icone` (5 occurrences `- id: comp-icone`) | Imprime les 5 extraits, chacun avec son propre en-tête `# <fichier>:<ligne>`, triés par chemin de fichier | — |
| ID chemin | `07-ecrans/carte/01` (aucun `- id:` correspondant, mais préfixe de fichier existant) | Imprime le contenu entier de `conception/07-ecrans/carte/01-principale.yaml` | — |
| ID introuvable | `XYZ-INEXISTANT` | Rien sur stdout | Message clair sur stderr, code de sortie non nul |
| Génération d'index | `--index` | Écrit `conception/INDEX.md` : une table par `- id:` trouvé (id, fichier:ligne) et une table des fichiers adressables par chemin | — |
| Index inchangé | `--index` rejoué sans modification de `conception/` | `conception/INDEX.md` regénéré à l'identique | Aucun diff |

</intent-contract>

## Code Map

- `conception/` -- 124 fichiers, 885 occurrences de la clé `- id: <valeur>` toutes profondeurs confondues (`grep -rn "^\s*- id:" conception/ | wc -l`), y compris des doublons réels et voulus (ex. `D1.2` apparaît dans `03-fonctionnalites/01-carte-exploration-temporelle.yaml:153` -- définition détaillée -- et 2 fois dans `03-fonctionnalites/00-index.yaml:356,521` -- listés dans des sections de synthèse). Les préfixes observés couvrent des catalogues très divers : `D<n>[.<n>]` (domaines/sous-domaines), `I<n>` (invariants), `comp-*` (composants, AD-10), `TOK-*`/`ICON-*`/`CRV-*`/`DUR-*`/`HAP-*`/`TMP-*`/`SHA-*`/`CHO-*`/`ETAT-*`/`MAP-*`/`PI-*`/`E-*` (catalogues de tokens/interactions/écrans), et des identifiants plus locaux en snake_case (personas, champs de modèle de données). Aucune tentative de classification sémantique n'est faite : chaque occurrence de `- id:` est traitée uniformément comme une entrée adressable (choix documenté ci-dessus, "Never").
- `conception/07-ecrans/carte/01-principale.yaml` (et similaires) -- exemple de fichier adressable par chemin (`07-ecrans/carte/01`), le préfixe numérique du nom de fichier sans son suffixe descriptif ni son extension.
- `conception/15-maquette.md` -- seul fichier non-YAML de `conception/` ; adressable uniquement par chemin (pas d'extraction `- id:` applicable), affiché en entier si ciblé par chemin.
- `tools/check_import_direction.dart` -- référence de convention existante : script Dart autonome (`dart:io` seul), invoqué via `dart run tools/<nom>.dart`, câblé dans `pubspec.yaml` (`scripts.analyze`). `tools/ctx.dart` suit la même convention (pas de câblage melos requis par l'AC, mais le fichier vit au même endroit).
- `docs/architecture/architecture-HistoLyon-2026-09-17/ARCHITECTURE-SPINE.md:287` -- `conception/INDEX.md # GÉNÉRÉ — id → fichier#ancre` ; aucune autre précision de format n'existe dans la conception ou l'architecture, d'où le choix `fichier:ligne` comme substitut d'ancre (YAML n'a pas d'ancres natives).

## Tasks & Acceptance

**Execution:**
- `tools/ctx.dart` -- créer le script : parcourt `conception/**/*.yaml` (lecture ligne à ligne, pas de dépendance YAML externe) pour trouver toutes les lignes `^\s*-\s*id:\s*"?<ID>"?\s*$` correspondant à l'argument ; pour chaque match, imprime un en-tête `# <chemin>:<ligne>` puis le bloc depuis cette ligne jusqu'à la prochaine ligne de même indentation (ou moindre) non vide, ou fin de fichier. Si aucun match, tente une résolution par chemin (fichier dont le chemin relatif sous `conception/`, sans extension, égale ou commence par l'argument) et affiche le fichier entier si trouvé ; sinon erreur stderr + exit non nul. -- cœur de l'AC 1
- `tools/ctx.dart` -- ajouter le mode `--index` : régénère `conception/INDEX.md` avec deux tables Markdown ("Par ID" : id, fichier:ligne, une ligne par occurrence triée par chemin puis ligne ; "Par fichier" : chemin adressable, fichier réel), en écrasant tout contenu existant. -- cœur de l'AC 2
- `docs/stories/spec-2-2-tools-ctx-et-conception-index-md.md` -- consigner dans Implementation Notes la sortie réelle de `dart run tools/ctx.dart D1.2` et de la génération d'index -- preuve auditable

**Acceptance Criteria:**
- Given `conception/` importée, when `dart run tools/ctx.dart D1.2` est exécuté, then les 3 extraits YAML réels (`01-carte-exploration-temporelle.yaml:153`, `00-index.yaml:356`, `00-index.yaml:521`) s'affichent, chacun avec son en-tête `# fichier:ligne`.
- Given `conception/` importée, when `dart run tools/ctx.dart --index` est exécuté, then `conception/INDEX.md` est généré et couvre les 885 occurrences `- id:` ainsi que tous les fichiers adressables par chemin sous `conception/`.
- Given `conception/INDEX.md` déjà généré sans changement de `conception/`, when `dart run tools/ctx.dart --index` est rejoué, then aucun diff n'apparaît (idempotent).

## Implementation Notes

- `tools/ctx.dart` écrit sans dépendance pub tierce (`dart:io` seul), même convention que `tools/check_import_direction.dart`. Deux modes : lookup (`<ID>` ou `<chemin>`) et `--index`.
- Extraction de bloc par indentation : depuis la ligne `- id: <ID>` (indentation mesurée en nb d'espaces de tête), le bloc s'étend jusqu'à la prochaine ligne non vide de même indentation ou moindre (ou fin de fichier) ; les lignes vides finales sont retirées. Vérifié visuellement sur `D1.2` (le bloc s'arrête juste avant le séparateur `# ===...` précédant `D1.3`, à la bonne profondeur).
- En-tête `# <chemin>:<ligne>` : le chemin est relatif à `conception/` (sans le préfixe `conception/`), pour rester dans le même espace d'adressage que les arguments de résolution par chemin (`07-ecrans/carte/01`, pas `conception/07-ecrans/carte/01`) — la matrice I/O de la spec dit tantôt « fichier », tantôt « chemin » sans trancher le format exact ; ce choix a été documenté ici faute de test explicite sur la forme littérale.
- Résolution par chemin : « le chemin relatif sous `conception/`, sans extension, égale ou finit par l'argument » (texte de la spec) est interprété comme un **préfixe** (`relNoExt == arg || relNoExt.startsWith(arg)`), cohérent avec l'exemple donné (`07-ecrans/carte/01` doit matcher `07-ecrans/carte/01-principale.yaml`, ce qui est un `startsWith`, pas un `endsWith` littéral) et avec le Code Map (« le préfixe numérique du nom de fichier »). Si plusieurs fichiers partagent ce préfixe, tous sont affichés (même philosophie que pour un ID dupliqué : jamais de désambiguïsation silencieuse).
- `conception/INDEX.md` s'exclut lui-même de la table "Par fichier" (et n'est jamais scanné pour des `- id:` puisque ce n'est pas un `.yaml`) : c'est l'artefact généré, pas du contenu adressable de `conception/`.
- Sortie réelle de `dart run tools/ctx.dart D1.2` (en-têtes seuls, le contenu complet a été vérifié visuellement) :
  ```
  # 03-fonctionnalites/00-index.yaml:356
  # 03-fonctionnalites/00-index.yaml:521
  # 03-fonctionnalites/01-carte-exploration-temporelle.yaml:153
  ```
  Les 3 occurrences attendues par l'AC sont bien les 3 seules imprimées, dans cet ordre (trié par chemin puis ligne).
- Sortie réelle de `dart run tools/ctx.dart --index` :
  ```
  tools/ctx: conception/INDEX.md régénéré (885 entrées "Par ID", 124 fichiers "Par fichier").
  ```
  885 correspond exactement à `grep -rn "^\s*- id:" conception/ | wc -l`. 124 fichiers (122 `.yaml` + `15-maquette.md` + 1 fichier racine `01-essence.yaml`/`02-personas.yaml`, etc. — décompte réel via `find conception -type f | wc -l`, `conception/INDEX.md` lui-même exclu). Note : le Code Map de la spec mentionne "144 fichiers" ; le décompte réel du dépôt au moment de l'implémentation est 124 (`find conception -type f -name "*.yaml" | wc -l` = 122, `-name "*.md"` = 1 avant génération). Écart de comptage dans la prose de la spec, sans impact sur l'AC (qui porte sur les 885 occurrences `- id:`, vérifiées exactes).
  `git diff --stat -- conception/INDEX.md` après premier commit du fichier : `1 file changed, 1024 insertions(+)`.
- Idempotence vérifiée : deux exécutions successives de `dart run tools/ctx.dart --index` produisent un `conception/INDEX.md` strictement identique (`diff` vide).
- `dart run tools/ctx.dart 07-ecrans/carte/01` : affiche bien le contenu entier de `conception/07-ecrans/carte/01-principale.yaml` (vérifié, premières lignes = en-tête de commentaire `E-CARTE-PRINCIPALE`).
- `dart run tools/ctx.dart XYZ-INEXISTANT` : rien sur stdout, `tools/ctx: aucun ID ni fichier correspondant à 'XYZ-INEXISTANT' sous conception/.` sur stderr, code de sortie 1.
- `dart run melos run analyze` (équivalent `melos run analyze`, exécuté via `dart run melos run analyze` faute de `melos` sur le PATH global de l'environnement d'implémentation) : `dart analyze .` → `No issues found!`, `tools/check_import_direction.dart` → `aucune violation.` Aucune régression.
- `dart format --set-exit-if-changed tools/ctx.dart` : conforme après un premier passage de reformatage automatique.
- `conception/` n'a subi aucune écriture autre que la création de `conception/INDEX.md` (`git status --short` avant/après ne montre que ce fichier en `??`, aucun fichier `conception/` existant modifié).

## Spec Change Log

## Review Triage Log

### 2026-09-18 — Review pass
- verdicts: 23 findings — high 0, medium 6, low 14, false 3, maybe-false 0
- findings:
  - `[low]` `patch` (blind-hunter) commentaire inline après `- id: X` (ex. `- id: D1.2  # note`) casse à la fois l'indexation (le commentaire est absorbé dans l'id capturé) et la recherche (`_idPatternFor` exige une fin de ligne stricte après l'id) — latent : `conception/` est figée (jamais rééditée), donc aucun cas réel actuellement, mais correction peu coûteuse. Corrigé : les deux regex tolèrent et ignorent un commentaire `#...` final.
  - `[low]` `patch` (blind-hunter) id entre guillemets simples (`- id: 'D1.2'`) non déguillemetté (seuls les doubles guillemets sont retirés) — même latence que ci-dessus. Corrigé : les deux formes de guillemets sont retirées.
  - `[medium]` `patch` (blind-hunter) la résolution par chemin (`relNoExt == arg || relNoExt.startsWith(arg)`) matche sur la chaîne entière du chemin relatif, pas sur un segment : un argument court comme `1` ou `01` matche plusieurs fichiers non liés dans des dossiers différents et en affiche le contenu entier au lieu de signaler une entrée introuvable ou ambiguë — contredit l'intention même de la story (lire un extrait précis sans tout charger). Corrigé.
  - `[medium]` `patch` (blind-hunter) aucun test automatisé pour `tools/ctx.dart`, alors qu'AD-14/NFR6 (tests d'abord) sont des contraintes transverses du projet — seule `check_import_direction.dart` en est dispensée par précédent, mais cette story introduit une vraie logique de branchement qui le justifie. Corrigé : `test/tools/ctx_test.dart` ajouté.
  - `[low]` `patch` (blind-hunter) validation d'argument superflu incohérente : `--index garbage` est ignoré silencieusement alors que `ID1 ID2` sur la branche de recherche simple est rejeté. Corrigé : la vérification `args.length > 1` s'applique aussi à `--index`.
  - `[low]` `patch` (blind-hunter) argument vide/blanc non validé : `startsWith('')` matche tous les fichiers, provoquant un dump de la totalité de `conception/` — même racine que la 3e ligne (résolution par chemin trop permissive), regroupé avec elle. Corrigé.
  - `[false]` reject (blind-hunter) « duplication » d'un `id:` imbriqué (enfant sous un parent) affiché à la fois seul et dans le bloc du parent — réfuté : c'est le comportement voulu et explicitement documenté (Boundaries : « un ID qui apparaît à plusieurs endroits doit toutes les montrer »), pas un défaut.
  - `[false]` reject (blind-hunter) extraction de bloc « absorbant » du contenu plus indenté non lié à l'id — réfuté : en YAML, tout contenu plus indenté sous une clé lui appartient sémantiquement ; il n'existe pas de « contenu non lié » à cette profondeur.
  - `[low]` reject, hors périmètre par intention (blind-hunter) `conception/INDEX.md` ne distingue pas une occurrence « définition » d'une occurrence « référence/synthèse » pour un id dupliqué — décision de périmètre déjà prise et documentée explicitement dans la spec d'origine (Boundaries : jamais de désambiguïsation silencieuse), pas un oubli.
  - `[medium]` `defer` (blind-hunter) aucune détection automatisée (CI/pre-commit/melos) de péremption de `conception/INDEX.md` — réel, mais explicitement hors périmètre de l'épic 2 : `docs/epics.md` NFR1 câble les checks CI correspondants sur l'Epic 9. Différé (voir frontmatter `deferred`).
  - `[low]` reject, correctif de texte de spec seul (blind-hunter) Code Map de la spec disait « 144 fichiers » alors que l'implémentation a mesuré 124 — corrigé directement dans la spec (pas de patch de code nécessaire).
  - `[low]` `patch` (edge-case-hunter) même défaut que la 5e ligne (`--index garbage` non validé).
  - `[medium]` `patch` (edge-case-hunter) même racine que les lignes 3 et 6 (résolution par chemin trop permissive, cas argument vide).
  - `[low]` `patch` (edge-case-hunter) même défaut que la 2e ligne (guillemets simples non gérés).
  - `[low]` `patch` (edge-case-hunter) même défaut que la 1re ligne, versant recherche (`_idPatternFor` échoue sur commentaire inline).
  - `[low]` `patch` (edge-case-hunter) même défaut que la 1re ligne, versant index (`_anyIdLinePattern` absorbe le commentaire inline dans l'id capturé).
  - `[low]` `patch` (edge-case-hunter) lecture non protégée d'un fichier illisible/non-UTF-8 sous `conception/` : exception brute non interceptée au lieu du contrat stderr+exit-code propre de l'outil — aucun fichier binaire n'existe actuellement sous `conception/` (vérifié), donc défensif plutôt que réel. Corrigé.
  - `[low]` `patch` (edge-case-hunter) écriture de `conception/INDEX.md` non protégée (permissions, disque plein) : même traitement que la ligne précédente. Corrigé.
  - `[low]` reject, correctif de texte de spec seul (edge-case-hunter) le texte de la spec disait « égale ou finit par l'argument » alors que l'implémentation fait un `startsWith` (préfixe), cohérent avec l'exemple donné dans la spec elle-même — corrigé directement dans le texte de la spec (« commence par »), le comportement du code était déjà correct.
  - `[false]` reject (intent-alignment) invocation `tools/ctx D1.2` vs `dart run tools/ctx.dart D1.2` — le rapporteur lui-même conclut à une divergence mineure/défendable (même convention que `check_import_direction.dart`, même forme abrégée utilisée pour tous les autres `tools/*` dans `epics.md`), pas un défaut.
  - `[low]` reject, hors périmètre déjà tranché (intent-alignment) format `id → fichier#ancre` littéral (lien/ancre markdown) vs `fichier:ligne` texte brut — choix déjà documenté et justifié dans la spec d'origine (YAML sans ancre native), et cohérent avec la convention de clickabilité `fichier:ligne` déjà utilisée dans tout cet outillage BMAD ; pas un oubli.
  - `[medium]` `patch` (intent-alignment) même défaut que la 4e ligne (absence de test automatisé).
  - `[low]` reject, hors périmètre par intention (intent-alignment) même défaut que la 9e ligne (pas de distinction définition/référence pour un id dupliqué).

## Auto Run Result

**Résumé :** `tools/ctx.dart` créé (script Dart autonome, `dart:io` seul) : recherche par ID (toutes occurrences affichées, jamais de désambiguïsation silencieuse) avec repli sur résolution par chemin, et mode `--index` régénérant `conception/INDEX.md` (885 entrées "Par ID", 124 fichiers "Par fichier", idempotent). Suite de tests dédiée ajoutée.

**Fichiers modifiés :**
- `tools/ctx.dart` -- script (lookup + `--index`), avec parsing tolérant aux commentaires inline et aux deux styles de guillemets, résolution par chemin restreinte au dernier segment, validations d'arguments et E/S protégées.
- `conception/INDEX.md` -- généré (885 + 124 lignes).
- `test/tools/ctx_test.dart` -- suite de tests noire (spawn du CLI réel), 21 vérifications, couvrant toute la matrice I/O de la spec.
- `docs/stories/spec-2-2-tools-ctx-et-conception-index-md.md` -- spec, Implementation Notes, Review Triage Log, deux corrections de texte (comptage de fichiers, formulation "commence par").

**Revue :** 4 lentilles, 23 findings.
- Patchés : 6 entrées (2 `medium` -- résolution par chemin trop permissive (arguments courts/vides dumpant plusieurs/tous les fichiers), absence de test automatisé (AD-14/NFR6) ; 4 `low` -- commentaires inline et guillemets simples non gérés dans le parsing d'id, incohérence de validation des arguments surnuméraires sur `--index`, E/S non protégées). Tous corrigés par le sous-agent d'implémentation, revérifiés (nouveaux tests + AC toujours vertes).
- Différé (1, `medium`) : détection automatisée de péremption de `conception/INDEX.md` — explicitement hors périmètre de l'épic 2 (Epic 9, `docs/epics.md` NFR1). Consigné en frontmatter `deferred`.
- Rejetés (`false`, 3) : "duplication" d'un id imbriqué (comportement voulu), extraction absorbant du contenu plus indenté (sémantique YAML normale), invocation `tools/ctx` vs `dart run tools/ctx.dart` (convention déjà établie par `check_import_direction.dart`).
- Rejetés hors périmètre déjà tranché en amont (`low`, 2) : absence de distinction définition/référence pour un id dupliqué, format `fichier#ancre` littéral vs `fichier:ligne` — décisions de conception déjà prises et documentées dans la spec d'origine.
- Rejetés car le correctif était un texte de spec seul (`low`, 2) : comptage "144" vs "124" fichiers, formulation "finit par" vs comportement réel "commence par" — corrigés directement dans la spec.
- Aucun `intent_gap` ni `bad_spec`.

**Follow-up review recommended :** `true` — deux entrées `medium` patchées lors de cette première passe (seuil atteint). Risque nommé : le correctif de la résolution par chemin (restriction au dernier segment) et la consolidation des regex d'id (`_matchIdLine`) sont une logique substantiellement réécrite qui n'a pas elle-même été soumise aux 4 lentilles de revue (seule la version pré-patch l'a été) ; seule la suite de tests ajoutée par le même sous-agent la couvre.

**Vérification effectuée :** les 6 commandes de la section `## Verification` rejouées après patch (toutes conformes), plus `dart test/tools/ctx_test.dart` (21/21) et `melos run analyze` (propre). Matrix Test Audit : les 6 scénarios de l'I/O Matrix sont chacun couverts par un test qui s'est exécuté et a réussi.

**Risques résiduels :** voir Follow-up review recommended ci-dessus ; par ailleurs, `conception/INDEX.md` peut devenir périmé sans alerte tant que l'Epic 9 n'a pas câblé la détection CI correspondante (différé, connu).

## Verification

**Commands:**
- `dart run tools/ctx.dart D1.2` -- expected: 3 extraits avec en-têtes `# fichier:ligne`, aucun autre bloc
- `dart run tools/ctx.dart 07-ecrans/carte/01` -- expected: contenu entier de `conception/07-ecrans/carte/01-principale.yaml`
- `dart run tools/ctx.dart XYZ-INEXISTANT` -- expected: rien sur stdout, message d'erreur sur stderr, code de sortie non nul
- `dart run tools/ctx.dart --index && git diff --stat -- conception/INDEX.md` -- expected: fichier créé/mis à jour, table "Par ID" avec 885 lignes
- `dart run tools/ctx.dart --index` (rejoué) puis `git diff -- conception/INDEX.md` -- expected: sortie vide (idempotent)
- `melos run analyze` -- expected: aucune régression sur le reste du workspace
