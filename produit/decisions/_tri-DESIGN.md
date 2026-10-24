---
id: DOC-TRI-DESIGN
type: document
titre: "Tri du groupe DESIGN : ce qui est repris, ce qui ne l’est pas"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

# Tri DESIGN

Format : bloc source, puis destination ou raison du rejet. Les règles sont celles des fichiers de `conception/` ; les numéros de ligne sont ceux du bloc.

## 12-tokens (TOKENS.md)
| source | destination ou raison |
|---|---|
| 01-couleurs:37 règle d’or (pas de noir/blanc pur) | reprise dans TOKENS.md/R2 |
| 01-couleurs:49 à 339, 18 couleurs | reprises, une section chacune (rôle, usage ; valeurs non recopiées, DEC-12) |
| 01-couleurs:49 note de double usage de la couleur primaire | reprise dans TOK-COLOR-PRIMARY |
| 01-couleurs:169 usage textuel de l’or interdit | reprise dans TOK-COLOR-OR-ACCENT |
| 01-couleurs, ratios de contraste déclarés (4,06 ; 3,23 ; 2,32…) | rejetés : valeurs chiffrées, la mesure se refait sur le package ; seules les conséquences (grand texte, décoratif) sont gardées |
| 01-couleurs, tests de daltonisme et paires critiques à valider | rejetés : validation visuelle non faite ; pas une règle de produit |
| 02-typographies:38 à 205, 3 fontes et 12 styles | repris (rôle, usage) ; tailles, graisses, interlignes renvoyés au package |
| 02-typographies, note sur les polices non latines et i18n | rejetée : app en français seulement (DEC-15) |
| 03-espace-et-forme:34 à 164, 7 espacements, 5 rayons, 3 ombres | repris ; valeurs renvoyées au package |
| 03-espace-et-forme:181 bordures sans token | reprise dans TOKENS.md/R8 |
| 04-opacites-constantes:38 à 106, 4 opacités | reprises ; contradiction 0,4 / 0,5 : DEC-81 |
| 04-opacites-constantes, bascule de couleur du désactivé | reprise dans TOKENS.md/R9 |
| 00-index, `persona_check`, `perimetre`, articulation avec les autres chantiers | rejetés : méta de conception |
| 15-maquette:113 règles à respecter côté code | reprises dans TOKENS.md/R1 à R3 |

## 13-icones (ICONES.md)
| source | destination ou raison |
|---|---|
| 02-icones-categories:46 à 277, 11 icônes | reprises (nom Lucide, usage) ; deux personnalisées (DEC-11) |
| 02-icones-categories, versions 14 px dédiées | reprises dans R2 ; production hors périmètre produit |
| 03-icones-ui-fonctionnelles, 15 icônes d’interface | reprises, usage vérifié dans la source |
| 03-icones-ui-fonctionnelles, les ~20 autres (audio, favori, partage, signalement, recherche, filtre, couche, caméra, notification, anonymat, provenance, vérification, modes, langue, visibilité, création) | rejetées pour le MVP : fonctions reportées ; nom Lucide gardé dans la section « Hors MVP » |
| 04-icones-back-office, 10 icônes | rejetées : l’administration n’est pas au MVP (DEC-04) ; noms Lucide gardés |
| 01-charte-graphique (règles de style, tailles, couleurs) | reprise dans ICONES.md/R1 à R3 |
| assets/README et MANIFEST (59 / 60 SVG, « dessins originaux ») | rejetés : contradiction avec la maquette (DEC-80) |

