---
id: ECR-TRANSVERSES-DIALOGUE-CONFIRMATION
type: ecran
titre: "Dialogue de confirmation"
statut: mvp
priorite: important
jalon: JAL-GEL
liens:
  capacites: [CAP-D8.2]
  flux: [FLX-C7]
  composants: [COMP-DIALOGUE-CONFIRMATION, COMP-BACKDROP]
  entites: []
  decisions: [DEC-05, DEC-14]
  questions: []
anciens_ids: [E-TRANSVERSES-DIALOGUE-CONFIRMATION]
sources:
  - conception/07-ecrans/transverses/04-dialogue-confirmation.yaml:17
  - conception/08-contenu/04-microcopy-grand-public.yaml:252
  - conception/11-reponse-parametrique/03-chorégraphies.yaml:206
images: []
budget_tokens: 2000
derniere_verif: 2026-10-24
---

## Rôle
Patron unique pour toute décision sensible. L’utilisateur répond avant toute autre action. À réserver aux vraies décisions : pas de confirmation inutile.

## Instance au MVP
Une seule : abandonner un parcours en cours (FLX-C7). Titre « Abandonner ce parcours ? », description « Vous quittez le parcours en cours. Vous pourrez toujours le relancer plus tard depuis Mes parcours. », boutons « Abandonner » et « Annuler ». Après confirmation, un message éphémère « Parcours abandonné » apparaît (ECR-TRANSVERSES-MESSAGE-EPHEMERE).

## Composition
- **Fond bloquant** (COMP-BACKDROP) derrière le dialogue.
- **Titre** : libellé de l’action, jamais « Êtes-vous sûr ? ».
- **Description** : ce qui sera fait, ce qui sera perdu, la réversibilité.
- **Issue de confirmation** : libellé qui dit l’action, jamais « OK ».
- **Issue d’annulation** : « Annuler ».
Ensemble : COMP-DIALOGUE-CONFIRMATION. Ouverture : CHO-OUVERTURE-M8 (TOK-CHO-OUVERTURE-M8).

## États
- **ouvert** — le reste de l’app est inactif ; un seul dialogue à la fois.
- **en traitement** — après confirmation, indicateur bref avant fermeture.
- **erreur d’exécution** — « L’action n’a pas pu aboutir. Vous pouvez réessayer. » ; le contexte reste intact.
- **annulé** — fermeture, retour exact à l’écran appelant sans trace.

## Interactions
- Tap sur la confirmation → exécute et ferme. Tap sur « Annuler » → ferme.
- Un tap hors du dialogue ne le ferme pas.

## Libellés de l’écran
Vouvoiement (DEC-14), voir l’instance ci-dessus.

## Hors MVP
- Instances suppression de compte, effacement de l’historique, publication d’un parcours : comptes, profil et parcours personnels hors MVP.
- Confirmations en cascade et variantes destructive ou neutre : non nécessaires avec une seule instance.
