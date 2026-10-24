---
id: ECR-TRANSVERSES-PARCOURS-PERSISTANT
type: ecran
titre: "Surface persistante du parcours en cours"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  capacites: [CAP-D3.4, CAP-D3.5]
  flux: [FLX-C5]
  composants: [COMP-SURFACE-PERSISTANTE-PARCOURS, COMP-INDICATEUR-PROGRESSION, COMP-DIALOGUE-CONFIRMATION]
  entites: [ENT-PARCOURS, ENT-ETAPE, ENT-HISTORIQUE-DE-VISITE]
  decisions: [DEC-05, DEC-07, DEC-40]
anciens_ids: [E-TRANSVERSES-PARCOURS-PERSISTANT]
sources:
  - conception/07-ecrans/transverses/02-parcours-persistant.yaml:15
images: []
budget_tokens: 2000
derniere_verif: 2026-10-24
---

## Rôle
Barre qui reste visible tant qu’un parcours est en cours : elle évite de perdre le fil quand on va sur la carte ou le profil, et ramène d’un geste à l’étape courante.

## Composition
Une barre en pied d’écran (COMP-SURFACE-PERSISTANTE-PARCOURS), visible sur les trois onglets :
1. **Identité** : titre du parcours.
2. **Progression** (COMP-INDICATEUR-PROGRESSION) : « Étape n sur Y » et titre court de l’étape courante, dérivés de l’historique.
3. **Accès** : toute la barre est cliquable.
4. **Fermeture explicite** : action d’abandon qui ouvre le dialogue de confirmation (COMP-DIALOGUE-CONFIRMATION).

## États
- **nominal** — quand : parcours en cours ; on voit : la barre sur les trois onglets.
- **fin** — quand : dernière étape vue ou sautée ; on voit : la barre cède la place à ECR-PARCOURS-FIN-CELEBRATION puis disparaît.
- **abandon confirmé** — quand : abandon validé ; on voit : la barre disparaît.

## Interactions
- Tap sur la barre → ECR-PARCOURS-EN-COURS-TERRAIN (FLX-C5).
- Fermeture → dialogue « Abandonner ce parcours ? » ; annulation : la barre reste inchangée.
- Le saut d’étape n’est pas dans la barre : il vit sur l’écran du parcours en cours (DEC-40).

## Libellés de l’écran
Titre du parcours, « Étape {n} sur {total} », « Abandonner » (vouvoiement d’interface, DEC-14).

## Hors MVP
- Indicateur de mode terrain/canapé (un seul mode, DEC-05).
- Provenance éditorial/communautaire/personnel (un seul parcours éditorial).
- Cohabitation avec l’audio persistant, le bandeau hors-ligne et le mode présentation.
- Pause, déviation, rappel (CAP-D3.10).
