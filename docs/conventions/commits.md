# Commits

**Source :** [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md) — table `Consistency Conventions`, ligne « Commits ». AD liée : AD-12 (« Une story = 1 issue GitHub = 1 branche `story/<ID>-<slug>` = 1 PR »).

## Convention

- Format Conventional Commits : `type(scope): sujet`.
- `scope` est le slug de la feature concernée (voir convention « Langue des identifiants »), ou `supabase` / `content` / `docs` pour ce qui n'est pas une feature d'app.
- Le corps du message cite l'issue liée : `#<issue>`.

## Pourquoi

AD-12 fait de la story (donc de l'issue GitHub) l'unité de travail traçable ; citer `#<issue>` dans chaque commit permet de retrouver, depuis GitHub, tout le travail rattaché à une story sans dépendre du seul titre de la PR. Le `scope` = slug de feature garde une correspondance directe avec l'arborescence du code (AD-5) : `git log --grep` ou un filtre par scope retrouve tout l'historique d'une feature sans ambiguïté de nommage.

## Exemple

```
feat(proximite): geofencer les pins connus en arrière-plan

Ajoute le service core/location et la RPC de lecture des pins proches.

#57
```
