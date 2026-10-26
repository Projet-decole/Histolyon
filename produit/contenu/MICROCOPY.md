---
id: DOC-MICROCOPY
type: document
titre: "Microcopy de l’interface MVP"
statut: mvp
liens:
  decisions: [DEC-03, DEC-04, DEC-05, DEC-09, DEC-14, DEC-15]
  questions: [QO-906, QO-907, QO-908, QO-909]
anciens_ids: []
sources:
  - conception/08-contenu/04-microcopy-grand-public.yaml:46
  - conception/08-contenu/04-microcopy-grand-public.yaml:157
  - conception/08-contenu/04-microcopy-grand-public.yaml:302
  - conception/08-contenu/04-microcopy-grand-public.yaml:862
  - conception/08-contenu/04-microcopy-grand-public.yaml:993
  - DEC-14
  - DEC-09
derniere_verif: 2026-10-24
---

# Microcopy de l’interface MVP

Libellés des écrans du MVP, repris tels quels de la source (aucun texte créé). Tous vouvoient (DEC-14) ; ce qui a été écarté (tutoiement, hors MVP) est dans DOC-TRI-CONTENU. Voix de l’interface : sobre, sans exclamation ni emoji (DOC-GUIDE-REDACTION R6, R34). Entre parenthèses : la ligne d’origine dans `conception/08-contenu/04-microcopy-grand-public.yaml`. Les identifiants D… sont ceux du dictionnaire d’origine.

16 blocs retenus.

## M1. Verbes d’action
Emplacement : tous les écrans. (l. 49-68)
« Continuer » (D1), « Annuler » (D2, jamais « OK »), « Réessayer » (D4), « Retour » (D6), « Fermer » (D8), « Démarrer » (D14), « Reprendre » (D15), « Abandonner » (D18), « Sauter cette étape » (D19), « Approfondir » (D20).

## M2. Statuts
Emplacement : tous les écrans. (l. 82-87)
« Chargement » (D40), « En cours » (D41, parcours engagé), « Terminé » (D42), « Hors ligne » (D44, sans tiret), « Erreur de chargement » (D45, toujours suivi de « Réessayer »).

## M3. Entités nommées
Emplacement : tous les écrans. (l. 118-123)
« Pin » (majuscule en début de phrase, minuscule au fil), « Parcours » (invariable), « Étape » (« Étape 3 sur 7 »), « Catégorie », « Époque » (jamais « Période »), « Source ».

## M4. Sections de navigation
Emplacement : barre à trois onglets. (l. 104-106)
« Carte », « Parcours », « Profil ».

## M5. ECR-CARTE-PRINCIPALE
(l. 306-307, 317)
- Titre : « Carte »
- Aucun pin à l’époque affichée : « Aucun pin à cette époque dans cette zone. Élargissez la vue ou changez d’époque. »

## M6. ECR-CARTE-APERCU-PIN
(l. 159-179, 321-324)
- Titre : celui du pin, sans qualificatif ; aucun chrome de titre supplémentaire.
- Teaser : extrait court du récit (DOC-GABARIT-PIN).
- Bouton : « Voir le récit »
- Affichent aussi l’époque et la catégorie (M3).

## M7. ECR-PIN-CONSULTATION-APPROFONDIE
(l. 180-192, 360-377)
- Titre : celui du pin, sans préfixe (« Bellecour », pas « Pin : Bellecour »). Pas de libellé de section : le récit est l’écran.
- Accès 3D : « Voir en 3D »
- Pied de page : « Sources »
- Retour : « Retour » (M1)

## M8. ECR-PIN-CONSULTATION-3D
(l. 387-396)
- Titre : celui du modèle 3D.
- Lien : « Sources de la reconstitution »
- Chargement : « Chargement de la reconstitution… »
- Hors ligne : « Reconstitution indisponible hors ligne. »
- Appareil limité : « Votre appareil peine à afficher cette reconstitution. »

## M9. ECR-PARCOURS-FICHE-DETAIL
(l. 440-452)
- Titre : celui du parcours.
- Métadonnées : « Durée estimée », « Distance », « {n} étapes », « Époques traversées ».
- Densité : « Lecture légère », « Lecture moyenne », « Lecture dense ».
- Actions : « Démarrer ce parcours », « Reprendre ».

## M10. ECR-PARCOURS-EN-COURS-TERRAIN (pas à pas manuel)
Écran retenu sous son identifiant d’origine (DEC-05). (l. 476-492, 494-506)
- Progression : « Étape {n} sur {total} »
- Navigation : « Étape suivante », « Étape précédente »
- Autres actions : « Sauter cette étape », « Abandonner »

## M11. ECR-PARCOURS-FIN-CELEBRATION
(l. 517-532 ; DEC-09)
- Titre : celui du parcours.
- Récapitulatif : intitulé « En chemin », « Durée totale », « Époques traversées ».
- Compteur : « X étapes vues sur Y » (formulation fixée par DEC-09 ; la source disait « {n} étapes parcourues » et « {n} étapes laissées de côté », l. 523-524).
- Les phrases d’ouverture du récit de fin sont au tutoiement : voir DOC-TRI-CONTENU et QO-909.

## M12. ECR-TRANSVERSES-PARCOURS-PERSISTANT
(l. 876-885)
- Titre du parcours en cours ; « Étape {n} sur {total} »
- Retour : « Revenir au parcours »
- Sortie : « Quitter le parcours »

## M13. ECR-TRANSVERSES-BANDEAU-OFFLINE
(l. 887-892)
- Bandeau : « Hors ligne. Vous lisez le contenu déjà téléchargé. »
- Retour de connexion : « Connexion retrouvée. »
- Le contenu étant embarqué (DEC-04), le bandeau ne s’affiche que si l’app tente une ressource distante.

## M14. ECR-TRANSVERSES-DIALOGUE-CONFIRMATION
(l. 251-271, 894-905)
- Règle : le titre dit l’action (« Abandonner ce parcours ? »), la description dit ce qui sera fait et perdu, un bouton dit l’action, l’autre est « Annuler ». Jamais « Êtes-vous sûr ? » ni « OK ».
- Abandon d’un parcours : titre « Abandonner ce parcours ? » ; description « Vous quittez le parcours en cours. Vous pourrez toujours le relancer plus tard depuis Mes parcours. » (voir QO-906) ; boutons « Abandonner », « Annuler ».
- Échec après confirmation : « L’action n’a pas pu aboutir. Vous pouvez réessayer. »

## M15. ECR-TRANSVERSES-MESSAGE-EPHEMERE
(l. 277-293, 1000-1003)
- Règle : phrase nominale, point final, pas d’exclamation.
- Seule instance retenue : « Connexion retrouvée. » (à employer avec le bandeau M13 lorsqu’une opération était en attente).

## M16. États vides et erreurs liés
(l. 1030-1034)
- Échec de chargement : « Erreur de chargement. » ; avec action : « Erreur de chargement. Réessayez. » Aucun code ni trace visible.
- État vide de la carte : voir M5.
