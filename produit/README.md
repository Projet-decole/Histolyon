---
id: DOC-README
type: document
titre: "Par où commencer"
statut: mvp
anciens_ids: []
sources:
  - brief:lot1
derniere_verif: 2026-10-24
---

# `produit/` — le produit HistoLyon, en lecture courante

`produit/` est la source de vérité du produit (DEC-01). `conception/` reste gelé en archive. Rien ici n’est inventé : chaque unité cite ses sources dans son frontmatter.

## Par où commencer

| Vous êtes… | Lisez d’abord |
|---|---|
| Une personne qui découvre le projet | `VISION.md`, puis `FEUILLE-DE-ROUTE.md` |
| Un agent qui implémente une issue | `dart run tools/ctx.dart pack CAP-<id>` (fiche + écrans + flux + entités + composants en résumé) |
| Une personne qui rédige du contenu | `contenu/GUIDE-REDACTION.md`, puis `GABARIT-PIN.md` ou `GABARIT-PARCOURS.md` |
| Une personne qui fait du design | `design/TOKENS.md`, `design/ICONES.md`, `design/MAQUETTE.md` |
| Le jury ou un relecteur | `decisions/` (DEC-01 à DEC-15, puis `_tri.md` et `_collisions.md`) |
| Quelqu’un qui cherche d’où vient un fait | `_correspondance.csv` (ancien id → nouvel id → source) |

## Organisation

- `capacites/` : les 59 capacités (`statut: mvp` complètes, `s2` en fiche courte).
- `ecrans/`, `composants/`, `flux/` : un fichier par unité du MVP. `ecrans/img/` : captures de référence (DEC-10).
- `donnees/` : entités (`ENT-…`), `INVARIANTS.md`, `CYCLES-DE-VIE.md`.
- `design/`, `contenu/` : règles de design et d’écriture.
- `decisions/` : décisions `DEC-xx`, questions ouvertes `QO-xx`, tri de ce qui n’est pas repris.
- `_modeles/` : gabarits d’unités (hors corpus).

## Outil

```bash
dart run tools/ctx.dart check
```

Autres sous-commandes : `lire <ID|chemin>`, `pack <CAP-…> [--complet]`, `chercher "<texte>"`, `refs <ID>`, `liste [--type …] [--statut mvp|s2]`, `chemin <ID>`. L’ancien usage `dart run tools/ctx.dart <ID>` lit toujours `conception/`.

## Identifiants

Typés et uniques : `CAP-`, `ECR-`, `COMP-`, `FLX-`, `ENT-`, `INV-`, `TOK-`, `ICN-`, `EPQ-`, `MOD-`, `SRF-`, `DEC-`, `QO-`, `JAL-`, plus `DOC-` pour les documents transversaux. L’ancien identifiant figure dans `anciens_ids`.
