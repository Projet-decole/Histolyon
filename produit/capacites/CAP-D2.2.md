---
id: CAP-D2.2
type: capacite
titre: "Catégorisation des pins"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  ecrans: [ECR-CARTE-APERCU-PIN, ECR-PIN-CONSULTATION-APPROFONDIE]
  flux: []
  entites: [ENT-PIN, ENT-CATEGORIE]
  invariants: []
  composants: [COMP-CHIP-CATEGORIE, COMP-TAG-CATEGORIE]
  decisions: [DEC-04, DEC-11, DEC-33]
  questions: []
anciens_ids: [D2.2]
sources:
  - conception/03-fonctionnalites/02-pins-et-contenu.yaml:156
  - conception/09-cartographie/02-pins.yaml:21
  - content/categories/classique.yaml:1
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
Donner à chaque pin un repère de type immédiat : une catégorie unique, visible par une icône. Version minimale : classement et affichage, sans filtre.

## Persona (litmus)
Le père lyonnais reconnaît à l’œil qu’un pin est une « Anecdote » après quelques découvertes.

## Version MVP / reporté
- MVP : 11 catégories figées, une par pin, icône sur le pin, chip « icône + libellé » dans l’aperçu et la consultation.
- Reporté : filtrage par catégorie (recherche, CAP-D1.4), saisie par l’équipe (back-office). Voir DEC-33.

## Règles
R1. Il existe 11 catégories : Classique, Anecdote, Musée/Institution, Personne, Événement, Lieu disparu, Vie quotidienne, Architecture, Nature/Géographie, Patrimoine vivant & Traditions, Gastronomie. Elles correspondent aux fichiers de `content/categories/`.
R2. Un pin a exactement une catégorie. Pas de pin sans catégorie, pas de catégorie « Autre », pas de hiérarchie, pas de catégorie choisie par l’utilisateur.
R3. Règle de tri pour l’équipe : un objet encore vivant ou expérimentable en 2026 va dans « Patrimoine vivant & Traditions » ou « Gastronomie » ; un objet du passé va dans la catégorie historique correspondante.
R4. La distinction passe par l’icône de la catégorie (`ICN-CAT-ARCHITECTURE`, par exemple), identique sur le pin de la carte (CAP-D2.1) et dans le chip de l’aperçu (CAP-D2.4) et de la consultation (CAP-D2.5). La couleur n’est pas utilisée pour la catégorie.
R5. Le libellé de catégorie est toujours accessible en texte (lecteur d’écran, chip).
R6. Le contenu embarqué (DEC-04) ne contient que des pins déjà classés ; un pin sans catégorie valide est rejeté à la génération de l’instantané.

## États et cas limites
- **Catégorie inconnue** dans les données : pin écarté et signalé dans le journal, jamais affiché sans icône.

## Critères de fin
CF1. Les 11 catégories existent avec libellé et icône.
CF2. Chaque pin affiché montre l’icône de sa catégorie sur la carte, l’aperçu et la consultation.
CF3. Deux catégories sont distinguables sans la couleur.
CF4. Aucun pin de l’instantané n’a zéro ou deux catégories.

## Hors MVP
- Filtre par catégorie : CAP-D1.4 (voir `_tri-D2`).
- Ajout d’une 12e catégorie et saisie par l’éditeur : back-office S2.

## Questions ouvertes
Aucune.
