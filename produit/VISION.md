---
id: DOC-VISION
type: document
titre: "Vision : essence, figures et rôles"
statut: mvp
liens:
  decisions: [DEC-13, DEC-14, DEC-15]
anciens_ids: [kenji, mme_dupont, mme_martin, pere_lyonnais, editeur_de_contenu, valideur_scientifique, moderateur_communaute, institution]
sources:
  - conception/01-essence.yaml:29
  - conception/01-essence.yaml:92
  - conception/01-essence.yaml:120
  - conception/01-essence.yaml:176
  - conception/01-essence.yaml:213
  - conception/01-essence.yaml:297
  - conception/01-essence.yaml:369
  - conception/02-personas.yaml:142
  - conception/02-personas.yaml:215
  - conception/02-personas.yaml:288
  - conception/02-personas.yaml:364
  - conception/02-personas.yaml:453
  - conception/02-personas.yaml:540
  - conception/02-personas.yaml:553
  - conception/02-personas.yaml:579
  - DEC-13
  - DEC-14
  - DEC-15
derniere_verif: 2026-10-24
---

# Vision

À lire avant toute décision de produit ou de contenu. Si une règle d’un autre document contredit ce texte, ce texte prime, ou on le met à jour explicitement.

## 1. L’essence

**Ce que c’est.** HistoLyon transforme chaque rue de Lyon en livre d’histoire vivant (conception/01-essence.yaml:30). Une carte temporelle pour remonter le temps là où l’on marche, des pins qui racontent ce qu’on n’aurait jamais trouvé seul, l’histoire comme la dirait un conteur et non comme l’écrirait un manuel.

**La boussole.** Entre un audioguide et un conteur, il y a toute la distance recherchée. L’audioguide récite ; le conteur regarde dans les yeux, ménage le suspense, fait sourire. HistoLyon est toujours du côté du conteur. Devant tout choix, y compris un libellé d’écran, on demande : est-ce que ça sert le livre vivant ? Si la réponse est « non » ou « pas sûr », on s’arrête.

**Pour qui.** Le grand public curieux : quelqu’un qui marche dans Lyon, ou qui en rêve, et se demande « c’était quoi ici, avant ? ». Ni les passionnés pointus, ni les chercheurs. Quatre axes balisent l’espace des usages, et le produit doit tenir aux deux bouts de chacun : visiteur ↔ habitant, terrain ↔ canapé, seul ↔ encadré, préparé ↔ spontané.

**Le manque comblé.** Aujourd’hui, on ne sait rien ou l’on ouvre Wikipédia (froid, coupé du lieu). Les audioguides sont linéaires, les applications touristiques promotionnelles, les livres se lisent chez soi. HistoLyon est l’entre-deux : un compagnon qui raconte au lieu d’instruire et laisse choisir la profondeur.

**Trois principes, dans cet ordre** (toute décision s’appuie sur l’un d’eux) :
1. **Sérendipité** : découvrir sans avoir cherché. Le déclencheur est le lieu, pas la requête ; la carte est l’écran d’accueil ; l’app propose, l’utilisateur peut toujours refuser.
2. **Historicité** : vrai, sourcé, sérieux sans être austère. Pas de récit inventé « pour faire joli » ; si l’on simplifie, on l’assume ; les sources sont tracées (INV-04) et validées par l’historienne.
3. **Émerveillement** : l’utilisateur s’arrête, sourit, veut en savoir plus. Le ton conteur est obligatoire, y compris dans la microcopy ; le visuel fait respirer.

**Ce qu’on refuse** (choix pris, pas oublis) :
- le ton encyclopédique, la mascotte ou le personnage-guide ;
- le mur d’inscription et toute friction au lancement : l’app s’ouvre sur la carte, sans tutoriel ni salve de permissions ;
- le GPS pas à pas, l’écran « Explorer » séparé, les notifications imposées ;
- le city branding et le ton joyeux « à la Duolingo » ; la joie vient du contenu, pas de l’interface ;
- le canapé comme mode dégradé : c’est un usage à part entière, sans message du type « vous n’êtes pas à Lyon ».

**Atmosphère.** Chaud, sobre, conteur, posé, chaleureux, sérieux sans austérité (parchemin chaud, pas de thème sombre). Le ton n’est ni joyeux, ni clinique, ni promotionnel, ni solennel.

**Le cadre.** Projet de fin d’études évalué par un jury : la qualité de la démarche et des choix compte autant que le code. L’absence de pression de marché ne dispense d’aucune rigueur.

### Le MVP n’est pas une version dégradée (DEC-13)

L’essence refuse les « V1/V2 » appauvries : on ne sort pas « le minimum vendable ». Le MVP (rendu du 07/02/2027) est donc une **tranche verticale complète** : carte et slider d’époques, un parcours de 7 à 10 pins, un pin avec vue 3D, qui tiennent l’essence de bout en bout. Ce qui n’est pas dans la tranche est reporté, jamais livré à moitié.