## 11-reponse-parametrique (MOUVEMENT.md)
| source | destination ou raison |
|---|---|
| 01-durees-et-courbes:43 à 235, 6 durées, 6 courbes | repris (valeurs de la source) |
| 01-durees-et-courbes, mouvement réduit | repris dans MOUVEMENT.md/R4, R5 |
| 02-haptique, 3 classes | reprises (sections d’haptique) ; tableau détaillé des événements rejeté : redondant avec les chorégraphies |
| 03-chorégraphies, M2, M3, M6, M8, M9, P2, P3, calage, pilotage, lancement, abandon, fin, saut latéral, retour | reprises |
| 03-chorégraphies, M4 (entrée, sortie, sommeil, réveil), M7 (ouverture, rejet), P1 (apparition, disparition) | rejetées : mode présentation, proximité et audio sont hors MVP (QO-101, DEC-05) |
| 04-mappings, slider vers axes, contexte de parcours, déjà visité, réseau | repris |
| 04-mappings, mode M4 vers persistantes | rejeté : mode présentation hors MVP |
| 05-comportements-temporels, auto-dismiss du message, échantillonnages du slider et de la carte | repris |
| 05-comportements-temporels, auto-dismiss de l’alerte et de l’onboarding, délais de recherche et de formulaire, défilement, appui long, double tap, délais réseau | rejetés : aucune capacité MVP ne les emploie (DEC-04, DEC-05) |
| 00-index et blocs `persona_check`, `articulation` | rejetés : méta de conception |

## 09-cartographie (CARTE.md)
| source | destination ou raison |
|---|---|
| 01-fond-et-epoques:41 à 133, cinq axes et ancres | repris (CARTE.md/R5 à R9 et sections EPQ) |
| 01-fond-et-epoques:182 à 203, invariants de lisibilité L1 à L5 | L1 à L3 repris dans CARTE.md/R10 ; L4 (forme empilée) et L5 (contour de vérification) rejetés : multi-époques (DEC-02) et communauté (DEC-04) |
| 01-fond-et-epoques, couches d’archives | rejetées : couches avancées hors MVP |
| 02-pins:198, 206 priorités PR1 et PR2 | reprises dans TOK-MAP-CONTEXTE-PARCOURS-VERS-PIN |
| 03-parcours-traces, provenance, avancée, étape courante, numérotation, un seul tracé | repris dans CARTE.md/R11 à R14 |
| 03-parcours-traces, modes terrain et canapé, déviation | rejetés : un seul mode pas à pas (DEC-05) |
| 03-parcours-traces, tracé communautaire en revue | rejeté : communauté hors MVP |
| 04-densite-zoom:133 à 152, règles de regroupement R1 à R4 | reprises (section « Regroupement ») |
| 04-densite-zoom, héritage forme empilée et contour de vérification | rejeté : multi-époques et communauté |
| 00-index:387 à 432, décisions D1 à D10 | reprises sur le fond (icône pour la catégorie, couleur pour la provenance, pas d’accent par époque, axes continus) ; le badge « Officiel » abandonné n’est pas repris |
| fond de carte, attribution, emprise | repris de DEC-06, DEC-21 et du document d’architecture (R1 à R4) |

## 05-architecture-info (SURFACES.md)
| source | destination ou raison |
|---|---|
| modes M1 à M9, sections S1 à S3, persistantes P1 à P3 | repris, avec la part MVP indiquée ; M4, M7, P1 en une ligne « hors MVP » |
| règles de navigation N1 à N7 | reprises dans SURFACES.md/R1 à R8 (N4, mode présentation, écartée) |
| règles de coexistence C1 à C6 | C3, C5, C6 reprises ; C1 (audio) réduite, C2 (mode présentation) et C4 (alerte) écartées |
| entrées externes E1 à E3 | E1 repris (R9) ; lien universel et notification écartés |
| `persona_check`, `reformulations_imposees`, `articulation` | le vocabulaire imposé est gardé en une ligne ; le reste rejeté |

## 14/07 marque et 15-maquette (MARQUE.md, MAQUETTE.md)
| source | destination ou raison |
|---|---|
| 07-marque, décisions D-MARQUE-1 à 5, logo, icône d’application | repris (R1 à R7) |
| 07-marque, favicon, signature image partageable, signature code visuel | rejetés : surfaces de partage hors MVP |
| 15-maquette, accès, pages, écrans, conventions | repris dans MAQUETTE.md |
| 15-maquette, index des composants (118 nœuds) | rejeté : sera repris par les fiches de composants |
| 15-maquette, écrans du back-office, page jury | rejetés |
