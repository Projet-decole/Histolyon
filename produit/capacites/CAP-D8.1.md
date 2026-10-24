---
id: CAP-D8.1
type: capacite
titre: "Point d’accès conditionnel à la 3D"
statut: mvp
priorite: important
jalon: JAL-GEL
liens:
  ecrans: [ECR-PIN-CONSULTATION-3D]
  flux: [FLX-B4, FLX-B2]
  entites: [ENT-MODELE-3D, ENT-PIN]
  invariants: [INV-04]
  composants: [COMP-VIEWER-3D]
  decisions: [DEC-02, DEC-13, DEC-50]
  questions: []
anciens_ids: [D8.1]
sources:
  - conception/03-fonctionnalites/08-3d-ar.yaml:74
  - conception/06-flows/02-consultation-pin.yaml:262
  - conception/04-donnees/01-contenu.yaml:369
  - conception/08-contenu/04-microcopy-grand-public.yaml:364
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
Un pin n’offre la 3D que s’il a un modèle 3D. La plupart n’en ont pas : l’apparition du point d’accès est un signal (« ce lieu a une dimension de plus »). Sans modèle, rien ne s’affiche, pas même un message.

## Persona (litmus)
Kenji découvre la 3D par hasard sur un pin qui s’y prête, sans tutoriel, et ne se demande jamais pourquoi les autres n’en ont pas.

## Version MVP / reporté
- MVP : un pin au plus porte un modèle ; le point d’accès ouvre la visionneuse (CAP-D8.2). Au moins un pin du parcours de démonstration en porte un (DEC-13).
- Reporté : choix entre plusieurs modèles et accès à l’AR (DEC-50, CAP-D8.3).

## Règle d’apparition (à retenir)
Le bouton « Voir en 3D » existe si et seulement si les trois conditions sont vraies : (1) le pin est affiché en consultation approfondie ; (2) il a un modèle 3D rattaché ; (3) ce modèle est publié, a au moins une source (INV-04) et son fichier est disponible dans l’app. Sinon, aucun élément, aucun espace réservé.

## Règles
R1. Le point d’accès n’apparaît que si les conditions de la règle d’apparition sont réunies.
R2. Sans modèle, aucun élément visuel ni message : pas de bouton grisé, pas de « indisponible ».
R3. Le point d’accès se trouve dans la consultation approfondie du pin (CAP-D2.5), jamais dans l’aperçu rapide (CAP-D2.4) ni sur la carte.
R4. Il s’affiche de la même façon quand le pin est ouvert depuis une étape de parcours ; ouvrir la 3D ne fait pas avancer le parcours.
R5. L’activation est un geste volontaire ; ni le défilement ni l’arrivée sur le pin ni un parcours en cours ne l’ouvrent.
R6. L’activation ouvre ECR-PIN-CONSULTATION-3D (FLX-B4), jamais une vue AR.
R7. Libellé : « Voir en 3D » ; le lecteur d’écran l’annonce comme ouvrant une reconstitution 3D.
R8. Tout contenu transmis par la 3D a un équivalent texte dans le récit du pin : la 3D enrichit, elle ne porte jamais seule une information.
R9. La détection lit seulement la présence du modèle dans l’instantané (DEC-04) ; elle ne charge pas le fichier et ne ralentit pas les pins sans 3D.

## États et cas limites
- **Pin sans modèle** : consultation identique à aujourd’hui, rien d’ajouté.
- **Modèle sans source ou non publié** : traité comme absent (R1).
- **Pin retiré ou fichier manquant** : traité comme absent ; pas de message.

## Critères de fin
CF1. Un pin avec modèle affiche « Voir en 3D » dans sa consultation approfondie.
CF2. Un pin sans modèle n’affiche aucun élément lié à la 3D.
CF3. Le tap sur « Voir en 3D » ouvre la visionneuse (CAP-D8.2).
CF4. Le bouton est absent de l’aperçu rapide et de la carte.
CF5. Aucune action automatique n’ouvre la visionneuse.
CF6. Le récit du pin reste complet sans la 3D (R8).

## Hors MVP
- Choix 3D ou AR au point d’accès, sélection entre plusieurs modèles (DEC-50).
- Accès à la 3D depuis un index de reconstitutions sans pin.

## Questions ouvertes
Aucune.
