---
id: ECR-PARCOURS-FIN-CELEBRATION
type: ecran
titre: "Fin du parcours"
statut: mvp
priorite: important
jalon: JAL-GEL
liens:
  capacites: [CAP-D3.9]
  flux: [FLX-C9]
  composants: [COMP-ITEM-LISTE-ETAPE, COMP-BUTTON-PRIMARY]
  entites: [ENT-PARCOURS, ENT-ETAPE, ENT-HISTORIQUE-DE-VISITE]
  decisions: [DEC-05, DEC-09, DEC-14]
anciens_ids: [E-PARCOURS-FIN-CELEBRATION]
sources:
  - conception/07-ecrans/parcours/08-fin-celebration.yaml:16
  - conception/08-contenu/04-microcopy-grand-public.yaml:517
images:
  - {etat: nominal, fichier: img/ECR-PARCOURS-FIN-CELEBRATION--nominal@2x.png, node_figma: ""}
budget_tokens: 2000
derniere_verif: 2026-10-24
---

## Rôle
Marque la fin du parcours par un moment dédié : phrase de clôture et récapitulatif honnête de ce qui a été vu (CAP-D3.9). L’expérience reste pleine si des étapes ont été sautées (DEC-09).

## Composition
De haut en bas :
1. **Ouverture** : image atmosphérique, titre du parcours, mention de fin.
2. **Conclusion narrative** : phrase de clôture, présente seulement si le parcours en porte une.
3. **Récapitulatif « En chemin »** : « X étapes vues sur Y », durée totale, époques traversées.
4. **Étapes** (COMP-ITEM-LISTE-ETAPE) : coche sur les étapes vues ; tap pour rouvrir le pin.
5. **Sortie** (COMP-BUTTON-PRIMARY) : retour à la fiche.

## États
- **tout vu** — quand : X = Y ; on voit : « Parcours achevé », récapitulatif positif, conclusion si elle existe.
- **partiel** — quand : X < Y ; on voit : « X étapes vues sur Y », étapes sautées sans coche, ton sans reproche.
- **sans conclusion** — quand : le parcours n’a pas de phrase de clôture ; on voit : zone absente.

## Interactions
- Tap sur une étape → consultation approfondie du pin, hors contexte de parcours.
- Sortie → fiche du parcours, où l’action devient « Recommencer ».
- L’écran ne se ferme jamais seul (FLX-C9).

## Libellés de l’écran
Mentions : « Parcours achevé » ; version partielle à adapter (QO-304). Récit (tutoiement, DEC-14) : « Tu as parcouru les {n} étapes du {nom_parcours}. Voici ce qu’on a vu ensemble. » ; partiel : « Tu as parcouru {n} étapes sur {total}. Le reste t’attend quand tu voudras. » Récapitulatif : « En chemin », « Durée totale », « Époques traversées », compteur « {n} étapes vues sur {total} » (DEC-09). Sortie : libellé d’origine « Revenir à mes parcours » à adapter (QO-304).

## Hors MVP
- « Partager une trace de ce parcours » (image partageable), « Partager le parcours », « Laisser un retour » (S2).
- Badges, quiz, distance parcourue (S2).
- Parcours retiré entre-temps, réseau indisponible, re-consultation depuis l’historique.
- Vue « Mes parcours » (catalogue écarté, DEC-05).
