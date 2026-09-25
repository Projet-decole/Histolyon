# Refus hérités de l'essence

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Refus hérités de l'essence ». Source spine : frontmatter `sources: conception/01-essence.yaml` et contexte du porteur (contraintes 3.1–3.3, attentes 2.1–2.4, `.memlog.md`).

## Convention

Quatre refus posés dès l'essence du produit, à ne pas réintroduire sans amendement :

- pas de thème sombre ;
- pas de guidage turn-by-turn (pas de navigation pas-à-pas façon GPS) ;
- pas d'inscription obligatoire (l'app s'utilise sans Compte, cf. AD-4 « Profil sans Compte ») ;
- pas de notification de proximité **par défaut** (opt-in explicite si jamais activée, cf. D4 et AD-9/AD-20).

## Pourquoi

Ces refus viennent du document d'essence du produit (`conception/01-essence.yaml`), cité comme source de la spine elle-même, et du contexte du porteur. Ils ne sont pas des oublis à combler au fil des stories : une feature qui ajoute un thème sombre, une inscription forcée avant usage, ou une notification de proximité activée par défaut contredit une décision produit déjà prise en amont de l'architecture, et doit repasser par un amendement plutôt que par une implémentation locale.

## Exemple

Une story « ajouter les réglages de notification » peut ajouter un interrupteur **désactivé par défaut** pour les notifications de proximité — jamais activé par défaut. Une story « mode sombre » proposée en cours de route est refusée en l'état et redirigée vers un amendement d'AD si le porteur veut vraiment rouvrir la question.
