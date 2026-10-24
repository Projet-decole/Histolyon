---
id: DOC-TRI-CONTENU
type: document
titre: "Tri de l’essence, des personas, de 08-contenu et de la microcopy grand public"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

# Recouvrement du groupe CONTENU

Sources : `conception/01-essence.yaml`, `02-personas.yaml`, `08-contenu/01…04, 06`. La microcopy admin (`05-microcopy-admin.yaml`) n’a pas été lue : hors périmètre de ce groupe. « R » renvoie à DOC-GUIDE-REDACTION, « M » à DOC-MICROCOPY.

## 1. Essence (`01-essence.yaml`)
| Source (ligne) | Bloc | Sort |
|---|---|---|
| :29 | pitch, respirations | reprise dans DOC-VISION §1 (les trois premières respirations ; la dernière, « depuis la rue ou depuis le canapé », est écartée : choix terrain/canapé reporté, DEC-05) |
| :45 | nature du projet | reprise résumée (cadre, jury). Écartés : durée, rythme, équipe de 7 personnes (organisation, pas vision) |
| :55 | « Pas de MVP, pas de V1/V2 » | reprise et nuancée par DEC-13 dans DOC-VISION |
| :63-79 | conception = code, liberté d’ambition, rigueur | reprise en une phrase (« pas une excuse pour bâcler ») |
| :92 | promesse, métaphore | reprise (DOC-VISION §1) |
| :120 | pour qui, 4 axes | reprise ; les axes terrain/canapé et seul/encadré restent des axes de lecture, leurs modes dédiés sont S2 |
| :176 | envie et manque | reprise résumée ; alternatives réduites à une phrase |
| :213 | trois principes | reprise ; `consequences_sur_le_produit` : « Surprenez-moi » et notifications de proximité reportés (S2), quiz, énigmes, AR et audio synchronisé neutralisés (DEC-03) |
| :297 | ce qu’on refuse | reprise des refus actifs ; « mode dark » reporté et écarté du corps (le thème sombre est une règle de design) |
| :369 | atmosphère et ton | reprise (mots-clés, ce que le ton n’est pas) ; `reference_visuelle_courte` renvoyée au design |
| :402 | test de cohérence | reprise condensée (DOC-VISION §4) |

## 2. Personas (`02-personas.yaml`)
| Source (ligne) | Bloc | Sort |
|---|---|---|
| :46, :87-137 | rôle des personas, principes d’emploi (dont `persona_check_obligatoire`, `pas_de_modification…`) | rejetée : méthode de travail de l’ancienne conception ; remplacée par les litmus |
| :142, :215, :288, :364 | quatre figures | reprise avec un litmus chacun. Écartés : description de photo, contexte d’usage détaillé, positions sur les axes, moments de vérité, frustrations, drapeaux rouges |
| :172 | Kenji, drapeau rouge « Microcopy en français uniquement » | rejetée : contredit DEC-15 (l’app est en français, Kenji aspirationnel) |
| :210 | Kenji, litmus « en japonais » | reprise sans « en japonais » (DEC-15) |
| :283 | Dupont, litmus (préparer un parcours en 30 min ; parent qui ouvre le lien) | rejetée : création de parcours et partage par lien hors MVP. Remplacé par le litmus de tonalité de 01-strategie-narrative.yaml:292 |
| :359 | Martin, litmus plein écran / source visible | reprise de la partie « source visible » ; le plein écran (mode présentation) n’est pas dans le MVP |
| :433 | Père, litmus « Surprenez-moi » et notifications | rejetée : S2. Remplacée par le moment de vérité :417 (lire l’anecdote vite) |
| :453, :540, :553 | éditeur, valideur, modérateur | reprise ; modérateur réduit à l’exigence de tenabilité (S2) |
| :579 | institution | reprise en une ligne |
| :625-760 | couverture des axes, grille de scénarios, portée et limites | rejetée : outillage de l’ancienne conception |

