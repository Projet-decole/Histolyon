---
id: CAP-D8.2
type: capacite
titre: "Consultation 3D immersive"
statut: mvp
priorite: important
jalon: JAL-GEL
liens:
  ecrans: [ECR-PIN-CONSULTATION-3D]
  flux: [FLX-B4, FLX-B2]
  entites: [ENT-MODELE-3D, ENT-PIN, ENT-EPOQUE, ENT-SOURCE]
  invariants: [INV-04]
  composants: [COMP-VIEWER-3D]
  decisions: [DEC-04, DEC-13, DEC-14, DEC-50, DEC-51]
  questions: [QO-401, QO-402, QO-403, QO-405]
anciens_ids: [D8.2]
sources:
  - conception/03-fonctionnalites/08-3d-ar.yaml:160
  - conception/06-flows/02-consultation-pin.yaml:262
  - conception/04-donnees/01-contenu.yaml:369
  - conception/07-ecrans/pin/03-consultation-3d.yaml:16
  - conception/08-contenu/04-microcopy-grand-public.yaml:387
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
Donner l’espace et l’attention nécessaires pour explorer une reconstitution : tourner autour, s’approcher, chercher un détail. L’écran n’a pas d’éléments superflus, mais la rigueur historique reste visible (titre, époque, sources).

## Persona (litmus)
Mme Martin projette la reconstitution en classe, lisible depuis le fond de la salle, et peut citer sa source devant ses élèves.

## Version MVP / reporté
- MVP : un modèle, manipulation au toucher, contextualisation, retour au pin. Démo prévue : fontaine de la place des Jacobins.
- Reporté : superposition AR, sélecteur de modèles, partage, audio dédié (DEC-50, CAP-D8.3).

## Règles
R1. La visionneuse occupe tout l’écran et masque le chrome non essentiel (DEC-51).
R2. Un geste de glissement fait tourner le modèle, un pincement l’approche ou l’éloigne ; les mouvements sont progressifs, sans à-coup brusque.
R3. Titre du modèle, époque recréée et accès aux sources restent accessibles sans masquer la scène (INV-04, QO-402).
R4. Un retour est toujours présent ; il ramène à la consultation approfondie du pin et libère les ressources de rendu.
R5. Les surfaces persistantes (parcours en cours, bandeau hors ligne) sont en retrait pendant la consultation ; la progression du parcours n’a pas bougé au retour.
R6. La visionneuse n’est jamais ouverte automatiquement (CAP-D8.1/R5).
R7. Chargement : indicateur discret « Chargement de la reconstitution… » ; le retour reste possible (QO-401).
R8. Échec de chargement : message sobre et retour proposé ; la consultation du pin n’est pas bloquée.
R9. Aucune information n’est portée seulement par la 3D : le récit du pin a l’équivalent (CAP-D8.1/R8).
R10. La contextualisation est lisible par un lecteur d’écran et en projection (texte grand, contraste fort).
R11. Le contenu 3D est un enrichissement : l’app est complète sans lui (DEC-13).

## États et cas limites
- **chargement** / **nominal** / **erreur** : voir ECR-PIN-CONSULTATION-3D.
- **Hors ligne** : le contenu est local (DEC-04) ; ce cas n’existe que si le fichier est distant (QO-401).
- **Appareil trop lent** : comportement à définir (QO-403).
- **Attribution du modèle** : QO-405.

## Critères de fin
CF1. Un modèle se consulte en plein écran, chrome masqué.
CF2. L’utilisateur le fait tourner, l’approche et l’éloigne sans saccade perceptible.
CF3. Titre, époque et sources sont accessibles pendant la consultation.
CF4. Le retour vers la consultation approfondie fonctionne à tout moment, y compris pendant le chargement.
CF5. Au retour, la progression du parcours est inchangée.
CF6. Une erreur de chargement n’empêche ni le retour ni la lecture du pin.

## Hors MVP
- Bascule vers l’AR, permission caméra, ancrage géographique (CAP-D8.3, DEC-05, DEC-06).
- Sélecteur de modèles, visite guidée scénarisée, partage depuis la 3D, audio pendant la 3D.
- Mode présentation générique (DEC-51).

## Questions ouvertes
QO-401, QO-402, QO-403, QO-405.
