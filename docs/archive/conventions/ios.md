# iOS

**Source :** réunion d'équipe du 2026-09-22 (`docs/DECISIONS.md`, Phase 2) — organisation validée avec code partagé pour Android et iOS, sans licence développeur Apple payante (donc sans publication ni test réel sur iOS pour l'instant).

## Convention

- Le code des features (`domain/`, `data/`, la majorité de `presentation/`) reste multiplateforme par construction : Flutter, pas de code spécifique à une plateforme sans raison documentée.
- Avant d'ajouter une dépendance ou un appel qui n'existe que côté Android (permissions, notifications, signature, plugin natif sans équivalent iOS documenté), vérifier qu'un équivalent iOS existe dans la documentation du package. Si aucun équivalent n'est confirmé, documenter la dette dans un commentaire `// DETTE-IOS: <quoi, pourquoi>` à l'endroit concerné et lister le fichier ici.
- N'écris jamais de code qui suppose implicitement Android (ex. chemins de fichiers, permissions) sans passer par une abstraction que Flutter gère déjà nativement pour les deux plateformes.

## Pourquoi

Sans Mac ni licence Apple, rien de spécifique à iOS ne peut être compilé ni testé avant qu'un Mac + une licence apparaissent (`docs/ARCHITECTURE-SPINE.md`, Deferred). Le risque n'est pas dans le code Flutter générique (déjà portable), mais dans les dépendances ou appels Android-only ajoutés sans y penser, invisibles jusqu'au jour où quelqu'un essaie de compiler pour iOS — où ils se découvrent tous d'un coup, potentiellement en bloc de retard. Documenter la dette au fil de l'eau (`// DETTE-IOS:`) la rend visible et priorisable plutôt que découverte en une fois.

## Exemple

Un plugin de notification qui n'expose une API que pour Android FCM sans mode APNs documenté : soit on choisit un plugin multiplateforme équivalent (ex. `firebase_messaging`, qui gère les deux), soit on l'utilise quand même en commentant `// DETTE-IOS: notification-service n'a pas d'implémentation APNs confirmée, à vérifier avant tout build iOS` et en le référençant ici.
