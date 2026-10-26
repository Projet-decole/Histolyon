---
id: COMP-SELECTEUR-SECTION-PRINCIPALE
type: composant
titre: "Sélecteur de section principale"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  composants: [COMP-LIBELLE-TEXTE, COMP-ICONE]
  ecrans: [ECR-CARTE-PRINCIPALE, ECR-PARCOURS-FICHE-DETAIL]
  decisions: [DEC-05]
anciens_ids: [comp-selecteur-section-principale]
sources:
  - conception/10-composants/04-shell.yaml:82
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Barre de navigation entre les sections de premier niveau. Saut latéral : chaque section garde l’état de sa pile interne. Intention close, non surchargeable. La coquille de l’app compte trois onglets : Carte, Parcours, Profil.

## Variantes et états
- Section active : Carte, Parcours, Profil, mise en relief.
- États : défaut, pressé, focus, désactivé en mode présentation (mode absent de la tranche).

## Composition
- Trois couples `label_Sn` (COMP-LIBELLE-TEXTE) et `icone_Sn` (COMP-ICONE), un par section.

## Tokens
Libellés TOK-TYPO-UI-XS sous l’icône.

## Interactions natives
Tap sur une section inactive : saut latéral. Tap sur la section active : sans effet ou retour en haut de page (non tranché : QO-511). Reste visible quand un parcours est en cours (la surface persistante coexiste).

## Hors MVP
Hors MVP : neutralisé : surface persistante audio (audio). Le Profil est une section de la coquille mais son contenu est hors de la tranche.

## Remarque Figma
Aucun nœud référencé.
