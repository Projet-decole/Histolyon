---
id: COMP-LIEN-TEXTE
type: composant
titre: "Lien texte"
statut: mvp
priorite: important
jalon: JAL-FU3
liens:
  composants: [COMP-LIBELLE-TEXTE, COMP-ICONE]
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  decisions: []
anciens_ids: [comp-lien-texte]
sources:
  - conception/10-composants/01-atomes.yaml:848
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Navigation textuelle vers une cible référencée (par exemple une source documentaire d’un pin). Intention ouverte : le parent câble la cible. Un lien externe ouvre le navigateur du téléphone.

## Variantes et états
- Portée : interne, externe. Style : dans le texte, isolé.
- États : défaut, pressé, visité, désactivé, focus clavier.

## Composition
- `label` (1) : COMP-LIBELLE-TEXTE.
- `icone_externe` (0..1) : COMP-ICONE, si la cible sort de l’app.

## Tokens
Aucun token propre documenté ; couleur d’action TOK-COLOR-PRIMARY probable (QO-501).

## Interactions natives
Tap : navigation. Le contenu d’un lien externe dépend du réseau : hors-ligne, le bandeau d’information s’affiche (COMP-BANDEAU-INFORMATION-OFFLINE).

## Hors MVP
Hors MVP : neutralisé : comp-formulaire-creation-compte, comp-formulaire-connexion-compte (comptes écartés).

## Remarque Figma
Aucun nœud référencé.
