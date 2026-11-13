---
id: DOC-FEUILLE-DE-ROUTE
type: document
titre: "Feuille de route du MVP"
statut: mvp
anciens_ids: []
sources:
  - brief:lot1
derniere_verif: 2026-11-13
---

# Feuille de route

Jalons du rendu du 07/02/2027. Les dates viennent du brief du lot 1. Le contenu attendu à chaque jalon est une proposition de découpage (aucune source ne le fixe) : à confirmer par le porteur du projet. La [version détaillée](#version-détaillée) plus bas explique chaque jalon pas à pas.

## JAL-FU2 — Follow-up 2 (13/11/2026)
Le projet est recadré et prêt à produire. Le corpus `produit/` est lisible par un agent (`ctx check` vert) et le périmètre MVP est figé (DEC-01 à DEC-15). Le contenu est embarqué, et l'app démarre sans base de données. Le fond de carte est validé sur téléphone (DEC-110). Les tickets ont une charge, et le suivi est calculé depuis GitHub. L'outillage éditorial est prêt (guide de rédaction, prompt de conversion). La fiche d'un pin est en relecture. La carte avec le slider d'époques passe au follow-up 3.

## JAL-FU3 — Follow-up 3 (18/12/2026)
D'abord la première tranche visible : la carte de Lyon avec le slider d'époques (CAP-D1.1, CAP-D1.2, CAP-D1.3). Ensuite les pins : CAP-D2.1, CAP-D2.2, CAP-D2.4, CAP-D2.5, CAP-D2.6. Le parcours en pas à pas (CAP-D3.3, CAP-D3.4, CAP-D3.5) est préparé, puis livré au gel. À éviter : la période de Noël (≈ 19/12 → 03/01).

## JAL-GEL — Gel du MVP (21/01/2027)
Parcours en pas à pas (CAP-D3.3, CAP-D3.4, CAP-D3.5), fin de parcours (CAP-D3.9) et pin avec vue 3D (CAP-D8.1, CAP-D8.2). Plus aucune nouvelle capacité après cette date ; seulement correctifs et finition. Congés du 22/01 au 29/01.

## JAL-ORAL — Oral (05/02/2027)
Démo sur téléphone : parcours de 7 à 10 pins, un pin avec vue 3D de la fontaine de la place des Jacobins (droits du modèle à vérifier).

## JAL-RENDU — Rendu (07/02/2027)
Livraison du MVP. Dépôt personnel, poussée sur le dépôt de l’école à chaque rendu.

## JAL-S2 — Second semestre
Tout ce qui est en statut `s2` : Supabase et backend (DEC-04), multi-époques (DEC-02), contenus riches (DEC-03), proximité et géolocalisation (DEC-05, DEC-06), AR, communauté, audio, profil et compte.

## Ligne de coupe
- **Indispensable** (statut `mvp`, 14 capacités, `ctx liste --type capacite --statut mvp`) : une tranche verticale complète (DEC-13). Si le temps manque, on réduit la quantité de contenu (nombre de pins du parcours : 7 au minimum), jamais la complétude d’une capacité.
- **Si le temps** : rien n’est promis. Les capacités `s2` ne démarrent qu’après le rendu.
- **Jamais avant le rendu** : géolocalisation, alertes de proximité, AR, comptes, communauté.

---

# Version détaillée

Le résumé ci-dessus sert à ceux qui connaissent déjà le projet. Cette partie s'adresse à toute l'équipe, y compris si tu arrives sur le projet. Elle dit, jalon par jalon, ce qu'on doit pouvoir montrer, ce que ça change pour la personne qui utilise l'app, et quels tickets y mènent, dans quel ordre.

## D'où on part, et pourquoi ce découpage

Fin octobre, le constat était simple. L'app ne montrait presque rien : quelques écrans « à venir ». La spécification d'origine était trop grosse pour être lue, par un humain comme par un agent IA. Et il restait quinze semaines avant le rendu.

Donc on a réduit le projet à **une seule histoire complète**. On ouvre l'app sur la carte de Lyon. On fait glisser le temps avec le slider. On découvre des pins. On suit un parcours de 7 à 10 lieux, étape par étape. L'un d'eux, la fontaine de la place des Jacobins, s'ouvre en 3D. On le montre sur un téléphone. Tout le reste attend le second semestre.

Ce choix a une conséquence : **chaque jalon ajoute un morceau visible de cette histoire**. Un jalon n'est pas « on a avancé sur la carte ». C'est une phrase qu'on peut montrer, téléphone en main.

### Comment lire les tickets

- Chaque ticket GitHub a une **charge** : 1, 2, 3 ou 5. Une charge de 1, c'est un petit ticket qu'une session d'agent IA peut réaliser et qu'une personne peut relire en un quart d'heure. Une charge de 3, c'est environ trois fois plus.
- Chaque ticket appartient à un **jalon** GitHub : `J1` (follow-up 2), `J2` (follow-up 3), `J3` (gel du MVP), `J4` (oral et rendu), `S2` (après le MVP).
- « Dépend de » indique ce qui doit être fusionné avant de commencer. Un ticket dont les dépendances ne sont pas fusionnées n'est pas prêt.
- Une **capacité** (`CAP-…`) décrit un comportement de l'app, avec ses critères de fin. Pour la lire : `dart run tools/ctx.dart pack CAP-D1.2`.

### Le rythme qu'il faut tenir

Au 13/11/2026, la charge restante avant le gel est :

| Jalon | Charge totale | Faite | Restante |
|---|---|---|---|
| J1 · Follow-up 2 | 20 | 8 | 12 |
| J2 · Follow-up 3 | 44 | 6 | 38 |
| J3 · Gel du MVP | 35 | 0 | 35 |
| **Avant le gel** | **99** | **14** | **≈ 85** |

Entre le 13/11 et le 21/01, il y a environ dix semaines. Les vacances de Noël en retirent deux. Il reste donc **environ 8 semaines utiles**. Pour finir à temps, il faut terminer **environ 10,5 de charge par semaine**, toute l'équipe confondue.

Le débit mesuré sur les trois dernières semaines est de 4,7 par semaine, et une seule personne l'a produit. À ce rythme, le MVP finirait vers la fin mars. **Donc** le travail doit être réparti entre tous, et la ligne de coupe doit être prête.

*Pour toi* : un ticket de charge 3 par semaine et par personne suffit presque à combler l'écart.

### La ligne de coupe, avec des exemples

La règle (DEC-13) : on ne livre jamais une capacité à moitié. Si le temps manque, on réduit la **quantité**, pas la **complétude**.

- **Oui** : on publie 7 pins au lieu de 10. Le parcours reste complet, du début à l'écran de fin.
- **Oui** : on écrit un parcours plus court, si chaque étape s'ouvre, se lit et mène à la suivante.
- **Non** : un parcours sans écran de fin, ou une fiche de pin sans ses sources. Ce serait une capacité incomplète.
- **Non** : ajouter une capacité du second semestre (géolocalisation, AR, comptes, audio) parce qu'« elle serait vite faite ». Une idée nouvelle se note, s'estime en charge, et se tranche au point de périmètre (voir `docs/PROCESS.md`).

## Follow-up 2 (13/11/2026) : le projet est prêt à produire

**La phrase.** Le projet est recadré. N'importe quel membre peut lancer l'app sans base de données, lire ce qu'il doit construire avec `ctx`, prendre un ticket et suivre l'avancement.

**Ce qu'on peut voir dans l'app.** Peu de choses, et c'est assumé. L'app démarre avec son contenu embarqué. La fiche d'un pin (La Cour des Voraces) est en relecture. Le fond de carte de Lyon s'affiche sur un téléphone Android dans un essai séparé.

**Ce qui est fait.**

| Ticket | Charge | Apport |
|---|---|---|
| #125 | 3 | Le suivi hebdomadaire est calculé depuis GitHub |
| #168 | 3 | Le tableau de projet est remis à plat (vues « Mes tâches », « À assigner »…) |
| #166 | 1 | Un prompt convertit un brouillon de pin en fichier de contenu |
| #162 | 1 | Le hook de push ne casse plus les tests |

Faits en avance, alors qu'ils appartiennent au jalon J2 : le contenu embarqué et le démarrage sans base (#130), et l'essai du fond de carte sur téléphone (#129, DEC-110).

**Ce qui reste dans ce jalon.**

| Ticket | Charge | Apport | Dépend de |
|---|---|---|---|
| #86 | 1 | Chaque membre lance l'app sur son poste et le dit en commentaire | rien |
| #122 | 2 | Décision go / no-go sur les droits du modèle 3D de la fontaine | rien |
| #123 | 1 | Atelier parcours : les 7 à 10 pins, leur ordre, le fil narratif | rien |
| #124 | 2 | Le guide de rédaction est remis à l'éditorial (version Word) | rien |
| #165 | 1 | Les bornes et les libellés des 10 époques sont validés | rien |
| #126 | 3 | Le suivi a un historique et une vue client publiée | #125 |
| #127 | 1 | Le rapport du follow-up 2 (une page) | #126 |
| #128 | 1 | Relecture et CI obligatoires sur `main`, droits des membres | rien |

**Pourquoi ces tickets comptent.** #122, #123, #124 et #165 ne contiennent pas de code, mais ils bloquent la suite. Sans l'atelier parcours (#123) et le guide (#124), aucun pin ne peut être rédigé. Sans les époques validées (#165), le slider affiche des bornes provisoires. Sans la décision sur les droits (#122), le pin 3D reste incertain.

**Atteint quand** : chaque membre a lancé l'app, les décisions #122, #123 et #165 sont écrites, et le rapport du follow-up est poussé sur le dépôt de l'école.

**Risques.** Les quatre tickets non techniques n'ont pas encore de responsable. Les pull requests ouvertes attendent une relecture.

## Follow-up 3 (18/12/2026) : la carte vit, les pins racontent

**La phrase.** On ouvre l'app sur la carte de Lyon. On fait glisser le slider d'époques : la carte change d'apparence, et seuls les pins de l'époque choisie restent. On touche un pin : un aperçu s'ouvre. On l'approfondit : la fiche complète raconte le lieu, avec ses sources. Trois pins réels sont publiés.

**Ce que l'utilisateur peut faire.**

- Voir la carte de Lyon plein écran, se déplacer et zoomer, hors ligne. *Carte de base de Lyon* (CAP-D1.1).
- Faire glisser le temps sur 10 époques. *Slider d'époques* (CAP-D1.2).
- Sentir l'époque à l'œil, grâce à un style de carte qui varie. *Apparence de la carte par époque* (CAP-D1.3).
- Voir les pins de l'époque, chacun avec l'icône de sa catégorie. *Pin sur la carte* (CAP-D2.1), *Catégorisation des pins* (CAP-D2.2).
- Lire un aperçu sans quitter la carte. *Aperçu rapide d'un pin* (CAP-D2.4).
- Lire la fiche complète : récit, encart « Le saviez-vous », sources. *Consultation approfondie d'un pin* (CAP-D2.5), *Contenus tissés* (CAP-D2.6).

**Le chemin critique, dans l'ordre.** Chaque ligne attend la précédente.

1. #98 · Carte de Lyon plein écran avec attribution (3). Dépend de #129, déjà fait : il peut démarrer tout de suite.
2. #108 · Slider d'époques (3). Dépend de #98.
3. #109 · Pins sur la carte, filtrés par époque (3). Dépend de #98, #108 et #130.
4. #133 · Aperçu rapide d'un pin (2). Dépend de #109.
5. #137 · Test d'acceptation de la première tranche (2). Dépend de #130, #98, #108, #109 et #99.

**En parallèle**, sans attendre le chemin critique :

| Ticket | Charge | Apport | Dépend de |
|---|---|---|---|
| #99 | 3 | Fiche d'un pin : récit et encarts texte (en relecture) | #130 |
| #131 | 3 | Les tuiles de Lyon sont embarquées dans l'app | #129 |
| #132 | 2 | Un style de carte unique aux couleurs de la charte | #131 |
| #134 | 2 | Les polices de la charte sont fournies à l'app | rien |
| #135 | 2 | Les icônes : catégories et interface | rien |
| #136 | 3 | Un APK de démo installable sur téléphone | rien |
| #106 | 3 | Visionneuse 3D : un modèle s'affiche et se manipule | rien |
| #141 | 1 | Le rapport du follow-up 3 (une page) | #127 |

**Le contenu éditorial.** Les pins n°1 à 3 (#138, #139, #140, charge 2 chacun) sont rédigés, relus et publiés. Ils dépendent de l'atelier parcours (#123) et du guide (#124). Chaque pin passe par trois états : rédigé, relu, publié. Il a au moins une source archivistique ou académique.

**La 3D.** La visionneuse (#106) peut avancer avec n'importe quel modèle d'essai. Elle n'attend pas la décision sur les droits.

**Atteint quand** : le test d'acceptation (#137) passe sur un téléphone avec le contenu embarqué. On montre la carte, le slider, trois pins réels, leur aperçu et leur fiche.

**Risques.** Le chemin critique est une chaîne de trois tickets de charge 3. Si #98 ne démarre pas tout de suite, tout le jalon glisse. Les bords gris au zoom minimum (DEC-110) restent à régler dans #98. La période de Noël commence le lendemain du follow-up : rien ne doit être prévu après le 18/12.

## Gel du MVP (21/01/2027) : le parcours se vit de bout en bout

**La phrase.** On ouvre le parcours depuis l'onglet Parcours. On le démarre. On avance étape par étape, et le slider se place tout seul sur l'époque de chaque étape. Sur la fontaine de la place des Jacobins, on ouvre la vue 3D. À la fin, un bilan dit ce qu'on a vu. Les 7 à 10 pins du parcours sont publiés.

**Ce que l'utilisateur peut faire.**

- Lire la fiche du parcours (teaser, durée, étapes, époques) et décider de le suivre. *Fiche parcours* (CAP-D3.3).
- Le démarrer d'un geste : la carte se recadre, le tracé apparaît. *Lancement de parcours* (CAP-D3.4).
- Avancer à son rythme, en pas à pas manuel, sans géolocalisation. Sauter une étape est permis. *Vivre un parcours étape par étape* (CAP-D3.5).
- Voir un écran de fin : « X étapes vues sur Y », durée, époques traversées. *Fin et célébration* (CAP-D3.9).
- Ouvrir la 3D sur le seul pin qui a un modèle, la tourner, s'en approcher. *Point d'accès conditionnel à la 3D* (CAP-D8.1), *Consultation 3D immersive* (CAP-D8.2).

**Le chemin critique, dans l'ordre.**

1. #105 · Le parcours dans le contenu : format, validation, parcours du MVP (3). Dépend de #123.
2. #142 · Fiche d'un parcours, depuis l'onglet Parcours (3). Dépend de #130 et #105.
3. #143 · Parcours pas à pas : une étape à la fois (3). Dépend de #142.
4. Puis, en parallèle : #144 · Le slider se place sur l'époque de l'étape (2), qui dépend de #143 et #108 ; et #145 · Fin du parcours : bilan et retour à la carte (2), qui dépend de #143.

**La 3D.** #146 · La visionneuse s'ouvre depuis la fiche de la fontaine (3). Dépend de #106 et #122.

**Le contenu éditorial.** Les pins n°4 à 10 (#147 à #153, charge 2 chacun). Le minimum est 7 pins publiés en tout, donc au moins les pins n°4 à 7. Les pins n°8 à 10 sont la marge que la ligne de coupe permet de sacrifier.

**La stabilisation.**

| Ticket | Charge | Apport | Dépend de |
|---|---|---|---|
| #154 | 2 | Cinq personnes extérieures essaient l'app | #136 |
| #155 | 3 | Les corrections de stabilisation avant le gel | #154 |

**Atteint quand** : le parcours complet se fait sur un téléphone, de la fiche du parcours à l'écran de fin, en passant par la vue 3D ; au moins cinq personnes extérieures ont essayé l'app sans aide (#154), et les problèmes bloquants sont corrigés ou ont un ticket. Après le 21/01, aucune nouvelle capacité n'entre ; seuls les correctifs et la finition sont permis.

**Risques.** #105 attend l'atelier parcours (#123) : un atelier tardif retarde tout le jalon. Les pins sont nombreux, et chacun a besoin d'une relecture historique. Si la décision #122 est un no-go, le pin 3D devient plus modeste (plan B décrit dans #122). Les congés du 22/01 au 29/01 suivent immédiatement le gel.

## Oral (05/02/2027) : la démo ne doit pas rater

**La phrase.** On fait la démo sur téléphone, devant le jury, sans surprise : un parcours de 7 à 10 pins et la vue 3D de la fontaine.

**Les tickets.**

| Ticket | Charge | Apport | Dépend de |
|---|---|---|---|
| #156 | 2 | Le scénario de démo est écrit et répété trois fois sur le téléphone | #155 |
| #157 | 1 | Un plan B : captures et vidéo de secours | #156 |

**Atteint quand** : le scénario est écrit, trois répétitions complètes passent sans accroc (dont une avec un réseau limité), et les captures et la vidéo de secours existent.

**Risques.** Il ne reste qu'une semaine entre la fin des congés (29/01) et l'oral. Les répétitions doivent donc être prêtes avant les congés.

## Rendu (07/02/2027) : on livre

**La phrase.** Le MVP est livré, avec son rapport final, sur le dépôt de l'école.

**Le ticket.** #158 · Rapport final et poussée sur le dépôt de l'école (1). Dépend de #157.

**Atteint quand** : le rapport final (indicateurs, tendance, décisions, ce qui est reporté) est écrit, et le dépôt est poussé sur celui de l'école le 05/02 et le 07/02.

## Second semestre : ce qui attend

**La phrase.** Rien de ce jalon ne démarre avant le rendu.

Ce qui y est rangé : Supabase hébergé (#110), les règles de cycle de vie des parcours et de modération (#103, #104), l'app d'administration (#102), le catalogue des parcours (#100), le profil et les favoris (#101), l'AR (#107) et l'audio (#95). On y trouve aussi la géolocalisation, les alertes de proximité, les comptes et la communauté.

*Pour toi* : si tous tes tickets sont dans ce jalon, ils ne sont plus prioritaires. Prends plutôt un ticket du jalon courant dans la vue « À assigner » du tableau de projet.
