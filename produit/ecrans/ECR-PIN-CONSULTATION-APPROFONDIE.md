---
id: ECR-PIN-CONSULTATION-APPROFONDIE
type: ecran
titre: "Consultation approfondie d’un pin"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  capacites: [CAP-D2.5, CAP-D2.6, CAP-D2.2, CAP-D8.1]
  flux: [FLX-B2, FLX-B4]
  composants: [COMP-LAYOUT-CONSULTATION-PIN-APPROFONDIE, COMP-HEADER-RETOUR-TITRE, COMP-CHIP-CATEGORIE, COMP-CHIP-EPOQUE, COMP-ZONE-NARRATION, COMP-SAVIEZ-VOUS, COMP-CITATION, COMP-ZONE-SOURCES, COMP-BUTTON-SECONDARY, COMP-MESSAGE-EPHEMERE]
  entites: [ENT-PIN, ENT-CATEGORIE, ENT-EPOQUE, ENT-SOURCE, ENT-MEDIA]
  decisions: [DEC-03, DEC-04, DEC-32, DEC-34]
anciens_ids: [E-PIN-CONSULTATION-APPROFONDIE]
sources:
  - conception/07-ecrans/pin/01-consultation-approfondie.yaml:14
  - conception/08-contenu/04-microcopy-grand-public.yaml:360
images: []
budget_tokens: 2000
derniere_verif: 2026-10-24
---

## Rôle
Surface de lecture pleine page d’un pin : le récit, ses encarts et ses sources. C’est ici que l’historicité devient visible. Point d’accès à la vue 3D (ECR-PIN-CONSULTATION-3D, décrite par CAP-D8.1).

## Composition
De haut en bas, en un seul défilement :
1. **En-tête** : retour, titre du pin, chip de catégorie (`COMP-CHIP-CATEGORIE`), chip d’époque (`COMP-CHIP-EPOQUE`).
2. **Récit principal** (`COMP-ZONE-NARRATION`) : image d’ouverture si elle existe, puis le texte.
3. **Encarts** : « Le saviez-vous » (`COMP-SAVIEZ-VOUS`) et citations (`COMP-CITATION`), distincts du récit (CAP-D2.6).
4. **Point d’accès 3D** : « Voir en 3D », présent seulement si le pin a un modèle 3D (CAP-D8.1). Absent sinon, jamais grisé.
5. **Pied « Sources »** (`COMP-ZONE-SOURCES`) : liste des sources avec crédit.
6. **Accès « Étape suivante »**, seulement avec un parcours actif (CAP-D3.5).

## États
- **chargement** — quand : ouverture ; on voit : structure et titre, indicateur « Chargement ».
- **nominal** — quand : pin chargé ; on voit : tout ce qui précède.
- **sans modèle 3D** — le point d’accès 3D est absent.
- **sans encart** — le récit enchaîne sur « Sources ».
- **parcours actif** — « Étape suivante » en pied.
- **pin retiré** — message éphémère « Ce pin a été retiré. Retour à la carte. » puis retour.
- **erreur de chargement** — « Erreur de chargement » et bouton « Réessayer » ; le retour reste possible.

## Interactions
- Retour → surface d’origine (aperçu ou carte, FLX-B2).
- « Voir en 3D » → ECR-PIN-CONSULTATION-3D (FLX-B4).
- « Étape suivante » → étape suivante du parcours (CAP-D3.5).
- Défilement : lecture continue, médias chargés au fil du défilement.

## Libellés de l’écran
Interface au vouvoiement (DEC-14), récit au tutoiement.
- Titre : titre du pin sans préfixe (« Bellecour », pas « Pin : Bellecour »).
- « Voir en 3D » · « Sources » (pied) · « Étape suivante ».
- « Ce pin a été retiré. Retour à la carte. »
- « Chargement » · « Erreur de chargement » · « Réessayer ».
- Pas de libellé de section pour le récit : le récit est l’écran.

## Hors MVP
- Mode présentation (« Mode présentation », « Quitter la présentation »).
- Navigation multi-époques (CAP-D2.3).
- Zone post-narrative : « Petite question », « Pour aller plus loin », « À voir aussi » (CAP-D2.7).
- Audio (« Écouter », « Pause »), section commentaires, favori, partage, signalement.
- Marque « Sources en cours de vérification » : règle prévue, sans pin communautaire au MVP.
- Archives, avant/après, puzzle, frise (DEC-03) ; entrées par lien universel ou proximité (DEC-05).
- Onglets « Récit / Sources / Commentaires » de la microcopy d’origine : rejetés (DEC-32).
