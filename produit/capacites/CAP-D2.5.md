---
id: CAP-D2.5
type: capacite
titre: "Consultation approfondie d’un pin"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  flux: [FLX-B2]
  entites: [ENT-PIN, ENT-CATEGORIE, ENT-EPOQUE, ENT-SOURCE, ENT-MEDIA]
  invariants: [INV-03, INV-04]
  composants: [COMP-ZONE-NARRATION, COMP-ZONE-SOURCES, COMP-BLOC-SOURCES]
  decisions: [DEC-03, DEC-04, DEC-05, DEC-14, DEC-32, DEC-34]
  questions: []
  capacites: [CAP-D2.4, CAP-D2.6, CAP-D8.1, CAP-D3.5]
anciens_ids: [D2.5]
sources:
  - conception/03-fonctionnalites/02-pins-et-contenu.yaml:416
  - conception/07-ecrans/pin/01-consultation-approfondie.yaml:14
  - conception/06-flows/02-consultation-pin.yaml:104
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
Cœur du contenu : l’histoire du lieu se déploie en pleine surface, en une seule progression de lecture, avec ses sources visibles. Pas d’onglets, pas de galerie à part.

## Persona (litmus)
Le père lyonnais lit une anecdote d’un trait, tombe sur un encart « Le saviez-vous » au bon moment, et peut vérifier la source.

## Version MVP / reporté
- MVP : en-tête, récit, encarts texte (CAP-D2.6), accès 3D conditionnel, pied « Sources », accès à l’étape suivante en parcours.
- Reporté : audio, mode présentation sans chrome, multi-époques, zone post-narrative (CAP-D2.7), commentaires, favori, partage, signalement. Voir ECR-PIN-CONSULTATION-APPROFONDIE.

## Règles
R1. La consultation occupe toute la surface et se lit en un seul défilement continu, sans onglets (DEC-32).
R2. Elle s’ouvre depuis l’aperçu (« Voir le récit », DEC-34) ; la carte est masquée derrière.
R3. Ordre de lecture : en-tête (titre, catégorie, époque) → récit principal avec encarts → accès 3D si applicable → pied « Sources ».
R4. Le récit s’adresse au lecteur au tutoiement narratif ; l’interface (boutons, messages) vouvoie (DEC-14).
R5. Le point d’accès « Voir en 3D » (FLX-B4, ECR-PIN-CONSULTATION-3D) n’existe que si le pin a un modèle 3D (CAP-D8.1). Sinon il est absent, jamais grisé.
R6. Le pied « Sources » liste toutes les sources du pin avec leur crédit (INV-04). Un pin publié a au moins une source.
R7. Retour : à l’aperçu si la consultation en vient (carte conservée), à la carte pour un autre point d’entrée, à l’étape du parcours si elle en vient (CAP-D3.5).
R8. Parcours actif : un accès « Étape suivante » est présent en pied de consultation (CAP-D3.5, DEC-05). La navigation reste manuelle.
R9. Un pin retiré entre l’ouverture et le rafraîchissement : message « Ce pin a été retiré. Retour à la carte. » puis retour gracieux.
R10. Pin communautaire en vérification : marque « Sources en cours de vérification », durable (règle prévue, sans effet au MVP).
R11. La progression reste fluide ; les images se chargent au fil de la lecture.
R12. Le texte du récit est lisible au lecteur d’écran ; chaque image a un texte alternatif.

## États et cas limites
- **Chargement** : structure puis contenu (local, très bref).
- **Nominal** : tout est lisible.
- **Sans modèle 3D** : pas d’accès 3D.
- **Sans encart** : récit seul puis sources.
- **Retiré / erreur de chargement** : message et possibilité de réessayer ou de revenir.

## Critères de fin
CF1. Depuis l’aperçu, « Voir le récit » ouvre la consultation du même pin.
CF2. Un pin sans modèle 3D n’a aucun accès 3D ; un pin avec modèle ouvre ECR-PIN-CONSULTATION-3D.
CF3. Le pied « Sources » liste les sources du pin avec crédit.
CF4. Avec un parcours actif, « Étape suivante » est visible en pied ; hors parcours, il est absent.
CF5. Le retour ramène à la surface d’origine avec son contexte.
CF6. Aucun onglet ni élément latéral n’ouvre un contenu : tout est dans le défilement.
CF7. Un pin retiré ferme la consultation avec le message prévu.

## Hors MVP
- Audio, mode présentation, AR, commentaires, favori, partage, signalement, zone post-narrative (CAP-D2.7), navigation multi-époques (CAP-D2.3).

## Questions ouvertes
Aucune.
