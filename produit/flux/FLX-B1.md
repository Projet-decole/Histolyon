---
id: FLX-B1
type: flux
titre: "Aperçu rapide d’un pin"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  ecrans: [ECR-CARTE-PRINCIPALE, ECR-CARTE-APERCU-PIN]
  invariants: [INV-03]
  decisions: [DEC-02, DEC-04]
anciens_ids: [B1]
sources:
  - conception/06-flows/02-consultation-pin.yaml:40
budget_tokens: 500
derniere_verif: 2026-10-24
---

## Déclencheur
Tap sur un pin de la carte (CAP-D2.1). Les entrées par recherche et par pin lié sont hors MVP.

## Déroulé
1. L’aperçu s’ouvre par-dessus la carte, qui garde zoom, position et époque.
2. Il montre titre, catégorie, époque, teaser, image (CAP-D2.4).
3. L’utilisateur lit puis approfondit, tape un autre pin, ou referme.

## Bifurcations
- « Voir le récit » → FLX-B2.
- Tap sur un autre pin → l’aperçu se met à jour, sans fermer ni recentrer la carte.
- Fermeture (geste ou tap hors aperçu) → carte, contexte intact.

## Sorties
FLX-B2 ou retour à la carte.

## Cas particuliers
- Parcours actif et pin hors parcours : signal « Ce lieu n’est pas dans votre parcours », sans blocage.
- Pin retiré ou introuvable : « Ce pin n’est plus disponible. Retour à la carte. », aperçu non ouvert.
- Pin communautaire en vérification : marque visible (prévu, sans effet au MVP).

## Invariants
INV-03
