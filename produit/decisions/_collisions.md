---
id: DOC-COLLISIONS
type: document
titre: "Collisions d’identifiants de conception/"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

# Collisions d’identifiants de `conception/`

Généré par `dart run tools/ctx_correspondance.dart`. Un identifiant est en collision quand le même texte désigne des objets différents (rôles distincts) ou est défini plusieurs fois. Dans `produit/`, chaque identifiant est typé (CAP-, ECR-, FLX-…) et unique ; l’ancien id est dans `anciens_ids` et dans `_correspondance.csv`.

Total : 944 définitions, 674 identifiants distincts, 141 répétés (34 avec plusieurs rôles, 107 définis plusieurs fois pour un même rôle).

## Collisions de rôle

| ancien id | occurrences | rôles |
|---|---|---|
| C1 | 4 | cluster de données ; élément d’architecture ; flux |
| C2 | 4 | cluster de données ; élément d’architecture ; flux |
| C3 | 4 | cluster de données ; élément d’architecture ; flux |
| C4 | 4 | cluster de données ; élément d’architecture ; flux |
| C5 | 4 | cluster de données ; élément d’architecture ; flux |
| C6 | 4 | cluster de données ; élément d’architecture ; flux |
| D1 | 10 | domaine fonctionnel ; décision locale ; flux ; ancre ou décision de cartographie ; état, interaction ou décision ; durée, courbe, chorégraphie, mapping ou décision ; décision de tokens ; décision d’icônes ; surface hors app ou décision |
| D10 | 5 | domaine fonctionnel ; ancre ou décision de cartographie ; état, interaction ou décision ; décision de tokens ; décision d’icônes |
| D11 | 2 | domaine fonctionnel ; décision de tokens |
| D2 | 10 | domaine fonctionnel ; décision locale ; flux ; ancre ou décision de cartographie ; état, interaction ou décision ; durée, courbe, chorégraphie, mapping ou décision ; décision de tokens ; décision d’icônes ; surface hors app ou décision |
| D3 | 10 | domaine fonctionnel ; décision locale ; flux ; ancre ou décision de cartographie ; état, interaction ou décision ; durée, courbe, chorégraphie, mapping ou décision ; décision de tokens ; décision d’icônes ; surface hors app ou décision |
| D4 | 9 | domaine fonctionnel ; flux ; ancre ou décision de cartographie ; état, interaction ou décision ; durée, courbe, chorégraphie, mapping ou décision ; décision de tokens ; décision d’icônes ; surface hors app ou décision |
| D5 | 9 | domaine fonctionnel ; flux ; ancre ou décision de cartographie ; état, interaction ou décision ; durée, courbe, chorégraphie, mapping ou décision ; décision de tokens ; décision d’icônes ; surface hors app ou décision |
| D6 | 9 | domaine fonctionnel ; flux ; ancre ou décision de cartographie ; état, interaction ou décision ; durée, courbe, chorégraphie, mapping ou décision ; décision de tokens ; décision d’icônes ; surface hors app ou décision |
| D7 | 9 | domaine fonctionnel ; flux ; ancre ou décision de cartographie ; état, interaction ou décision ; durée, courbe, chorégraphie, mapping ou décision ; décision de tokens ; décision d’icônes ; surface hors app ou décision |
| D8 | 8 | domaine fonctionnel ; flux ; ancre ou décision de cartographie ; état, interaction ou décision ; décision de tokens ; décision d’icônes ; surface hors app ou décision |
| D9 | 7 | domaine fonctionnel ; flux ; ancre ou décision de cartographie ; état, interaction ou décision ; décision de tokens ; décision d’icônes |
| E-ADMIN-ACCUEIL | 3 | écran ; principe ou bloc de contenu |
| E-ADMIN-CATALOGUE-PINS | 3 | écran ; principe ou bloc de contenu |
| E-ADMIN-MODERATION-COMMUNAUTAIRE | 3 | écran ; principe ou bloc de contenu |
| E-ADMIN-MODERATION-SOUMISSIONS | 3 | écran ; principe ou bloc de contenu |
| E-ADMIN-PROMOTION-COMMUNAUTAIRE | 3 | écran ; principe ou bloc de contenu |
| E-ADMIN-RETRAIT-REOUVERTURE-PIN | 3 | écran ; principe ou bloc de contenu |
| E-ADMIN-SAISIE-PIN-TEMPLATE | 3 | écran ; principe ou bloc de contenu |
| E-ADMIN-VALIDATION-SCIENTIFIQUE | 3 | écran ; principe ou bloc de contenu |
| E1 | 4 | élément d’architecture ; flux ; état, interaction ou décision |
| E2 | 4 | élément d’architecture ; flux ; état, interaction ou décision |
| E3 | 4 | élément d’architecture ; flux ; état, interaction ou décision |
| P1 | 2 | mode/surface ; principe ou bloc de contenu |
| P2 | 2 | mode/surface ; principe ou bloc de contenu |
| P3 | 2 | mode/surface ; principe ou bloc de contenu |
| PR1 | 2 | ancre ou décision de cartographie ; durée, courbe, chorégraphie, mapping ou décision |
| PR2 | 2 | ancre ou décision de cartographie ; durée, courbe, chorégraphie, mapping ou décision |
| persona_check_obligatoire | 2 | persona ou règle de lecture ; domaine fonctionnel |

