---
type: review
lens: rubric-walker
target: ../ARCHITECTURE-SPINE.md
date: 2026-09-17
verdict: NE PASSE PAS EN L'ÉTAT — 2 critiques, 4 hauts à corriger avant adoption
---

# Revue rubrique — Architecture Spine HistoLyon

Méthode : lecture intégrale de la spine, confrontation aux sources citées (`conception/04-donnees/00-index.yaml` I1–I10 et entités, `03-fonctionnalites/00-index.yaml`, `08-contenu/06-i18n.yaml`, `04-donnees/01-contenu.yaml` Média/Modèle 3D, `.memlog.md`), rendu réel des trois diagrammes mermaid avec `@mermaid-js/mermaid-cli`.

Verdict : **la spine fixe bien les grandes frontières (schéma, ownership, process) mais contient une contradiction interne bloquante (AD-5 vs `core/router`) et laisse silencieuses deux dimensions qui feront diverger les features dès les premières stories : l'enveloppe Supabase gratuite / médias lourds, et le modèle d'autorisation (rôles) dont dépendent RLS et back-office.**

---

## 1. Les vrais points de divergence sont-ils fixés ?

Ce qui est bien fixé (et suffit pour des features construites par des gens différents) : un seul langage (AD-1), le schéma SQL comme vérité et les types générés (AD-2, AD-3), la partition serveur/terminal (AD-4), un seul chemin de mutation (AD-6), l'unité hors-ligne (AD-9), le contrat 3D (AD-11), les conventions de nommage/erreurs/état/config, le process (AD-12 → AD-18).

Points de divergence **manqués** ou laissés ambigus (détail dans les findings) :

| # | Point manquant | Qui diverge concrètement |
| --- | --- | --- |
| a | Composition root : qui a le droit d'importer les features (routeur, `ProviderScope`, bootstrap) | AD-5 interdit `core/ → features`, la convention État met `go_router` dans `core/router`. Le lint d'imports est inapplicable tel quel. |
| b | Sens exact domain ↔ data et lieu des interfaces de repository / des providers Riverpod | « Clean Architecture allégée » (paradigme) vs `presentation → domain → data` (AD-5). Une feature fera l'inversion de dépendance, l'autre non. |
| c | Modèles de domaine partagés (Pin, Parcours, Époque sont utilisés par D1, D2, D3, D4, D7) | Une feature consomme `api_types` directement, l'autre mappe vers ses propres entités de `domain/`. AD-5 interdit feature→feature, mais ne dit pas où vit `Pin`. |
| d | Modèle d'autorisation (éditeur / validateur / modérateur / grand public) | RLS pour I2, I3, I4, I5 (D9) et écrans admin (D10) sont écrits par des personnes différentes ; « RLS par `auth.uid()` » ne couvre que l'identité, pas le rôle. |
| e | Logique serveur : fonctions SQL/RPC vs Edge Functions (TypeScript) | Promotion I10, modération I3, image partageable C6, page publique D11 (piste Edge Function en Deferred). Un dev écrira du plpgsql, l'autre du TS. |
| f | Binaires (images, audio, glTF, extraits PMTiles) en phase 1 « contenu en fichiers » | `content/` ne liste que du YAML. Où vivent les fichiers que le YAML référence, qui les téléverse, dans quel bucket, sous quel chemin ? |
| g | Schéma local Drift (Profil, Favori, Historique, paquets hors-ligne) | AD-2 ne gouverne que le backend. D6 (`core/profile`) et D3/D7 (`core/offline`) créeront chacun leur `Database` Drift et leur politique de migration. |
| h | Fond de carte vs couches de données ; source de tuiles en ligne vs hors-ligne | AD-8 : « un style par Époque, le slider ne modifie pas les couches ». Pins, tracés, position (palier 9 §02–03) sont des couches ajoutées par code ; PMTiles hors-ligne exige une URL de source différente → deux styles par Époque ou une injection non spécifiée. |

## 2. Rules applicables / vérifiables ? Empêchent-elles ce qu'annonce Prevents ?

