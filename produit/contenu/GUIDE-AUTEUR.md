---
id: DOC-GUIDE-AUTEUR
type: document
titre: "Guide d’écriture d’un pin, pour qui rédige"
statut: mvp
liens:
  decisions: [DEC-02, DEC-03, DEC-14]
  invariants: [INV-04]
anciens_ids: []
sources:
  - conception/08-contenu/01-strategie-narrative.yaml:52
  - conception/08-contenu/01-strategie-narrative.yaml:118
  - conception/08-contenu/01-strategie-narrative.yaml:158
  - conception/08-contenu/02-template-pin.yaml:99
  - conception/08-contenu/02-template-pin.yaml:146
  - conception/08-contenu/02-template-pin.yaml:279
  - conception/08-contenu/06-i18n.yaml:37
  - content/pins/cour-des-voraces.yaml:24
  - DEC-02
  - DEC-03
  - DEC-14
derniere_verif: 2026-10-27
---

# Guide d’écriture d’un pin

Version pour la personne qui rédige, sans vocabulaire technique. C’est la **source** de la version Word partagée avec l’éditorial : on modifie ce fichier d’abord, puis on met à jour le document Word (qui n’est pas versionné : c’est un fichier de partage, à refaire quand le guide change). La version détaillée, avec les règles numérotées et leurs sources, est DOC-GUIDE-REDACTION ; le gabarit de champs côté dépôt est DOC-GABARIT-PIN.

## 1. À quoi sert un pin

HistoLyon est une carte de Lyon. Chaque pin est un lieu. Quand on le touche, on voit d’abord un aperçu (un titre, une phrase), puis la fiche avec le récit. Votre texte est ce que lira une personne debout dans la rue, son téléphone à la main. Elle ne cherche pas une encyclopédie : elle veut qu’on lui raconte ce qu’elle a sous les yeux.

## 2. La voix : un conteur, pas un audioguide

Imaginez que vous emmenez un ami de passage voir le quartier. Le ton est chaleureux sans être familier, posé sans être solennel, précis sans être pédant, sérieux sans être austère. Dans le récit, on s’adresse à une seule personne, au tutoiement (« tu pousses la porte »). Les textes de l’interface (boutons, messages) sont au vouvoiement : ce n’est pas votre travail.

- **Juste** : « Tu pousses la porte, place Colbert, et tu te retrouves dans une cour intérieure vertigineuse. »
- **À éviter** : « 1831 : première révolte des canuts. 1834 : seconde révolte. » (une chronologie sèche) ou « Cet incroyable lieu magique vous fascinera ! » (des adjectifs vides).

## 3. Ce qu’il faut fournir pour un pin

| Élément | Ce qu’on attend | Longueur |
| --- | --- | --- |
| Titre | Le nom du lieu ou du sujet, sans préfixe (« Bellecour », pas « Pin : Bellecour ») | quelques mots |
| Époque | **Une seule** époque (liste ci-dessous) | — |
| Catégorie | **Une seule** catégorie (liste ci-dessous) | — |
| Lieu | Adresse précise et, si possible, coordonnées (latitude, longitude) | — |
| Teaser | Une phrase qui donne envie sans tout dire : un fait et pourquoi il compte. Elle s’affiche dans l’aperçu sur la carte | 10 à 25 mots |
| Récit | Le texte principal, en plusieurs paragraphes | 200 à 800 mots |
| « Le saviez-vous » (facultatif) | Une anecdote ou un détail qui prolonge le récit sans le résumer | 1 à 3 phrases |
| Citation (facultatif) | Une citation d’archive, introduite sobrement, entre guillemets, avec son crédit | courte |
| Sources | Au moins une, idéalement archivistique ou académique (voir plus bas) | — |

**Les 10 époques** (bornes provisoires, à valider par l’historienne) : Antiquité romaine (-43 à 476), Haut Moyen Âge (476 à 987), Moyen Âge (987 à 1492), Renaissance (1492 à 1610), Époque classique (1610 à 1789), Révolution et Empire (1789 à 1815), XIXe siècle (1815 à 1939), Seconde Guerre mondiale (1939 à 1945), XXe siècle (1945 à 2000), Aujourd’hui (2000 à nos jours).

**Les 11 catégories** : Classique, Anecdote, Musée et institution, Personne, Événement, Lieu disparu, Vie quotidienne, Architecture, Nature et géographie, Patrimoine vivant et traditions, Gastronomie.

