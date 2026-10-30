# Convertir un brouillon en pin

À utiliser quand un brouillon de pin existe (texte libre, Word, SharePoint) et qu'il faut produire le fichier `content/pins/<slug>.yaml`.

**Si ton agent IA travaille dans le dépôt**, dis-lui : « Convertis ce brouillon en pin, en suivant `prompts/convertir-un-brouillon-en-pin.md` », puis colle le brouillon.

**Si ton IA n'a pas accès au dépôt**, colle-lui le texte ci-dessous, puis le contenu de `produit/contenu/GABARIT-PIN.md`, de `content/pins/cour-des-voraces.yaml` (l'exemple) et le brouillon.

---

Tu vas convertir mon brouillon en un fichier YAML de pin pour HistoLyon, en suivant le gabarit et l'exemple que je te colle. Tu transformes la forme, tu n'écris pas l'histoire à ma place.

Règles, sans exception :
1. **N'invente rien.** Ni fait, ni date, ni coordonnée, ni source, ni citation. Si une information du gabarit manque dans le brouillon (époque, catégorie, coordonnées, source), ne la devine pas : écris `# À COMPLÉTER : <ce qu'il manque>` dans le YAML et liste-le-moi à la fin.
2. **Ne réécris pas mon texte.** Garde mes mots dans `teaser`, `narration` et `post_narratif`. Tu peux corriger la typographie (guillemets « », apostrophe ’, points de suspension …, espaces insécables avant `: ; ! ?`) et rien d'autre. Si une phrase te semble contredire le guide de rédaction (`produit/contenu/GUIDE-REDACTION.md`), signale-le-moi sans la modifier.
3. **Une seule époque** (slug de `content/epoques/`), **une seule catégorie** (slug de `content/categories/`), **au moins une source** (slug de `content/sources/`). Si la source n'existe pas encore dans `content/sources/`, propose le fichier de source à créer avec sa référence ou sa cote exacte, tel que je l'ai écrite.
4. **Aucun média.** Les images, l'audio et les modèles 3D ne vont jamais dans le dépôt (DEC-03). Si mon brouillon en cite, liste-les moi à part, avec leur crédit et leur licence, sans les mettre dans le YAML.
5. **N'écris jamais** les champs `provenance`, `statut` ni les dates : ils sont gérés par les scripts. `id` : un UUID v4 nouveau. `slug` : minuscules et tirets, stable.
6. `post_narratif` contient au plus un `le_saviez_vous` ou une `citation_historique`.

Quand tu as fini :
- Donne-moi le fichier YAML complet.
- Donne-moi la liste des `À COMPLÉTER` et des remarques sur le guide.
- Donne-moi les commandes à lancer : `dart run tools/validate_content.dart`, puis `dart run tools/gen_contenu_embarque.dart` si le dépôt contient déjà ce script.

Si le brouillon est ambigu, pose une question précise au lieu de choisir.
