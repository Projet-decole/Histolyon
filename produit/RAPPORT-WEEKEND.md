---
id: DOC-RAPPORT-WEEKEND
type: document
titre: "Rapport du lot 1 (week-end du 24/10/2026)"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

# Rapport du lot 1

Branche `produit-v1` (issue de `main`, rien de poussé). `dart run tools/ctx.dart check` retourne 0 : 216 fichiers, 0 erreur, 0 avertissement.

## Fait, par type
| Type | Nombre | Tokens (≈) |
|---|---|---|
| Capacités MVP complètes | 14 | 14 500 |
| Capacités `s2` (fiches courtes) | 45 (59 au total) | 7 100 |
| Écrans | 11 (+ 13 images de référence) | 8 900 |
| Composants | 48 | 17 600 |
| Flux | 12 | 4 200 |
| Entités | 11 (9 `mvp`, `ENT-MEDIA` et `ENT-BADGE` en `s2`) | 5 700 (les 9 `mvp`) |
| Invariants | 7 (`INV-01, 03, 04, 06, 07, 08, 09`) | dans `donnees/INVARIANTS.md` |
| Décisions | 38 (DEC-01 à 15 imposées, 23 propositions) | 10 800 |
| Questions ouvertes | 56 (`decisions/QO.md`) | |
| Documents (VISION, design/, contenu/, tris…) | 34 | 54 000 |

Outils : `tools/ctx.dart` v2 (`lire`, `pack`, `chercher`, `refs`, `liste`, `chemin`, `check`) dans `tools/ctx_v2.dart`, `ctx_corpus.dart`, `ctx_check.dart` ; générateur `tools/ctx_correspondance.dart` ; tests `test/tools/ctx_v2_test.dart` et `ctx_v2_recherche_test.dart`. L’ancien usage de `ctx.dart` est inchangé (`ctx_test.dart` vert, non modifié).

## Mesures
- Budgets : toutes les unités sont sous leur plafond (`ctx check`). Total CAP + ECR + COMP + FLX + ENT du MVP ≈ 51 k tokens, pour ≈ 45 k visés (dépassement de 13 %, surtout les 48 composants).
- `ctx pack` des 14 CAP `mvp` : de 4 360 à 7 796 tokens, aucun au-dessus de 8 000. Les plus lourds : CAP-D3.5 (7 796), CAP-D2.1 (7 570), CAP-D2.5 (7 324). Marge faible : une entité ou un écran qui grossit fait repasser un pack au-dessus.
- Recherche : 15 questions types, 15/15 dans les 3 premiers résultats (`ctx_v2_recherche_test.dart`). Deux ajustements ont été nécessaires et sont visibles : mot « longueur » ajouté au titre de la règle sur la taille du récit (la recherche n’a pas de synonymes), et indexation séparée des règles numérotées `R…` des documents. Le test valide ma propre liste de questions, pas des questions de tiers.
- Couverture des règles : les 14 fiches MVP reprennent ou rejettent avec raison les 180 lignes (`regles_fonctionnelles` + `definition_of_done`) de leurs sources, via les tables `decisions/_tri-<groupe>.md`. Contre-vérification par un second agent sur 6 capacités (80 lignes) et 7 autres unités : aucune omission de règle, 0 gravité haute, 8 moyennes, ≈ 17 basses (`decisions/_verif.md`). Les 8 moyennes ont été corrigées sauf celles listées plus bas. Les 8 autres fiches MVP n’ont pas été contre-vérifiées : le « 100 % » repose sur les tableaux de tri des rédacteurs, non sur une vérification automatique.
- Correspondance : 944 identifiants de `conception/` dans `_correspondance.csv` (347 repris, 597 non repris avec le rôle). `decisions/_collisions.md` : 34 identifiants à plusieurs rôles et 107 définis plusieurs fois.
- Diff contre `origin/main` : uniquement `produit/**`, `tools/ctx.dart`, `tools/ctx_*.dart`, `test/tools/ctx_v2_*` (nouveaux). `dart analyze tools test/tools` propre ; `ctx_test`, `ctx_v2_test`, `ctx_v2_recherche_test` verts.

