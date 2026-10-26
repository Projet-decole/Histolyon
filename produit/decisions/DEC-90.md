---
id: DEC-90
type: decision
titre: "Parcours : pas de description courte stockée, la description de la fiche est teaser_narratif"
statut: mvp
liens:
  questions: [QO-904]
anciens_ids: []
sources:
  - conception/08-contenu/03-template-parcours.yaml:48
  - conception/08-contenu/03-template-parcours.yaml:87
  - content/schema/parcours.schema.json:1
  - supabase/migrations/20260925120000_schema_complet.sql:238
derniere_verif: 2026-10-24
---
## Décision proposée
Au MVP, un parcours porte : `titre`, `teaser_narratif` (la « description longue » de la fiche), `conclusion_narrative`, `signature_editoriale`, et par étape `introduction` (et `transition_depuis_precedente`, facultative). La « description courte » du catalogue n’est ni rédigée ni stockée ; si un écran en a besoin, il affiche le titre et les métadonnées (durée, étapes, densité). Les gabarits l’appliquent (DOC-GABARIT-PARCOURS).

## Sources en conflit
- `conception/08-contenu/03-template-parcours.yaml:87` décrit quatre couches propres au parcours, dont une description courte « accroche en catalogue ».
- Le schéma réel (`content/schema/parcours.schema.json`) n’a que `teaser_narratif` et `conclusion_narrative` ; la table `etape` n’a que `introduction` et `transition_depuis_precedente`.

## Conséquence
Solution la plus prudente : ne pas ajouter de colonne depuis `produit/`. Si l’équipe veut une accroche en liste, ce sera une migration et une décision distinctes (S2). Le MVP n’ayant qu’un parcours (DEC-13), l’impact est nul tant qu’il n’y a pas de catalogue.
