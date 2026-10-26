---
id: CAP-D3.3
type: capacite
titre: "Fiche parcours"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  ecrans: [ECR-PARCOURS-FICHE-DETAIL]
  flux: [FLX-C3]
  entites: [ENT-PARCOURS, ENT-ETAPE]
  invariants: [INV-08]
  composants: [COMP-ITEM-LISTE-ETAPE, COMP-BUTTON-PRIMARY]
  decisions: [DEC-04, DEC-05, DEC-13]
  questions: [QO-302]
anciens_ids: [D3.3]
sources:
  - conception/03-fonctionnalites/03-parcours.yaml:226
  - conception/06-flows/03-parcours.yaml:110
  - conception/07-ecrans/parcours/03-fiche-detail.yaml:15
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
La fiche donne tout ce qu’il faut pour décider de démarrer le parcours, dans le ton conteur : teaser, durée, étapes, époques. Elle est aussi le point de départ du lancement (CAP-D3.4) et du retour au parcours.

## Persona (litmus)
Une personne qui ne connaît pas le parcours sait en quelques secondes s’il lui convient, et lui donne envie de l’ouvrir.

## Version MVP / reporté
- MVP : une fiche pour l’unique parcours éditorial embarqué (7 à 10 pins, DEC-13, DEC-04). Aucun catalogue : la surface Parcours ouvre cette fiche directement (voir QO-302).
- Reporté (S2) : catalogue, filtres, parcours communautaires et personnels (CAP-D3.1, CAP-D3.2), favori, partage, retours, signalement (DEC-04, DEC-05).

## Règles
R1. La fiche est une surface dédiée, jamais un aperçu superposé.
R2. Elle s’ouvre sans catalogue : le contenu du parcours vient de l’instantané embarqué (DEC-04). Le MVP n’a qu’un parcours, la fiche n’a donc pas d’écran amont.
R3. L’en-tête présente une image d’ouverture, le titre, le teaser narratif et la marque « Officiel » du parcours éditorial. Le teaser est obligatoire, court, au ton conteur.
R4. Les métadonnées montrent la durée estimée, la distance estimée, le nombre d’étapes, les époques traversées (INV-08) et la densité du contenu en trois niveaux.
R5. La liste des étapes est ordonnée : position, titre du pin, catégorie, époque. Un tap sur une étape ouvre son aperçu dans la fiche, sans la quitter.
R6. L’aperçu d’étape montre le pin (titre, teaser) et l’introduction d’étape si elle existe. Il propose d’ouvrir la consultation approfondie du pin (CAP-D2.5) ; le retour ramène à la fiche.
R7. Les métadonnées et le teaser sont visibles avant l’action de démarrage. L’action n’est jamais masquée par eux.
R8. L’action principale est unique, sans choix de mode (DEC-05) : « Démarrer ce parcours ». Elle devient « Reprendre » si le parcours est en cours, « Recommencer » s’il a été terminé ou abandonné.
R9. Aucune indication de difficulté physique n’est affichée.
R10. Le retour de la fiche ramène à l’onglet d’où l’on vient.

## États et cas limites
- **Nominal** : toutes les zones sont affichées depuis le contenu embarqué.
- **En cours** : l’action devient « Reprendre » et ramène à ECR-PARCOURS-EN-COURS-TERRAIN.
- **Déjà terminé** : la dernière fin est rappelée (date, « X étapes vues sur Y », DEC-09) ; l’action est « Recommencer ».
- **Abandonné** : l’action est « Recommencer ».
- **Contenu illisible** : message gracieux invitant à réessayer.

## Critères de fin
CF1. Depuis la surface Parcours, l’utilisateur atteint la fiche sans écran intermédiaire.
CF2. Titre, teaser, durée, distance, nombre d’étapes, époques et densité sont affichés.
CF3. Un tap sur une étape affiche son aperçu dans la fiche ; la consultation approfondie s’ouvre depuis cet aperçu et le retour revient à la fiche.
CF4. « Démarrer ce parcours » lance CAP-D3.4 ; l’action change selon l’état (en cours, terminé, abandonné).
CF5. Aucun élément de catalogue, de favori, de partage ou de signalement n’apparaît.

## Hors MVP
- Catalogue et filtres : E-PARCOURS-PRINCIPAL, E-PARCOURS-FILTRES (CAP-D3.2).
- Libellé de démarrage en trois variantes selon la proximité, rayon « à proximité » : géolocalisation écartée (DEC-05, DEC-06).
- Favori, partage de la fiche, retours synthétisés, signalement (S2).
- Marques « Sources en cours de vérification » et « Parcours partagé en privé », états retiré et hors-ligne : sans communauté ni backend (DEC-04).

## Questions ouvertes
QO-302 — le point d’accès à la fiche sans catalogue (onglet Parcours) est une hypothèse.