## Contradictions et décisions proposées (à valider)
Les rédacteurs ont consigné leurs contradictions en DEC-20 et suivants (plages par groupe) (statut `mvp`, « décision proposée »). Les plus importantes :
- DEC-20 : « un seul style de carte » (DEC-06) contre « une apparence par époque » (D1.3) → un style, paramètres qui varient. DEC-82 : contredit `docs/ARCHITECTURE-SPINE.md:113`, à aligner hors `produit/`.
- DEC-40 : l’écran « saut d’étape » n’est pas gardé ; un bouton « Sauter cette étape » sur l’écran du parcours (étape non complétée, DEC-09).
- DEC-50 : un modèle 3D par pin, pas d’AR ; DEC-51 : la visionneuse masque son chrome (le mode présentation est hors MVP).
- DEC-70 à 74 : écarts source/SQL/Drift (parcours « personnel », colonnes de l’étape, historique de visite).
- DEC-60 à 62 : layouts de composants, 17 identifiants d’écran inexistants dans `10-composants` (le brief en annonçait 19), 10 composants cités mais non définis.
- DEC-80 : décompte des icônes, contradiction Lucide ; DEC-90 : pas de « description courte » de parcours.

## Écarts au brief
- ≈ 216 fichiers `.md` dans `produit/` pour un plafond de ≈ 120 : les 59 CAP adressables, 48 composants et 55 fichiers de `decisions/` expliquent le dépassement.
- Ajouts non prévus : `design/SURFACES.md` (modes MOD- et surfaces SRF-), préfixe d’identifiant `DOC-` pour les documents, `_perimetre-mvp.yaml` (lu par `ctx check`), `decisions/_tri-<groupe>.md` + `_tri.md`, `QO-<groupe>.md` + `QO.md`.
- Entités : `ENT-MEDIA` et `ENT-BADGE` sont en `s2` (DEC-03 écarte les médias, rien dans les sources n’impose le badge au MVP), alors que le brief les liste dans le périmètre. Elles existent mais ne comptent pas comme `mvp`.
- Microcopy : 16 blocs retenus, pas 19 (seuls ceux qui servent les écrans MVP).
- Composants : 48 écrits, pour ≈ 46 attendus.
- Sources de décisions : `brief:lot1` (le brief n’est pas dans le dépôt) ; `AGENTS.md` accepté comme source dans `ctx check`.
- Motifs interdits : `decisions/` et `_correspondance.csv` citent volontairement `persona_check…` (retiré, ancien identifiant) ; `ctx check` les exempte.
- Branche locale renommée `produit-v1`.

## Blocages et réserves
- Aucun blocage de plus de 3 itérations.
- Les node ids Figma ne sont pas dans l’export d’images : `node_figma` est vide dans les fiches d’écran.
- Contre-vérification : restent notamment (voir `decisions/_verif.md`) CAP-D1.2 R11 (indication du slider reprise alors que les questions du groupe contenu la dit écartée), CAP-D2.4 R9 (« Ce pin n’est plus disponible ») contre son écran qui le déclare sans objet, et l’image exigée par CAP-D2.4 R3 que l’écran rend optionnelle (QO-104). À arbitrer.
- Quatre fiches de données ont été écrites par heredoc shell, 33 fiches S2 par script (déroge à la consigne « outil dédié d’abord » du CLAUDE.md global ; contenu inchangé).

## À regarder en priorité
1. `decisions/DEC-40.md`, `DEC-50.md`, `DEC-20.md` : trois choix de produit pris par défaut prudent (saut d’étape, 3D sans AR, un seul style de carte).
2. Questions ouvertes qui bloquent l’implémentation : QO-401 / QO-203 (le modèle 3D est-il embarqué ? conflit avec la règle « jamais de `.glb` dans le dépôt »), QO-601 (cible d’une étape vue dans Drift), QO-105 (époque par défaut), QO-301 (reprise après fermeture).
3. Bornes d’époques (`design/CARTE.md`, DEC-08) : reprises de `content/epoques/*.yaml`, « à valider par l’historienne ». Le libellé de `antiquite_romaine` est « Antiquité ».
4. Les packs de CAP-D3.5, CAP-D2.1, CAP-D2.5 sont à 7,3–7,8 k : surveiller `ctx check`.
5. `ENT-MEDIA` et `ENT-BADGE` en `s2` alors que le brief les listait dans le périmètre : à confirmer. Les droits du modèle 3D de la fontaine des Jacobins restent à vérifier (QO-405).

## Images (P7)
13 captures copiées de `produit/_import-figma/` (du dépôt principal, jamais commité) vers `ecrans/img/` avec les noms `ECR-<NOM>--<état>@2x.png` et liées dans les fiches. Frames manquantes : voir `design/MAQUETTE.md`.
