# Review — Réconciliation spine ↔ conception

- **Cible :** `ARCHITECTURE-SPINE.md` (draft, 2026-09-17)
- **Inputs lus (et seulement ceux-là) :** `01-essence.yaml` (§6 principes, §7 ce_qu_on_refuse), `03-fonctionnalites/00-index.yaml` (§6 comportements transverses, §7 priorisation), `04-donnees/00-index.yaml` (I1–I10, glossaire, « ce qui n'est PAS une entité »), `04-donnees/06-distribution.yaml` (invariants de cluster D1–D3), `08-contenu/06-i18n.yaml`, `15-maquette.md` §1–4.
- **Angle :** uniquement ce qui n'a pas atterri ou qui est contredit. Ce qui est correctement couvert n'est cité que pour délimiter le manque.
- **Date :** 2026-09-17

## Verdict

La spine ne viole frontalement aucun refus de l'essence, mais elle **contredit I6 par AD-4** (Parcours personnel et Image partageable déclarés « serveur »), **laisse trois comportements transverses sans lieu ni règle** (permissions juste-à-temps, géolocalisation, mode présentation) et **casse elle-même la traçabilité 1:1 des tokens** qu'AD-10 prétend garantir (`TOK-COLOR-PRIMARY` → `TokColor.primary` est le renommage que la maquette interdit). La convention i18n prépare de surcroît une infrastructure que `06-i18n.yaml` exclut explicitement.

Attention : le cluster 06-distribution numérote ses invariants `D1`, `D2`, `D3` — même préfixe que les domaines fonctionnels D1–D11. Dans ce rapport, les invariants du cluster sont notés **C6-D1 / C6-D2 / C6-D3** pour lever l'ambiguïté (la spine, elle, ne les cite jamais par identifiant — voir §C).

---

## A. Refus de l'essence (§7) — contradictions ou trous

| Refus | Où la spine devrait le porter | Constat |
|---|---|---|
| Mur d'inscription au lancement | AD-4, convention Auth | **Trou (mineur).** La convention Auth dit « RLS par `auth.uid()` » sans énoncer que la **lecture du contenu publié est ouverte au rôle `anon`** (sans session). C'est la règle qui matérialise « l'app fonctionne sans compte » côté backend ; elle est implicite, pas écrite, donc non testée en pgTAP au titre d'AD-2. |
| Toute friction au lancement (« pas de pop-up de permissions en bloc ») | aucun AD | **Absent.** Aucune règle « aucune permission système n'est demandée avant le premier usage qui la justifie », aucun lieu pour le service de permissions (voir §D-6). |
| Notifications de proximité par défaut | convention Proximité | **Trou (mineur).** La convention fixe le géofencing local mais pas le fait que le mode (balade libre / Surprenez-moi / en parcours) est un **attribut du Profil local, défaut = balade libre** (palier 4 « ce qui n'est pas une entité » : préférence utilisateur). Sans ça, rien n'interdit un défaut à « Surprenez-moi » dans une story. |
| Mode canapé comme mode dégradé | AD-9 | **Ambiguïté.** AD-9 : « hors emprise préchargée, l'app affiche l'état hors-ligne … et ne promet rien ». Formulé sur le hors-ligne, mais rien dans la spine ne distingue « pas de réseau » de « pas à Lyon / pas de position ». Sans service de géolocalisation défini (§D-2), le cas canapé (position absente ou hors Lyon, réseau présent) n'a pas de règle et risque d'hériter du bandeau hors-ligne — ce qui serait le mode dégradé refusé. |
| Turn-by-turn GPS, écran Explorer, mascotte, ton, city branding, peppy, mode dark | — | Pas de contradiction. Note : la maquette est « light, pas de structure dark » ; la spine ne dit rien du `ThemeData`/`MaterialApp` de `core/`, qui par défaut Flutter injecte `#FFFFFF`/`#000000` — la règle de charte « pas de blanc pur ni de noir pur » n'est pas portée (voir §E). |

Principes essentiels (§6) : rien dans la spine ne les contredit. Le seul point de contact structurel — « la carte est l'écran d'accueil » — n'est pas énoncé dans `core/router` (route initiale = carte, pas de splash bloquant). Mineur mais absent.

---

## B. Invariants I1–I10 — contradictions ou trous

AD-2 pose la règle générale « chaque invariant I1–I10 = contrainte SQL/RLS + pgTAP ». Ce qui suit est ce que cette règle **ne couvre pas** ou ce que d'autres AD contredisent.

| Inv. | Constat | AD concerné |
|---|---|---|
| **I1** Identité civile jamais collectée | **Trou.** Le Deferred « Méthode d'authentification (mot de passe / magic link / **tiers**) » n'est pas borné : un fournisseur tiers (Google, Apple) écrit nom/prénom/avatar dans `auth.users.raw_user_meta_data`, hors de portée d'une contrainte sur `compte`. I1 n'est donc pas garantissable par AD-2 seul ; il faut une condition de revisite du type « tout fournisseur tiers doit être configuré pour n'importer que l'email, et `raw_user_meta_data` est purgé/ignoré » — absente. | AD-2, Deferred Auth |
| **I6** Profil anonyme strictement local | **Contradiction.** AD-4 : « le serveur possède le contenu éditorial et communautaire (C1, C2, C4, C5, C6) ». Or I6 s'applique explicitement à **« Parcours (provenance personnelle) »** (dans C2) et à **« Image partageable »** (dans C6), qui doivent rester sur le terminal tant qu'il n'y a pas de Compte. La partition d'AD-4 est par cluster alors que I6 coupe **à l'intérieur** de C2 et C6. Aucune règle ne dit que `parcours` de provenance personnelle vit en Drift et n'est poussé qu'à la création de Compte (opt-in par catégorie). | AD-4 |
| **I6 × Lien universel** | **Non tranché.** 06-distribution impose le « modèle CAPABILITY » : un Lien universel vers un Parcours personnel est résoluble par quiconque le détient, sans publication ni modération. Cela exige que le Parcours personnel soit lisible par le serveur (Edge Function différée) — ce qui heurte I6 « aucune synchronisation cloud » sans Compte. La conception porte la tension ; la spine devait la trancher (ex. « partage d'un Parcours personnel ⇒ Compte requis » ou « upload de ce seul Parcours = acte explicite opt-in ») et ne le fait pas. | AD-4, Deferred Lien universel |
| **I7** Catalogues Catégorie et Époque ouverts | **Tension.** AD-8 : « un fichier de style JSON par Époque dans `packages/map_styles/`, nommé par le `slug` ». Une Époque ajoutée en base (I7 : « à tout moment ») n'a pas de style tant que l'APK n'est pas relivré — le catalogue est ouvert en données et **fermé dans le binaire**. Il manque au minimum une règle de repli (style par défaut si `slug` inconnu) et/ou l'hébergement des styles en Storage plutôt qu'en package. | AD-8 |
| **I9** Pin sans coordonnées existe | **Trou (mineur).** Convention « positions en `geography(Point, 4326)` » sans dire que la colonne est **nullable** ; AD-9 précharge « pins + médias + extrait PMTiles de son emprise » sans dire qu'une Étape sur un Pin non localisé n'entre pas dans le calcul d'emprise. | Convention Dates & géo, AD-9 |
| **I10** Promotion, crédit de l'auteur conservé | **Trou (mineur).** La convention « Statut & provenance » fixe les deux enums mais pas la colonne de **crédit** (pseudonyme de l'auteur original) ni l'interdiction de l'effacer (« la promotion n'efface pas l'historique » ⇒ trace append-only). | Convention Statut & provenance |
| I2, I3, I5 | Couverts par RLS + enum. **Note de séquencement :** AD-2 exige un pgTAP par invariant, donc le schéma communautaire (D9, *si_le_temps*) doit exister dès les premières migrations. Ce n'est pas contradictoire avec §7 de l'index 3, mais ce coût d'entrée n'est pas explicité. | AD-2 |
| I4, I8 | Rien à signaler. | — |

---

## C. Invariants du cluster distribution (C6-D1 / C6-D2 / C6-D3)

| Invariant | Constat |
|---|---|
| **C6-D1** Pas de tracking marketing | Convention Vie privée : « aucun SDK d'analytics ni de tracking (invariants cluster 06) ». **Couvert pour l'app** ; **non couvert pour la page web publique / payload Open Graph** différée (Edge Function) : rien n'interdit qu'un futur lien porte `?utm=` ou qu'un compteur de résolutions soit ajouté — la question ouverte « statistique agrégée : opt-in ou exclu ? » n'est pas tranchée par la spine alors que c'est une décision d'architecture (logs de l'Edge Function). |
| **C6-D2** Pas d'identité d'expéditeur encodée | **Absent.** Rien sur le lieu de génération de l'Image partageable (locale, sur le terminal, sans métadonnées EXIF de position — l'invariant « aucune métadonnée de localisation ni de session embarquée dans le fichier généré » est une contrainte d'implémentation qui doit être nommée). |
| **C6-D3** Validité couplée à la cible, résolution gracieuse | **Absent.** La convention Identifiants (slug = « clé de seed et d'URL ») laisse entendre que le Lien universel = slug de la cible, sans le dire. Conséquences non tranchées : (a) le Lien universel, l'Image partageable et le Code visuel **n'ont aucune table** dans la spine bien qu'AD-4 les déclare « possédés par le serveur » (C6) ; (b) l'état `retombé` n'a pas de règle (dérivé du `statut` de la cible ? stocké ?) ; (c) le slug n'est défini que pour les « entités éditoriales », alors qu'un Parcours communautaire ou personnel a aussi un Lien universel — qui attribue son slug ? |

---

## D. Comportements transverses (index 3, §6) — lieu et règle

Règle de lecture : par AD-5, un comportement référencé depuis plusieurs features **doit** vivre dans `core/` ou `packages/`, jamais dans une feature (une feature n'importe jamais une autre feature).

| # | Comportement | Référencé depuis | Lieu dans la spine | Règle dans la spine | Verdict |
|---|---|---|---|---|---|
| 1 | Mode présentation sans chrome | D2.5, D3.6, D1.1, D8.2 | **aucun** | **aucune** | **Absent.** Palier 4 le qualifie « état d'écran temporaire ». Il traverse 4 features ⇒ doit être un état de `core/` (ex. `core/presentation_mode`) ou un scaffold de `ui_kit`. Rien ne dit non plus comment il interagit avec `go_router` (les routes doivent le préserver) ni avec l'audio en arrière-plan. |
| 2 | Géolocalisation | D1.1, D3.4/3.5, D4.2/4.3, D8.3 | **aucun** (`core/` liste : router, profile, offline, session, supabase client) | convention Proximité (« géofencing local ») — c'est le **consommateur**, pas le service | **Absent.** Sans `core/location`, `features/carte` et `features/proximite` porteront chacune leur flux de position, ce qu'AD-5 interdit de partager. Rien sur le cas « position refusée / hors Lyon » (mode canapé, §A). |
| 3 | Lecture audio en arrière-plan | D2.5, D3.5, D7 | `features/audio` (D7) | AD-9, AD-6 | **Partiel / contradiction AD-5.** Le lecteur est déclenché depuis `pins` et `parcours` ; s'il vit dans `features/audio`, ces deux features doivent l'importer — interdit par AD-5. Le service de lecture (session audio, **foreground service Android**, contrôles de notification, permission `POST_NOTIFICATIONS` sur Android 13+) doit descendre dans `core/`. Aucune règle non plus sur ce que fait l'audio quand le mode présentation ou le hors-ligne s'active. |
| 4 | Mode hors-ligne | D1.1, D3.4, D7 | `core/offline` | AD-9 | **Couvert**, avec deux trous : (a) **contradiction interne** avec la convention Proximité — « géofencing local à partir des pins préchargés » alors qu'AD-9 dit « la seule unité de préchargement est le Parcours, rien d'autre » : le mode *Surprenez-moi* hors parcours (D4.2, balade libre dans Lyon) n'a **aucune source de pins définie** ; (b) la bascule « médias non préchargés mais réseau présent » (canapé) n'est pas distinguée du hors-ligne. |
| 5 | Partage natif système | D2.4/2.5, D3.3/3.8/3.9, D11 | `features/partage` (D11) | AD-6 | **Partiel / contradiction AD-5.** Même problème que l'audio : `pins` et `parcours` doivent déclencher le partage sans importer `features/partage`. Il manque soit un `core/share` (préparation du Lien universel + `Share.shareXFiles`), soit la règle « le partage est une route de `core/router` vers laquelle on navigue ». Et aucune table/lieu pour les artefacts C6 (§C). |
| 6 | Permissions juste-à-temps | D1.1, D4.2/4.3, D7, D8.3, D5.5 | **aucun** | **aucune** | **Absent.** C'est le comportement transverse le plus directement lié à un refus de l'essence (« toute friction au lancement »). Il faut : un `core/permissions` (ou équivalent) unique point d'appel ; la règle « aucune demande avant l'action qui la justifie, refus accepté sans blocage » ; l'attribut « déjà demandée » dans le Profil Drift (palier 4 : « Profil mémorise si déjà demandée ; autorité reste à l'OS ») ; et le lien avec la permission de notification exigée par l'audio en arrière-plan (#3). |

Bilan : **3 absents (1, 2, 6), 2 partiels avec conflit AD-5 (3, 5), 1 couvert avec contradiction interne (4).**

---

## E. Traçabilité 1:1 des tokens (maquette §4) vs AD-10

| Exigence de la maquette | AD-10 | Constat |
|---|---|---|
| « Le nom de la variable Figma = l'id exact ; **reprendre ces mêmes identifiants comme noms de constantes** … ne pas la casser en renommant côté code » | « portant **exactement** l'identifiant Figma (`TOK-COLOR-PRIMARY` → `TokColor.primary`, mapping documenté une fois) » | **Contradiction interne à AD-10.** L'exemple donné est un renommage (`TOK-COLOR-PRIMARY` ≠ `TokColor.primary`), et « mapping documenté une fois » reconnaît qu'il y a traduction. Ce n'est pas la traçabilité 1:1 demandée. Deux voies compatibles avec Dart : constantes nommées littéralement (`tokColorPrimary` par transformation **mécanique et réversible** documentée, pas « mapping ») ou, mieux, un fichier de tokens généré (`design_tokens.json` exporté de Figma → Dart généré, comme `api_types`), ce qui rend la 1:1 vérifiable en CI. Aujourd'hui la règle repose sur la discipline humaine. |
| « Aucune valeur … à la fois en Figma et dans l'app avec une valeur différente … c'est un signal à vérifier » | rien | **Absent.** Aucun contrôle de dérive (pas d'export Figma versionné dans le dépôt, pas de test comparant `design_tokens` à cet export). AD-3 a ce mécanisme pour les types ; AD-10 ne l'a pas pour les tokens. |
| Ids distincts à valeur identique (`TOK-COLOR-PIN-EDITORIAL` = PRIMARY, `TOK-COLOR-CONTOUR-VERIFICATION` = TEXTE-PRINCIPAL) | rien | **Trou.** Sans règle « un id = une constante, jamais un alias », un dev factorisera ces doublons et cassera la traçabilité. |
| Trois natures de tokens Figma : variables (`COLOR`, `FLOAT`), Text Styles (`typo/<id>`, 3 fontes), Effect Styles (`shadow/<id>`) | « chaque token du palier 12 est une constante » | **Trou.** Les 12 `TOK-TYPO-*` ne sont pas des constantes scalaires mais des `TextStyle` avec fontes embarquées (Playfair Display, Lora, Inter) — la spine ne dit pas que les fontes sont des assets de `packages/design_tokens` ni comment un Text Style devient un token. |
| Code Connect **indisponible** (plan Starter) ⇒ mapping `comp-*` ↔ code manuel | « les composants `comp-*` vivent dans `packages/ui_kit` » | **Trou.** Aucune convention de nommage `comp-xxx` → classe Dart ni de document de mapping ; la maquette dit explicitement que ce mapping doit être tenu à la main. |
| « Pas de blanc pur ni de noir pur nulle part » | « une feature n'utilise aucune valeur visuelle littérale » | **Trou.** La règle ne couvre que `features/` ; `core/` (ThemeData, `MaterialApp`, scaffold par défaut) et `ui_kit` ne sont pas tenus par AD-10, et Flutter injecte du `#FFFFFF`/`#000000` par défaut. Un lint ou un test de `ThemeData` est nécessaire. |
| « palier 12 » vs collection Figma | AD-10 cite « palier 12 / la maquette Figma » | **Ambiguïté de source.** Si palier 12 et Figma divergent, la spine ne dit pas qui gagne ; la maquette se présente comme l'état réel vérifié. |

---

## F. i18n — compatibilité avec `06-i18n.yaml`

Convention spine : « Textes UI dans des ARB (`flutter_localizations`), clés = ids de microcopy du palier 8 ; **contenu éditorial i18n porté par les entités**, pas par les ARB. »

| Point de 06-i18n | Constat |
|---|---|
| §1 `perimetre_exclu` : « Traduction du contenu narratif (Pins, Parcours) » et « toute infrastructure de traduction … pas préparée activement » | **Contradiction.** « Contenu éditorial i18n porté par les entités » prépare une modélisation multilingue des Pins/Parcours (colonnes par langue, jsonb `{fr: …}`) que 06-i18n refuse explicitement comme sur-ingénierie. Les entités sont **mono-langue**. La seule exception légitime est la **citation d'archives** (original + traduction française, double champ sur Source/Pin) — ce n'est pas de l'i18n, c'est un attribut métier, et la spine ne le nomme pas. |
| §1 « clés i18n, gestion de locale, sélecteur de langue » exclus **mais** §2 « clés stables côté code », « placeholders nommés » | **Compatible sous condition, condition absente.** ARB + `flutter_localizations` est le moyen Flutter standard d'avoir des clés stables, des placeholders nommés et la pluralisation ICU (2 formes fr). Mais la convention doit dire explicitement : `supportedLocales = [fr]` **forcé**, aucun sélecteur, aucun `.arb` autre que `app_fr.arb`, locale `fr_FR` imposée à `intl` pour les formats (JJ/MM/AAAA, virgule décimale, espace insécable des milliers). Sans ça, `flutter_localizations` suit la locale du terminal (Kenji en `ja` ⇒ formats japonais, dates `2026/01/15`). |
| §2 typographie (apostrophes courbes U+2019, guillemets « », espaces insécables, points de suspension U+2026) | **Absent.** C'est une règle de contenu des ARB et des YAML `content/` ; un lint CI (`ci-content`) la vérifierait facilement, la spine ne le prévoit pas. |
| §3 contenu communautaire : « si une métadonnée de langue de soumission est disponible, indicateur discret ; sinon on n'invente pas » | **Non tranché.** La spine ne dit pas si `commentaire`/`retour` portent une colonne `langue` (nullable, jamais détectée automatiquement). C'est une décision de schéma (AD-2), donc de la spine. |
| §6 « back-office en français » | Compatible (AD-1, même stack). |

---

## G. Priorisation (index 3, §7) — cohérence de séquencement

- D10.1 (templates, cœur) → AD-7 phase 1 `content/` YAML conformes aux templates : **cohérent**.
- D8 (si_le_temps) → AD-11 + Deferred : **cohérent**.
- D9 (si_le_temps) → AD-2 impose pgTAP pour I2/I3/I5/I10 dès le départ ⇒ tables communautaires dans le socle avant tout écran communautaire. **Non contradictoire mais non explicité** (coût d'entrée sur le cœur).
- D11 (important) → 3 des 4 briques (page web, schéma du lien, payload OG) sont **Deferred** et les entités C6 n'ont ni table ni lieu : l'écart entre « important » et « différé sans lieu » n'est pas justifié dans la spine.

---

## H. Synthèse classée

### Bloquant (contredit une source ou casse une AD de la spine elle-même)

1. **AD-4 contredit I6** : Parcours de provenance personnelle (C2) et Image partageable (C6) sont déclarés « serveur » ; I6 les impose locaux sans Compte. La partition doit être par entité/provenance, pas par cluster. Et le modèle CAPABILITY du Lien universel vers un Parcours personnel doit être tranché (Compte requis, ou upload opt-in explicite de ce seul Parcours).
2. **AD-10 casse la 1:1 qu'elle énonce** : `TOK-COLOR-PRIMARY` → `TokColor.primary` est le renommage que la maquette interdit ; pas de contrôle de dérive, pas de règle « un id = une constante, jamais un alias », fontes/Text Styles/Effect Styles non traités, mapping `comp-*` manuel non prévu.
3. **Permissions juste-à-temps absentes** (lieu et règle), alors que c'est la traduction directe du refus « toute friction au lancement » et que le palier 4 en fixe déjà la persistance (Profil mémorise « déjà demandée »).

### Important (trou structurel que AD-5 rendra visible à la première story)

4. **Géolocalisation sans service dans `core/`** ; **audio arrière-plan** et **partage natif** logés dans une feature alors qu'ils sont invoqués depuis `pins` et `parcours` (AD-5 interdit l'import) ; **mode présentation sans chrome** sans lieu ni règle.
5. **Convention Proximité vs AD-9** : « pins préchargés » vs « Parcours seule unité de préchargement, rien d'autre » — *Surprenez-moi* hors parcours n'a pas de source de données.
6. **Convention i18n vs 06-i18n §1** : « contenu éditorial i18n porté par les entités » prépare le multilingue refusé ; `supportedLocales=[fr]` forcé et locale `fr_FR` pour `intl` ne sont pas écrits.
7. **Cluster C6 sans atterrissage** : ni table, ni lieu pour Lien universel / Image partageable / Code visuel ; C6-D2 (pas d'identité encodée, pas d'EXIF) et C6-D3 (résolution gracieuse, état `retombé`) sans règle ; slug non défini pour les Parcours non éditoriaux.

### Mineur (à écrire, pas à débattre)

8. I1 vs Deferred « auth tiers » : borner l'import de `raw_user_meta_data`.
9. I7 vs AD-8 : catalogue Époque ouvert en base, fermé dans le binaire (`map_styles`) — style de repli ou styles en Storage.
10. Lecture `anon` du contenu publié non énoncée (mur d'inscription) ; défaut « balade libre » du mode de proximité non énoncé ; colonne position nullable (I9) ; colonne de crédit append-only (I10) ; colonne `langue` nullable sur les contributions ; règle « pas de `#FFFFFF`/`#000000` » étendue à `core/` et `ui_kit` ; route initiale = carte ; lint typographique sur ARB et `content/`.

---

## I. Ce que cette review n'a pas vérifié

- Les fichiers de domaine D1–D11 et les clusters C1–C5 (hors périmètre demandé) : les trous relevés ici sur les colonnes (crédit I10, langue, position nullable) pourraient être précisés dans ces fichiers sans que la spine change.
- Le palier 12 lui-même : la comparaison tokens a été faite sur la maquette §4 (49 tokens), que le document présente comme l'état réel.
- Les versions de la Stack (non demandé).
