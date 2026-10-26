---
id: ECR-TRANSVERSES-BANDEAU-OFFLINE
type: ecran
titre: "Bandeau hors ligne"
statut: mvp
priorite: secondaire
jalon: JAL-GEL
liens:
  capacites: [CAP-D8.2]
  flux: []
  composants: [COMP-BANDEAU-INFORMATION-OFFLINE]
  entites: []
  decisions: [DEC-04, DEC-06, DEC-14]
  questions: [QO-404]
anciens_ids: [E-TRANSVERSES-BANDEAU-OFFLINE]
sources:
  - conception/07-ecrans/transverses/03-bandeau-offline.yaml:15
  - conception/08-contenu/04-microcopy-grand-public.yaml:887
images: []
budget_tokens: 2000
derniere_verif: 2026-10-24
---

## Rôle
Dire que la connexion manque et que l’app montre le contenu déjà présent, pour qu’une action indisponible ne soit pas incomprise. Information seulement, pas une action.

## Hors ligne au MVP
Le contenu est un instantané embarqué (DEC-04) et les tuiles de la carte aussi (DEC-06) : lire un pin, la carte ou un parcours fonctionne sans réseau. « Hors ligne » n’est donc pas un mode dégradé normal ; le bandeau ne s’affiche que lorsque l’app tente une ressource distante sans réseau. Laquelle : QO-404.

## Composition
- **Indicateur d’état** + **message court** (COMP-BANDEAU-INFORMATION-OFFLINE), sur toutes les surfaces principales.

## États
- **hors ligne** — quand : réseau absent et ressource distante demandée ; on voit : « Hors ligne. Vous lisez le contenu déjà téléchargé. »
- **reconnexion** — quand : réseau retrouvé ; le bandeau disparaît ; message possible « Connexion retrouvée. » (message éphémère, voir ECR-TRANSVERSES-MESSAGE-EPHEMERE).
- **en retrait** — pendant la consultation 3D : masqué, la condition reste suivie (DEC-51).
- **réseau instable** — pas de clignotement : délai anti-rebond à fixer à l’implémentation (valeur non précisée par les sources).

## Interactions
- Aucune : le bandeau n’est pas un point d’accès. Le tap qui ouvre une explication n’est pas retenu (question de la source non tranchée, aucune fonction MVP ne l’exige).

## Libellés de l’écran
Vouvoiement (DEC-14). Libellé de statut « Hors ligne » (sans tiret). « Hors ligne. Vous lisez le contenu déjà téléchargé. » ; « Connexion retrouvée. ».

## Hors MVP
- Distinction connexion absente et connexion restreinte par le profil (profil hors MVP).
- Actions mises en attente (commentaire, envoi) : communauté hors MVP.
