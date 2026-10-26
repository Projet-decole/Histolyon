---
id: DEC-80
type: decision
titre: "Icônes : Lucide épinglé, deux personnalisées, décompte de l’inventaire non figé"
statut: mvp
liens:
  decisions: [DEC-11]
anciens_ids: []
sources:
  - brief:lot1
  - conception/13-icones/assets/README.md:8
  - conception/13-icones/assets/MANIFEST.yaml:154
  - conception/15-maquette.md:121
  - conception/13-icones/03-icones-ui-fonctionnelles.yaml:606
derniere_verif: 2026-10-24
---

## Décision proposée
Les icônes viennent de Lucide (`lucide-static@1.21.0`, ISC) et de deux icônes personnalisées, ICN-CAT-ARCHITECTURE et ICN-CAT-LIEU-DISPARU (DEC-11). Le nombre total d’icônes n’est pas un critère : `produit/design/ICONES.md` liste seulement celles que le MVP utilise, avec leur nom Lucide. La chaîne de confiance est : fiche d’icône (nom Lucide) puis `lucide-static@1.21.0`.

## Sources en conflit
- Décompte : 59 SVG (`assets/README.md:37`), 60 SVG (`assets/MANIFEST.yaml:4`, `:154`), 54 composants (`15-maquette.md:121`), alors que l’index parle de 37 icônes d’interface (`13-icones/00-index.yaml:216`) contre 29 dans l’inventaire de fichiers et 33 dans la maquette.
- Origine : « dessins originaux HistoLyon, aucun fichier Lucide » (`assets/README.md:8`, `:27`) contre « 48 SVG Lucide + 2 personnalisées » (`15-maquette.md:127`).
- Icône de chargement : « non définie » (`03-icones-ui-fonctionnelles.yaml:606`) alors qu’elle est définie plus haut (`loader-circle`).
- Lieu disparu : la charte dit `landmark-off` Lucide (`01-charte-graphique.yaml:300`), la fiche d’icône dit personnalisée parce que `landmark-off` renvoie une erreur dans `lucide-static@1.21.0` (`02-icones-categories.yaml:156`).

## Conséquence
Solution prudente appliquée dans ICONES.md : Lucide pour tout ce qui existe dans la version épinglée, personnalisées pour l’arche et le monument barré, aucun décompte. Les SVG du dossier de conception (« dessins originaux ») ne sont pas une source ; la maquette Figma et `lucide-static@1.21.0` le sont. Le chargement est `loader-circle`.
