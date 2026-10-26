---
id: COMP-PIN
type: composant
titre: "Pin"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  composants: [COMP-ICONE, COMP-BADGE-NOMBRE]
  ecrans: [ECR-CARTE-PRINCIPALE, ECR-CARTE-APERCU-PIN]
  decisions: [DEC-02, DEC-04, DEC-12]
  capacites: []
anciens_ids: [comp-pin]
sources:
  - conception/10-composants/03-fonctionnels.yaml:50
  - conception/10-composants/03-fonctionnels.yaml:676
budget_tokens: 800
derniere_verif: 2026-10-24
---

## Rôle
Marqueur d’un pin sur la carte. Sa couleur dit la provenance, sa forme dit l’empilement d’époques, son contour dit la vérification, son icône dit la catégorie. Intention ouverte : un tap émet « pin sélectionné », la carte ouvre l’aperçu rapide.

## Variantes et états
Cinq dimensions orthogonales :
- Provenance : éditorial, communautaire. La communauté est hors MVP (CAP-D9.2).
- Multi-époques : simple, empilé. Au MVP : simple seul (DEC-02).
- Vérification : absente, en cours. Règle R1 : un pin éditorial n’est jamais « en cours ». Au MVP : absente.
- Contexte de parcours : normal, étape courante, étape complétée, étape à venir, hors parcours.
- Déjà visité : non, oui.
Règles de cumul : étape courante et déjà visité, la mise en relief prime sur l’atténuation. Hors parcours et déjà visité : les deux modulations se cumulent. Un pin sans coordonnées reste invisible sur la carte.
États d’interaction : défaut, pressé, sélectionné, focus, désactivé (rare). Défaut, pressé, sélectionné au tap, retour au défaut sur tap ailleurs.

## Composition
- `icone_categorie` (1) : COMP-ICONE ; repli sur icône générique.
- `badge_multi_epoques` (0..1) : COMP-BADGE-NOMBRE, absent au MVP.

## Tokens
TOK-COLOR-PIN-EDITORIAL, TOK-COLOR-PIN-COMMUNAUTAIRE, TOK-COLOR-CONTOUR-VERIFICATION, TOK-SHADOW-MD, TOK-MAP-CONTEXTE-PARCOURS-VERS-PIN, TOK-MAP-DEJA-VISITE-VERS-PIN.

## Interactions natives
Visibilité selon l’époque sélectionnée (sur « Aujourd’hui », les pins de toutes les époques sont cumulés). Le contexte de parcours suit le parcours en cours. Le long appui de la source n’est pas retenu.

## Remarque Figma
Aucun nœud référencé.
