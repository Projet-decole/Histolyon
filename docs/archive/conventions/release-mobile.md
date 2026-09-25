# Release mobile

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Release mobile ». AD liée : AD-16 (trois environnements, migrations et secrets pilotés par la CI) et AD-1 (`apps/mobile` = Android).

## Convention

- La version sémantique (semver) vit dans `pubspec.yaml` (`version: X.Y.Z+N`).
- Le `build number` (`+N`) **est** le numéro de run CI — jamais incrémenté à la main.
- La clé de signature Android est un secret d'Environment GitHub, jamais committée.

## Pourquoi

Faire du numéro de run CI le build number (plutôt qu'un compteur manuel) élimine tout risque de collision ou d'oubli d'incrément avant une release — cohérent avec AD-16, où c'est la CI qui pilote la publication vers `dev`/`demo`. Garder la clé de signature en secret d'Environment (et non dans le dépôt) suit la même règle que les autres secrets (AD-16, config & secrets) : un dépôt public ou partagé ne doit jamais permettre de re-signer une release au nom du projet.

## Exemple

Un run CI numéro `842` qui construit l'APK de démo produit une version `1.3.0+842` ; la clé de signature est lue depuis le secret `ANDROID_SIGNING_KEY` de l'Environment `demo`, jamais présente dans `apps/mobile/`.
