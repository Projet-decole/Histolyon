# HistoLyon — Référence maquette Figma pour le développement

> Ce document décrit l'état réel de la maquette Figma telle qu'elle existe aujourd'hui, l'indexe intégralement, et donne les clés pour l'utiliser lors du développement.
>
> Produit le 2026-09-15 par vérification directe du fichier Figma (MCP `get_metadata` / `get_screenshot`) et de l'historique des sessions de conception.

---

## 1. Statut réel en une phrase

La maquette couvre l'intégralité de l'inventaire d'écrans de la conception (mobile + admin desktop), le système de composants, tokens, icônes et marque, un calibrage d'époque fonctionnel, et une page de présentation jury — avec de la navigation câblée entre plusieurs écrans.

---

## 2. Accès au fichier

| Paramètre | Valeur |
|---|---|
| Nom du fichier | HistoLyon |
| File key | `zh0M2STvsYURlBgJNyCokB` |
| URL de base | `https://www.figma.com/design/zh0M2STvsYURlBgJNyCokB/Histo-Lyon` |
| Nœud → URL | ajouter `?node-id=<id avec tiret>` (ex. `904:8185` → `?node-id=904-8185`) |
| Plan Figma | Starter — **Code Connect indisponible** (nécessite un plan Org/Enterprise avec siège Dev). Le mapping composant Figma ↔ composant code devra donc se faire manuellement (ou via un plan supérieur), pas via `list_file_components_for_code_connect`. |
| Mode couleur | **light** — pas de structure dark |
| Accès MCP | `get_metadata` (structure), `get_design_context` (specs + code de référence), `get_screenshot` (visuel). Pas d'outil fiable de listing exhaustif des pages du fichier — utiliser les node-id de la table ci-dessous plutôt que de compter dessus. |

---

## 3. Carte des pages

Vérifié par sondage direct du fichier (pas par les YAML de suivi). Chaque page contient l'entièreté du palier indiqué, sauf mention contraire.

| Page | Node ID | Palier d'origine | Contenu |
|---|---|---|---|---|
| **01 · Fondations** | `347:2` | 1 (tokens) | Banc d'inspection technique : swatches de toutes les variables + styles |
| **02 · Charte** | `354:2` | 2 (charte) | DA présentée : palette annotée + contrastes WCAG mesurés, 12 spécimens typo, spacing/radius/ombres/opacités, mini-bestiaire d'usage (pin éditorial/communautaire/en vérification, tracé, chip Époque) |
| **03 · Icônes** | `368:2` | 3 (icônes) | 54 composants `ICON-*` par famille (catégories/UI/back-office) |
| **04 · Marque** | `375:2` | 4 (marque) | Logo (3 déclinaisons), app icons, favicons, règles d'usage |
| **05 · Composants** | `396:2` | 5 (composants) | Board d'inventaire (`493:801`) + tous les masters `comp-*` (mobile + desktop admin) |
| **06 · Écrans** | `678:2` | 6 + 8 (fusionnés) | 41 écrans/surfaces mobiles : carte, pin, parcours (y compris tous les écrans initialement « différables »), communauté, profil, partage, surfaces transverses M/P |
| **07 · Calibrage époques** | non retrouvé (frames en `904:8xxx`-`904:9xxx`) | 7 (calibrage) | Écran carte avec slider aux 10 ancres d'Époque, câblé (tap pour avancer/reculer dans le temps) |
| **08 · Admin desktop** | `866:2` | 8 (admin) | 8 écrans back-office desktop (layout sidebar + topbar), palette desktop 1440px |
| **12 · Présentation jury** | `908:15453` (frame racine `908:15454`) | 12 (jury) | Page one-shot 1440px, 7 sections (Hero, Pourquoi, Pour qui, Carte temporelle signature, Les piliers, DA & surfaces, Parcours démo) |

**Pages prévues mais non réalisé** : une page dédiée au surfaces hors-app — page web, code visuel, image partageable, payload Open Graph.

---

## 4. Design tokens

