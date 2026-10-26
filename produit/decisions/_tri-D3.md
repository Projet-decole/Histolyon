---
id: DOC-TRI-D3
type: document
titre: "Tri des règles de D3 (parcours)"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

# Tri D3 : règles de la source vers les unités

Source : `conception/03-fonctionnalites/03-parcours.yaml`. Les lignes citées sont celles de chaque règle. « Reprise » renvoie à `<unité>/R<n>` (règle) ou `CF<n>` (critère de fin).

## D3.3 Fiche parcours (règles)
| Ligne | Règle (résumé) | Sort |
|---|---|---|
| 255 | Surface dédiée, pas d’aperçu superposé | reprise dans CAP-D3.3/R1 |
| 256 | Mise en condition visuelle, titre, auteur ou marque officielle | reprise dans CAP-D3.3/R3 (marque « Officiel » seule : un seul parcours éditorial) |
| 257 | Métadonnées durée, distance, étapes, époques, densité | reprise dans CAP-D3.3/R4 |
| 258 | Teaser narratif obligatoire | reprise dans CAP-D3.3/R3 |
| 259 | Aperçu de l’itinéraire avec étapes numérotées | rejetée : doublon avec la liste des étapes numérotées (R5) et le tracé de la carte au lancement (CAP-D3.4/R5) ; l’agrandissement n’existe pas dans l’écran d’origine |
| 260 | Liste des étapes, activation vers l’aperçu du pin | reprise dans CAP-D3.3/R5, R6 |
| 261 | Libellé de démarrage en 3 variantes selon la proximité | rejetée : géolocalisation écartée (DEC-05, DEC-06) ; remplacée par un libellé selon l’état (R8) |
| 262 | Partage et sauvegarde dans l’espace personnel | rejetée : S2 (partage, favoris, comptes ; DEC-04) |

## D3.3 (definition_of_done)
| Ligne | Critère | Sort |
|---|---|---|
| 285 | Blocs 1 à 7 affichés | reprise dans CAP-D3.3/CF2, CF3 ; bloc 6 (variantes) : DEC-05 ; bloc 7 (auteur, complétions, partage) : rejeté S2 |
| 286 | Libellé de démarrage adapté à la proximité | rejetée : DEC-05 ; remplacé par CAP-D3.3/CF4 |
| 287 | Étapes consultables en aperçu pin | reprise dans CAP-D3.3/CF3 |
| 288 | Aperçu d’itinéraire agrandissable | rejetée : voir ligne 259 |
| 289 | Partage et sauvegarde fonctionnent | rejetée : S2 (DEC-04) |

## D3.4 Lancement (règles)
| Ligne | Règle | Sort |
|---|---|---|
| 354 | Bascule automatique sur la carte | reprise dans CAP-D3.4/R2 |
| 355 | Recadrage sur l’itinéraire puis étape 1 | reprise dans CAP-D3.4/R4 |
| 356 | Itinéraire, distinction parcouru / non parcouru | reprise dans CAP-D3.4/R5 ; mise à jour dans CAP-D3.5/R5 |
| 357 | Pins hors parcours atténués | reprise dans CAP-D3.4/R5 |
| 358 | Pins du parcours en avant et numérotés | reprise dans CAP-D3.4/R5 |
| 359 | Présence persistante avec contrôles | reprise dans CAP-D3.4/R6 ; ECR-TRANSVERSES-PARCOURS-PERSISTANT |
| 360 | Slider sur l’époque de l’étape 1 | reprise dans CAP-D3.4/R7 (DEC-07) |
| 361 | Variante « rejoindre le départ » : application de navigation | rejetée : DEC-05 |

## D3.4 (definition_of_done)
| Ligne | Critère | Sort |
|---|---|---|
| 384 | Bascule sur la carte | reprise dans CAP-D3.4/CF1 |
| 385 | Recadrage et approche de l’étape 1 | reprise dans CAP-D3.4/R4 |
| 386 | Itinéraire visible et stylisé | reprise dans CAP-D3.4/CF2 |
| 387 | Pins numérotés / atténués | reprise dans CAP-D3.4/CF2 |
| 388 | Présence persistante | reprise dans CAP-D3.4/CF3 |
| 389 | Slider auto-positionné | reprise dans CAP-D3.4/CF4 |
| 390 | « S’y rendre » ouvre la navigation système | rejetée : DEC-05 |

## D3.5 Vivre un parcours (règles)
| Ligne | Règle | Sort |
|---|---|---|
| 457 | La géoloc déclenche l’arrivée | rejetée : DEC-05 |
| 458 | Signal discret et ouverture automatique à l’arrivée | rejetée : DEC-05 ; remplacée par le tap (CAP-D3.5/R3) |
| 459 | Déclenchement manuel d’arrivée (repli) | reprise dans CAP-D3.5/R3, R4 (FLX-E3) |
| 460 | Passage à l’étape suivante toujours disponible, saut volontaire | reprise dans CAP-D3.5/R6, R7 (DEC-40) |
| 461 | Direction et distance simples | rejetée : DEC-05 |
| 462 | Déport vers l’application de navigation | rejetée : DEC-05 |
| 463 | Transitions narratives (éditoriaux) | rejetée : en attente de décision, QO-303 |
| 464 | Audio en arrière-plan | rejetée : audio hors MVP |
| 465 | Présence persistante : titre, étape, progression, contrôles | reprise dans CAP-D3.5/R2, R11 |

