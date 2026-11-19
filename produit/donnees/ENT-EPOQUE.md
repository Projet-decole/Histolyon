---
id: ENT-EPOQUE
type: entite
titre: "Époque"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  entites: [ENT-PIN, ENT-PARCOURS, ENT-MODELE-3D]
  invariants: [INV-07, INV-08]
  decisions: [DEC-02, DEC-07, DEC-08, DEC-74, DEC-111]
anciens_ids: [epoque]
sources:
  - conception/04-donnees/01-contenu.yaml:189
  - supabase/migrations/0001_socle.sql:57
  - content/epoques/antiquite.yaml:1
budget_tokens: 1500
derniere_verif: 2026-11-19
---

## Rôle
Position dans le temps long de Lyon ; alimente le slider d’époques, mécanisme central de navigation temporelle.

## Attributs
| nom | type | obligatoire | règle |
|---|---|---|---|
| id / slug | uuid / texte unique | oui | slug stable |
| libelle | texte | oui | non vide |
| borne_debut, borne_fin | entiers (années, négatif = avant J.-C.) | oui | `borne_debut ≤ borne_fin` |
| ordre | entier | oui | ordre chronologique sur le slider |

## Les 10 époques du MVP
Bornes et libellés validés par l’historienne (DEC-111), source de vérité `content/epoques/*.yaml`. Les bornes de deux époques voisines se touchent (recouvrement admis).

| ordre | slug | libellé | début | fin |
|---|---|---|---|---|
| 1 | antiquite | Antiquité | -680 | 476 |
| 2 | haut_moyen_age | Haut Moyen Âge | 476 | 987 |
| 3 | moyen_age_classique | Moyen Âge classique | 987 | 1328 |
| 4 | bas_moyen_age | Bas Moyen Âge | 1328 | 1492 |
| 5 | epoque_moderne | Époque moderne | 1492 | 1789 |
| 6 | revolution_empire | Révolution et Ier Empire | 1789 | 1815 |
| 7 | xixe_siecle | XIXe siècle | 1815 | 1914 |
| 8 | guerres_mondiales | Guerres mondiales | 1914 | 1945 |
| 9 | xxe_siecle | XXe siècle | 1945 | 2000 |
| 10 | xxie_siecle | XXIe siècle | 2000 | 2027 |

Identifiants du corpus : `EPQ-` + slug en majuscules, `_` → `-` (`moyen_age_classique` donne `EPQ-MOYEN-AGE-CLASSIQUE`).

## Relations
Référencée par les pins (MVP : un pin, une époque, DEC-02), les parcours (≥ 1, ENT-PARCOURS) et les modèles 3D (exactement 1, ENT-MODELE-3D). Quand un parcours est actif, le slider se place sur l’époque de l’étape courante (DEC-07).

## Cycle de vie
Aucun statut. Catalogue ouvert, additions seulement (INV-07).

## Invariants
INV-07 ; INV-08 (liaison n-n possible) ; bornes cohérentes (contrainte SQL).

## Correspondance SQL
Table `epoque` : `id`, `slug`, `libelle`, `borne_debut`, `borne_fin`, `ordre`, `created_at` ; contrainte `epoque_bornes_coherentes`. Liaisons : `pin_epoque`, `parcours_epoque`, `modele_3d.epoque_id`. Écart : la source parle d’« année ou expression de période », le SQL fixe des entiers (DEC-74).

## Hors MVP
Fragments musicaux par époque ; ajout d’époques.
