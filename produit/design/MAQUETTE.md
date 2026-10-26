---
id: DOC-DESIGN-MAQUETTE
type: document
titre: "Maquette Figma : accès, pages, nœuds et conventions"
statut: mvp
liens:
  decisions: [DEC-10, DEC-12]
  questions: [QO-806, QO-810]
anciens_ids: []
sources:
  - conception/15-maquette.md:15
  - conception/15-maquette.md:29
  - conception/15-maquette.md:177
  - conception/15-maquette.md:209
  - conception/15-maquette.md:241
  - conception/15-maquette.md:247
derniere_verif: 2026-10-24
---

# Maquette Figma

Référence visuelle du produit. Les valeurs de tokens sont dans le package (DEC-12), pas dans Figma ni ici. Les captures de référence sont versionnées dans le dépôt (DEC-10).

## Accès
- Fichier « HistoLyon », clé `zh0M2STvsYURlBgJNyCokB`, adresse de base `https://www.figma.com/design/zh0M2STvsYURlBgJNyCokB/Histo-Lyon`. Pour ouvrir un nœud, ajouter `?node-id=` suivi de l’identifiant avec un tiret (`904:8185` devient `904-8185`).
- Plan Starter : pas de liaison automatique composant Figma vers composant code. Le rapprochement est manuel.
- Mode de couleur unique, clair.
- Outils d’accès : lecture de la structure, du contexte de conception et de captures. Le nœud donne la spécification, ne vous fiez pas à une description figée.

## Pages utiles
| page | nœud | contenu |
|---|---|---|
| 01 · Fondations | `347:2` | variables et styles (tokens) |
| 02 · Charte | `354:2` | palette annotée, contrastes, typographies, bestiaire d’usage |
| 03 · Icônes | `368:2` | icônes par famille (ICONES.md) |
| 04 · Marque | `375:2` | logo, icône d’application (MARQUE.md) |
| 05 · Composants | `396:2` | inventaire (nœud `493:801`) et tous les composants |
| 06 · Écrans | `678:2` | 41 écrans mobiles de 390 × 844 |
| 07 · Calibrage époques | frames `904:8xxx` à `904:9xxx` | écran de carte aux dix ancres (seul `904:8185`, Antiquité de -43 à 476, est confirmé) |

Les pages 08 (administration), 12 (présentation du jury) et la page hors-app (non réalisée) ne concernent pas le MVP.

## Écrans de la page 06 utiles au MVP
| écran du corpus | nœud |
|---|---|
| ECR-CARTE-PRINCIPALE | nominal `678:13`, chargement initial `679:4891`, hors ligne avec cache `679:287`, parcours en cours `679:472` |
| ECR-CARTE-APERCU-PIN | `689:862` |
| ECR-PIN-CONSULTATION-APPROFONDIE | `693:1928` |
| ECR-PIN-CONSULTATION-3D | `807:4975` |
| catalogue des parcours (section Parcours) | `691:1765` |
| ECR-PARCOURS-FICHE-DETAIL | `694:2058` |
| surface de lancement d’un parcours | `694:6044` |
| surface de saut d’étape | `783:5658` |
| ECR-PARCOURS-FIN-CELEBRATION | `696:2488` |
| écran principal du profil | avec compte `793:3601`, sans compte `795:6352` |
| surfaces transverses | message éphémère `816:9026`, dialogue de confirmation `816:9181`, progression persistante (audio et parcours) `816:8574` |

Deux frames existent pour un parcours en cours (terrain `695:2205`, canapé `781:3228`) alors que le MVP n’a qu’un mode (DEC-05) : voir QO-810. Les écrans de la page 06 ne sont pas tous intégrés au corpus ; ce tableau ne garde que ce qui touche le MVP.

## Conventions
R1. **Le nom Figma est l’identifiant de conception, sans traduction.** Dans le corpus, les noms de composants et d’écrans s’écrivent en majuscules avec le préfixe de leur type (les écrans perdent leur préfixe `E-`).
R2. Un composant imbriqué est une vraie instance, jamais un visuel recréé. Les icônes s’échangent par instance-swap, pas par variante.
R3. Les états pressé et sélectionné sont câblés par réaction de prototype, sauf quand l'état change la structure.
R4. Chaque variante contient tous les calques nommés, même masqués (animation propre entre écrans).
R5. L’état de chargement est un squelette qui miroite, jamais un cercle de chargement seul (sauf micro-attente).
R6. Le pin est le composant le plus complexe : cinq axes de variantes (provenance, contexte de parcours, multi-époques, vérification, déjà visité), 60 variantes matérialisées. Le slider d’époque a dix variantes, une par ancre, de largeur fixe 358 px dans un écran de 390 px.
R7. La carte, la vue 3D et la caméra ne sont que des états représentatifs : le rendu réel est à implémenter dans l’app.
R8. Les quatre gabarits de mise en page d’écran ont été supprimés ; la structure d’un écran se lit sur l’écran lui-même.
R9. **Nommage des états d’écran.** Cible : `ECR-<NOM>--<etat>` (double tiret, jamais de barre oblique). Dans les faits, la maquette utilise souvent un nom suivi d’un descriptif après un point médian (par exemple « nominal_charge »). Vérifier au cas par cas.

## Images de référence
Captures versionnées dans `produit/ecrans/img/`, nommées `ECR-<NOM>--<etat>@2x.png` (DEC-10). Chaque fiche d’écran les liste dans son champ `images` avec l’état, le fichier et le nœud Figma.

## Frames manquantes
Images importées le 24/10/2026 depuis l’export Figma (PNG 780 × 1688, soit 2× 390 × 844) : 13 frames dans `ecrans/img/`, liées dans le champ `images` de chaque fiche d’écran. Les node ids ne sont pas dans l’export : champ `node_figma` à renseigner.

Frames absentes de l’export pour les écrans du MVP :
- ECR-TRANSVERSES-BANDEAU-OFFLINE : pas de frame propre ; le bandeau se voit dans la frame `offline_avec_cache` de ECR-CARTE-PRINCIPALE.
- ECR-PARCOURS-EN-COURS-TERRAIN : une seule frame (état nominal) ; l’état « étape sautée » et la fin partielle n’ont pas de frame.
- ECR-PIN-CONSULTATION-APPROFONDIE, ECR-PIN-CONSULTATION-3D, ECR-PARCOURS-FICHE-DETAIL, ECR-PARCOURS-FIN-CELEBRATION, ECR-CARTE-APERCU-PIN : état nominal seulement (pas de frame chargement ni erreur).
- ECR-TRANSVERSES-DIALOGUE-CONFIRMATION : instance « abandon de parcours » ; ECR-TRANSVERSES-MESSAGE-EPHEMERE : seule frame « lien copié » (instance de partage, hors MVP ; le message « Parcours abandonné » du MVP n’a pas de frame) ; ECR-TRANSVERSES-PARCOURS-PERSISTANT : frame audio + parcours (l’audio est hors MVP).
- Écrans hors MVP exportés mais non copiés : recherche, filtres, alerte de proximité, communauté, profil, partage, éditeur, canapé, lancement, saut d’étape, AR, mode présentation.

## Ce qui n’est pas confirmé
Les interactions câblées dans le prototype n’ont pas d’inventaire exhaustif : à tester dans Figma avant de supposer un enchaînement. La liste nominative des dix ancres de la page 07 n’est confirmée que pour la première.
