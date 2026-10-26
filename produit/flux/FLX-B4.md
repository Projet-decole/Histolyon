---
id: FLX-B4
type: flux
titre: "Accès à la consultation 3D d’un pin"
statut: mvp
priorite: coeur
jalon: JAL-GEL
liens:
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE, ECR-PIN-CONSULTATION-3D]
  invariants: []
  decisions: [DEC-04, DEC-13]
  questions: [QO-203]
anciens_ids: [B4]
sources:
  - conception/06-flows/02-consultation-pin.yaml:262
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
Tap sur « Voir en 3D » dans la consultation approfondie, pour un pin doté d’un modèle 3D (CAP-D8.1).

## Déroulé
1. Le point d’accès n’existe que si le pin a un modèle 3D validé. Il n’est jamais grisé.
2. Le tap charge le modèle et ouvre ECR-PIN-CONSULTATION-3D en plein écran. Indicateur « Chargement de la reconstitution… ».
3. L’utilisateur tourne, rapproche, éloigne le modèle. Titre, époque recréée et sources restent accessibles.
4. Retour : la consultation approfondie du même pin se rouvre au même endroit.

## Bifurcations
- Modèle indisponible : message éphémère, retour à la consultation (QO-203).
- Appareil trop limité : « Votre appareil peine à afficher cette reconstitution. », la consultation reste utilisable.

## Sorties
Retour à FLX-B2. La bascule AR (FLX-B5 d’origine) est hors MVP.

## Cas particuliers
- Un seul modèle par pin au MVP : pas de sélection préalable.

## Invariants
Aucun.
