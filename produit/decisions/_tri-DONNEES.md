---
id: DOC-TRI-DONNEES
type: document
titre: "Tri du groupe DONNEES : ce qui n’est pas repris"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

## Entités reprises : attributs et règles non repris
| entité | source | non repris | raison |
|---|---|---|---|
| ENT-PIN | 01-contenu.yaml:32 | provenance `communautaire`, `auteur_communautaire`, médias, fragments musicaux, visibilité communautaire dès `en_revue`, plusieurs époques | hors MVP ; DEC-02 pour les époques |
| ENT-PIN | 01-contenu.yaml:142 | 4 questions ouvertes (catégorie après publication, conservation après retrait, workflow de promotion, pins sans localisation) | non bloquantes au MVP |
| ENT-CATEGORIE | 01-contenu.yaml:149 | aucun | liste finale : QO-602 |
| ENT-EPOQUE | 01-contenu.yaml:189 | « expression de période » comme borne ; granularité du libellé | DEC-74 ; DEC-08 |
| ENT-SOURCE | 01-contenu.yaml:235 | ajout de source par un contributeur communautaire ; format de référence par type | hors MVP ; relève de la saisie admin |
| ENT-MEDIA | 01-contenu.yaml:285 | tout (entité s2) | DEC-03 |
| ENT-BADGE | 01-contenu.yaml:334 | tout (entité s2) | non imposé par le MVP |
| ENT-MODELE-3D | 01-contenu.yaml:369 | format technique du modèle ; cycle de vie suivant le pin | implémentation ; QO-605 |
| ENT-PARCOURS | 02-parcours.yaml:37 | provenance `personnel` et ses états ; provenance `communautaire`, `auteur_communautaire`, `retours_actifs`, promotion ; badge, image d’ouverture | DEC-70 ; hors MVP |
| ENT-PARCOURS | 02-parcours.yaml:285 | algorithme de durée et de distance ; limite d’étapes ; quiz et badges de fin ; cohérence des époques | non bloquant ou hors MVP |
| ENT-ETAPE | 02-parcours.yaml:296 | `note_personnelle` ; étape optionnelle | DEC-71 ; hors MVP |
| ENT-PROFIL | 03-utilisateur.yaml:44 | langue, mode de notification de proximité, permissions demandées, compte associé, synchronisation, section engageante | DEC-15, DEC-05, DEC-73 ; hors MVP |
| ENT-HISTORIQUE-DE-VISITE | 03-utilisateur.yaml:352 | `résultat_quiz_post_narratif`, `score_quiz`, rétention glissante, synchronisation | hors MVP (quiz) ; DEC-72 |

## Entités non reprises
| entité | source | raison |
|---|---|---|
| couche_cartographique | 01-contenu.yaml:463 | décrite dans le code, pas en base (`schema_complet.sql`) ; filtre de carte hors MVP |
| fragment_musical | 01-contenu.yaml:422 | audio neutralisé (DEC-03) |
| compte | 03-utilisateur.yaml:169 | pas de compte au MVP (INV-06) |
| favori | 03-utilisateur.yaml:281 | favori neutralisé au MVP |
| commentaire | 04-communaute.yaml:43 | communauté hors MVP |
| retour_de_parcours | 04-communaute.yaml:129 | communauté hors MVP |
| signalement | 04-communaute.yaml:219 | communauté hors MVP |
| trace_de_moderation | 04-communaute.yaml:318 | communauté hors MVP |
| template | 05-production.yaml:58 | saisie admin ; décrit dans le code |
| trace_de_validation | 05-production.yaml:162 | audit éditorial côté serveur (table `trace_validation`, écrite par les RPC) ; invisible dans l’app |
| lien_universel | 06-distribution.yaml:74 | partage neutralisé ; URL dérivée du slug |
| image_partageable | 06-distribution.yaml:149 | partage neutralisé ; générée par l’app |
| code_visuel | 06-distribution.yaml:253 | partage neutralisé ; généré par l’app |

## Invariants non repris
| invariant | source | raison |
|---|---|---|
| I2 compte requis pour publier | 00-index.yaml:140 | aucune publication communautaire au MVP |
| I5 anonymat du signaleur | 00-index.yaml:185 | signalement hors MVP |
| I10 promotion pin communautaire vers éditorial | 00-index.yaml:241 | pas de pin communautaire au MVP |
| I3 | 00-index.yaml:155 | repris sous forme minimale (INV-03) : sans objet fonctionnel au MVP |
