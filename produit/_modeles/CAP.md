---
id: CAP-D0.0                 # CAP-<ancien id de domaine> ; ex. CAP-D1.2
type: capacite
titre: "Titre court de la capacité"
statut: mvp                  # mvp | s2 | hors-perimetre
priorite: coeur              # coeur | important | secondaire
jalon: JAL-FU2               # jalon cible (voir FEUILLE-DE-ROUTE.md)
liens:
  ecrans: []                 # ECR-…
  flux: []                   # FLX-…
  entites: []                # ENT-…
  invariants: []             # INV-…
  composants: []             # COMP-… (hors ceux déjà cités par les écrans)
  decisions: []              # DEC-…
  questions: []              # QO-… (seulement si elle bloque encore)
anciens_ids: [D0.0]
sources:
  - conception/03-fonctionnalites/XX.yaml:123
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
Trois lignes au plus : ce que la capacité permet et pourquoi.

## Persona (litmus)
Une ligne : le test qui dit si la capacité réussit pour la personne concernée.

## Version MVP / reporté
- MVP : …
- Reporté : … (DEC-xx)

## Règles
R1. Une règle testable par ligne, phrases courtes.
R2. …

## États et cas limites
- **Nom de l’état** : quand, ce qui se passe.

## Critères de fin
CF1. Critère vérifiable (qui, quoi, résultat observable).
CF2. …

## Hors MVP
- Ce qui n’est pas fait ici, avec le renvoi (CAP-…, DEC-…).

## Questions ouvertes
Aucune. (ou : QO-xx — pourquoi elle bloque)
