---
id: DOC-QO-D3
type: document
titre: "Questions ouvertes du groupe D3 (parcours)"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

## QO-301 — Reprise du parcours après fermeture de l’app
Pourquoi elle bloque : la source (cas limites, S2) prévoit une invitation à reprendre, mais aucune règle MVP ne dit si la progression survit à la fermeture. Sans réponse, le comportement au redémarrage d’un parcours en cours n’est pas testable.
Unité : CAP-D3.5. Source : conception/03-fonctionnalites/03-parcours.yaml:937.

## QO-302 — Accès à la fiche sans catalogue
Pourquoi elle bloque : le MVP n’a pas d’écran catalogue. L’hypothèse retenue est que l’onglet Parcours ouvre directement la fiche de l’unique parcours ; à confirmer pour l’écran de navigation et pour le titre de l’onglet.
Unité : CAP-D3.3, ECR-PARCOURS-FICHE-DETAIL. Source : conception/03-fonctionnalites/03-parcours.yaml:138.

## QO-303 — Transitions narratives entre étapes
Pourquoi elle bloque : la source les réserve aux parcours éditoriaux, mais DEC-03 limite le contenu à des récits et encarts texte. Faut-il un texte de transition entre deux étapes au MVP, et où l’afficher ?
Unité : CAP-D3.5. Source : conception/03-fonctionnalites/03-parcours.yaml:426.

## QO-304 — Libellés à adapter au pas à pas
Pourquoi elle bloque : trois textes d’origine supposent des notions écartées. Mention de fin partielle (« Parcours partiellement achevé » vs DEC-09 qui bannit l’idée d’incomplétude), sortie « Revenir à mes parcours » (la vue « Mes parcours » n’existe pas), description du dialogue d’abandon (« depuis Mes parcours »).
Unité : CAP-D3.9, ECR-PARCOURS-FIN-CELEBRATION, ECR-PARCOURS-EN-COURS-TERRAIN. Source : conception/08-contenu/04-microcopy-grand-public.yaml:517.
