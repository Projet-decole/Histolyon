---
id: ECR-PARCOURS-FICHE-DETAIL
type: ecran
titre: "Fiche d’un parcours"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  capacites: [CAP-D3.3, CAP-D3.4]
  flux: [FLX-C3, FLX-C4]
  composants: [COMP-BUTTON-PRIMARY, COMP-BUTTON-BACK, COMP-ITEM-LISTE-ETAPE, COMP-APERCU-RAPIDE-PIN]
  entites: [ENT-PARCOURS, ENT-ETAPE]
  decisions: [DEC-04, DEC-05, DEC-09, DEC-13, DEC-14]
anciens_ids: [E-PARCOURS-FICHE-DETAIL]
sources:
  - conception/07-ecrans/parcours/03-fiche-detail.yaml:15
  - conception/08-contenu/04-microcopy-grand-public.yaml:440
images: []
budget_tokens: 2000
derniere_verif: 2026-10-24
---

## Rôle
Permet de décider de démarrer l’unique parcours du MVP. Présente le teaser, les métadonnées et les étapes, puis lance le parcours (CAP-D3.3). Point d’entrée de la surface Parcours, sans catalogue (QO-302).

## Composition
De haut en bas, :
1. **En-tête narratif** : image d’ouverture, titre, teaser narratif, marque « Officiel » ; bouton retour (COMP-BUTTON-BACK).
2. **Métadonnées** : durée estimée, distance, nombre d’étapes, époques traversées, densité (légère, moyenne, dense).
3. **Liste des étapes** : une rangée par étape (COMP-ITEM-LISTE-ETAPE) avec position, titre du pin, catégorie, époque.
4. **Aperçu d’étape** : zone interne à la fiche, affichée au tap sur une étape (COMP-APERCU-RAPIDE-PIN) : titre, teaser du pin, introduction d’étape si elle existe, accès à la consultation approfondie.
5. **Action principale** (COMP-BUTTON-PRIMARY), toujours visible.

## États
- **nominal** — quand : parcours jamais commencé ; on voit : toutes les zones, action « Démarrer ce parcours ».
- **en cours** — quand : le parcours est en cours ; on voit : action « Reprendre ».
- **déjà terminé** — quand : le parcours a été terminé ; on voit : rappel de la fin précédente (« X étapes vues sur Y », DEC-09) et action « Recommencer ».
- **abandonné** — quand : le parcours a été abandonné ; on voit : action « Recommencer ».
- **erreur** — quand : le contenu embarqué ne se lit pas ; on voit : message gracieux invitant à réessayer.

## Interactions
- Tap sur une étape → affiche son aperçu dans la fiche.
- Tap dans l’aperçu → consultation approfondie du pin ; le retour ramène à la fiche.
- « Démarrer ce parcours » → lancement, bascule sur la carte (FLX-C4).
- « Reprendre » → écran du parcours en cours (ECR-PARCOURS-EN-COURS-TERRAIN).
- « Recommencer » → relance à l’étape 1 (FLX-C4).
- Retour → onglet d’origine.

## Libellés de l’écran
Titre : titre du parcours. Métadonnées : « Durée estimée », « Distance », « {n} étapes », « Époques traversées », « Lecture légère », « Lecture moyenne », « Lecture dense » (le singulier de « {n} étapes » pour une seule étape reste à définir). Actions : « Démarrer ce parcours », « Reprendre », « Recommencer ». Le texte du message d’erreur est à écrire par le groupe contenu. Les valeurs visuelles viennent des tokens du groupe DESIGN.

## Hors MVP
- Catalogue et filtres : E-PARCOURS-PRINCIPAL, E-PARCOURS-FILTRES.
- Écran de lancement E-PARCOURS-LANCEMENT (DEC-05).
- Favori, partage (lien, code visuel), « Laisser un retour », signalement, retours synthétisés (S2).
- Marques « Sources en cours de vérification » et « Parcours partagé en privé », états retiré et hors-ligne (DEC-04).
- Trois variantes du libellé de démarrage selon la proximité (DEC-05).