| AD | Verdict | Détail |
| --- | --- | --- |
| AD-1 | Vérifiable | Structure du workspace, contrôlable en CI. |
| AD-2 | **Partiellement invérifiable** | « aucune modification manuelle d'un projet Supabase » : aucun mécanisme (un `supabase db diff` nightly contre `dev` le rendrait vérifiable). « chaque invariant I1–I10 … possède un test pgTAP » : I6 (données strictement locales) et I9 (non-affichage sur la carte) sont des comportements client, pas des contraintes SQL ; I3 (marque distinctive) et I10 (crédit conservé) ne sont que partiellement exprimables en SQL. Tel quel, le Gardien des tests ne peut pas cocher la case. |
| AD-3 | Vérifiable | CI diff sur la génération : bon. |
| AD-4 | Vérifiable | Lieu (`core/profile/sync/`) et nature (explicite, opt-in, par catégorie) fixés. |
| AD-5 | **Contradictoire** | Voir 1.a et 1.b : le lint d'imports annoncé ne peut pas être écrit sans décider du composition root et du sens domain↔data. |
| AD-6 | Vérifiable, mais incomplète | « injectés que dans `data/` » est lintable. Ne dit pas où vit le provider (`presentation/` ? `domain/` ?). |
| AD-7 | **Molle sur un point** | « JSON Schema dérivé du schéma SQL » : dérivé par quoi ? Aucun outil dans `tools/` (ctx, gen-types, sync-agents, report, seed). Écrit à la main, il dérivera — exactement ce que Prevents veut éviter. |
| AD-8 | Ambiguë | Voir 1.h : « ne modifie pas les couches à la main » ne distingue pas fond (style) et couches de données applicatives. |
| AD-9 | Incomplète | « extrait PMTiles de son emprise » : produit par qui, où (terminal ? CI ? bucket ?). Un extrait PMTiles ne se fabrique pas sur un téléphone avec l'outillage courant. |
| AD-10 | Vérifiable, contradiction interne mineure | « exactement l'identifiant Figma » puis « `TokColor.primary`, mapping documenté » : ce n'est pas exactement l'identifiant. Générer `design_tokens` depuis `conception/12-tokens/*.yaml` (qui sont déjà des YAML avec ids) rendrait la Rule mécanique. |
| AD-11 | Vérifiable | Bucket, entité, point d'entrée `ImmersionViewer(modelRef)` : bon contrat. |
| AD-12 | **Molle** | « plus d'une couche non triviale » : « non triviale » n'est pas décidable ; et une story fonctionnelle touche par construction data+domain+presentation. Soit on assume des stories horizontales par couche (cohérent avec AD-14), soit on retire cette clause. |
| AD-13 | Vérifiable | Protection de branche GitHub. |
| AD-14 | Vérifiable au moment de la PR | « premier commit = tests » : vérifiable dans la PR, effacé par le squash (AD-13) — acceptable puisque relu. Périmètre du cliquet de couverture non défini (global ? par app ? par package ?) : deux workflows CI l'implémenteront différemment. |
| AD-15 | Vérifiable sauf « jamais lue entière » | `< 150 lignes` et « générés par `tools/sync-agents` » sont lintables. « jamais lue entière » est une consigne, pas une règle. |
| AD-16 | Vérifiable, incomplète | Le chemin de seed n'est spécifié que pour `local`. `dev` et `demo` : seedés par la CI ? à la main ? (divergence immédiate avec « aucune modification manuelle »). |
| AD-17 | Vérifiable | L'outil est nommé et ses entrées listées. |
| AD-18 | Process, non vérifiable par construction | Acceptable pour un AD de process ; « mis à jour quand un rôle change, pas avant » est un vœu. |

## 3. Deferred : quelque chose qui laisse diverger dès maintenant ?

