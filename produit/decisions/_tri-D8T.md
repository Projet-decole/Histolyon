---
id: DOC-TRI-D8T
type: document
titre: "Tri des règles D8.1 et D8.2 (groupe D8T)"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

Source : `conception/03-fonctionnalites/08-3d-ar.yaml`.

## D8.1 — règles fonctionnelles
| Source | Devenir |
| --- | --- |
| :97 apparition conditionnelle | reprise dans CAP-D8.1/R1 (règle d’apparition fondée sur le modèle, DEC-50) |
| :98 aucun élément sans contenu | reprise dans CAP-D8.1/R2 |
| :99 consultation approfondie, pas aperçu | reprise dans CAP-D8.1/R3 |
| :100 activation consciente | reprise dans CAP-D8.1/R5 |
| :101 ouvre la 3D, pas l’AR | reprise dans CAP-D8.1/R6 |

## D8.1 — definition_of_done
| Source | Devenir |
| --- | --- |
| :122 point d’accès présent avec contenu | reprise dans CAP-D8.1/CF1 |
| :123 rien sans contenu | reprise dans CAP-D8.1/CF2 |
| :124 ouvre D8.2 | reprise dans CAP-D8.1/CF3 |
| :125 absent de l’aperçu | reprise dans CAP-D8.1/CF4 |
| :126 aucune activation automatique | reprise dans CAP-D8.1/CF5 |

Enjeu d’accessibilité (:130) repris dans R7, R8 et CF6 ; performance (:137) dans R9.

## D8.2 — règles fonctionnelles
| Source | Devenir |
| --- | --- |
| :188 famille du mode présentation | réécrite : mode présentation hors MVP, la visionneuse masque seule son chrome (CAP-D8.2/R1, DEC-51) |
| :189 manipulation | reprise dans CAP-D8.2/R2 |
| :190 contextualisation | reprise dans CAP-D8.2/R3 |
| :191 retour à tout moment | reprise dans CAP-D8.2/R4 |
| :192 bascule AR conditionnée | rejetée : AR reportée en S2 (CAP-D8.3, DEC-50, DEC-05, DEC-06) |
| :193 surfaces persistantes cèdent | reprise dans CAP-D8.2/R5, sans renvoi au mode présentation (DEC-51) |

## D8.2 — definition_of_done
| Source | Devenir |
| --- | --- |
| :216 consultation plein écran | reprise dans CAP-D8.2/CF1 |
| :217 chrome masqué, cohérent avec le mode présentation | réécrite dans CF1 (DEC-51) |
| :218 tourner, rapprocher, éloigner | reprise dans CAP-D8.2/CF2 |
| :219 contextualisation accessible | reprise dans CAP-D8.2/CF3 |
| :220 retour à tout moment | reprise dans CAP-D8.2/CF4 |
| :221 bascule AR si contenu AR et terminal compatible | rejetée : renvoie à CAP-D8.3, hors MVP (DEC-50) |

## Autres blocs non repris
- `ce_qu_on_ne_fait_pas` de D8.2 sur la visite guidée scénarisée : placé en « Hors MVP ».
- Questions ouvertes de D8.1 (nombre de pins : engagement d’un pin, couvert par DEC-13 ; accès 3D puis AR : tranché par DEC-50).
- Questions ouvertes de D8.2 sur moteur, interactif ou pré-rendu, fidélité visuelle, audio : choix technique (voir `docs/DECISIONS.md`) ou hors MVP ; fallback appareil : QO-403 ; attribution : QO-405.
- D8.3 et D8.4 : fiches courtes `s2`, règles non reprises (hors MVP).

## Écrans
- Écartés (hors MVP, cités dans les « Hors MVP ») : pin/04-consultation-ar, pin/02-mode-presentation, transverses/06-dialogue-permission, 01-audio-persistant, 07-indication-onboarding, 08-invitation-microparcours.
- Écran 3D : sélecteur de modèle, point d’accès AR, états AR, audio narratif, parcours en cours (repris dans R5) : sélecteur, AR et audio rejetés (DEC-50, audio hors MVP).
- Écran 3D : l’état « parcours en cours » est repris dans CAP-D8.2/R5 ; l’état « hors ligne avec cache » est rejeté (DEC-04, tout est local).
