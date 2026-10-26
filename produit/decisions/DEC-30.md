---
id: DEC-30
type: decision
titre: "Encarts texte du MVP : à la suite du récit, dans l’ordre des données"
statut: mvp
liens:
  capacites: [CAP-D2.6]
anciens_ids: []
sources:
  - conception/03-fonctionnalites/02-pins-et-contenu.yaml:553
  - content/pins/cour-des-voraces.yaml:78
derniere_verif: 2026-10-24
---

## Décision proposée
Au MVP, les encarts « Le saviez-vous » et citation s’affichent à la suite du récit, avant le pied « Sources », dans l’ordre où ils figurent dans les données du pin. Aucune position fine dans le récit.

## Sources en conflit
CAP-D2.6 d’origine : les contenus sont insérés à des positions choisies par l’éditrice dans le récit. Le contenu réel (`contenu_narratif.post_narratif`) range l’encart « Le saviez-vous » sous une clé post-narrative, sans position.

## Conséquence
Solution la plus prudente : aucun champ nouveau. Une position d’insertion éventuelle est posée en QO-202. La zone post-narrative (CAP-D2.7) reste hors MVP : ces encarts n’en sont pas.
