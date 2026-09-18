# Usage de l'IA

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Usage de l'IA ». AD liée : AD-15 (architecture documentaire — `prompts/` contient les prompts portables de l'équipe).

## Convention

- Chaque PR déclare l'assistance IA reçue : quel outil, ce qui a été généré (le gabarit de PR, `PULL_REQUEST_TEMPLATE.md`, a un champ dédié).
- Une relecture humaine est obligatoire avant fusion, quelle que soit l'origine du code (IA ou non).
- Les prompts utilisés en équipe sont versionnés dans `prompts/`, pas gardés dans l'historique de chat de chacun.

## Pourquoi

AD-15 fixe que `prompts/` contient « les prompts portables (dev-story, review, découpe) collables dans toute IA et une checklist "sans IA" » : verser les prompts dans le dépôt (plutôt que les garder dans un outil individuel) est ce qui rend l'assistance IA traçable et reproductible par n'importe quel membre de l'équipe, y compris ceux qui n'ont pas accès au même outil. Déclarer l'assistance IA par PR et exiger une relecture humaine maintient la responsabilité du contenu fusionné sur `main` (cohérent avec AD-13, trunk-based avec relecture obligatoire) même quand une partie du code vient d'un agent.

## Exemple

Le champ « Assistance IA » du gabarit de PR est rempli avec : « Claude Code (Sonnet), squelette de la feature `proximite` généré puis retouché à la main sur les policies RLS ». Le prompt dev-story utilisé est celui de `prompts/dev-story.md`, pas une variante gardée uniquement dans l'historique local de l'auteur.