## 3. Stratégie narrative (`08-contenu/01-strategie-narrative.yaml`)
| Source (ligne) | Règle | Sort |
|---|---|---|
| :28-47 | périmètre, test de pureté | rejetée : méta |
| :61-65 | cinq tons | reprise dans R2 à R5 |
| :68 | une seule personne | reprise dans R1 |
| :74-96 | deux voix, règle de bascule | reprise dans R6 (DEC-14). La source rattache à la « voix du récit » les « transitions d’étape, célébration de fin de parcours, indications d’onboarding » (:76-77) : corrigé, ces textes sont de l’interface et vouvoient |
| :98-110 | registres par figure, back-office | reprise dans R7 ; le registre back-office est hors périmètre |
| :119-153 | longueurs qualifiées | reprise dans R14, R15 ; haïku et paragraphe repris dans les gabarits |
| :160 | P1 raconter | reprise dans R8 |
| :167 | P2 préciser | reprise dans R9 |
| :175 | P3 faire confiance | reprise dans R10 |
| :183 | P4 ne pas culpabiliser | reprise dans R11 |
| :192 | P5 annoncer avant d’agir | reprise dans R12 (utile aux dialogues, M14) |
| :199 | P6 sources visibles | reprise dans R22 |
| :208 | P7 cohérence terminologique | reprise dans R13 |
| :224-293 | patterns PT1 à PT7 | non repris en bloc : PT1 (confirmation), PT3 (invitation), PT4 (permission), PT2 (alerte de tracé) hors MVP ; PT5 (refus gracieux) et PT6/PT7 (fin) portés par M14, M15, M16, M11 et R28 |
| :301-334 | anti-patterns | reprise dans R29 à R34 (peppy, encyclopédique, promotionnel, mystique, émotion forcée) ; « familiarité forcée » reprise dans R33 |
| :344-386 | exemples canoniques | non repris : « Lyon. Tu peux remonter le temps… » (onboarding, tutoiement dans l’interface), suppression de compte, permission caméra, modération, hors zone avec géolocalisation (hors MVP). L’exemple de teaser traboule (:351) n’est pas repris pour ne pas introduire de faits non vérifiés |
| :368 | « Tu as parcouru trois étapes sur cinq… » | corrigée (tutoiement dans une interface), voir QO-909 |

## 4. Gabarit de pin (`02-template-pin.yaml`)
| Source (ligne) | Règle | Sort |
|---|---|---|
| :60-94 | structure en segments | reprise : teaser, narration, post-narratif, sources (DOC-GABARIT-PIN) |
| :99-141 | teaser | reprise dans R14 ; exemples (médaillon, traboule, chanson) non repris : faits fictifs (le vrai teaser est dans `cour-des-voraces.yaml`) |
| :146-179 | narration, ouverture, cœur, transitions, clôture | reprise dans R15 à R18 |
| :181-209 | tissage des sources | reprise dans R22 à R24 |
| :211-235 | tissage des médias (appel par le récit, ambiance, interactif) | rejetée : médias hors MVP (DEC-03) |
| :237-242 | anti-patterns de la narration | reprise dans R29, R33 ; « surexplication » dans R10 |
| :244-274 | deux narrations d’exemple | non reprises : faits fictifs (quarante médaillons…) |
| :279-296 | post-narratif, voix | reprise réduite à R20 |
| :297-307 | pins liés | rejetée : hors MVP, non retenu par DEC-03 |
| :309-336 | quiz, énigme | rejetée : neutralisés (DEC-03) |
| :338-349 | citation historique | reprise dans R20 (forme YAML : QO-902) |
| :351-363 | le saviez-vous | reprise dans R20 |
| :365-369 | empilement, gamification, reconnaissance peppy | reprise dans R20, R32 |
| :374-405 | sources, pied de page | reprise dans R22, R23 |
| :412-421 | pin communautaire en revue | rejetée : communauté S2 |
| :423-432 | pin sans localisation | rejetée : cas absent du MVP (pin réel localisé) |
| :434-450 | pin multi-époques, modèles A/B | rejetée : DEC-02 (une époque, un récit) |

## 5. Gabarit de parcours (`03-template-parcours.yaml`)
| Source (ligne) | Règle | Sort |
|---|---|---|
| :50-70 | structure, provenances | reprise pour l’éditorial seul. Communautaire et personnel : rejetée (S2) |
| :77-85 | titre | reprise dans R26 |
| :87-98 | description courte | rejetée : pas de colonne, voir DEC-90 |
| :120-137 | description longue | reprise comme `teaser_narratif` |
| :171-192 | introduction d’étape | reprise dans R27 |
| :219-255 | célébration de fin | reprise dans R28 (formules à proscrire) ; formules « à tutoiement » corrigées par DEC-14 et DEC-09 |
| :257-302 | trois voix, exemples de fin | non repris : exemples fictifs (« sept traboules ») et tutoiement |
| :309-328 | spécificités par provenance | reprise éditorial seul |
| :333-351 | vérification I3, partage F2, retiré | rejetée : hors MVP (communauté, partage, DEC-04) |