Conséquences sur la lecture de l’essence au MVP : Surprenez-moi, notifications de proximité, choix terrain/canapé, communauté et AR sont reportés (S2) ; l’app est en français uniquement (DEC-15) ; le tutoiement est réservé au récit et l’interface vouvoie (DEC-14).

## 2. Les figures grand public

Quatre figures servent de boussoles humaines. Elles ne modulent pas le ton (une seule voix pour tous) mais le paramétrage et les critères de contrôle. Chacune a un litmus : un test à passer avant de valider une décision.

### Kenji Tanaka, 22 ans, touriste japonais (`kenji`)
Étudiant, premier voyage en France, seul, deux jours à Lyon sur recommandation de l’office du tourisme. Veut comprendre « pourquoi Lyon est Lyon », repartir avec des anecdotes. Visiteur, surtout terrain, préparation rapide la veille. **Persona aspirationnel** : l’app reste en français (DEC-15) ; il sert de test de lisibilité, pas de cahier des charges de traduction.
**Litmus :** à la première ouverture, comprend-il quoi faire en moins de 60 secondes sans tutoriel ? (conception/02-personas.yaml:210)

### Claire Dupont, 38 ans, maîtresse en sortie scolaire (`mme_dupont`)
Maîtresse de CM1-CM2 à Villeurbanne, une sortie par an dans le Vieux Lyon avec 28 élèves et des parents accompagnateurs peu à l’aise avec le numérique. Encadrée, très préparée, canapé pour préparer et terrain pour exécuter. Veut que les enfants retiennent que Lyon a une histoire, sans y passer ses soirées.
**Litmus :** peut-elle finir un parcours en ayant sauté des étapes, sans message qui blesse l’enseignante ou les enfants ? (conception/08-contenu/01-strategie-narrative.yaml:292 ; DEC-09)

### Hélène Martin, 42 ans, professeure en classe (`mme_martin`)
Professeure d’histoire-géographie en 4e, à Lyon. Projette l’app au tableau ou la met sur les tablettes. Canapé exclusif, très préparée, historicité non négociable : elle ne projette rien d’imprécis. Rend vivant un cours avec une carte qui change avec le temps.
**Litmus :** quand elle cite une archive, la source est-elle visible et crédible pour un collègue qui regarde par-dessus son épaule ? (conception/02-personas.yaml:359)

### Marc Dubois, 41 ans, le père lyonnais (`pere_lyonnais`)
Lyonnais de souche, Croix-Rousse, promenade du dimanche avec ses enfants, sans plan précis. Spontané, terrain, habitant « extrême ». Veut redécouvrir des rues qu’il croit connaître, trouver des anecdotes à raconter ; aucune préparation, aucun objectif d’apprentissage.
**Litmus :** peut-il lire l’anecdote avant que ses enfants ne le tirent par la manche (teaser court visible immédiatement) ? (conception/02-personas.yaml:417). Le test d’origine (anecdote reçue au bon moment en mode « Surprenez-moi », :433) est reporté (S2).

## 3. Les rôles de production

Ces rôles produisent le contenu sur une autre surface (outil d’édition, pas l’app grand public). Ils ne sont pas dans les quatre axes. Au début, une seule personne peut les tenir tous (auto-validation à acter).

### Éditeur de contenu (`editeur_de_contenu`)
Anaïs Lefèvre, 25 ans, master 2 d’histoire, rédige les pins et les parcours. Double exigence : rigueur scientifique et ton conteur. Sa fierté est cette double contrainte, à condition que les outils ne l’épuisent pas ; les modèles cadrent la structure sans dicter le ton.
**Litmus :** saisit-elle un pin moyen, sources déjà collectées, en moins de 30 minutes ? (conception/02-personas.yaml:526)

### Valideur scientifique (`valideur_scientifique`)
Relit un pin avant publication pour vérifier la rigueur historique : l’institution partenaire ou un membre senior (l’historienne). Attend de lire le pin tel que l’utilisateur le verra, d’accéder vite aux sources, d’annoter sans modifier, d’avoir un workflow tracé.
**Litmus :** relit-il le pin dans le même outil, sans changer de contexte ? (conception/02-personas.yaml:528)

### Modérateur de communauté (`moderateur_communaute`)
Modère contributions et commentaires. Rôle réservé : la communauté est reportée (S2). On garde seulement l’exigence d’une modération tenable avec peu de temps et de décisions tracées. (conception/02-personas.yaml:553)

### L’institution (`institution`), en une ligne
Archives, mairie, office du tourisme : ce n’est pas un persona mais un partenaire qui fournit et valide les sources et recommande l’app ; on lui doit des sources visibles et traçables sur chaque pin, des crédits clairs et aucun contenu inventé. (conception/02-personas.yaml:579)

## 4. Comment s’en servir

Avant de valider un écran, une règle ou un texte : passer les questions d’essence (histoire ou fait récité ? déclencheur = le lieu ? vrai et sourçable ? friction inutile ?) puis le litmus des figures concernées. Un « non » ou un « pas sûr » se règle avant la validation, quitte à revenir ici. Le détail de la rédaction est dans DOC-GUIDE-REDACTION.
