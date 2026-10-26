---
id: CAP-D2.4
type: capacite
titre: "Aperçu rapide d’un pin"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  ecrans: [ECR-CARTE-APERCU-PIN]
  flux: [FLX-B1]
  entites: [ENT-PIN, ENT-CATEGORIE, ENT-EPOQUE, ENT-MEDIA]
  invariants: [INV-03]
  composants: [COMP-APERCU-RAPIDE-PIN, COMP-CHIP-CATEGORIE, COMP-CHIP-EPOQUE, COMP-IMAGE-HERO]
  decisions: [DEC-02, DEC-04, DEC-14, DEC-34]
  questions: []
anciens_ids: [D2.4]
sources:
  - conception/03-fonctionnalites/02-pins-et-contenu.yaml:321
  - conception/06-flows/02-consultation-pin.yaml:40
  - conception/08-contenu/04-microcopy-grand-public.yaml:321
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
Laisser découvrir un pin en quelques secondes sans quitter la carte : on lit, puis on approfondit ou on referme. Geste réflexe, léger.

## Persona (litmus)
Le père lyonnais lit le teaser en quelques secondes et décide de fermer ou d’aller plus loin.

## Version MVP / reporté
- MVP : aperçu superposé à la carte, avec titre, catégorie, époque, teaser, image, accès à la consultation, signal « hors parcours ».
- Reporté : navigation entre époques (CAP-D2.3), partage, favori, signalement, « Ajouter au parcours » (création de parcours, S2).

## Règles
R1. L’aperçu se superpose à la carte, qui reste visible derrière avec son contexte (zoom, position, époque du slider).
R2. Il s’ouvre par un tap sur un pin (CAP-D2.1) ; la consultation ne s’ouvre jamais directement au tap.
R3. Il présente : titre du lieu sans préfixe, chip de catégorie (icône + libellé), chip d’époque, teaser narratif court (voix du récit, DEC-14), une image, et le bouton « Voir le récit » (DEC-34).
R4. Pas de défilement long dans l’aperçu : tout tient sans scroll.
R5. Fermeture par geste de fermeture ou par tap hors de l’aperçu ; la carte retrouve son contexte intact.
R6. Tap sur un AUTRE pin pendant que l’aperçu est ouvert : l’aperçu reste ouvert et se met à jour avec le nouveau pin, sans fermeture ni empilement. La carte ne change ni de zoom ni de position à cause de ce tap.
R7. Pendant un parcours actif, sur un pin hors parcours : signal discret « Ce lieu n’est pas dans votre parcours ». Aucune action bloquée.
R8. Si le pin n’a pas d’image, l’aperçu s’affiche sans emplacement vide.
R9. Pin retiré ou introuvable : message « Ce pin n’est plus disponible. Retour à la carte. » et l’aperçu ne s’ouvre pas.
R10. L’aperçu prend le focus à l’ouverture et se lit au lecteur d’écran ; ses contrôles ont un nom accessible. Ouverture perçue comme immédiate (contenu local, DEC-04).
R11. Un pin communautaire en vérification affiche « Sources en cours de vérification » (règle prévue, sans effet au MVP).

## États et cas limites
- **Ouvert** : contenu du pin courant.
- **Mise à jour** : autre pin tapé (R6).
- **Fermé** : retour carte.
- **Sans image** : R8.
- **Pin introuvable** : R9.

## Critères de fin
CF1. Un tap sur un pin ouvre l’aperçu avec tous les éléments de R3.
CF2. Fermer l’aperçu (geste ou tap dehors) ramène la carte au même zoom, même position, même époque.
CF3. Taper un autre pin met l’aperçu à jour sans le refermer et sans recentrer la carte.
CF4. « Voir le récit » ouvre la consultation (CAP-D2.5).
CF5. Le signal hors parcours n’apparaît qu’avec un parcours actif et un pin hors parcours.
CF6. Le focus passe à l’aperçu à l’ouverture.

## Hors MVP
- Navigation entre époques, partage, favori, signalement : CAP-D2.3, voir ECR-CARTE-APERCU-PIN.
- « Ajouter au parcours » en création de parcours : parcours personnels S2.
- Aperçu hors ligne « non préchargé » : sans objet avec le contenu embarqué (DEC-04).

## Questions ouvertes
Aucune.
