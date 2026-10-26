---
id: DOC-TRI-COMP
type: document
titre: "Tri des composants (groupe COMP)"
statut: mvp
sources: [brief:lot1]
derniere_verif: 2026-10-24
---

# Tri des composants

Source : `conception/10-composants/` fichiers atomes, molécules, fonctionnels, shell (le back-office n’est pas lu). 114 composants définis : 48 écrits, 25 neutralisés (hors MVP, non écrits, cités en « Hors MVP »), 41 hors périmètre (pas d’ancrage MVP). Règle : un composant est écrit s’il est ancré dans un écran MVP, dans la liste explicite du brief ou dans la fermeture de composition des composants écrits. Les règles fonctionnelles de chaque fiche sont reprises dans `COMP-…` (pas de numéro R propre : les composants portent des états et variantes, pas de règles numérotées).

Légende : E = écrit ; N = neutralisé (lié à une capacité écartée) ; H = hors périmètre (aucun écran MVP, écarté sans capacité nommée).

| Ancien id | Décision | Raison / fiche |
|---|---|---|
| comp-alerte-proximite | N | proximité (DEC-05) |
| comp-apercu-rapide-pin | E | COMP-APERCU-RAPIDE-PIN |
| comp-avant-apres | N | avant/après (DEC-03) |
| comp-avatar | H | profil et compte, hors tranche |
| comp-backdrop | E | COMP-BACKDROP |
| comp-badge-nombre | E | COMP-BADGE-NOMBRE |
| comp-badge-statut | E | COMP-BADGE-STATUT |
| comp-bandeau-information-offline | E | COMP-BANDEAU-INFORMATION-OFFLINE |
| comp-barre-filtres | H | recherche et catalogue, hors tranche |
| comp-bloc-sources | E | COMP-BLOC-SOURCES |
| comp-button-back | E | COMP-BUTTON-BACK |
| comp-button-fab-creation | H | création de parcours personnel, hors tranche |
| comp-button-fermeture-overlay | E | COMP-BUTTON-FERMETURE-OVERLAY |
| comp-button-play-audio | N | audio |
| comp-button-primary | E | COMP-BUTTON-PRIMARY |
| comp-button-secondary | E | COMP-BUTTON-SECONDARY |
| comp-button-tertiary | E | COMP-BUTTON-TERTIARY |
| comp-camera-ar | N | AR, jamais avant le rendu |
| comp-card-parcours-compact | H | catalogue, favoris, historique hors tranche |
| comp-card-parcours-large | E | COMP-CARD-PARCOURS-LARGE |
| comp-carousel | N | carrousel d’archives (DEC-03) |
| comp-carte | E | COMP-CARTE |
| comp-champ-saisie-date | H | formulaires, hors tranche |
| comp-champ-saisie-lieu | H | formulaires, hors tranche |
| comp-champ-saisie-nombre | H | formulaires, hors tranche |
| comp-champ-saisie-textarea | H | formulaires, hors tranche |
| comp-champ-saisie-texte | H | formulaires et recherche, hors tranche |
| comp-chip-categorie | E | COMP-CHIP-CATEGORIE |
| comp-chip-couche-carte | H | filtres de couches, hors tranche |
| comp-chip-epoque | E | COMP-CHIP-EPOQUE |
| comp-chip-filtre | H | recherche, hors tranche |
| comp-citation | E | COMP-CITATION |
| comp-cluster-densite | E | COMP-CLUSTER-DENSITE |
| comp-compteur-statistique | N | statistiques |
| comp-controle-favori | N | favori |
| comp-controle-partage | N | partage |
| comp-controle-signalement | N | signalement |
| comp-dialogue-confirmation | E | COMP-DIALOGUE-CONFIRMATION |
| comp-dialogue-permission | N | permission (DEC-05) |
| comp-encart-information | E | COMP-ENCART-INFORMATION |
| comp-enigme | N | énigme (DEC-03) |
| comp-espaceur | H | transverse sans écran cité ; remplacé par les tokens d’espacement |
| comp-filtres-couches | H | filtres de couches, hors tranche |
| comp-formulaire-connexion-compte | H | comptes, S2 |
| comp-formulaire-creation-compte | H | comptes, S2 |
| comp-formulaire-creation-parcours | H | parcours personnels, hors tranche |
| comp-formulaire-saisie-pin | H | contribution communautaire, S2 |
| comp-frise-chronologique | N | frise (DEC-02, DEC-03) |
| comp-grid-recherche | H | recherche et catalogue, hors tranche |
| comp-header-retour-titre | E | COMP-HEADER-RETOUR-TITRE |
| comp-header-retour-titre-action | E | COMP-HEADER-RETOUR-TITRE-ACTION |
| comp-header-titre-action | H | en-tête des sections Parcours et Profil, hors tranche |
| comp-icone | E | COMP-ICONE |
| comp-image-avatar-small | E | COMP-IMAGE-AVATAR-SMALL |
| comp-image-hero | E | COMP-IMAGE-HERO |
| comp-indicateur-chargement | H | transverse sans écran cité |
| comp-indicateur-permission | N | permission |
| comp-indicateur-progression | E | COMP-INDICATEUR-PROGRESSION |
| comp-indication-onboarding | N | onboarding |
| comp-info-progress-etape | E | COMP-INFO-PROGRESS-ETAPE |
| comp-invitation-microparcours | H | écran hors MVP |
| comp-item-commentaire | N | commentaires |
| comp-item-historique-visite | H | historique, profil hors tranche |
| comp-item-liste-etape | E | COMP-ITEM-LISTE-ETAPE |
| comp-item-liste-parcours-simple | H | catalogue et profil, hors tranche |
| comp-item-liste-pin-apercu | H | recherche et favoris, hors tranche |
| comp-item-liste-simple | H | paramètres, hors tranche |
| comp-layout-carte-principale | E | COMP-LAYOUT-CARTE-PRINCIPALE, DEC-60 |
| comp-layout-consultation-pin-approfondie | E | COMP-LAYOUT-CONSULTATION-PIN-APPROFONDIE, DEC-60 |
| comp-layout-parcours | H | DEC-60 |
| comp-layout-profil | H | DEC-60 |
| comp-lecteur-audio | N | audio |
| comp-lecteur-video | N | vidéo |
| comp-libelle-bouton | E | COMP-LIBELLE-BOUTON |
| comp-libelle-chip | E | COMP-LIBELLE-CHIP |
| comp-libelle-texte | E | COMP-LIBELLE-TEXTE |
| comp-lien-texte | E | COMP-LIEN-TEXTE |
| comp-lien-universel-qr | N | partage |
| comp-mention-anonymat | N | signalement |
| comp-message-ephemere | E | COMP-MESSAGE-EPHEMERE |
| comp-message-erreur-inline | H | formulaires, hors tranche |
| comp-message-success-inline | H | formulaires, hors tranche |
| comp-page-indicator | N | carrousel et onboarding |
| comp-pin | E | COMP-PIN |
| comp-puzzle | N | puzzle (DEC-03) |
| comp-quiz | N | quiz (DEC-03) |
| comp-rangee-favori | H | profil, favori |
| comp-rangee-historique | H | profil, historique |
| comp-rangee-profil-action | H | profil |
| comp-recherche-surface | H | recherche, hors tranche |
| comp-saviez-vous | E | COMP-SAVIEZ-VOUS |
| comp-selecteur-section-principale | E | COMP-SELECTEUR-SECTION-PRINCIPALE |
| comp-separateur | H | transverse sans écran cité ; trait d’opacité TOK-OPACITY-SEPARATEUR |
| comp-slider-epoque | E | COMP-SLIDER-EPOQUE |
| comp-status-pin-verification | E | COMP-STATUS-PIN-VERIFICATION (QO-506) |
| comp-surface-persistante-audio | N | audio |
| comp-surface-persistante-parcours | E | COMP-SURFACE-PERSISTANTE-PARCOURS |
| comp-surface-ponctuelle-filtres-couches | H | absorbée par comp-filtres-couches, hors tranche |
| comp-surface-ponctuelle-filtres-parcours | H | filtres du catalogue, hors tranche |
| comp-surface-ponctuelle-lancement-parcours | H | choix de mode écarté (DEC-05) |
| comp-surface-ponctuelle-recherche | H | recherche, hors tranche |
| comp-surface-ponctuelle-saut-etape | H | écran hors tranche |
| comp-tag | E | COMP-TAG (QO-504) |
| comp-tag-categorie | E | COMP-TAG-CATEGORIE (QO-505) |
| comp-tag-provenance | E | COMP-TAG-PROVENANCE |
| comp-toggle-switch | H | paramètres, hors tranche |
| comp-trace-parcours | E | COMP-TRACE-PARCOURS |
| comp-viewer-3d | E | COMP-VIEWER-3D |
| comp-vignette-pin | E | COMP-VIGNETTE-PIN |
| comp-zone-commentaires | N | commentaires |
| comp-zone-narration | E | COMP-ZONE-NARRATION |
| comp-zone-post-narrative | N | post-narratif (DEC-03) |
| comp-zone-sources | E | COMP-ZONE-SOURCES |
| comp-zone-vide | H | états vides de listes hors tranche |

## Défauts de source traités
- Identifiants d’écran erronés : DEC-61.
- Composants cités sans définition : DEC-62.
- Layouts « supprimés de Figma » : DEC-60.
- Écart voile Figma et tokens d’opacité : QO-512.
- Aucun nœud Figma n’est référencé dans les quatre fichiers : toutes les fiches portent « aucun nœud référencé ».