Un lieu qui a vécu plusieurs époques (Bellecour, par exemple) : choisissez **l’époque dont vous racontez l’histoire**. Une seconde époque sera possible plus tard, pas pour le premier parcours.

## 4. Écrire le récit

- **Ouvrir par un détail qu’on voit ou qu’on entend** : « en levant les yeux… », « tu pousses la porte… ».
- **Raconter par respirations** : plusieurs paragraphes, des transitions simples (« et puis », « ce qui change tout »), jamais un pavé.
- **Tisser les dates** dans une phrase qui dit pourquoi le fait compte, au lieu de les poser en liste.
- **Dire l’incertitude** quand elle existe (« l’origine de ce nom reste discutée »), sans déformer.
- **Finir sans morale** : une phrase qui referme, pas de « en conclusion » ni de « cela nous rappelle que… ».
- **Expliquer les mots lyonnais la première fois, dans la phrase** : canuts, traboule, bouchon, soyeux, guignol. « C’est une traboule, un raccourci typique de Lyon, qu’utilisaient les canuts, les ouvriers de la soie. »
- **Un pin, un récit** : une époque, une voix, du début à la fin.

*Un exemple réel* : le pin « La Cour des Voraces » (fichier `content/pins/cour-des-voraces.yaml`). Son récit s’ouvre dans le lieu (« Tu pousses la porte… »), explique les canuts et les traboules, place 1831 et 1834 dans l’histoire du quartier, avoue que l’origine du nom est discutée, et se ferme sur le décor qui n’a pas bougé.

## 5. Les sources

Au moins une source par pin. Pour chacune, notez :

- le **type** (archive, livre, article, site) ;
- la **référence exacte** ou la cote (une cote d’archive complète si possible) ;
- la **date de consultation** ;
- **ce qu’elle a permis d’établir**.

La source ne se colle pas dans le texte (« Selon AML 3SAT127… ») : elle va dans la liste des sources du pin. Une citation directe est courte, entre guillemets, créditée juste après, et jamais tronquée pour l’effet. **Wikipédia ne suffit pas seul** : chaque pin vise au moins une source archivistique ou académique. On n’invente jamais ; si on simplifie un fait, on ne le déforme pas.

## 6. À ne pas faire

- une chronologie sèche ou une énumération sans contexte ;
- un teaser qui dévoile tout, ou un résumé technique (« Pin sur la traboule des Voraces, XIXe ») ;
- des adjectifs vides (« incroyable », « magique », « fascinant ») ou une émotion forcée ;
- un ton de voix-off grave (« Et c’est ainsi que dans le silence des siècles… ») ;
- une morale en conclusion ;
- des jeux, des points, des scores, ou un reproche (« parcours incomplet ») ;
- des emojis.

## 7. Typographie

Guillemets français « comme ceci » avec espaces insécables, apostrophe courbe ’, points de suspension en un seul caractère …, dates littéraires dans le récit (« en janvier 1850 », « à la fin du XVIIIe siècle »), nombres avec espace pour les milliers (12 345) et virgule décimale (3,14), heure en 24 h (14:30). Les noms propres lyonnais ne se reformulent pas (Croix-Rousse, Vieux Lyon, Fourvière, Bellecour, la Saône, le Rhône).

## 8. Liste de contrôle avant de rendre

- Une seule époque, une seule catégorie, une adresse précise.
- Teaser d’une phrase, qui ne dévoile pas tout.
- Récit de 200 à 800 mots, qui commence dans le lieu et finit sans morale.
- Dates tissées dans le récit, mots lyonnais expliqués.
- Au moins une source, avec sa référence exacte, dont une archivistique ou académique si possible.
- Aucun des interdits de la partie 6.
- Dates, noms et coordonnées vérifiés une seconde fois.

## 9. Comment rendre un pin

1. Remplissez le **gabarit** (document Word, un tableau par pin) et déposez-le à l’endroit convenu sur SharePoint.
2. Une personne de l’équipe le convertit en fichier du dépôt (vous n’avez rien de technique à faire) et le fait relire pour la forme et les sources par une autre personne.
3. Vous validez la version finale avant publication.

## Annexe : fiche de recherche par lieu

Pour garder la trace de ce qui est trouvé aux archives ou à la bibliothèque, avant même d’écrire : une fiche par lieu et par source (voir la version Word, tableau à remplir). Champs : lieu, source (type, référence ou cote), date de consultation, ce qu’elle dit (en quelques lignes), citation exacte éventuelle, photographiée (oui ou non), fiabilité (sûr, à recouper).