## 6. i18n (`08-contenu/06-i18n.yaml`)
| Source (ligne) | Règle | Sort |
|---|---|---|
| :23 | français uniquement | reprise dans R35 (DEC-15) |
| :37-47 | voix, genre | reprise dans R6, R40 |
| :49-54 | typographie | reprise dans R36 |
| :56-62 | formats | reprise dans R37, R38 |
| :64-67 | pluralisation | reprise dans R39 |
| :69-71 | clés stables, interpolation | rejetée : règle de code, pas de rédaction |
| :78-89 | noms propres, termes, citations | reprise dans R41 à R43 |
| :91-94 | contenu communautaire en langue étrangère | rejetée : S2 |
| :96 | émojis | reprise dans R34 |
| :102-110 | `persona_check` Kenji | rejetée : remplacée par DEC-15 |
| :115-134 | questions ouvertes, cohérence | rejetée : sans objet |

## 7. Microcopy grand public (`08-contenu/04-microcopy-grand-public.yaml`)
| Source (ligne) | Bloc | Sort |
|---|---|---|
| :46-80 | verbes D1 à D31 | reprise partielle dans M1. Écartés : D3 Confirmer, D5 Plus tard, D7 Voir plus, D9-D13, D16 Relancer (parcours relancé hors MVP), D17 Mettre en pause, D21-D31 (favori, partage, signalement, comptes, permissions) |
| :81-92 | statuts D40 à D50 | reprise dans M2 (D40, D41, D42, D44, D45). Écartés : D43, D46-D50 (modération, brouillons, communauté) |
| :94-101 | retours D52 à D58 | rejetée : liens, favoris, brouillons, modération hors MVP |
| :103-113 | sections D70 à D79 | reprise de D70 à D72 (M4). Écartés : D73-D79 (« Mes parcours », « Catalogue », favoris, historique, paramètres, contributions, compte) |
| :115-130 | entités D90 à D102 | reprise de D90 à D95 (M3). Écartés : D96-D102 (couche, commentaire, signalement, retour, compte, code visuel, lien) |
| :132-140 | connecteurs de liste | rejetée : listes et filtres hors MVP |
| :142-149 | modes et indicateurs | rejetée : terrain/canapé (DEC-05), présentation, « Surprenez-moi », audio |
| :159-178 | aperçu rapide (M2 d’origine) | reprise dans M6. Teaser de parcours « Sept étapes, une heure de marche… » : rejetée (exemple fictif) |
| :180-199 | consultation approfondie | reprise dans M7 ; commentaires et marque communautaire rejetés |
| :201-211 | mode présentation | rejetée : hors MVP |
| :213-230 | surface ponctuelle (recherche, filtres, commentaire) | rejetée : recherche et filtres hors MVP |
| :232-249 | alertes (proximité, arrivée, micro-parcours) | rejetée : proximité (DEC-05), onboarding neutralisé ; tutoiement |
| :251-275 | dialogue de confirmation | reprise dans M14 (abandon) ; suppression de compte et publication rejetées (comptes, communauté) ; voir QO-906 |
| :277-293 | message éphémère | reprise dans M15 ; « Lien copié », éloignement du tracé (tutoiement + géolocalisation), modération rejetés |
| :306-318 | ECR-CARTE-PRINCIPALE | reprise dans M5 (titre, état vide). Écartés : premier lancement (tutoiement, onboarding), recherche, couches, localisation, Surprenez-moi, hors zone (géolocalisation, DEC-06), `offline_sans_cache` (contenu embarqué, DEC-04). Indication « Glissez… » : QO-908 |
| :321-328 | ECR-CARTE-APERCU-PIN | reprise dans M6 (« Voir le récit »). Écartés : signalement, `offline_sans_cache`, pin retiré (instantané, DEC-04) |
| :330-356 | recherche, couches, alerte de proximité | rejetée : hors MVP |
| :360-378 | ECR-PIN-CONSULTATION-APPROFONDIE | reprise dans M7 (récit, « Voir en 3D », « Sources »). Écartés : quiz, lien externe, pins liés, commentaires, présentation, audio, marque communautaire, pin retiré, hors-ligne sans cache |
| :380-385 | mode présentation | rejetée : hors MVP |
| :387-396 | ECR-PIN-CONSULTATION-3D | reprise dans M8, sauf « Voir sur place » et `ar_indisponible_terminal` (AR hors MVP) |
| :398-406 | ECR-PIN-CONSULTATION-AR | rejetée : AR hors MVP |
| :410-422 | ECR-PARCOURS-PRINCIPAL | rejetée : aucune fiche d’écran MVP (QO-907) |
| :424-438 | ECR-PARCOURS-FILTRES | rejetée : filtres hors MVP |
| :440-460 | ECR-PARCOURS-FICHE-DETAIL | reprise dans M9. Écartés : partage privé, retours, marques communautaire et privée, parcours retiré (DEC-04), étape indisponible, « Recommencer » |
| :462-474 | ECR-PARCOURS-LANCEMENT | rejetée : DEC-05. « Un autre parcours est déjà en cours » : QO-908 |
| :476-492 | ECR-PARCOURS-EN-COURS-TERRAIN | reprise partielle dans M10. Écartés : indicateur de mode, texte « Tu te diriges… » (tutoiement + déplacement), proximité, déviation, bascule canapé, pause, permission révoquée, hors-ligne |
| :494-506 | ECR-PARCOURS-EN-COURS-CANAPE | reprise des libellés communs dans M10. Écartés : indicateur de mode, bascule vers le terrain, « Marquer la dernière étape comme vue » (QO-908) |
| :508-515 | ECR-PARCOURS-SAUT-ETAPE | rejetée : sélecteur de saut hors MVP ; « marquées comme non vues » et « partiellement complété » remplacés par DEC-09 |
| :517-532 | ECR-PARCOURS-FIN-CELEBRATION | reprise partielle dans M11. Écartés : ouvertures au tutoiement (QO-909), « Parcours achevé / partiellement achevé » (titre : l’adjectif « partiellement » est à éviter, R11), partage, retour de parcours, « Revenir à mes parcours », parcours retiré |
| :534-558 | ECR-PARCOURS-EDITEUR | rejetée : création de parcours hors MVP |
| :560-860 | profil, communauté, partage | rejetée : hors MVP (profil, comptes, communauté, partage non lus ligne à ligne) |
| :864-874 | audio persistant | rejetée : audio hors MVP |
| :876-885 | ECR-TRANSVERSES-PARCOURS-PERSISTANT | reprise dans M12, sauf indicateurs terrain/canapé |
| :887-892 | bandeau offline | reprise dans M13 |
| :894-905 | dialogue de confirmation | reprise dans M14 |
| :907-916 | message éphémère | reprise dans M15 |
| :918-945 | permission, onboarding, micro-parcours | rejetée : permissions, onboarding, invitation neutralisés |
| :953-986 | demandes de permission | rejetée : aucune permission au MVP (DEC-05, DEC-06) ; caméra liée à l’AR |
| :995-1003 | connexion perdue / retrouvée | « retrouvée » reprise dans M15 ; « perdue » rejetée (parle de modifications conservées, sans édition au MVP) |
| :1005-1014 | cible retirée (pin, parcours) | rejetée : instantané embarqué (DEC-04) |
| :1016-1028 | permission refusée | rejetée : aucune permission |
| :1030-1034 | échec de chargement | reprise dans M16 |
| :1036-1057 | échec d’envoi, champs requis, seuils, serveur | rejetée : pas d’envoi ni de saisie ni de serveur au MVP (DEC-04) |
| :1065-1110 | cohésion narrative (terrain, canapé, proximité) | rejetée : tutoiement + géolocalisation ; « Étape suivante / précédente » repris dans M10 |

## 8. Écarts et corrections
- **Tutoiement dans l’interface.** Corrigé par DEC-14 : exemples de 01-strategie-narrative.yaml:346, :368, de 03-template-parcours.yaml:249, :277, :289, :351, et de 04-microcopy-grand-public.yaml:241-244, :289, :481-483, :520-521, :531, :1072-1082. Les textes concernés sont absents de DOC-MICROCOPY.
- **Écart avec `content/`** : description courte (DEC-90), citation (QO-902), format de parcours (QO-904), teaser (QO-901), sources du pin réel (QO-903).
- **Microcopy admin** : non lue, hors périmètre.
