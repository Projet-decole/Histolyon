---
id: ECR-CARTE-APERCU-PIN
type: ecran
titre: "Aperçu rapide d’un pin"
statut: mvp
priorite: coeur
jalon: JAL-FU2
liens:
  capacites: [CAP-D2.4]
  flux: [FLX-A3]
  composants: [COMP-APERCU-RAPIDE-PIN, COMP-CHIP-CATEGORIE, COMP-LIBELLE-TEXTE, COMP-BUTTON-PRIMARY]
  entites: [ENT-PIN, ENT-EPOQUE, ENT-CATEGORIE]
  decisions: [DEC-02, DEC-03, DEC-04, DEC-14]
  questions: [QO-104]
anciens_ids: [E-CARTE-APERCU-PIN]
sources:
  - conception/07-ecrans/carte/02-apercu-pin.yaml:14
  - conception/08-contenu/04-microcopy-grand-public.yaml:321
  - conception/10-composants/04-shell.yaml:132
images:
  - {etat: nominal, fichier: img/ECR-CARTE-APERCU-PIN--nominal@2x.png, node_figma: ""}
budget_tokens: 2000
derniere_verif: 2026-10-24
---

## Rôle
Consultation courte d’un pin, carte visible derrière. La personne décide en quelques secondes d’approfondir ou de refermer d’un geste neutre. Invite sans embarquer.

## Composition
Panneau (COMP-APERCU-RAPIDE-PIN) au-dessus de la carte :
- **Catégorie** (COMP-CHIP-CATEGORIE).
- **Titre et époque** (COMP-LIBELLE-TEXTE) : une seule époque par pin (DEC-02).
- **Teaser** (COMP-LIBELLE-TEXTE) : court extrait du récit, au tutoiement narratif (DEC-14).
- **Vignette** : optionnelle, voir QO-104.
- **Bouton « Voir le récit »** (COMP-BUTTON-PRIMARY) : ouvre la consultation approfondie (CAP-D2.5).

## États
- **nominal** — quand : tap sur un pin ; on voit : catégorie, titre, époque, teaser, bouton, carte visible derrière.
- **sans vignette** — quand : le pin n’a pas de média ; on voit : le panneau sans vignette, sans trou.
- **fermé** — quand : geste neutre de fermeture ; on voit : la carte seule.

## Interactions
- Tap sur « Voir le récit » → consultation approfondie du pin (CAP-D2.5).
- Geste neutre de fermeture (tap hors du panneau) → l’aperçu se ferme, la carte reprend (FLX-A3).
- Tap sur un autre pin → l’aperçu passe à ce pin.

## Libellés de l’écran
- Bouton : « Voir le récit »
- Pas de titre propre : le titre du pin tient lieu de titre.
- Exemple de teaser (récit, tutoiement narratif) : « Cette traboule traversait toute la maison. Les canuts l’utilisaient pour sortir leurs pièces de soie sans les abîmer dans la pluie. »

## Hors MVP
- Favori, partage, signalement et marque de provenance communautaire (favori, partage, communauté hors MVP).
- États chargement, pin retiré, hors-ligne avec ou sans cache : sans objet, le contenu est embarqué (DEC-04).
- Pin sans localisation accédé par recherche (CAP-D1.4).
- Atterrissage depuis une notification de proximité (CAP-D4.2, DEC-05).
- Images d’archives dans l’aperçu (DEC-03).
