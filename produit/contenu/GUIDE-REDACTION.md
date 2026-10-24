---
id: DOC-GUIDE-REDACTION
type: document
titre: "Guide de rédaction"
statut: mvp
liens:
  decisions: [DEC-02, DEC-03, DEC-14, DEC-15]
  invariants: [INV-04]
  questions: [QO-901]
anciens_ids: []
sources:
  - conception/08-contenu/01-strategie-narrative.yaml:52
  - conception/08-contenu/01-strategie-narrative.yaml:118
  - conception/08-contenu/01-strategie-narrative.yaml:158
  - conception/08-contenu/01-strategie-narrative.yaml:299
  - conception/08-contenu/02-template-pin.yaml:99
  - conception/08-contenu/02-template-pin.yaml:146
  - conception/08-contenu/02-template-pin.yaml:279
  - conception/08-contenu/03-template-parcours.yaml:219
  - conception/08-contenu/06-i18n.yaml:23
  - conception/08-contenu/06-i18n.yaml:37
  - conception/01-essence.yaml:369
  - DEC-14
  - DEC-15
derniere_verif: 2026-10-24
---

# Guide de rédaction

Pour qui écrit un texte de l’app : récit d’un pin, parcours, libellé. Chaque règle porte sa source (`fichier:ligne`, dans `conception/08-contenu/` sauf mention). Les gabarits de champs sont dans DOC-GABARIT-PIN et DOC-GABARIT-PARCOURS, les libellés d’interface dans DOC-MICROCOPY. La philosophie est dans DOC-VISION : le conteur, pas l’audioguide.

## 1. Voix et ton

- **R1. Une seule personne.** On s’adresse à une personne, comme à un ami de passage qu’on emmène voir le quartier, jamais à une foule. (01-strategie-narrative.yaml:68)
- **R2. Chaleureux sans familier.** On accueille, on n’embrasse pas : la distance respectueuse permet le frisson. (:61)
- **R3. Posé sans solennel.** On prend son temps, sans poser. La phrase est tendue par l’envie de raconter. (:62)
- **R4. Précis sans pédant.** Faits nets, savoir qui ne s’exhibe pas : on nomme ce qui se passe, on n’aligne pas des dates. (:63)
- **R5. Sérieux sans austère, chaleureux sans complaisant.** La rigueur autorise la chaleur ; de l’affection pour Lyon, pas d’éloge marketing. (:64-65)
- **R6. Récit au tutoiement narratif, interface au vouvoiement (DEC-14).** Ce qui raconte une histoire ou situe un lieu dit « tu » (« tu vois ce mur ? »). Ce qui décrit une action ou en demande une dit « vous ». Dans le doute, vouvoyer. (:74-96)
- **R7. Le ton est le même pour toutes les figures.** Pas de variante par lecteur. (:98)

## 2. Principes de rédaction

- **R8. Raconter, jamais réciter.** Tout fait est tissé dans une phrase qui dit pourquoi il compte. Pas de date sèche, pas d’énumération sans contexte. (01-strategie-narrative.yaml:160)
- **R9. Le mot juste plutôt que le mot rare.** Le mot que comprend un Lyonnais sans formation universitaire. (:167)
- **R10. Faire confiance au lecteur.** Pas de surexplication ni de redondance. (:175)
- **R11. Ne jamais culpabiliser.** Une étape sautée, un parcours abandonné sont légitimes. Pas de « parcours incomplet », pas de « Vous n’avez pas terminé ». (:183 ; 03-template-parcours.yaml:250-255 ; DEC-09)
- **R12. Annoncer avant d’agir.** Toute action irréversible est précédée d’un texte qui dit ce qu’elle fait. (:192)
- **R13. Même mot pour la même chose.** « Pin », « parcours », « étape », « époque » partout, sans « point d’intérêt » ni « itinéraire ». (:208)

## 3. Le récit d’un pin

- **R14. Teaser : une phrase qui donne envie sans tout dire.** Un fait plus un pourquoi, environ 10 à 25 mots. Promesse d’un récit, pas son résumé. Le chiffre ou la date sont tissés dans la phrase, jamais posés en début. (02-template-pin.yaml:107-128 ; 01-strategie-narrative.yaml:129-135). Le teaser réel de la Cour des Voraces compte deux phrases courtes : voir QO-901.
- **R15. Récit : longueur d’environ 200 à 800 mots.** Plusieurs paragraphes, une seule voix de bout en bout, des « respirations » : pas de pavé sans transition. Pas de plafond strict, mais un pin long doit respirer. (01-strategie-narrative.yaml:150-153 ; 02-template-pin.yaml:155-160)
- **R16. Ouverture sensorielle ou spatiale.** Installer le lieu et le moment : « en levant les yeux », « tu pousses la porte ». (02-template-pin.yaml:163-166)
- **R17. Transitions sobres.** Connecteurs simples (« et puis », « ce qui change tout »), pas de marqueurs scolaires. (:172-174)
- **R18. Clôture sans morale.** Une phrase qui referme sans verrouiller. Ni « En conclusion », ni « Voilà l’histoire fascinante ». (:176-179)
- **R19. Une époque, un récit (DEC-02).** Un pin est rattaché à une seule époque et porte un seul récit.
- **R20. Après le récit : « Le saviez-vous » et citation seulement (DEC-03).** Un « Le saviez-vous » prolonge le récit (anecdote, détail, écho d’aujourd’hui) sans le résumer. Une citation d’archive s’introduit sobrement, s’écrit entre guillemets et se crédite brièvement. Pas d’empilement de prolongements. (02-template-pin.yaml:338-363, 365-369)
- **R21. Pas de média riche (DEC-03).** Ni images d’archives, ni avant/après, ni quiz, ni énigme au MVP : le récit doit tenir seul.

