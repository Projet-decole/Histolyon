---
id: CAP-D2.1
type: capacite
titre: "Pin sur la carte"
statut: mvp
priorite: coeur
jalon: JAL-FU3
liens:
  ecrans: [ECR-CARTE-PRINCIPALE, ECR-CARTE-APERCU-PIN]
  flux: [FLX-B1]
  entites: [ENT-PIN, ENT-CATEGORIE, ENT-EPOQUE]
  invariants: [INV-03, INV-08, INV-09]
  composants: [COMP-PIN, COMP-CLUSTER-DENSITE]
  decisions: [DEC-02, DEC-04, DEC-05, DEC-31]
  questions: [QO-201]
anciens_ids: [D2.1]
sources:
  - conception/03-fonctionnalites/02-pins-et-contenu.yaml:64
  - conception/09-cartographie/02-pins.yaml:31
  - conception/09-cartographie/04-densite-zoom.yaml:63
budget_tokens: 2500
derniere_verif: 2026-10-24
---

## Intention
Marquer sur la carte les lieux qui ont une histoire à raconter, sans saturer l’écran. Le pin dit d’un coup d’œil de quel type de lieu il s’agit et d’où vient son contenu. Il déclenche l’aperçu (CAP-D2.4).

## Persona (litmus)
Le père lyonnais distingue d’un coup d’œil un pin « Anecdote » d’un pin « Architecture », même dans une zone dense.

## Version MVP / reporté
- MVP : pins éditoriaux issus de l’instantané embarqué (DEC-04), un pin = une époque (DEC-02), catégorie par icône, provenance par couleur, regroupement, contexte de parcours.
- Reporté : marque « multi-époques » (CAP-D2.3, DEC-02), pins communautaires (S2, DEC-04), mise en avant « à proximité » (DEC-05).

## Règles
R1. Un pin est rattaché à un lieu, à une catégorie (CAP-D2.2) et à UNE époque (DEC-02). Un pin sans catégorie ou sans époque n’est pas affiché.
R2. Un pin sans coordonnées existe mais ne s’affiche pas sur la carte (INV-09).
R3. La catégorie se lit par l’icône placée dans le pin, jamais par la seule couleur.
R4. La couleur du pin porte la provenance : `TOK-COLOR-PIN-EDITORIAL` pour un pin éditorial, `TOK-COLOR-PIN-COMMUNAUTAIRE` pour un pin communautaire. Au MVP tous les pins sont éditoriaux.
R5. Un pin communautaire en cours de vérification (INV-03) porte en plus le contour `TOK-COLOR-CONTOUR-VERIFICATION`. Règle prévue, sans effet au MVP.
R6. Le slider d’époques (CAP-D1.2) détermine les pins visibles : seuls les pins de l’époque sélectionnée s’affichent. La règle de la vue « Aujourd’hui » (vue cumulée) appartient à CAP-D1.2.
R7. Contexte de parcours actif : le pin du parcours est renforcé, l’étape courante est nettement mise en relief, un pin hors parcours est atténué mais reste visible et tapable. Sans parcours actif, tous les pins sont à l’état normal.
R8. Seule l’étape courante peut être animée ; aucun autre pin n’a d’animation permanente.
R9. Au-dessous d’un niveau de zoom, les pins proches se regroupent en cluster (COMP-CLUSTER-DENSITE). L’étape courante d’un parcours actif n’est jamais absorbée par un cluster.
R10. Un tap sur un pin ouvre l’aperçu (CAP-D2.4). Un tap sur un cluster zoome sur la zone jusqu’à voir les pins individuels.
R11. Un pin ne masque pas la lecture de la carte : taille et nombre restent lisibles.
R12. Chaque pin a un nom accessible « catégorie, nom du lieu ».

## États et cas limites
- **Normal** : aucun parcours actif, rendu de base.
- **Du parcours / étape courante / hors parcours** : voir R7.
- **Époque vide** : aucun pin à l’époque sélectionnée ; le message est porté par ECR-CARTE-PRINCIPALE.
- **Zone dense** : clusters actifs ; le seuil chiffré reste à fixer (QO-201).

## Critères de fin
CF1. Les pins affichent l’icône de leur catégorie et la couleur éditoriale.
CF2. Changer d’époque au slider change l’ensemble des pins affichés.
CF3. Au zoom large, les pins d’une zone dense sont regroupés ; un tap sur le cluster rapproche la vue.
CF4. Un tap sur un pin ouvre son aperçu (FLX-B1).
CF5. Avec un parcours actif, pin du parcours, étape courante et pin hors parcours sont distinguables ; l’étape courante n’est jamais dans un cluster.
CF6. Un pin sans coordonnées n’apparaît pas sur la carte.
CF7. Le nom accessible de chaque pin contient catégorie et lieu.

## Hors MVP
- Marque « multi-époques » (forme empilée) : CAP-D2.3.
- Pin communautaire visible (couleur, contour) : couleurs citées, aucune donnée au MVP.
- Pin « déjà visité » et « à proximité du tracé » : non repris (voir `_tri-D2`).

## Questions ouvertes
QO-201 — seuil de zoom du regroupement : bloque l’implémentation de R9.
