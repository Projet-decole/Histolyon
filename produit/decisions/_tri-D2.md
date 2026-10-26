---
id: DOC-TRI-D2
type: document
titre: "Tri des règles et critères du groupe D2"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

Source unique : `conception/03-fonctionnalites/02-pins-et-contenu.yaml`. Les flux (`conception/06-flows/02-consultation-pin.yaml`) : B1, B2, B4, B5 repris (B5 sans AR, DEC-35). **B3** (navigation multi-époques, DEC-02), **B6** (post-narratif, CAP-D2.7), **B7** (favori) : non repris.

## D2.1 — CAP-D2.1
| source | sort |
|---|---|
| :88 règle pin = lieu + catégorie | reprise dans CAP-D2.1/R1 |
| :88 au moins une époque | reprise dans CAP-D2.1/R1 (une seule, DEC-31) |
| :88 contexte normal / parcours / hors parcours | reprise dans CAP-D2.1/R7 |
| :88 « à proximité du tracé » | rejetée : aucune variante visuelle définie dans la grammaire des pins |
| :89 regroupement | reprise dans CAP-D2.1/R9 (seuil : QO-201) |
| :90 tap pin → aperçu | reprise dans CAP-D2.1/R10 |
| :91 tap cluster → approfondit | reprise dans CAP-D2.1/R10 |
| :92 filtre par époque, « Aujourd’hui » | reprise dans CAP-D2.1/R6 ; vue cumulée renvoyée à CAP-D1.2 |
| DoD :116 catégorie distinguable | reprise dans CAP-D2.1/CF1 |
| DoD :117-119 regroupement et tap | reprise dans CAP-D2.1/CF3, CF4 |
| DoD :120 contextes distinguables | reprise dans CAP-D2.1/CF5 (sans « à proximité ») |
| DoD :121 pins multi-époques signalés | rejetée : hors MVP, DEC-02 |
| DoD :122 filtre d’époque | reprise dans CAP-D2.1/CF2 |
| ce_qu_on_ne_fait_pas (animation, lisibilité) | reprise dans CAP-D2.1/R8, R11 |

## D2.2 — CAP-D2.2
| source | sort |
|---|---|
| :181 onze catégories | reprise dans CAP-D2.2/R1 |
| :182 exclusives | reprise dans CAP-D2.2/R2 |
| :183 obligatoire à la création | reprise adaptée dans CAP-D2.2/R6 (DEC-33) |
| :184 règle vivant/passé | reprise dans CAP-D2.2/R3 |
| :185 visuellement distinguable | reprise dans CAP-D2.2/R4 |
| DoD :205 11 catégories disponibles à la création | reprise adaptée dans CAP-D2.2/CF1 |
| DoD :206 pas de pin sans catégorie | reprise dans CAP-D2.2/CF4 |
| DoD :207 distinction sur D2.1, D2.4, D2.5 | reprise dans CAP-D2.2/CF2 |
| DoD :208 filtre dans la recherche | rejetée : relève de CAP-D1.4, DEC-33 |

## D2.4 — CAP-D2.4
| source | sort |
|---|---|
| :348 superposition à la carte | reprise dans CAP-D2.4/R1 |
| :349 ouverture par tap | reprise dans CAP-D2.4/R2 |
| :350 fermeture geste ou tap dehors | reprise dans CAP-D2.4/R5 |
| :351 contenu présenté | reprise dans CAP-D2.4/R3 ; navigation entre époques et partage rejetés (DEC-02, hors MVP) |
| :352 « Ajouter au parcours » en création | rejetée : parcours personnels S2 |
| :353 signal hors parcours | reprise dans CAP-D2.4/R7 |
| ne_fait_pas : autre pin tapé | reprise dans CAP-D2.4/R6 (comportement fixé) |
| DoD :375-381 | CF1, CF2, CF3, CF4, CF5 ; partage et « Ajouter » rejetés |

## D2.5 — CAP-D2.5
| source | sort |
|---|---|
| :457 pleine surface, progression | reprise dans CAP-D2.5/R1 |
| :458 structure audio, teaser, post-narrative | reprise partielle dans CAP-D2.5/R3 ; audio et post-narrative rejetés (hors MVP, CAP-D2.7) |
| :459 accès audio conditionnel | rejetée : audio hors MVP |
| :460 teaser d’engagement | rejetée : CAP-D2.7 reportée |
| :461 accès 3D conditionnel | reprise dans CAP-D2.5/R5 |
| :462-463 mode présentation | rejetée : hors MVP |
| :464 étape suivante en pied | reprise dans CAP-D2.5/R8 |
| ne_fait_pas : pas d’onglets, pas d’élément latéral | reprise dans CAP-D2.5/R1 (DEC-32) |
| ne_fait_pas : pas d’accès 3D sans modèle | reprise dans CAP-D2.5/R5 |
| ne_fait_pas : retour toujours présent | reprise dans CAP-D2.5/R7 |
| ne_fait_pas : frontière nette récit/post-narratif | rejetée : CAP-D2.7 reportée |
| ne_fait_pas : pas d’auto-promotion | rejetée : doublon avec l’essence du produit, sans effet testable |
| DoD :491-498 | CF1, CF2, CF4, CF5 ; audio, teaser, mode présentation, multi-époques rejetés |

## D2.6 — CAP-D2.6
| source | sort |
|---|---|
| :568 six types | reprise partielle dans CAP-D2.6/R1 (deux types, DEC-03) |
| :569 insertion contextuelle | reprise adaptée dans CAP-D2.6/R2 (DEC-30) |
| :570 sources visibles archive/citation | reprise dans CAP-D2.6/R3 (citation) ; archives rejetées (DEC-03) |
| :571 pas d’éléments latéraux | reprise dans CAP-D2.6/R5 |
| :572 avant/après | rejetée : DEC-03 |
| :573 puzzle optionnel | rejetée : DEC-03 |
| :574 frise mini | rejetée : DEC-03 |
| :575 chargement progressif | reprise dans CAP-D2.5/R11 |
| ne_fait_pas : pas de citation inventée | reprise dans CAP-D2.6/R4 |
| DoD :601-606 | CF1-CF3 pour les deux types ; avant/après, puzzle, frise et chargement des médias riches rejetés (DEC-03) |

## D2.3 et D2.7
Fiches courtes `s2` (DEC-02, DEC-03). Aucune règle reprise.

## Contradictions et défauts
DEC-30 (encarts), DEC-31 (une époque), DEC-32 (sans onglets), DEC-33 (catégories), DEC-34 (libellé « Voir le récit »), DEC-35 (B5 sans AR).