## 4. Les sources

- **R22. Au moins une source par pin (INV-04).** Visible, lisible : ni note de bas de page invisible, ni tampon administratif dans le fil (« Selon AML 3SAT127, … »). (01-strategie-narrative.yaml:199-206 ; 02-template-pin.yaml:206-209, 376-380)
- **R23. Deux emplacements.** Une citation directe porte son crédit court juste après ; les autres faits sont référencés dans le pied de page « Sources » (type, référence, crédit). (02-template-pin.yaml:188-204, 391-400)
- **R24. Tisser ou ne pas citer.** Une citation longue plaquée sans introduction casse la voix. Une citation tronquée pour l’effet est interdite. (02-template-pin.yaml:209, 349)
- **R25. On n’invente jamais.** Un récit simplifié l’assume ; il ne déforme pas. Les sources sont tracées et l’historienne valide avant publication. (01-essence.yaml:255-258)

## 5. Parcours

- **R26. Titre qui annonce un fil, pas une zone.** « Sept traboules pour comprendre les Canuts » plutôt que « Le Vieux Lyon » ; ni pédagogisme (« Découvrir… »), ni emphase touristique. (03-template-parcours.yaml:84-85)
- **R27. Le parcours met en séquence, il ne répète pas.** Description et introductions d’étape annoncent ce qui change et créent une attente sans raconter le pin. On n’écrit pas d’introduction quand l’étape est dans la continuité ou que le teaser suffit. (:50-59, 173-192)
- **R28. Fin de parcours : reconnaître sans juger.** Constat honnête de ce qui a été vu (« X étapes vues sur Y », DEC-09), sans reproche, sans flatterie, sans « Ce n’est pas grave ». (:238-255)

## 6. Interdits

- **R29. Pas de chronologie sèche** (« 1492 : … | 1503 : … »), pas d’énumération encyclopédique, pas de ton « voix-off grave » (« Et c’est ainsi que dans le silence des siècles… »). (02-template-pin.yaml:238-240 ; 01-strategie-narrative.yaml:316-319)
- **R30. Pas de teaser qui dévoile tout**, pas de résumé technique (« Pin sur la traboule des Voraces, XIXe »), pas d’adjectifs vides (« incroyable », « magique »). (02-template-pin.yaml:125-128)
- **R31. Pas d’émotion forcée.** Le conteur ne dit pas « c’est fascinant » : il raconte de façon que ce le soit. (01-strategie-narrative.yaml:331-334)
- **R32. Pas de gamification** (points, badges, niveaux, score « 3/5 »), pas de ton « Bravo champion ! ». (:301-304 ; 02-template-pin.yaml:366-367)
- **R33. Pas de promotion** (« joyau incontournable »), pas de familiarité forcée dans l’interface, pas de conclusion morale (« Cela nous rappelle que… »). (01-strategie-narrative.yaml:311-329 ; 02-template-pin.yaml:242)
- **R34. Pas d’emoji.** (06-i18n.yaml:96-97)

## 7. Langue et typographie

- **R35. Français uniquement (DEC-15).** Aucune traduction ni mécanisme de langue au MVP. (06-i18n.yaml:23-32)
- **R36. Guillemets français « » et apostrophe courbe ’** (U+2019) ; points de suspension en un seul caractère … ; espace insécable avant « : ; ! ? » et à l’intérieur des chevrons. (:49-54)
- **R37. Dates.** Courtes en JJ/MM/AAAA, longues en toutes lettres (« le 15 janvier 2026 »). Dans le récit, forme littéraire libre (« en janvier 1850 », « à la fin du XVIIIe siècle »). Heure en 24 h (HH:MM). (:57-60)
- **R38. Nombres.** Virgule décimale (« 3,14 »), espace insécable pour les milliers (« 12 345 »). (:61-62)
- **R39. Pluriel.** Zéro est singulier : « Aucun favori », pas « 0 favori ». (:64-67)
- **R40. Genre.** Tournure neutre quand c’est possible (« Bienvenue »), pas de point médian. (:45-47)
- **R41. Noms propres lyonnais jamais reformulés** : Lyon, Croix-Rousse, Vieux Lyon, Fourvière, Bellecour, la Saône, le Rhône. (:78-80)
- **R42. Termes lyonnais glosés à la première occurrence**, dans le fil et non en note : canuts, traboule, bouchon, soyeux, guignol. « C’est une traboule, un raccourci typique de Lyon, qu’utilisaient les canuts, les ouvriers de la soie. » (:82-85)
- **R43. Citation en langue étrangère** : conservée, avec la traduction française à côté. (:87-89)

## Cohérence avec les gabarits

Les exemples de la source qui mélangeaient tutoiement et vouvoiement dans l’interface sont corrigés par DEC-14 (voir DOC-TRI-CONTENU).
