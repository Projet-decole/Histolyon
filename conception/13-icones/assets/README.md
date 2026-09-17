# HistoLyon — Assets icônes (palier 13)

Ce dossier contient les fichiers SVG des icônes inventoriées au palier 13. Les
sources YAML sont dans le dossier parent (`13-icones/`).

## Production

Les icônes sont dessinées originalement par l'équipe HistoLyon en cohérence
stricte avec la charte `01-charte-graphique.yaml` :

- Style monoline outlined strict (pas de fill)
- Grille technique 24×24 (`viewBox="0 0 24 24"`)
- Stroke 1.5 (ou 2 pour les versions catégories XS 14×14, cf. décision D10)
- Round caps (`stroke-linecap="round"`, `stroke-linejoin="round"`)
- `fill="none"` systématique
- `stroke="currentColor"` pour héritage des tokens couleur palier 12

## Inspiration stylistique

La charte palier 13 (décision D4) adopte **Lucide** (https://lucide.dev, ISC
License) comme référence stylistique — convention de stroke, grille 24×24,
round caps, métaphores UX universelles. Les SVG de ce dossier sont des
**dessins originaux HistoLyon** respectant ces conventions, pas des copies
des fichiers Lucide.

Lucide ISC License — Copyright (c) for the original Lucide project belongs
to its contributors and is preserved at the source. Aucun fichier Lucide
n'est reproduit ici ; les conventions visuelles UX universelles (cœur pour
favori, loupe pour recherche, etc.) sont des archétypes graphiques
non-copyrightables que cette charte applique selon ses propres règles.

## Organisation

```
assets/
├── README.md                  ← ce fichier
├── MANIFEST.yaml              ← inventaire des 59 SVG cibles avec statut
├── categories/                ← 11 SVG 24×24 catégories Pin
│   └── 14/                    ← 11 SVG 14×14 dédiés (D10 optical correction)
├── ui/                        ← 28 SVG icônes UI fonctionnelles
└── back-office/               ← 9 SVG icônes admin desktop
```

## Convention de dénomination

- Fichier : kebab-case correspondant au champ `nom_palier_13` de chaque fiche
  (ex. `navigation-retour.svg`, `controle-favori.svg`)
- Le chemin de sortie de chaque SVG est défini dans le champ
  `fichier_svg_attendu` de la fiche YAML correspondante.

## Mise à jour

Toute modification d'un SVG (changement de tracé, ajustement) est tracée :
1. Dans le `MANIFEST.yaml` (statut, date)
2. Dans le commit Git associé
3. Si la modification structurelle dépasse l'optimisation, dans le changelog
   de la fiche YAML correspondante.
