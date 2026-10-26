---
id: FLX-B2
type: flux
titre: "Consultation approfondie d’un pin"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  ecrans: [ECR-CARTE-APERCU-PIN, ECR-PIN-CONSULTATION-APPROFONDIE]
  invariants: [INV-03, INV-04]
  decisions: [DEC-03, DEC-04, DEC-05, DEC-34]
anciens_ids: [B2]
sources:
  - conception/06-flows/02-consultation-pin.yaml:104
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
« Voir le récit » depuis l’aperçu (FLX-B1), ou « Étape suivante » dans un parcours actif (CAP-D3.5). Lien universel et alerte de proximité : hors MVP (DEC-05).

## Déroulé
1. La consultation (ECR-PIN-CONSULTATION-APPROFONDIE) remplace la carte à l’écran.
2. Le contenu se lit en une progression : en-tête, récit, encarts, accès 3D si applicable, sources.
3. L’utilisateur fait défiler, puis revient ou continue.

## Bifurcations
- « Voir en 3D » → FLX-B4.
- « Étape suivante » (parcours actif) → étape suivante.
- Retour → aperçu s’il en vient, carte sinon, étape du parcours si elle en vient.

## Sorties
Retour à la surface d’origine ; FLX-B4.

## Cas particuliers
- Pin retiré : message « Ce pin a été retiré. Retour à la carte. », retour gracieux.
- Erreur de chargement : « Erreur de chargement », bouton « Réessayer ».
- App mise en arrière-plan : l’état et la position de lecture sont conservés.
- Les ouvertures en mode présentation, audio, favori, partage, commentaires, signalement et zone post-narrative sont hors MVP.

## Invariants
INV-03, INV-04
