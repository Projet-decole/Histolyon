---
id: CAP-D2.6
type: capacite
titre: "Contenus tissés (récit et encarts texte)"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  ecrans: [ECR-PIN-CONSULTATION-APPROFONDIE]
  flux: [FLX-B2]
  entites: [ENT-PIN, ENT-SOURCE]
  invariants: [INV-04]
  composants: [COMP-SAVIEZ-VOUS, COMP-CITATION]
  decisions: [DEC-03, DEC-14, DEC-30]
  questions: [QO-202]
anciens_ids: [D2.6]
sources:
  - conception/03-fonctionnalites/02-pins-et-contenu.yaml:540
  - content/pins/cour-des-voraces.yaml:80
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
Ponctuer le récit d’encarts courts, sans le casser ni créer de galerie à part. Version MVP (DEC-03) : le récit et deux encarts texte, « Le saviez-vous » et citation.

## Persona (litmus)
La professeure cite une citation en classe : sa source est visible et crédible aux yeux d’un collègue.

## Version MVP / reporté
- MVP : récit, encart « Le saviez-vous », encart citation sourcée.
- Reporté : images d’archives, avant/après, puzzle, frise mini, vidéo d’archive, colorisation, tous hors MVP (DEC-03).

## Règles
R1. Deux types d’encarts : « Le saviez-vous » (anecdote courte) et citation historique (texte, attribution, date, source).
R2. Les encarts s’affichent dans le flux de lecture de la consultation, à la suite du récit et avant le pied « Sources », dans l’ordre des données (DEC-30). Ils sont visuellement distincts du récit.
R3. Une citation affiche toujours son attribution et sa source ; une citation sans source n’est pas affichée (INV-04).
R4. Aucune citation inventée : le texte et le crédit viennent du contenu validé.
R5. Aucun élément latéral, onglet ou galerie ne sert à ouvrir un encart ; tout est dans la progression.
R6. Les encarts sont facultatifs par pin ; sans encart, le récit enchaîne sur le pied « Sources ».
R7. Ton : le récit et les encarts parlent au tutoiement narratif (DEC-14).
R8. Les encarts sont lus comme du texte par les lecteurs d’écran.

## États et cas limites
- **Sans encart** : récit seul.
- **Citation sans source** : encart omis.
- **Encart long** : il reste lisible, sans défilement interne.

## Critères de fin
CF1. Un pin avec un encart « Le saviez-vous » l’affiche, distinct du récit.
CF2. Un pin avec citation affiche texte, attribution, date et source.
CF3. Une citation sans source n’est pas affichée.
CF4. Un pin sans encart se lit normalement jusqu’aux sources.

## Hors MVP
- Archives, avant/après, puzzle, frise mini, vidéo, carrousel : composants neutralisés (DEC-03).
- Insertion de l’encart à une position fine du récit : QO-202.

## Questions ouvertes
QO-202 — le format de données d’une citation et d’une position d’insertion n’existe pas encore (seul « Le saviez-vous » est exemplifié) : bloque l’affichage fin.
