---
id: DOC-TRI-D1
type: document
titre: "Tri des règles et critères de fin de D1.1, D1.2, D1.3"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

# Recouvrement du domaine D1

Source : `conception/03-fonctionnalites/01-carte-exploration-temporelle.yaml`. « R » = règle de `regles_fonctionnelles`, « DoD » = ligne de `definition_of_done`.

## Carte de base
| Source (ligne) | Règle | Sort |
|---|---|---|
| :79 | Centrage initial = Bellecour | reprise dans CAP-D1.1/R2 (DEC-21) |
| :80 | Recentrage sur la position si à Lyon | rejetée : géolocalisation hors MVP (DEC-06) |
| :81 | Permission GPS au premier « Me localiser » | rejetée : pas de localisation (DEC-06) ; l’absence de permission est la règle CAP-D1.1/R4 |
| :82 | Refus de la permission sans blocage | rejetée : sans objet, aucune permission |
| :83 | Message « pas à Lyon » | rejetée : sans localisation (DEC-06) |
| :84 | Aucun message ni demande au lancement | reprise dans CAP-D1.1/R4 |
| :85 | Navigation limitée à Lyon | reprise dans CAP-D1.1/R3 (emprise des tuiles, DEC-06) |
| :109 | DoD ouverture directe centrée Bellecour | reprise dans CAP-D1.1/CF1 |
| :110 | DoD recentrage si géoloc autorisée | rejetée : DEC-06 |
| :111 | DoD « Me localiser » hors Lyon | rejetée : DEC-06 |
| :112 | DoD aucune permission au lancement | reprise dans CAP-D1.1/CF2 (étendue à toute la session) |
| :113 | DoD pan et zoom dans la zone | reprise dans CAP-D1.1/CF3 |
| :114 | DoD refus GPS sans effet | rejetée : sans objet (DEC-06) |

Ajouts hors source de D1.1 : R6 (tuiles embarquées, DEC-04), R7 (attribution, règle du projet), R5 (INV-06), CF4 et CF5.

## Slider d’époques
| Source (ligne) | Règle | Sort |
|---|---|---|
| :177 | Apparence évolue en continu | reprise dans CAP-D1.2/R1 |
| :178 | Pins rechargés à la fin du geste | reprise dans CAP-D1.2/R4 |
| :179 | Une dizaine d’époques | reprise dans CAP-D1.2/R6 : 10 époques de `content/epoques` (DEC-08) |
| :180 | « Aujourd’hui » = vue cumulée | reprise dans CAP-D1.2/R7 ; R8 précise les autres époques (DEC-02) |
| :181 | Parcours positionne le slider sans bloquer | reprise dans CAP-D1.2/R9 et R10 (DEC-07) |
| :202 | DoD navigation continue | reprise dans CAP-D1.2/CF1 |
| :203 | DoD calage et chargement des pins | reprise dans CAP-D1.2/CF2 |
| :204 | DoD période lisible pendant le geste | reprise dans CAP-D1.2/R2 et CF1 |
| :205 | DoD « Aujourd’hui » tous pins | reprise dans CAP-D1.2/CF3 |
| :206 | DoD parcours et déplacement manuel | reprise dans CAP-D1.2/CF5 |

Non repris : l’alternative au geste continu (enjeu accessibilité, ligne 212) devient QO-102 ; la question « bornes exactes » est tranchée par DEC-08 ; la question de priorité parcours/manuel est tranchée par DEC-07.

## Apparence par époque
| Source (ligne) | Règle | Sort |
|---|---|---|
| :259 | Apparence distincte par époque | reprise dans CAP-D1.3/R1 (DEC-20) |
| :260 | Transition progressive | reprise dans CAP-D1.3/R2 |
| :261 | Calage net | reprise dans CAP-D1.3/R3 |
| :262 | Lisibilité des pins prioritaire | reprise dans CAP-D1.3/R4 |
| :280 | DoD apparence définie par époque | reprise dans CAP-D1.3/CF1 |
| :281 | DoD transition progressive | reprise dans CAP-D1.3/CF2 |
| :282 | DoD calage net | reprise dans CAP-D1.3/CF3 |
| :283 | DoD pins visibles et touchables | reprise dans CAP-D1.3/CF4 |

Non repris : la question « couches de reconstitution dans D1.3 ou D1.5 » est résolue en renvoyant à CAP-D1.5 (S2). La question « Aujourd’hui neutre ou particulier » est résolue par le mapping (base neutre = Aujourd’hui, CAP-D1.3/R7).

## Écrans et flux
- ECR-CARTE-PRINCIPALE : états hors-ligne, permission refusée, audio, mode présentation, points d’accès recherche, couches, Surprenez-moi, localisation, invitation micro-parcours : voir « Hors MVP » de la fiche.
- ECR-CARTE-APERCU-PIN : favori, partage, signalement, provenance communautaire, états chargement, pin retiré, hors-ligne, pin sans localisation : voir « Hors MVP » de la fiche.
- FLX-A1 : étape de création de profil réduite à un profil anonyme local ; armement de l’invitation au micro-parcours (A2) rejeté (onboarding hors MVP).
- FLX-A3 : « Me localiser », couches, recherche et permission (A6) rejetés (DEC-06, CAP-D1.4, CAP-D1.5).