## Doublons de définition (même rôle)

| ancien id | rôle | sources |
|---|---|---|
| 01 | numéro de section | 06-flows/00-index.yaml:62 ; 07-ecrans/00-index.yaml:62 ; 09-cartographie/00-index.yaml:152 ; 10-composants/00-index.yaml:350 ; 11-reponse-parametrique/00-index.yaml:338 ; 12-tokens/00-index.yaml:269 ; 13-icones/00-index.yaml:246 ; 14-surfaces-hors-app/00-index.yaml:168 |
| 02 | numéro de section | 06-flows/00-index.yaml:68 ; 07-ecrans/00-index.yaml:67 ; 09-cartographie/00-index.yaml:163 ; 10-composants/00-index.yaml:356 ; 11-reponse-parametrique/00-index.yaml:354 ; 12-tokens/00-index.yaml:282 ; 13-icones/00-index.yaml:262 ; 14-surfaces-hors-app/00-index.yaml:186 |
| 03 | numéro de section | 06-flows/00-index.yaml:74 ; 07-ecrans/00-index.yaml:71 ; 09-cartographie/00-index.yaml:174 ; 10-composants/00-index.yaml:362 ; 11-reponse-parametrique/00-index.yaml:370 ; 12-tokens/00-index.yaml:291 ; 13-icones/00-index.yaml:272 ; 14-surfaces-hors-app/00-index.yaml:199 |
| 04 | numéro de section | 06-flows/00-index.yaml:82 ; 07-ecrans/00-index.yaml:75 ; 09-cartographie/00-index.yaml:184 ; 10-composants/00-index.yaml:377 ; 11-reponse-parametrique/00-index.yaml:386 ; 12-tokens/00-index.yaml:297 ; 13-icones/00-index.yaml:281 ; 14-surfaces-hors-app/00-index.yaml:211 |
| 05 | numéro de section | 06-flows/00-index.yaml:88 ; 07-ecrans/00-index.yaml:79 ; 10-composants/00-index.yaml:388 ; 11-reponse-parametrique/00-index.yaml:404 ; 14-surfaces-hors-app/00-index.yaml:224 |
| 06 | numéro de section | 06-flows/00-index.yaml:94 ; 07-ecrans/00-index.yaml:83 ; 14-surfaces-hors-app/00-index.yaml:237 |
| 07 | numéro de section | 06-flows/00-index.yaml:100 ; 07-ecrans/00-index.yaml:87 ; 14-surfaces-hors-app/00-index.yaml:249 |
| 08 | numéro de section | 06-flows/00-index.yaml:106 ; 07-ecrans/00-index.yaml:91 |
| A1 | flux | 06-flows/00-index.yaml:119 ; 06-flows/01-decouverte.yaml:39 |
| A2 | flux | 06-flows/00-index.yaml:122 ; 06-flows/01-decouverte.yaml:95 |
| A3 | flux | 06-flows/00-index.yaml:125 ; 06-flows/01-decouverte.yaml:141 |
| A4 | flux | 06-flows/00-index.yaml:128 ; 06-flows/01-decouverte.yaml:207 |
| A5 | flux | 06-flows/00-index.yaml:131 ; 06-flows/01-decouverte.yaml:252 |
| A6 | flux | 06-flows/00-index.yaml:134 ; 06-flows/01-decouverte.yaml:309 |
| B1 | flux | 06-flows/00-index.yaml:139 ; 06-flows/02-consultation-pin.yaml:40 |
| B2 | flux | 06-flows/00-index.yaml:142 ; 06-flows/02-consultation-pin.yaml:104 |
| B3 | flux | 06-flows/00-index.yaml:145 ; 06-flows/02-consultation-pin.yaml:200 |
| B4 | flux | 06-flows/00-index.yaml:148 ; 06-flows/02-consultation-pin.yaml:262 |
| B5 | flux | 06-flows/00-index.yaml:151 ; 06-flows/02-consultation-pin.yaml:324 |
| B6 | flux | 06-flows/00-index.yaml:154 ; 06-flows/02-consultation-pin.yaml:395 |
| B7 | flux | 06-flows/00-index.yaml:157 ; 06-flows/02-consultation-pin.yaml:459 |
| C10 | flux | 06-flows/00-index.yaml:188 ; 06-flows/03-parcours.yaml:433 |
| C11 | flux | 06-flows/00-index.yaml:191 ; 06-flows/03-parcours.yaml:471 |
| C12 | flux | 06-flows/00-index.yaml:194 ; 06-flows/03-parcours.yaml:514 |
| C13 | flux | 06-flows/00-index.yaml:197 ; 06-flows/03-parcours.yaml:567 |
| C7 | flux | 06-flows/00-index.yaml:179 ; 06-flows/03-parcours.yaml:312 |
| C8 | flux | 06-flows/00-index.yaml:182 ; 06-flows/03-parcours.yaml:361 |
| C9 | flux | 06-flows/00-index.yaml:185 ; 06-flows/03-parcours.yaml:395 |
| CHO-OUVERTURE-M2 | durée, courbe, chorégraphie, mapping ou décision | 11-reponse-parametrique/00-index.yaml:471 ; 11-reponse-parametrique/03-chorégraphies.yaml:74 |
| CRV-EASE-OUT | durée, courbe, chorégraphie, mapping ou décision | 11-reponse-parametrique/00-index.yaml:444 ; 11-reponse-parametrique/01-durees-et-courbes.yaml:170 |
| D1.1 | capacité | 03-fonctionnalites/00-index.yaml:519 ; 03-fonctionnalites/01-carte-exploration-temporelle.yaml:55 |
| D1.2 | capacité | 03-fonctionnalites/00-index.yaml:356 ; 03-fonctionnalites/00-index.yaml:521 ; 03-fonctionnalites/01-carte-exploration-temporelle.yaml:153 |
| DUR-COURT | durée, courbe, chorégraphie, mapping ou décision | 11-reponse-parametrique/00-index.yaml:434 ; 11-reponse-parametrique/01-durees-et-courbes.yaml:59 |
| E-CARTE-ALERTE-PROXIMITE | écran | 07-ecrans/00-index.yaml:121 ; 07-ecrans/carte/05-alerte-proximite.yaml:15 |
| E-CARTE-APERCU-PIN | écran | 07-ecrans/00-index.yaml:106 ; 07-ecrans/carte/02-apercu-pin.yaml:15 |
| E-CARTE-FILTRES-COUCHES | écran | 07-ecrans/00-index.yaml:116 ; 07-ecrans/carte/04-filtres-couches.yaml:14 |
| E-CARTE-PRINCIPALE | écran | 07-ecrans/00-index.yaml:101 ; 07-ecrans/carte/01-principale.yaml:15 |
| E-CARTE-RECHERCHE | écran | 07-ecrans/00-index.yaml:111 ; 07-ecrans/carte/03-recherche.yaml:14 |
| E-COMMUNAUTE-REDACTION-COMMENTAIRE | écran | 07-ecrans/00-index.yaml:238 ; 07-ecrans/communaute/01-redaction-commentaire.yaml:15 |
| E-COMMUNAUTE-REDACTION-RETOUR-PARCOURS | écran | 07-ecrans/00-index.yaml:260 ; 07-ecrans/communaute/05-redaction-retour-parcours.yaml:17 |
| E-COMMUNAUTE-REDACTION-SIGNALEMENT | écran | 07-ecrans/00-index.yaml:243 ; 07-ecrans/communaute/02-redaction-signalement.yaml:16 |
| E-COMMUNAUTE-SOUMISSION-PIN | écran | 07-ecrans/00-index.yaml:248 ; 07-ecrans/communaute/03-soumission-pin.yaml:16 |
| E-COMMUNAUTE-SUIVI-SOUMISSIONS | écran | 07-ecrans/00-index.yaml:254 ; 07-ecrans/communaute/04-suivi-soumissions.yaml:16 |
| E-PARCOURS-EDITEUR | écran | 07-ecrans/00-index.yaml:193 ; 07-ecrans/parcours/09-editeur.yaml:16 |
| E-PARCOURS-EN-COURS-CANAPE | écran | 07-ecrans/00-index.yaml:178 ; 07-ecrans/parcours/06-en-cours-canape.yaml:15 |
| E-PARCOURS-EN-COURS-TERRAIN | écran | 07-ecrans/00-index.yaml:173 ; 07-ecrans/parcours/05-en-cours-terrain.yaml:16 |
| E-PARCOURS-FICHE-DETAIL | écran | 07-ecrans/00-index.yaml:162 ; 07-ecrans/parcours/03-fiche-detail.yaml:15 |
| E-PARCOURS-FILTRES | écran | 07-ecrans/00-index.yaml:157 ; 07-ecrans/parcours/02-filtres.yaml:14 |
| E-PARCOURS-FIN-CELEBRATION | écran | 07-ecrans/00-index.yaml:188 ; 07-ecrans/parcours/08-fin-celebration.yaml:16 |
| E-PARCOURS-LANCEMENT | écran | 07-ecrans/00-index.yaml:168 ; 07-ecrans/parcours/04-lancement.yaml:15 |
| E-PARCOURS-PRINCIPAL | écran | 07-ecrans/00-index.yaml:151 ; 07-ecrans/parcours/01-principal.yaml:15 |
| E-PARCOURS-SAUT-ETAPE | écran | 07-ecrans/00-index.yaml:183 ; 07-ecrans/parcours/07-saut-etape.yaml:16 |
| E-PARTAGE-CODE-VISUEL | écran | 07-ecrans/00-index.yaml:267 ; 07-ecrans/partage/01-code-visuel.yaml:15 |
| E-PARTAGE-FIN-PARCOURS-IMAGE | écran | 07-ecrans/00-index.yaml:272 ; 07-ecrans/partage/02-fin-parcours-image.yaml:15 |
| E-PIN-CONSULTATION-3D | écran | 07-ecrans/00-index.yaml:139 ; 07-ecrans/pin/03-consultation-3d.yaml:16 |
| E-PIN-CONSULTATION-APPROFONDIE | écran | 07-ecrans/00-index.yaml:128 ; 07-ecrans/pin/01-consultation-approfondie.yaml:15 |
| E-PIN-CONSULTATION-AR | écran | 07-ecrans/00-index.yaml:144 ; 07-ecrans/pin/04-consultation-ar.yaml:15 |
| E-PIN-MODE-PRESENTATION | écran | 07-ecrans/00-index.yaml:134 ; 07-ecrans/pin/02-mode-presentation.yaml:16 |
| E-PROFIL-CONNEXION-COMPTE | écran | 07-ecrans/00-index.yaml:226 ; 07-ecrans/profil/06-connexion-compte.yaml:15 |
| E-PROFIL-CREATION-COMPTE | écran | 07-ecrans/00-index.yaml:221 ; 07-ecrans/profil/05-creation-compte.yaml:18 |
| E-PROFIL-FAVORIS | écran | 07-ecrans/00-index.yaml:206 ; 07-ecrans/profil/02-favoris.yaml:15 |
| E-PROFIL-HISTORIQUE | écran | 07-ecrans/00-index.yaml:211 ; 07-ecrans/profil/03-historique.yaml:17 |
| E-PROFIL-PARAMETRES | écran | 07-ecrans/00-index.yaml:216 ; 07-ecrans/profil/04-parametres.yaml:16 |
| E-PROFIL-PARAMETRES-COMPTE | écran | 07-ecrans/00-index.yaml:231 ; 07-ecrans/profil/07-parametres-compte.yaml:17 |
| E-PROFIL-PRINCIPAL | écran | 07-ecrans/00-index.yaml:201 ; 07-ecrans/profil/01-principal.yaml:16 |
| E-TRANSVERSES-AUDIO-PERSISTANT | écran | 07-ecrans/00-index.yaml:280 ; 07-ecrans/transverses/01-audio-persistant.yaml:16 |
| E-TRANSVERSES-BANDEAU-OFFLINE | écran | 07-ecrans/00-index.yaml:290 ; 07-ecrans/transverses/03-bandeau-offline.yaml:15 |
| E-TRANSVERSES-DIALOGUE-CONFIRMATION | écran | 07-ecrans/00-index.yaml:295 ; 07-ecrans/transverses/04-dialogue-confirmation.yaml:17 |
| E-TRANSVERSES-DIALOGUE-PERMISSION | écran | 07-ecrans/00-index.yaml:307 ; 07-ecrans/transverses/06-dialogue-permission.yaml:16 |
| E-TRANSVERSES-INDICATION-ONBOARDING | écran | 07-ecrans/00-index.yaml:312 ; 07-ecrans/transverses/07-indication-onboarding.yaml:21 |
| E-TRANSVERSES-INVITATION-MICROPARCOURS | écran | 07-ecrans/00-index.yaml:318 ; 07-ecrans/transverses/08-invitation-microparcours.yaml:20 |
| E-TRANSVERSES-MESSAGE-EPHEMERE | écran | 07-ecrans/00-index.yaml:301 ; 07-ecrans/transverses/05-message-ephemere.yaml:17 |
| E-TRANSVERSES-PARCOURS-PERSISTANT | écran | 07-ecrans/00-index.yaml:285 ; 07-ecrans/transverses/02-parcours-persistant.yaml:15 |
| F1 | flux | 06-flows/00-index.yaml:239 ; 06-flows/06-partage.yaml:41 |
| F2 | flux | 06-flows/00-index.yaml:242 ; 06-flows/06-partage.yaml:89 |
| F3 | flux | 06-flows/00-index.yaml:245 ; 06-flows/06-partage.yaml:139 |
| F4 | flux | 06-flows/00-index.yaml:248 ; 06-flows/06-partage.yaml:210 |
| F5 | flux | 06-flows/00-index.yaml:251 ; 06-flows/06-partage.yaml:273 |
| G1 | flux | 06-flows/00-index.yaml:255 ; 06-flows/07-communaute.yaml:42 |
| G2 | flux | 06-flows/00-index.yaml:258 ; 06-flows/07-communaute.yaml:93 |
| G3 | flux | 06-flows/00-index.yaml:261 ; 06-flows/07-communaute.yaml:149 |
| G4 | flux | 06-flows/00-index.yaml:264 ; 06-flows/07-communaute.yaml:227 |
| G5 | flux | 06-flows/00-index.yaml:267 ; 06-flows/07-communaute.yaml:317 |
| G6 | flux | 06-flows/00-index.yaml:270 ; 06-flows/07-communaute.yaml:380 |
| H1 | flux | 06-flows/00-index.yaml:274 ; 06-flows/08-back-office.yaml:45 |
| H2 | flux | 06-flows/00-index.yaml:277 ; 06-flows/08-back-office.yaml:100 |
| H3 | flux | 06-flows/00-index.yaml:280 ; 06-flows/08-back-office.yaml:154 |
| H4 | flux | 06-flows/00-index.yaml:283 ; 06-flows/08-back-office.yaml:206 |
| H5 | flux | 06-flows/00-index.yaml:286 ; 06-flows/08-back-office.yaml:268 |
| H6 | flux | 06-flows/00-index.yaml:289 ; 06-flows/08-back-office.yaml:317 |
| HAP-LEGER | durée, courbe, chorégraphie, mapping ou décision | 11-reponse-parametrique/00-index.yaml:455 ; 11-reponse-parametrique/02-haptique-et-feedback-non-visuel.yaml:38 |
| ICON-CAT-LIEU-DISPARU | icône | 13-icones/00-index.yaml:309 ; 13-icones/02-icones-categories.yaml:153 |
| ICON-UI-RETOUR | icône | 13-icones/00-index.yaml:330 ; 13-icones/03-icones-ui-fonctionnelles.yaml:30 |
| MAP-CONTEXTE-PARCOURS-VERS-PIN | durée, courbe, chorégraphie, mapping ou décision | 11-reponse-parametrique/00-index.yaml:507 ; 11-reponse-parametrique/04-mappings-parametriques.yaml:301 |
| TMP-AUTO-DISMISS-M9 | durée, courbe, chorégraphie, mapping ou décision | 11-reponse-parametrique/00-index.yaml:533 ; 11-reponse-parametrique/05-comportements-temporels-purs.yaml:37 |
| TOK-COLOR-PIN-EDITORIAL | token | 12-tokens/00-index.yaml:322 ; 12-tokens/01-couleurs.yaml:257 |
| TOK-OPACITY-BACKDROP-M6 | token | 12-tokens/00-index.yaml:365 ; 12-tokens/04-opacites-constantes.yaml:38 |
| TOK-SPACE-MD | token | 12-tokens/00-index.yaml:355 ; 12-tokens/03-espace-et-forme.yaml:49 |
| TOK-TYPO-DISPLAY-LG | token | 12-tokens/00-index.yaml:341 ; 12-tokens/02-typographies.yaml:103 |
| comp-badge-nombre | composant (définition ou usage) | 10-composants/01-atomes.yaml:413 ; 10-composants/03-fonctionnels.yaml:69 |
| comp-button-back | composant (définition ou usage) | 10-composants/00-index.yaml:449 ; 10-composants/01-atomes.yaml:154 |
| comp-button-primary | composant (définition ou usage) | 10-composants/00-index.yaml:493 ; 10-composants/00-index.yaml:591 ; 10-composants/00-index.yaml:633 ; 10-composants/01-atomes.yaml:76 |
| comp-button-secondary | composant (définition ou usage) | 10-composants/00-index.yaml:594 ; 10-composants/01-atomes.yaml:106 |
| comp-chip-categorie | composant (définition ou usage) | 10-composants/00-index.yaml:641 ; 10-composants/01-atomes.yaml:347 |
| comp-icone | composant (définition ou usage) | 10-composants/00-index.yaml:459 ; 10-composants/00-index.yaml:506 ; 10-composants/00-index.yaml:637 ; 10-composants/01-atomes.yaml:650 ; 10-composants/03-fonctionnels.yaml:65 |
| comp-libelle-bouton | composant (définition ou usage) | 10-composants/00-index.yaml:503 ; 10-composants/00-index.yaml:639 ; 10-composants/01-atomes.yaml:697 |
| comp-libelle-texte | composant (définition ou usage) | 10-composants/00-index.yaml:587 ; 10-composants/00-index.yaml:635 ; 10-composants/01-atomes.yaml:675 |
