---
id: DOC-DESIGN-TOKENS
type: document
titre: "Tokens visuels : règles d’usage"
statut: mvp
liens:
  decisions: [DEC-12, DEC-81]
  questions: [QO-801]
anciens_ids: []
sources:
  - conception/12-tokens/01-couleurs.yaml:37
  - conception/12-tokens/02-typographies.yaml:38
  - conception/12-tokens/03-espace-et-forme.yaml:84
  - conception/12-tokens/04-opacites-constantes.yaml:38
  - conception/15-maquette.md:49
  - packages/design_tokens/lib/src/colors.dart:1
  - packages/design_tokens/lib/src/typography.dart:1
derniere_verif: 2026-10-24
---

# Tokens visuels : règles d’usage

Ce document porte les **règles** (rôle, usage, contraintes). Les **valeurs** (hex, px, poids, alpha) sont dans `packages/design_tokens/lib/src/*.dart`, qui fait référence (DEC-12). Ne recopiez jamais une valeur : citez l’identifiant. Dans le code, `TOK-COLOR-PRIMARY` devient `TOK_COLOR_PRIMARY`.

## Règles générales
R1. Aucune couleur, taille, rayon, ombre ou opacité en dur dans une feature : tout vient d’un token (`melos run analyze` lance `tools/check_tokens.dart`).
R2. Pas de noir pur ni de blanc pur. Le « blanc » est `TOK-COLOR-BLANC-NARRATIF`, le « noir » est `TOK-COLOR-TEXTE-PRINCIPAL`. Les ombres reprennent la teinte de l’encre brune.
R3. Toute couleur visible existe dans l’inventaire ci-dessous. Un besoin nouveau s’ajoute d’abord au package, puis ici.
R4. Une couleur n’exprime pas la catégorie d’un pin (c’est l’icône, voir ICONES.md) et il n’y a pas de couleur d’accent par époque. La provenance se lit par la couleur du pin.
R5. Pas de thème sombre : un seul mode, clair.
R6. Trois fontes, jamais plus : titres en Playfair Display, récit en Lora, interface en Inter. Fonts embarquées localement.
R7. Les espacements sont des multiples de 4 et prennent leur valeur dans les 7 tokens `TOK-SPACE-*`.
R8. Les bordures n’ont pas de token propre : 1 px en `TOK-COLOR-TEXTE-TERTIAIRE` pour un champ au repos, 1,5 px en `TOK-COLOR-PRIMARY` pour un champ actif, 1,5 px en `TOK-COLOR-FONCTIONNEL-ERREUR` pour un champ en erreur.
R9. Un composant désactivé prend `TOK-OPACITY-DESACTIVE` et bascule sa couleur vers `TOK-COLOR-TEXTE-TERTIAIRE` au lieu de garder une teinte primaire atténuée.
R10. Les modulations qui dépendent d’un état dynamique (pin hors parcours, déjà visité, hors ligne) ne sont pas des tokens statiques : voir MOUVEMENT.md.

## Familles de couleurs

## TOK-COLOR-PRIMARY — Terracotta Lyon
Couleur d’action et signature de l’app : bouton principal, chip sélectionné, indicateur de progression actif. Même valeur que `TOK-COLOR-PIN-EDITORIAL` mais rôle distinct (contextes spatiaux disjoints). Sur le parchemin, le contraste ne passe que pour les aplats, les accents et le grand texte.

## TOK-COLOR-PRIMARY-FONCE — Brique ancienne
Variante foncée : état pressé du bouton principal, titre sur image sombre.

## TOK-COLOR-PRIMARY-CLAIR — Terracotta doux
Variante claire : icône sur fond sombre.

## TOK-COLOR-FOND-PRINCIPAL — Parchemin
Fond des écrans principaux (carte, parcours, profil) et de la consultation hors image.

## TOK-COLOR-FOND-SECONDAIRE — Parchemin foncé
Fond des cartes de parcours, surfaces ponctuelles, dialogues, encarts, chips non sélectionnés.

