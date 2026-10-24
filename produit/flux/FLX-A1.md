---
id: FLX-A1
type: flux
titre: "Premier lancement"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  ecrans: [ECR-CARTE-PRINCIPALE]
  invariants: [INV-01, INV-06]
  decisions: [DEC-04, DEC-05, DEC-06]
anciens_ids: [A1]
sources:
  - conception/06-flows/01-decouverte.yaml:39
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
Première ouverture de l’app après installation.

## Déroulé
1. L’app crée un profil local anonyme (sans identité civile).
2. Atterrissage direct sur ECR-CARTE-PRINCIPALE, centrée sur Bellecour : aucun écran intermédiaire, aucune slide d’onboarding, aucune permission, aucun compte.
3. La personne explore tout de suite (déplacement, zoom, tap sur un pin, slider). Rien n’est requis pour avancer.
4. L’indication « Glissez pour traverser les époques. » est armée pour le premier passage sur le slider ; elle disparaît à la première interaction.

## Bifurcations
- Tap sur un pin → ECR-CARTE-APERCU-PIN.
- Glissement du slider → FLX-A3.
- Tap sur Parcours ou Profil → l’autre section.

## Sorties
Carte prête à l’exploration libre.

## Cas particuliers
- Réinstallation : considérée comme un premier lancement (le profil local a disparu avec l’app).
- Sans réseau : sans effet, tuiles et contenu embarqués (DEC-04).

## Invariants
INV-01, INV-06.
