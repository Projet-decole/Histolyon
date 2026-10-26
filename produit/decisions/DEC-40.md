---
id: DEC-40
type: decision
titre: "Saut d’étape : un bouton sur l’écran du parcours, pas d’écran de saut"
statut: mvp
liens:
  capacites: [CAP-D3.5, CAP-D3.9]
  ecrans: [ECR-PARCOURS-EN-COURS-TERRAIN]
  flux: [FLX-C8]
anciens_ids: []
sources:
  - conception/07-ecrans/parcours/07-saut-etape.yaml:16
  - conception/06-flows/03-parcours.yaml:361
  - conception/04-donnees/03-utilisateur.yaml:352
derniere_verif: 2026-10-24
---

## Décision proposée
Au MVP, on n’écrit pas l’écran « Sélecteur de saut d’étape » (marqué « à confirmer » dans la source). On garde la fonction : un bouton « Sauter cette étape » sur l’écran du parcours en cours (ECR-PARCOURS-EN-COURS-TERRAIN). Il laisse l’étape non complétée et passe à la suivante, sans confirmation. La navigation libre se fait par « Étape suivante », « Étape précédente » et le tap dans la liste. Sauter la dernière étape termine le parcours (fin avec « X étapes vues sur Y », DEC-09).

## Sources en conflit
- DEC-09 suppose qu’une étape peut être sautée : la fonction doit exister.
- L’écran de saut d’origine (sélecteur multi-cibles, résumé d’impact) est « à confirmer », avec une confirmation non tranchée.
- La capacité d’origine veut un état « sautée » distinct ; les données n’en ont pas (étape non visitée = pas d’entrée d’historique). Retenu : « sautée » est dérivée, selon DEC-09.
- Accès au saut depuis la surface persistante : non retenu.

## Conséquence
- Solution la plus prudente : moins d’écrans, même comportement pour l’utilisateur.
- L’écran d’origine passe en S2.
- À valider par le porteur avant JAL-FU3.
