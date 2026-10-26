---
id: ECR-PIN-CONSULTATION-3D
type: ecran
titre: "Consultation 3D d’un pin"
statut: mvp
priorite: important
jalon: JAL-GEL
liens:
  capacites: [CAP-D8.1, CAP-D8.2]
  flux: [FLX-B4, FLX-B2]
  composants: [COMP-VIEWER-3D, COMP-BUTTON-BACK]
  entites: [ENT-MODELE-3D, ENT-PIN]
  decisions: [DEC-04, DEC-14, DEC-50, DEC-51]
  questions: [QO-401, QO-402, QO-403, QO-405]
anciens_ids: [E-PIN-CONSULTATION-3D]
sources:
  - conception/07-ecrans/pin/03-consultation-3d.yaml:16
  - conception/08-contenu/04-microcopy-grand-public.yaml:387
images:
  - {etat: nominal, fichier: img/ECR-PIN-CONSULTATION-3D--nominal@2x.png, node_figma: ""}
budget_tokens: 2000
derniere_verif: 2026-10-24
---

## Rôle
Explorer la reconstitution 3D rattachée à un pin : tourner, approcher, éloigner, tout en gardant visibles le titre, l’époque et les sources.

## Composition
- **Scène 3D** (COMP-VIEWER-3D) : plein écran, rendu manipulable au toucher.
- **Contextualisation discrète** : titre du modèle (issu du contenu), époque recréée, action « Sources de la reconstitution » (forme : QO-402). Attribution : QO-405.
- **Retour** (COMP-BUTTON-BACK) : ramène à la consultation approfondie du pin (FLX-B2).

## États
- **chargement** — quand : ouverture ; on voit : indicateur discret « Chargement de la reconstitution… », retour possible (QO-401).
- **nominal** — quand : modèle chargé ; on voit : la scène, la contextualisation ; surfaces persistantes en retrait (DEC-51).
- **erreur de chargement** — quand : le fichier ne se charge pas ; on voit : message sobre (« Erreur de chargement »), retour proposé.
- **hors ligne** — seulement si le fichier est distant (QO-401) : « Reconstitution indisponible hors ligne. » puis retour au pin. Au MVP le contenu est local (DEC-04), donc ce cas n’apparaît normalement pas.
- **ressources insuffisantes** — « Votre appareil peine à afficher cette reconstitution. » ; suite à définir (QO-403).

## Interactions
- Glissement → rotation ; pincement → approche ou éloignement.
- Tap sur « Sources de la reconstitution » → affiche les sources (QO-402).
- Retour → libère les ressources 3D et revient au pin (FLX-B4, FLX-B2).
- Pas de geste automatique : l’écran ne s’ouvre que depuis « Voir en 3D » (CAP-D8.1).

## Libellés de l’écran
Vouvoiement (DEC-14). « Chargement de la reconstitution… », « Sources de la reconstitution », « Reconstitution indisponible hors ligne. », « Votre appareil peine à afficher cette reconstitution. ». Le titre vient du contenu du modèle.

## Hors MVP
- Bouton « Voir sur place » et message sur l’appareil sans AR : AR hors MVP (CAP-D8.3, DEC-50) ; écran pin/04-consultation-ar écarté.
- Sélecteur de modèle, partage, audio pendant la 3D.
- Mode présentation (écran pin/02-mode-presentation écarté, DEC-51) ; dialogue de permission caméra (transverses/06 écarté).