Collection Figma **« HistoLyon — Tokens »** (`VariableCollectionId:345:2`, mode unique `light`). Convention : **le nom de la variable/du style Figma = l'id exact ci-dessous** (aucune traduction à faire). Pour le code : reprendre ces mêmes identifiants comme noms de constantes/design tokens dans le design system de l'app — la traçabilité 1:1 est le point qui a été soigné pendant toute la maquette, ne pas la casser en renommant côté code.

### Couleurs (18 — variable `COLOR` + Paint Style `color/<id>`)

| id | hex / valeur |
|---|---|
| `TOK-COLOR-PRIMARY` | `#B85220` (terracotta) |
| `TOK-COLOR-PRIMARY-FONCE` | `#8B3A14` |
| `TOK-COLOR-PRIMARY-CLAIR` | `#D4703A` |
| `TOK-COLOR-FOND-PRINCIPAL` | `#F5E8D0` (parchemin) |
| `TOK-COLOR-FOND-SECONDAIRE` | `#EDD9B5` |
| `TOK-COLOR-FOND-TERTIAIRE` | `#E5CCA0` |
| `TOK-COLOR-TEXTE-PRINCIPAL` | `#1C1108` (encre brune — le « noir » de l'app) |
| `TOK-COLOR-TEXTE-SECONDAIRE` | `#5C3D1E` |
| `TOK-COLOR-TEXTE-TERTIAIRE` | `#9B7B5A` |
| `TOK-COLOR-OR-ACCENT` | `#C9901A` (décoratif uniquement — contraste 2.32:1, texte interdit) |
| `TOK-COLOR-BLANC-NARRATIF` | `#FAF6F0` (le « blanc » de l'app — **jamais `#FFFFFF`**) |
| `TOK-COLOR-FONCTIONNEL-SUCCES` | `#276D45` |
| `TOK-COLOR-FONCTIONNEL-ERREUR` | `#B03427` |
| `TOK-COLOR-FONCTIONNEL-INFO` | `#2762A0` |
| `TOK-COLOR-PIN-EDITORIAL` | `#B85220` (= PRIMARY, id distinct) |
| `TOK-COLOR-PIN-COMMUNAUTAIRE` | `#7A6555` |
| `TOK-COLOR-CONTOUR-VERIFICATION` | `#1C1108` (= TEXTE-PRINCIPAL, id distinct) |
| `TOK-COLOR-OVERLAY-SOMBRE` | `rgba(28,17,8,0.65)` |

Contrastes mesurés et vérifiés WCAG (page 02 · Charte) : texte principal/secondaire sur parchemin = AAA ; terracotta sur parchemin = AA grand texte seulement (4.06:1) ; or accent = décoratif exclusivement.

### Espacement / radius / opacités (16 — variable `FLOAT`)

| Spacing | px | Radius | px | Opacité | valeur |
|---|---|---|---|---|---|
| `TOK-SPACE-XS` | 4 | `TOK-RADIUS-NONE` | 0 | `TOK-OPACITY-BACKDROP-M6` | 0.4 |
| `TOK-SPACE-SM` | 8 | `TOK-RADIUS-SM` | 4 | `TOK-OPACITY-BACKDROP-M8` | 0.65 |
| `TOK-SPACE-MD` | 12 | `TOK-RADIUS-MD` | 8 | `TOK-OPACITY-DESACTIVE` | 0.5 |
| `TOK-SPACE-LG` | 16 | `TOK-RADIUS-LG` | 12 | `TOK-OPACITY-SEPARATEUR` | 0.12 |
| `TOK-SPACE-XL` | 24 | `TOK-RADIUS-PILL` | 9999 | | |
| `TOK-SPACE-XXL` | 32 | | | | |
| `TOK-SPACE-XXXL` | 48 | | | | |

### Typographie (12 — Local Text Style `typo/<id>`)

3 fontes : **Playfair Display** (titres éditoriaux, Bold/Extra Bold), **Lora** (corps narratif, Regular/Semi Bold), **Inter** (UI, Regular/Medium).

| id | fonte | px / interligne | usage |
|---|---|---|---|
| `TOK-TYPO-DISPLAY-XL` | Playfair Display Extra Bold | 32 / 120% | splash, célébration de fin |
| `TOK-TYPO-DISPLAY-LG` | Playfair Display Bold | 26 / 125% | titre d'écran narratif |
| `TOK-TYPO-DISPLAY-MD` | Playfair Display Bold | 22 / 130% | titre d'aperçu rapide, section |
| `TOK-TYPO-DISPLAY-SM` | Playfair Display Bold | 18 / 135% | sous-titre, chip Époque actif |
| `TOK-TYPO-BODY-LG` | Lora Regular | 17 / 165% | récit principal |
| `TOK-TYPO-BODY-MD` | Lora Regular | 15 / 160% | teaser, description courte |
| `TOK-TYPO-BODY-SM` | Lora Regular | 14 / 155% | notes, légendes, sources |
| `TOK-TYPO-BODY-EMPHASIS` | Lora Semi Bold | 17 / 165% | mise en relief dans le récit |
| `TOK-TYPO-UI-LG` | Inter Medium | 16 / 140% | labels de boutons principaux |
| `TOK-TYPO-UI-MD` | Inter Medium | 14 / 140% | chips, badges, métadonnées |
| `TOK-TYPO-UI-SM` | Inter Regular | 12 / 140% | métadonnées (durée, distance, date) |
| `TOK-TYPO-UI-XS` | Inter Medium | 11 / 130% | labels du sélecteur de section |

### Ombres (3 — Effect Style `shadow/<id>`)

`TOK-SHADOW-SM` = `0 1px 3px rgba(28,17,8,0.12)` (cards au repos) · `TOK-SHADOW-MD` = `0 2px 8px rgba(28,17,8,0.20)` (pin, FAB) · `TOK-SHADOW-LG` = `0 4px 16px rgba(28,17,8,0.30)` (dialogues)

### Règles à respecter côté code

- Aucune valeur codée en dur ne doit exister à la fois en Figma et dans l'app avec une valeur différente — les deux sont censés partager la même source. Si un écart est constaté à l'implémentation, c'est un signal à vérifier, pas à trancher en silence.
- Pas de blanc pur (`#FFFFFF`) ni de noir pur (`#000000`) nulle part dans l'UI — c'est une règle de charte, pas un oubli.
- `TOK-COLOR-OR-ACCENT` est strictement décoratif (jamais de texte dessus).

---

## 5. Icônes (54 composants)

Page **03 · Icônes** (`368:2`). Style monoline **OUTLINED** uniquement (pas de variant rempli), stroke 1,5 (XS : 14×14 stroke 2). Couleur toujours par variable bindée (jamais de hex en dur), teinte par défaut `TOK-COLOR-TEXTE-PRINCIPAL`, re-bindée par le composant consommateur pour les usages contextuels.

**Convention de taille** : SM(16)/MD(20)/LG(24)/XL(32) = simple redimensionnement d'instance (pas des variants) ; seul **XS(14, stroke 2)** est un vrai variant géométrique dédié, sur les 11 familles catégories uniquement (`component set` taille=MD|XS).

Sourcing : 48 SVG [Lucide](https://lucide.dev) (`lucide-static@1.21.0`, licence ISC) + 2 customs (`ICON-CAT-ARCHITECTURE`, `ICON-CAT-LIEU-DISPARU` — géométries absentes de Lucide).

### Catégories de lieu (11 — sets MD|XS)

| id | source Lucide |
|---|---|
| `ICON-CAT-CLASSIQUE` | `landmark` |
| `ICON-CAT-ANECDOTE` | `sparkles` |
| `ICON-CAT-MUSEE-INSTITUTION` | `building-2` |
| `ICON-CAT-PERSONNE` | `user-round` |
| `ICON-CAT-EVENEMENT` | `zap` |
| `ICON-CAT-LIEU-DISPARU` | custom (`landmark-off`, absent de Lucide) |
| `ICON-CAT-VIE-QUOTIDIENNE` | `users` |
| `ICON-CAT-ARCHITECTURE` | custom (`archway`, absent de Lucide) |
| `ICON-CAT-NATURE-GEOGRAPHIE` | `waves` |
| `ICON-CAT-PATRIMOINE-VIVANT` | `heart-handshake` |
| `ICON-CAT-GASTRONOMIE` | `utensils` |

### UI fonctionnelles (33)

`ICON-UI-RETOUR`(arrow-left) · `FERMETURE`(x) · `CREATION-FAB`(plus) · `PLAY`(play) · `PAUSE`(pause) · `CALENDRIER`(calendar) · `LIEU`(map-pin) · `ERREUR`(circle-alert) · `SUCCES`(circle-check) · `INFO`(info) · `FAVORI`(heart) · `PARTAGE`(share) · `SIGNALEMENT`(flag) · `RECHERCHE`(search) · `FILTRE`(sliders-horizontal) · `CHECK`(check) · `SECTION-CARTE`(map) · `SECTION-PARCOURS`(route) · `SECTION-PROFIL`(circle-user-round) · `OFFLINE`(wifi-off) · `CHARGEMENT`(loader-circle) · `LIEN-EXTERNE`(external-link) · `ANONYMAT`(user-x) · `PROVENANCE-EDITORIAL`(badge-check) · `PROVENANCE-COMMUNAUTAIRE`(users) · `VERIFICATION-EN-COURS`(clock) · `COUCHE`(layers) · `MODE-SURPRENEZ-MOI`(dice-5) · `MODE-PRESENTATION`(monitor-play) · `DUREE`(clock) · `DISTANCE`(route) · `ETAPES`(milestone) · `LANGUE`(languages)

Ajoutées en cours de palier 5 (cascade, non comptées dans les 33 ci-dessus dans les specs d'origine mais présentes en Figma) : `ICON-UI-CAMERA`(camera), `ICON-UI-NOTIFICATION`(bell).

### Back-office (10)

`ICON-ADMIN-VALIDER`(circle-check) · `REJETER`(circle-x) · `MODERER`(shield-check) · `VALIDATION-SCIENTIFIQUE`(book-open-check) · `PROMOUVOIR`(circle-arrow-up) · `RETIRER`(archive) · `REOUVRIR`(archive-restore) · `TABLEAU-BORD`(layout-dashboard) · `CATALOGUE`(list) · `PREVISUALISATION`(eye)

---

## 6. Marque

Page **04 · Marque** (`375:2`). Source de vérité = déclinaison (a) éditée à la main par l'utilisateur dans Figma (node `378:2`) — toutes les autres déclinaisons en sont clonées.

| Artefact | Node ID | Description |
|---|---|---|
| Logo (a) Couleur | `378:2` | Dégradé terracotta (PRIMARY→PRIMARY-FONCE, valeurs bakées) + illustration parchemin + wordmark + tagline |
| Logo (b) Monochrome encre | `384:2` | Tout en TEXTE-PRINCIPAL sur fond parchemin |
| Logo (c) Monochrome parchemin | `384:26` | Tout en BLANC-NARRATIF sur fond encre |
| App icon iOS | `385:2` | 1024×1024, sans coins arrondis (l'OS gère), composition (a) complète |
| App icon Android — background | `385:26` | 1024, dégradé seul |
| Favicons | 512 / 180 / 64 / 32 / 16 | Lion seul sur terracotta, sans wordmark ni tagline |
| Règles d'usage | `387:31` | Clear space, taille minimale, fonds autorisés/interdits |

**Dette connue** : le foreground Android adaptive (illustration + wordmark en zone de sécurité ~66 %) a été retiré par l'utilisateur après production. Si le pipeline de build Android exige un foreground séparé du background, **il doit être reconstruit à partir de l'icône iOS** — il n'existe pas actuellement dans le fichier.

Text styles dédiés : `marque/wordmark` (Playfair Display Bold 52/100%) · `marque/tagline` (Inter Medium 15/120%, letter-spacing 18%, texte « LYON IMMERSIVE »).

---

## 7. Composants (118 masters)

Page **05 · Composants** (`396:2`), board d'inventaire `493:801`. Décompte final : **40 atomes + 30 molécules (1 non matérialisé séparément, voir note) + 24 fonctionnels + 14 shell mobile + 8 back-office + 2 shells admin desktop (sidebar/topbar) = 118 masters Figma**, retraçant 116 ids conception uniques.

### Conventions transverses (à connaître avant d'implémenter depuis Figma)

- **Nom Figma = id conception exact.** `comp-button-primary`, `comp-pin`, etc. Aucune traduction — reprendre ces noms tels quels comme identifiants de composants côté code facilite l'audit de correspondance.
- **Composant imbriqué = vraie instance**, jamais un visuel recréé inline (DRY absolu). Un composant qui utilise un bouton contient une instance de `comp-button-primary`, pas une copie.
- **Icônes = instance-swap**, pas un variant. Une propriété d'instance-swap expose l'icône échangeable (défaut renseigné), à ne pas confondre avec un vrai variant.
- **États `pressed`/`selected`/etc. câblés par réaction Figma** (prototype), pas par variant systématique — sauf quand l'état change réellement la structure.
- **Convention same-named layers** : chaque variant/état contient TOUS les calques nommés (même cachés). C'est ce qui permet le smart-animate propre entre écrans — à reproduire côté code si le système d'animation s'appuie sur des layer trees comparables (ou à ignorer si l'app anime autrement, mais bon à savoir en lisant les screens).
- **État loading = skeleton shimmer**, jamais un spinner seul (sauf `ICON-UI-CHARGEMENT` isolé pour micro-attente).
- **`comp-pin`** est le composant le plus complexe : 5 axes de variants (`provenance × contexteParcours × multiEpoques × verification × dejaVisite` = 60 variants matérialisés sur 80 théoriques, 20 exclus par invariant). C'est le pivot de tout l'affichage cartographique — à étudier en premier si vous implémentez la carte.
- **`comp-slider-epoque`** (fonctionnel, `534:1917`) est le producteur de l'état partagé "époque courante" (10 variants = 10 ancres réelles, largeur fixe 358px pour tenir dans l'écran 390px). Pivot du calibrage d'époque (page 07).
- Plusieurs composants **ne matérialisent pas un vrai moteur** (parti pris assumé, pas un oubli) : `comp-viewer-3d`, `comp-camera-ar`, `comp-carte` ne sont que des états représentatifs (placeholder/chargement/indisponible) — le vrai rendu 3D/AR/carte est à implémenter côté app, Figma ne fait que documenter les états d'UI autour.

### Index par famille

**Atomes (40)** — `comp-button-primary` `436:529`, `-secondary` `437:517`, `-tertiary` `437:546`, `-back` `438:527`, `-fermeture-overlay` `438:544`, `-fab-creation` `439:559`, `-play-audio` `439:589` · `comp-chip-epoque` `448:584`, `-couche-carte` `448:623`, `-categorie` `448:644`, `-filtre` `448:665` · `comp-champ-saisie-texte` `453:824`, `-textarea` `458:767`, `-nombre` `458:911`, `-date` `459:857`, `-lieu` `459:1086` · `comp-badge-statut` `463:763`, `-nombre` `468:764` · `comp-tag` `463:779`, `-categorie` `463:780`, `-provenance` `463:799` · `comp-mention-anonymat` `463:800` · `comp-status-pin-verification` `463:807` · `comp-toggle-switch` `462:756` · `comp-separateur` `480:770` · `comp-espaceur` `480:781` · `comp-avatar` `481:812` · `comp-image-avatar-small` `481:831` · `comp-image-hero` `481:864` · `comp-lien-texte` `483:782` · `comp-lien-universel-qr` `483:883` · `comp-indicateur-chargement` `484:794`, `-progression` `484:807` · `comp-page-indicator` `484:824` · `comp-message-erreur-inline` `485:777`, `-success-inline` `485:778` · `comp-libelle-bouton` `434:488`, `-chip` `448:547`, `-texte` `482:774` (pivot, ≥40 intégrations) · `comp-icone` : **non matérialisé séparément** — résolu directement par le système d'icônes (page 03), instance-swap.

**Molécules (30)** — `comp-header-titre-action` `504:839`, `-retour-titre-action` `504:806` (⚠️ `comp-header-retour-titre` sans action reste en arbitrage, non construit séparément) · `comp-controle-favori` `498:724`, `-partage` `498:729`, `-signalement` `498:746` · `comp-item-liste-simple` `505:777`, `-pin-apercu` `505:838`, `-parcours-simple` `507:869`, `-etape` `507:981` · `comp-item-historique-visite` `507:950` · `comp-card-parcours-large` `514:1486`, `-compact` `514:1566` · `comp-vignette-pin` `509:1040` · `comp-item-commentaire` `515:1142` · `comp-rangee-favori` `515:1233`, `-historique` `515:1234`, `-profil-action` `515:1280` · `comp-zone-narration` `519:1222`, `-sources` `519:1315`, `-commentaires` `519:1371`, `-post-narrative` `519:1372`, `-vide` `519:1460` · `comp-encart-information` `521:1386` · `comp-bloc-sources` `521:1387` · `comp-compteur-statistique` `521:1397` · `comp-indicateur-permission` `521:1439` · `comp-info-progress-etape` `521:1440` · `comp-carousel` `521:1504` · `comp-barre-filtres` `521:1505`

**Fonctionnels (24)** — `comp-pin` `401:2321` (pilote, 60 variants) · `comp-slider-epoque` `534:1917` (10 variants, producteur état époque) · `comp-cluster-densite` `527:1551` (8 variants) · `comp-frise-chronologique` `527:1454` · `comp-trace-parcours` `527:1570` (6 variants) · `comp-carte` `535:1738` (2 variants — nominal/offline ; structure scrollable + overlay fixe recherche/slider) · `comp-recherche-surface` `561:2092` (3 variants) · `comp-grid-recherche` `559:2139` (3) · `comp-filtres-couches` `559:2140` · `comp-alerte-proximite` `559:2215` · `comp-lecteur-audio` `584:2039` (4 variants, producteur état audio) · `comp-lecteur-video` `588:2121` (6) · `comp-quiz` `590:2131` (6, QCM + vrai/faux câblés) · `comp-avant-apres` `591:3485` (2) · `comp-viewer-3d` `592:2165` (3, placeholder) · `comp-camera-ar` `593:2190` (3, placeholder) · `comp-puzzle` `611:2309` (3, taquin photo) · `comp-enigme` `612:2278` (2) · `comp-citation` `614:2260` · `comp-saviez-vous` `614:2267` · `comp-formulaire-creation-compte` `622:2564` (3, producteur état compte) · `-connexion-compte` `623:2617` (3) · `-saisie-pin` `625:2754` (2, showcase dense — producteur soumission communautaire) · `-creation-parcours` `626:2793` (2)

**Shell mobile (14)** — `comp-selecteur-section-principale` `642:2745` (nav bas, 3 sections S1/S2/S3) · `comp-apercu-rapide-pin` `643:2803` (2, template M2) · `comp-backdrop` `657:3012` (3, voile réutilisable — **couleur non bindée à une variable**, exception documentée) · `comp-surface-ponctuelle-lancement-parcours` `655:3076` (2) · `-filtres-parcours` `654:2995` · `-saut-etape` `654:2943` · `comp-dialogue-confirmation` `660:2908` (2, neutre/destructif) · `comp-dialogue-permission` `661:2950` (3, géoloc/caméra/notification) · `comp-message-ephemere` `662:2965` (4, toast) · `comp-indication-onboarding` `663:2943` · `comp-invitation-microparcours` `663:2951` · `comp-surface-persistante-audio` `666:2958` (P1) · `-parcours` `666:2992` (P2) · `comp-bandeau-information-offline` `666:3011` (P3)

**Back-office (8, + 2 shells admin)** — `comp-tableau-bord-admin`, `comp-catalogue-pins-admin`, `comp-formulaire-saisie-pin-admin`, `comp-validation-scientifique`, `comp-moderation-communautaire`, `comp-moderation-soumissions`, `comp-promotion-communautaire`, `comp-retrait-reouverture-pin` — tous présents sur la page 05, node IDs précis non extraits dans cette passe (rechercher par nom exact dans Figma). Plus : `comp-shell-admin-sidebar` `872:12253` (8 variants — un par section active) et `comp-shell-admin-topbar` `872:12254`.

**Composants abandonnés en cours de route** (pour éviter qu'un dev les cherche en vain) : les 4 `comp-layout-*` (carte-principale, parcours, profil, consultation-pin-approfondie) ont été construits puis **supprimés** — la mise en page d'écran a été jugée relever de la composition d'écran, pas d'un composant réutilisable. Si vous cherchez "comment structurer l'écran carte", regardez l'écran lui-même (§ 8), pas un composant layout.

---

## 8. Écrans — index complet

### Page 06 · Écrans (`678:2`) — 41 frames mobiles (390×844)

**Carte** — `E-CARTE-PRINCIPALE` : nominal_charge `678:13`, chargement_initial `679:4891`, offline_avec_cache `679:287`, parcours_en_cours `679:472` · overlays : `E-CARTE-APERCU-PIN` `689:862`, `E-CARTE-RECHERCHE` `689:959`, `E-CARTE-FILTRES-COUCHES` `689:1061`, `E-CARTE-ALERTE-PROXIMITE` `689:1170`

**Pin** — `E-PIN-CONSULTATION-APPROFONDIE` `693:1928` · `E-PIN-MODE-PRESENTATION` `805:4909` · `E-PIN-CONSULTATION-3D` `807:4975` · `E-PIN-CONSULTATION-AR` `808:8518`

**Parcours** — `E-PARCOURS-PRINCIPAL` `691:1765` · `E-PARCOURS-FICHE-DETAIL` `694:2058` · `E-PARCOURS-LANCEMENT` `694:6044` · `E-PARCOURS-EN-COURS-TERRAIN` `695:2205` · `E-PARCOURS-FIN-CELEBRATION` `696:2488` · `E-PARCOURS-EDITEUR` `780:2807` · `E-PARCOURS-FILTRES` `780:5496` · `E-PARCOURS-EN-COURS-CANAPE` `781:3228` · `E-PARCOURS-SAUT-ETAPE` `783:5658`

**Communauté** — `E-COMMUNAUTE-SOUMISSION-PIN` `791:3531` · `-REDACTION-COMMENTAIRE` `791:3554` · `-REDACTION-SIGNALEMENT` `791:3577` · `-REDACTION-RETOUR-PARCOURS` `791:3600` · `-SUIVI-SOUMISSIONS` `791:3623`

**Profil** — `E-PROFIL-PRINCIPAL` avec compte `793:3601` / sans compte `795:6352` · `-FAVORIS` charge `796:4414` / vide `796:8244` · `-HISTORIQUE` `797:4577` · `-PARAMETRES` `798:4709` · `-CREATION-COMPTE` `799:4758` · `-CONNEXION-COMPTE` `799:4906` · `-PARAMETRES-COMPTE` `800:4880`

**Partage** — `E-PARTAGE-FIN-PARCOURS-IMAGE` `806:8323` · `E-PARTAGE-CODE-VISUEL` `806:8332`

**Surfaces transverses** — `M5` (progression persistante audio+parcours) `816:8574` · `P1` (audio persistant) `816:8786` · `M9` (message éphémère) `816:9026` · `M8` (dialogue confirmation) `816:9181`

*(Frame technique `678:3` = gabarit device, pas un écran.)*

### Page 07 · Calibrage époques — partiellement indexée

Écran carte avec slider aux 10 ancres. Confirmé par capture : `904:8185` = « Antiquité romaine » (−43 – 476). Les autres ancres (Haut Moyen Âge → Aujourd'hui) existent dans la plage de node IDs `904:8xxx`-`904:9xxx` d'après l'historique de session, mais n'ont pas été énumérées nommément dans cette passe — à confirmer par inspection Figma directe avant de s'appuyer dessus.

### Page 08 · Admin desktop (`866:2`) — 8 écrans (1440px, layout sidebar+topbar)

`E-ADMIN-ACCUEIL` `866:265` · `E-ADMIN-CATALOGUE-PINS` `868:201` · `E-ADMIN-SAISIE-PIN-TEMPLATE` `868:852` · `E-ADMIN-VALIDATION-SCIENTIFIQUE` `868:1513` · `E-ADMIN-MODERATION-COMMUNAUTAIRE` `868:1962` · `E-ADMIN-MODERATION-SOUMISSIONS` `868:12298` · `E-ADMIN-PROMOTION-COMMUNAUTAIRE` `868:12554` · `E-ADMIN-RETRAIT-REOUVERTURE-PIN` `868:12840`

### Page 12 · Présentation jury (`908:15453`)

Frame unique `908:15454` (1440×6015) en 7 sections empilées : Hero `909:14` · Pourquoi `910:13770` · Pour qui `911:4756` · Carte temporelle signature `912:15086` · Les piliers `913:2472` · DA & surfaces `914:3468` · Parcours démo `918:3468`. Pas des écrans app — support de pitch, à ne pas implémenter tel quel.

### Convention de nommage des écrans

`E-<ID>` pour l'état par défaut ; états additionnels en frames sœurs `E-<ID>--<etat>` (séparateur double-tiret, jamais de slash). États attendus selon le type d'écran : vide / chargement / erreur / offline / premierUsage / permissionRefusee. **Dans les faits, la maquette a souvent matérialisé les états comme des variantes du même nom suivies d'un descriptif après `·`** (ex. `E-CARTE-PRINCIPALE · nominal_charge`) plutôt que la convention `--etat` du cadre théorique — vérifier au cas par cas plutôt que supposer.

---

## 9. Ce qui n'est PAS confirmé — à vérifier avant de s'appuyer dessus

- **Interactions/prototypage (palier 10)** : plusieurs navigations sont câblées (profil ↔ ses sous-écrans, accès 3D/AR depuis le pin, abandon de parcours, toggles play/pause, flux quiz, ouverture/fermeture de surfaces). Il n'y a **pas d'inventaire exhaustif confirmé** de tout ce qui est câblé vs pas câblé — à tester dans Figma en mode Présentation avant de supposer qu'un enchaînement précis existe.
- **Surfaces hors-app (palier 9 conception : page web responsive, code visuel, image partageable, payload Open Graph)** : aucune page Figma dédiée retrouvée. Soit elle n'a jamais été construite, soit elle existe sous un node-id non couvert par cette passe — à vérifier avant de considérer ce périmètre comme non fait.
- **Exhaustivité de la page 07** : voir § 8, liste des 10 ancres non confirmée nommément.
- **Node IDs exacts des 8 composants back-office** : présence confirmée par nom, IDs précis non extraits (voir § 7).

Si un de ces points s'avère bloquant pour une story de dev, la vérification se fait en 1 appel `get_metadata`/`get_screenshot` sur le node concerné — ne pas réinvestir dans une re-analyse complète du fichier.

---

## 10. Comment travailler avec cette maquette

1. **Pour lire une spec d'écran ou de composant précisément** : ouvrir le node ID correspondant dans Figma (Dev Mode si disponible) ou via `get_design_context` du MCP Figma — c'est la source vivante, plus fiable que toute capture ou description figée.
2. **Respecter la traçabilité des noms** : un composant `comp-X` en Figma doit correspondre à un composant nommé de façon reconnaissable côté code (pas nécessairement identique, mais traçable) — c'est ce qui permettra à l'équipe de vérifier que le code reflète la maquette sans deviner.
3. **Les tokens (§ 4) sont la première chose à porter dans le code** — avant tout composant, ce sont eux qui garantissent que même un écran non encore répliqué pixel-perfect reste dans la charte.
4. **Pour tout ce qui n'est pas dans ce document (contenu exact d'un écran, wording précis, comportement détaillé d'un composant)** : la source de vérité fonctionnelle reste `design/conception/` (48 écrans, 55 flows, 24 entités, tous les textes UI) — la maquette Figma en est la matérialisation visuelle, pas une source indépendante.