## D3.5 (definition_of_done)
| Ligne | Critère | Sort |
|---|---|---|
| 490 | Détection géoloc à l’arrivée | rejetée : DEC-05 |
| 491 | Signal et ouverture automatique | rejetée : DEC-05 ; voir CAP-D3.5/R3 |
| 492 | Déclenchement manuel fonctionne | reprise dans CAP-D3.5/CF2 |
| 493 | Saut volontaire fonctionne | reprise dans CAP-D3.5/CF2 |
| 494 | Direction et distance affichées | rejetée : DEC-05 |
| 495 | Déport navigation système | rejetée : DEC-05 |
| 496 | Transitions narratives affichées | rejetée : QO-303 |
| 497 | Audio en arrière-plan | rejetée : audio hors MVP |
| 498 | Progression correctement incrémentée | reprise dans CAP-D3.5/CF3 |

## D3.9 Fin et célébration (règles)
| Ligne | Règle | Sort |
|---|---|---|
| 862 | Surface dédiée à la complétion de la dernière étape | reprise dans CAP-D3.9/R1 |
| 863 | Phrase narrative de conclusion | reprise dans CAP-D3.9/R4 |
| 864 | Statistiques distance, temps, étapes, quiz | reprise partielle dans CAP-D3.9/R5, R6 (étapes vues sur Y, durée, époques) ; distance : pas de géoloc (DEC-05) ; quiz : neutralisé |
| 865 | Trace du trajet avec étapes cochées | reprise dans CAP-D3.9/R7 (liste cochée) ; trace cartographique non reprise |
| 866 | Partage d’une image partageable | rejetée : S2 (partage hors MVP) |
| 867 | Badge collectionnable | rejetée : S2 (badges, profil) |
| 868 | Parcours complété dans l’espace personnel avec date et statistiques | reprise dans CAP-D3.9/R8 (historique, rappel sur la fiche) ; espace personnel : S2 |
| 869 | Relançable à tout moment | reprise dans CAP-D3.9/R8 |

## D3.9 (definition_of_done)
| Ligne | Critère | Sort |
|---|---|---|
| 894 | Détection de la complétion | reprise dans CAP-D3.9/CF1 |
| 895 | Moment de célébration affiché | reprise dans CAP-D3.9/CF1 |
| 896 | Statistiques calculées correctement | reprise dans CAP-D3.9/CF2 |
| 897 | Trace du trajet avec étapes cochées | reprise dans CAP-D3.9/R7 |
| 898 | Image partageable générée | rejetée : S2 |
| 899 | Badge décerné et visible (profil) | rejetée : S2 |
| 900 | Parcours marqué complété dans l’espace personnel | reprise dans CAP-D3.9/CF3, CF6 |

## Défauts de source traités
- Écran « Lancement » existant contre « pas d’écran Lancement dédié » : écran écarté, DEC-05.
- Ouverture automatique de la consultation contre tap exigé par le flux d’alerte d’arrivée : tap, DEC-05 (CAP-D3.5/R3).
- Étapes sautées absentes de l’historique (pas d’état explicite) contre état « sautée » : dérivée de l’absence d’entrée, DEC-09 et DEC-40.
- Critères de fin qui renvoient à du hors MVP (image partageable, badge, profil, distance, quiz) : rejetés ci-dessus.
- Marquage « vue » à l’ouverture (flux d’arrivée manuelle) contre « au retour » (flux de vie du parcours) : marquage à l’ouverture, le retour le trouve déjà fait (CAP-D3.5/R4).
- Écran de saut « à confirmer » : DEC-40.

## Hors périmètre de ce groupe
- Écrans écartés : catalogue (E-PARCOURS-PRINCIPAL), filtres (E-PARCOURS-FILTRES), lancement (E-PARCOURS-LANCEMENT), en cours canapé (E-PARCOURS-EN-COURS-CANAPE), éditeur (E-PARCOURS-EDITEUR), sélecteur de saut (E-PARCOURS-SAUT-ETAPE, DEC-40).
- Flux écartés : demande de permission juste-à-temps (A6), alerte d’arrivée par proximité (E2), notification Surprenez-moi (E1), catalogue et filtres (C1, C2), mode canapé (C6), déviations et pauses (C7), relancement et suivants (C10 à C13). Raison : DEC-05, DEC-04, S2.
- Capacités s2 : CAP-D3.1, D3.2, D3.6, D3.7, D3.8, D3.10 (fiches courtes). Dans D3.10, le saut d’étape et le pilotage du slider sont repris dans CAP-D3.5 (DEC-40, DEC-07).
- Valeurs de réponse paramétrique : TOK-CHO-LANCEMENT-PARCOURS, TOK-CHO-FIN-PARCOURS, TOK-CHO-PILOTAGE-AUTOMATIQUE-EPOQUE sont citées sans recopier les valeurs (groupe DESIGN).