## TOK-COLOR-FOND-TERTIAIRE — Lin
Encarts discrets et état pressé des cartes.

## TOK-COLOR-TEXTE-PRINCIPAL — Encre brune
Titres, récit et texte d’interface sur fond clair. Sert aussi de base aux ombres et aux voiles.

## TOK-COLOR-TEXTE-SECONDAIRE — Brun doux
Libellés, métadonnées, dates, sous-titres, citations.

## TOK-COLOR-TEXTE-TERTIAIRE — Sable
Placeholders, états inactifs (section de navigation non active). Contraste faible : jamais pour une information critique, basculer vers `TOK-COLOR-TEXTE-SECONDAIRE`.

## TOK-COLOR-OR-ACCENT — Or lyonnais
Filets et accents décoratifs seulement. Texte interdit (contraste insuffisant). Ne signale pas le caractère « éditorial ».

## TOK-COLOR-BLANC-NARRATIF — Blanc chaud
Texte sur fond terracotta et sur image sombre ; icône de catégorie à l’intérieur d’un pin.

## TOK-COLOR-FONCTIONNEL-SUCCES — Vert succès
Messages de succès, étape complétée.

## TOK-COLOR-FONCTIONNEL-ERREUR — Rouge erreur
Messages d’erreur, bordure de champ en erreur.

## TOK-COLOR-FONCTIONNEL-INFO — Bleu info
Liens dans le récit et indications neutres.

## TOK-COLOR-PIN-EDITORIAL — Pin éditorial
Teinte chaude de la provenance éditoriale, pour le pin, le tracé de parcours et le cluster. Au MVP tous les pins sont éditoriaux (DEC-04). Séparé de `TOK-COLOR-PRIMARY` pour pouvoir diverger plus tard.

## TOK-COLOR-PIN-COMMUNAUTAIRE — Pin communautaire
Teinte neutre de la provenance communautaire. Sans effet au MVP (pas de communauté, voir DEC-04).

## TOK-COLOR-CONTOUR-VERIFICATION — Contour de vérification
Contour **en pointillé** d’un pin ou d’un tracé communautaire en cours de vérification (INV-03). Règle prévue, sans effet au MVP.

## TOK-COLOR-OVERLAY-SOMBRE — Overlay sombre
Dégradé sombre en bas d’une image pour lire un titre posé dessus. Ne sert pas aux voiles de surface (voir `TOK-OPACITY-BACKDROP-M6` et `TOK-OPACITY-BACKDROP-M8`).

## Fontes

## TOK-FONT-TITRE-EDITORIAL — Playfair Display
Titres uniquement, jamais le texte courant. Graisses 700 et 800. Repli : Georgia, puis serif système.

## TOK-FONT-CORPS-NARRATIF — Lora
Récit long ; italique pour les citations. Graisses 400 et 600. Repli : Georgia, puis serif système.

## TOK-FONT-INTERFACE — Inter
Libellés, boutons, métadonnées, navigation. Graisses 400 et 500. Jamais pour un titre éditorial.

## Échelle typographique
Chaque texte de l’app utilise un de ces 12 tokens (fonte, taille, graisse, interligne dans le package).

## TOK-TYPO-DISPLAY-XL — Titre d’accueil et de célébration
Titre de l’écran de fin de parcours (prévu aussi pour un écran d’accueil, hors MVP). Playfair, le plus grand.

## TOK-TYPO-DISPLAY-LG — Titre d’écran narratif
Titre principal d’un pin ou d’un parcours, titre sur image.

## TOK-TYPO-DISPLAY-MD — Titre d’aperçu
Titre de l’aperçu rapide d’un pin et titres de section du récit.

## TOK-TYPO-DISPLAY-SM — Sous-titre
Sous-titres et libellé du chip d’époque sélectionné.

## TOK-TYPO-BODY-LG — Récit principal
Paragraphes du récit d’un pin, description longue d’un parcours.

## TOK-TYPO-BODY-MD — Texte court
Accroche, description courte, légende.

