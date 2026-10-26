---
id: DEC-62
type: decision
titre: "Composants cités mais non définis dans 10-composants"
statut: mvp
liens: {}
anciens_ids: []
sources:
  - conception/10-composants/01-atomes.yaml:878
  - conception/10-composants/01-atomes.yaml:934
  - conception/10-composants/02-molecules.yaml:300
derniere_verif: 2026-10-24
---

## Décision proposée
Ne créer aucune fiche pour les composants cités sans définition. Tous sont hors MVP ou sans objet : ils sont écartés avec la raison ci-dessous. Les motifs génériques de la source (par exemple `comp-item-liste-*`) désignent des familles, pas des composants.

## Sources en conflit
Un composant défini dans les quatre fichiers lus est cité dans `composants_qui_l_integrent` d’un autre, mais n’a pas de fiche :

| Cité (ancien id) | Cité par | Traitement |
|---|---|---|
| `comp-dialogue-partage` | lien universel QR | partage, hors MVP |
| `comp-overlay-partage` | lien universel QR | partage, hors MVP |
| `comp-dialogue-signalement` | mention d’anonymat | signalement, hors MVP |
| `comp-formulaire-signalement` | mention d’anonymat | signalement, hors MVP |
| `comp-item-liste-mention` | avatar miniature | commentaires, hors MVP |
| `comp-liste-simple` | séparateur | probablement `comp-item-liste-simple` ; hors tranche |
| `comp-zone-statistiques` | compteur statistique | statistiques, hors MVP |
| `comp-zone-suggestions` | vignette de pin | suggestions, hors MVP |
| `comp-formulaire-saisie-pin-admin` | carrousel | défini en back-office (fichier non lu), hors périmètre |
| `comp-card-parcours` | image hero | désigne les deux cartes de parcours ; le MVP n’écrit que la large |

Motifs génériques : `comp-chip-`, `comp-formulaire-`, `comp-item-liste-`, `comp-layout-`.

## Conséquence
Aucun lien `COMP-…` vers ces composants dans `produit/`. Dans les fiches, l’absence de fiche est dite en « Hors MVP : neutralisé : … » sans lien. Le doublon `comp-liste-simple` est signalé en QO-514.
