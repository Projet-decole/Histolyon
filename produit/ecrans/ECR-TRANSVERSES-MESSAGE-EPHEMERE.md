---
id: ECR-TRANSVERSES-MESSAGE-EPHEMERE
type: ecran
titre: "Message éphémère"
statut: mvp
priorite: secondaire
jalon: JAL-GEL
liens:
  capacites: [CAP-D8.2]
  flux: []
  composants: [COMP-MESSAGE-EPHEMERE]
  entites: []
  decisions: [DEC-14]
  questions: []
anciens_ids: [E-TRANSVERSES-MESSAGE-EPHEMERE]
sources:
  - conception/07-ecrans/transverses/05-message-ephemere.yaml:17
  - conception/08-contenu/04-microcopy-grand-public.yaml:278
  - conception/11-reponse-parametrique/03-chorégraphies.yaml:228
  - conception/11-reponse-parametrique/05-comportements-temporels-purs.yaml:37
images:
  - {etat: lien_copie, fichier: img/ECR-TRANSVERSES-MESSAGE-EPHEMERE--lien_copie@2x.png, node_figma: ""}
budget_tokens: 2000
derniere_verif: 2026-10-24
---

## Rôle
Retour bref, lisible et non bloquant : confirmer une action ou signaler un événement. Une idée par message, aucune action obligatoire, jamais promotionnel.

## Instances au MVP
- « Parcours abandonné » après l’abandon d’un parcours (flux d’origine C7, non repris ; confirmé par le dialogue).
- « Connexion retrouvée. » à la reconnexion (ECR-TRANSVERSES-BANDEAU-OFFLINE).
- Vue 3D : erreur ou indisponibilité signalée sur place (ECR-PIN-CONSULTATION-3D), pas par ce message.

## Composition
- **Zone de message** (COMP-MESSAGE-EPHEMERE) : une phrase courte, au-dessus de l’écran courant.
- **Action secondaire** : absente au MVP (elle n’existe que pour annuler une action réversible, hors MVP).

## États
- **visible** — l’écran reste utilisable. Apparition : TOK-CHO-OUVERTURE-M9.
- **remplacé** — un nouveau message remplace l’actuel (file simple).
- **disparu par délai** — fermeture automatique après TOK-TMP-AUTO-DISMISS-M9, mise en pause en arrière-plan.
- **en retrait** — pendant la consultation 3D, message différé tant que l’écran est plein écran (DEC-51).

## Interactions
- Aucune obligatoire. Pas de vibration à l’apparition.

## Libellés de l’écran
Vouvoiement (DEC-14). Phrases nominales, point final, sans exclamation : « Connexion retrouvée. » ; « Parcours abandonné ».

## Hors MVP
- Instances « Lien copié », « Favori ajouté ou retiré » avec « Annuler », « Modifications enregistrées », « Brouillon enregistré », « Envoyé pour modération », éloignement du tracé : partage, favoris, profil, communauté et proximité hors MVP.
- Balayage pour fermer : non retenu.