## TOK-TYPO-BODY-SM — Notes
Notes, légendes, sources.

## TOK-TYPO-BODY-EMPHASIS — Mise en relief
Même taille et interligne que `TOK-TYPO-BODY-LG`, graisse plus forte : un nom propre ou une date clé dans le récit.

## TOK-TYPO-UI-LG — Libellé de bouton
Libellés des boutons principaux.

## TOK-TYPO-UI-MD — Libellé de chip et badge
Chips, badges, métadonnées structurantes.

## TOK-TYPO-UI-SM — Métadonnée
Durée, distance, date, statut.

## TOK-TYPO-UI-XS — Libellé de navigation
Libellés sous les icônes des trois sections (Carte, Parcours, Profil). Taille minimale : le sens passe aussi par l’icône.

## Espacement

## TOK-SPACE-XS — 4
Écart minimal entre éléments très proches (icône et libellé d’un chip).

## TOK-SPACE-SM — 8
Écart court entre éléments groupés ; gap interne d’un bouton.

## TOK-SPACE-MD — 12
Intermédiaire : marge interne d’un encart, écart titre-description d’un item de liste.

## TOK-SPACE-LG — 16
Valeur par défaut : marge latérale des écrans, marge interne d’une carte, écart entre paragraphes.

## TOK-SPACE-XL — 24
Séparation forte entre sections d’un écran.

## TOK-SPACE-XXL — 32
Séparation majeure : sous un titre d’écran, écran de fin de parcours.

## TOK-SPACE-XXXL — 48
Cérémoniel et rare : marge centrale d’un écran de fin ou d’accueil.

## Rayons

## TOK-RADIUS-NONE — 0
Coin droit : séparateurs et filets.

## TOK-RADIUS-SM — 4
Badges, chips compacts, messages inline.

## TOK-RADIUS-MD — 8
Boutons, champs de saisie, encart « Le saviez-vous ».

## TOK-RADIUS-LG — 12
Cartes, encarts, aperçu de pin, dialogues, surfaces ponctuelles.

## TOK-RADIUS-PILL — Pilule
Chips (pilule) et formes circulaires. 9999 = rayon maximal.

## Ombres
Teinte encre brune, opacité croissante avec l’élévation.

## TOK-SHADOW-SM — Légère
Carte au repos, chip sélectionné, message éphémère.

## TOK-SHADOW-MD — Moyenne
Pin sur la carte, carte pressée, aperçu de pin.

## TOK-SHADOW-LG — Forte
Dialogue de confirmation, surfaces persistantes, surfaces ponctuelles.

## Opacités constantes

## TOK-OPACITY-BACKDROP-M6 — Voile de surface ponctuelle
Voile qui laisse le contexte visible derrière une surface ponctuelle (MOD-M6), base encre brune.

## TOK-OPACITY-BACKDROP-M8 — Voile de dialogue
Voile plus opaque pour un dialogue bloquant (MOD-M8), base encre brune.

## TOK-OPACITY-DESACTIVE — État désactivé
Opacité d’un composant entier désactivé, associée à la bascule de couleur de R9.

## TOK-OPACITY-SEPARATEUR — Séparateur léger
Filets de séparation entre éléments de liste, base encre brune.

## Écarts constatés
- Aucun écart de valeur entre les fichiers de conception et le package pour les couleurs, espacements, rayons, ombres, opacités et la typographie ; le package suit la maquette (conception/15-maquette.md:49).
- Les 3 fontes (`TOK-FONT-*`) n’ont pas de constante dans le package : le nom de fonte est écrit dans chaque style typographique. Voir QO-801.
- `TOK-OPACITY-DESACTIVE` : la conception dit 0,5 puis 0,4 en d’autres endroits ; le package et la maquette valent 0,5. Voir DEC-81.

## Hors MVP
Pas de thème sombre (R5). Les tokens de provenance communautaire et de vérification existent mais n’ont pas d’effet tant qu’il n’y a pas de communauté (DEC-04). Pas de fonte non latine (DEC-15).