- **Oui — « Outillage de modération (D9/D10) et validation scientifique »** : le différé est légitime pour les écrans, mais le *modèle de rôles* qu'ils supposent est requis par les policies RLS de la première migration (I2, I3, I4, I5) et par l'admin. Il n'est ni décidé ni différé explicitement → fuite.
- **Oui — « Page web publique … piste : Edge Function Supabase »** : la piste introduit du TypeScript côté serveur sans que la spine ait tranché « où va la logique serveur » (voir 1.e). Le différé lui-même est correct ; ce qui manque est la Rule amont.
- **Oui — « Bascule `content/` → admin »** : correct de différer, mais la condition de revisite doit inclure une sauvegarde/export, sinon la base `demo` (plan gratuit, pas de backup automatique) devient la seule copie du contenu.
- Les autres différés (moteur 3D, iOS, lien universel, méthode d'auth, hébergeur admin, seuils perf, supadart) sont bien isolés par une AD ou une convention et ne font pas diverger maintenant. Nuance sur la méthode d'auth : correcte à différer tant que la Rule Auth impose Supabase Auth et `auth.users.id = compte.id`.

## 4. Dimensions structurelles silencieuses

| Dimension | État | Commentaire |
| --- | --- | --- |
| Déploiement / environnements | Décidé (AD-16) | Manque le seed dev/demo et la distribution de l'APK (signature). |
| Secrets | Décidé (AD-16, Config) | Manque la règle anon key (publique, dans `env/*.json`) vs `service_role` (CI/`tools` uniquement, jamais dans une app). |
| **Quotas / plan gratuit Supabase** | **Silencieux** | Plan gratuit : 2 projets actifs par organisation (dev + demo = tout le quota, aucun projet de secours), **pause automatique après ~7 jours d'inactivité** (projet `demo` en pause le jour du jury), ~500 Mo base, ~1 Go Storage (images + audio + glTF + extraits PMTiles), ~5 Go d'egress/mois (téléchargement de paquets hors-ligne par 7 testeurs), pas de sauvegarde automatique. Aucune AD ne pose de budget ni de garde-fou. |
| Sauvegardes | Silencieux | En phase 1, `content/` en git est la sauvegarde ; en phase 2 il n'y en a plus. |
| Monitoring / observabilité / crash | Silencieux | Convention « logs sans identifiant utilisateur » sans bibliothèque de log ni remontée de crash. Chaque feature loggera à sa façon ; les bugs de démo ne remonteront pas. |
| Sécurité | Partiel | RLS par identité : oui. Rôles : non (1.d). Buckets Storage publics/privés : non dit. Modération/anonymat I5 : dépend des rôles. |
| Médias lourds | **Silencieux** | Voir 1.f : formats (webp/opus/glb), tailles max, chemins, buckets, qui téléverse, CDN/transform Supabase ou non. |
| Versionnage / release de l'app | Silencieux | Seul le tag `demo-YYYY-MM-DD` (backend) existe. `version`/`versionCode` Android, keystore de signature (debug ? release partagé ?), changelog, correspondance APK ↔ migration : rien. Deux APK sur deux téléphones du jury pourraient ne pas parler au même schéma. |
| Gestion des dépendances | Silencieux | Versions figées dans Stack, mais rien sur `pubspec.lock` committé, caret vs exact, politique de montée de version (Dependabot/Renovate), partage des contraintes via melos. |
| Licences OSM / assets | **Silencieux** | Tuiles OSM (ODbL) et OpenFreeMap exigent une attribution visible sur la carte (`features/carte`). Les spécialistes 3D « récupèrent sur internet » : sans champ `licence` obligatoire sur Modèle 3D/Média (palier 4 n'a que `crédit`), un modèle CC-BY-NC ou non redistribuable se retrouvera dans le bucket `models` et dans l'APK. Fragments musicaux (C1) : même sujet. |
| Schéma local Drift | Silencieux | Voir 1.g. |
| Logique serveur | Silencieux | Voir 1.e. |
| i18n | Décidé mais **contredit la conception** | `08-contenu/06-i18n.yaml` : « français uniquement », exclusion explicite de « toute infrastructure de traduction (clés i18n, gestion de locale) ». La convention spine impose ARB + `flutter_localizations` et parle de « contenu éditorial i18n porté par les entités ». Centraliser la microcopy est une bonne idée, mais il faut la reformuler (fr-only, pas de locale) et retirer la clause contenu i18n. |

## 5. Terseness

Globalement bon : la spine est un contrat, pas un essai. À couper ou raccourcir :

- AD-17 Rule, parenthèse « (SharePoint garde les CR de réunion, rien d'autre) » : rationale de process, pas une règle d'architecture ; à déplacer dans le doc organisation.
- AD-12 Rule, « (= format dev-story BMAD) » : justification, à retirer (le template est la règle).
- AD-7 Rule, « cette bascule est un amendement de la présente AD, pas une décision locale » : garder seulement « bascule = amendement de AD-7 ».
- AD-18 Prevents, « rien à montrer au jury sur l'ajustement » : argument, pas une divergence évitée.
- Consistency Conventions, ligne « Langue des identifiants » : trop dense (glossaire + slugs de features + slugs admin) ; scinder en « Nommage » et « Slugs de features ».
- Structural Seed, arbre : les commentaires « GÉNÉRÉ — ne pas éditer » sont utiles ; « # ce document (copie de référence) » sur `docs/ARCHITECTURE-SPINE.md` introduit une seconde copie de la spine — décider laquelle fait foi plutôt que commenter.
- Deferred, colonne « Pourquoi ça peut attendre » : rationale par design, acceptable ; garder les cellules à une ligne (c'est le cas).

## 6. Diagrammes mermaid

Les trois blocs rendent sans erreur avec mermaid-cli (`graph TD` AD-5 ; `graph LR` seed système ; `graph LR` environnements). Labels avec `<br/>`, `·`, `/`, `*` et sous-graphes à titre avec espace sont acceptés.

- Diagramme AD-5 : utile, mais il **grave la contradiction** (aucun nœud « app/composition root » ; `core/ -.interdit.-> features` alors que `core/router` doit connaître les écrans). À corriger avec la Rule.
- Diagramme système : utile ; manque le flux de seed vers `dev`/`demo` et la production des extraits PMTiles (qui n'apparaissent nulle part alors que AD-9 les exige).
- Diagramme environnements : redondant avec la Rule AD-16 (même contenu en prose une ligne au-dessus) ; à supprimer ou à enrichir du seed et de la signature d'APK pour qu'il apporte quelque chose.

---

## Findings

### Critiques

**C-1 — AD-5 + convention État + arbre `core/router` : contradiction qui rend le lint d'imports inapplicable.**
`core/` « n'importe aucune feature » mais `go_router` avec routes typées est déclaré dans `core/router`, donc `core/` importe chaque écran de feature. Idem pour l'assemblage des providers.
Correction : ajouter `apps/*/lib/app/` (composition root : `router.dart`, `bootstrap.dart`, `ProviderScope` overrides) **seul** autorisé à importer les features ; `core/router` ne contient que les noms/chemins de routes ; chaque feature exporte ses `GoRoute` depuis `presentation/routes.dart`. Mettre à jour le diagramme AD-5 et l'arbre.

**C-2 — Enveloppe opérationnelle Supabase gratuite absente (quotas, pause, sauvegarde).**
Deux projets gratuits = quota entier de l'organisation ; pause automatique après inactivité (le projet `demo` peut être en pause le jour du jury) ; ~1 Go Storage pour images + audio + glTF + PMTiles ; aucune sauvegarde automatique, et après la phase 2 d'AD-7 la base est la seule copie du contenu.
Correction : nouvelle AD « Enveloppe Supabase gratuite » : budget Storage par bucket, keep-alive hebdomadaire (workflow GitHub Actions qui requête `dev` et `demo`), `supabase db dump` hebdo en artefact CI + export Storage, contrôle de taille des médias en CI ; condition de revisite de la bascule AD-7 phase 2 = export automatique en place.

### Hauts

**H-1 — AD-5/AD-6 : sens domain↔data, lieu des interfaces de repository et des providers, et lieu des modèles de domaine partagés non fixés.**
« Clean Architecture allégée » suggère l'inversion (interface dans `domain/`, implémentation dans `data/`) ; la Rule dit `domain → data`. `Pin` est consommé par D1, D2, D3, D4, D7 : `api_types` direct ou entités par feature ?
Correction : trancher explicitement « pas d'inversion : `domain/` importe `data/` ; provider `@riverpod` dans `presentation/` ; les types générés `api_types` **sont** les entités de domaine (aucun mapping) ; tout modèle dérivé partagé vit dans `core/models/` ». Un guide `docs/guides/ajouter-une-feature.md` avec l'arborescence exacte.

**H-2 — Modèle d'autorisation (rôles) silencieux alors que RLS I2–I5 et l'admin en dépendent dès la première migration ; fuite via le Deferred « modération ».**
Correction : convention Auth complétée : table `membre_equipe(compte_id, role enum('editeur','validateur','moderateur'))` posée par la migration socle, policies RLS admin fondées dessus, pgTAP par rôle ; clé `anon` seule dans les apps, `service_role` uniquement en CI/`tools/seed` ; buckets Storage : lecture publique, écriture par rôle.

**H-3 — Médias lourds et extraits PMTiles : aucune règle de stockage, format, chemin ni de production.**
`content/` ne référence que du YAML ; les binaires n'ont ni emplacement ni téléverseur ; AD-9 exige un extrait PMTiles par Parcours que personne ne produit.
Correction : AD « Médias et paquets » : buckets `images | audio | models | tiles` ; chemin `<bucket>/<slug-entité>/<nom>` ; binaires hors git (dossier local ignoré ou Release GitHub) téléversés par `tools/seed` ; formats webp / opus (ou aac) / glb, tailles max en CI ; extraits PMTiles produits par `tools/tiles` (CI) à partir de l'emprise du Parcours, stockés dans `tiles/<slug-parcours>.pmtiles`, jamais sur le terminal.

**H-4 — Logique serveur non tranchée : fonctions SQL/RPC vs Edge Functions (TS).**
I10 (promotion transactionnelle), I3 (transition de modération), C6 (image partageable, lien), D11 (piste Edge Function en Deferred) appellent de la logique côté serveur ; AD-1 n'exclut pas le TS serveur.
Correction : Rule (dans AD-2 ou nouvelle AD) : « toute logique serveur = fonction SQL/plpgsql exposée en RPC, testée pgTAP ; Edge Functions uniquement par amendement, réservées au rendu HTML de D11 ».

### Moyens (9)

- M-1 AD-2 : Rule partiellement invérifiable (I6, I9 = client ; « aucune modification manuelle » sans contrôle). Ajouter une table invariant → mécanisme (SQL / RLS / client + test) et un `supabase db diff` nightly contre `dev`.
- M-2 Convention i18n contredit `08-contenu/06-i18n.yaml` (mono-langue, pas d'infra i18n). Reformuler : « microcopy centralisée dans un ARB `fr` unique, clés = ids palier 8 ; aucune gestion de locale » ; retirer « contenu éditorial i18n porté par les entités ».
- M-3 Schéma local Drift non gouverné : une seule `AppDatabase` dans `core/db` avec `schemaVersion` et migrations Drift versionnées ; `core/profile` et `core/offline` y déclarent leurs tables.
- M-4 AD-16 : seed de `dev` et `demo` non spécifié. Rule : `tools/seed` exécuté par le workflow de migration, idempotent, même source `content/`.
- M-5 AD-8 : distinguer fond (style JSON par Époque, `packages/map_styles`) et couches de données (`pins`, `traces`, `position`, sources GeoJSON nommées ajoutées par `features/carte`) ; source de tuiles injectée (`{tiles_url}` remplacé à l'exécution : OpenFreeMap ou `pmtiles://`), un seul fichier par Époque.
- M-6 AD-7 : « JSON Schema dérivé du schéma SQL » sans outil. Ajouter `tools/gen-content-schema` (même famille que `gen-types`) et le même contrôle CI de diff.
- M-7 Licences : attribution OSM/OpenFreeMap obligatoire dans `features/carte` (composant `ui_kit`) ; colonne `licence` (enum : domaine_public, cc_by, cc_by_sa, cc_by_nc, propriétaire_autorisé) obligatoire sur Média, Modèle 3D, Fragment musical ; CI de `content/` refuse une licence absente ou non redistribuable. À remonter au palier 4 comme amendement.
- M-8 Versionnage/release : `version` semver + `versionCode` = numéro de run CI ; keystore de release partagé (secret GitHub) ou APK debug assumé pour le jury — à écrire ; tag `demo-YYYY-MM-DD` déclenche à la fois migration `demo` et build APK, l'APK embarque l'URL `demo`.
- M-9 Observabilité : bibliothèque de log unique (`package:logging` via `core/log`), niveau par `--dart-define`, remontée de crash : décision explicite (aucune, ou Sentry auto-hébergé sans identifiant utilisateur) pour ne pas contredire la convention Vie privée par accident.

### Bas (7)

- B-1 AD-12 : « couche non triviale » indécidable ; clarifier « stories horizontales par couche » ou retirer la clause.
- B-2 AD-14 : périmètre du cliquet de couverture (par app/package, seuil initial) à fixer.
- B-3 AD-10 : générer `design_tokens` depuis `conception/12-tokens/*.yaml` (déjà des YAML avec ids) plutôt que recopier ; Rule alors mécaniquement vérifiable.
- B-4 Convention Erreurs : `Failure` sealed doit vivre dans `packages/` (partagé mobile/admin), sinon deux hiérarchies.
- B-5 Dépendances : `pubspec.lock` committé, versions exactes dans `pubspec.yaml`, montée de version = story `socle` ; Dependabot désactivé ou groupé.
- B-6 Diagramme environnements redondant avec AD-16 : supprimer ou y ajouter seed + APK signé.
- B-7 Prose : couper les parenthèses listées en §5 ; `docs/ARCHITECTURE-SPINE.md` « copie de référence » — désigner l'unique fichier faisant foi.
