---
id: DOC-INVARIANTS
type: document
titre: "Invariants de données du MVP"
statut: mvp
anciens_ids: [I1, I3, I4, I6, I7, I8, I9]
sources:
  - conception/04-donnees/00-index.yaml:117
  - conception/04-donnees/00-index.yaml:155
  - conception/04-donnees/00-index.yaml:177
  - conception/04-donnees/00-index.yaml:194
  - conception/04-donnees/00-index.yaml:213
  - conception/04-donnees/00-index.yaml:223
  - conception/04-donnees/00-index.yaml:232
derniere_verif: 2026-10-24
---

Ces règles valent quel que soit le stockage. Les invariants I2 (compte requis pour publier), I5 (anonymat du signaleur) et I10 (promotion d’un pin communautaire) ne sont pas repris au MVP : voir DOC-TRI-DONNEES.

## INV-01 — Identité civile jamais collectée
**Énoncé.** Aucune entité ne stocke nom, prénom, date de naissance, adresse postale ni numéro de téléphone. Le seul identifiant d’un utilisateur au MVP est l’identifiant anonyme du profil local.
**Portée.** ENT-PROFIL, ENT-HISTORIQUE-DE-VISITE ; signatures éditoriales (crédit collectif, jamais une personne civile) dans ENT-PARCOURS.
**Vérification.** Revue des schémas : aucune colonne d’identité civile ; aucun identifiant utilisateur dans les journaux de l’app.

## INV-03 — Modération avant visibilité des contributions communautaires
**Énoncé.** Aucune contribution communautaire n’est visible sans passer par la modération. Au MVP il n’y a aucune contribution communautaire : seuls des pins et parcours éditoriaux, déjà publiés, sont dans l’instantané (DEC-04).
**Portée.** ENT-PIN, ENT-PARCOURS (provenance `communautaire`), hors MVP.
**Vérification.** L’instantané ne contient que des objets de provenance `editorial`.

## INV-04 — Sources obligatoires pour valider
**Énoncé.** Un pin ne peut atteindre `valide` sans au moins une source rattachée. Un contenu sans source reste brouillon.
**Portée.** ENT-PIN, ENT-SOURCE ; par analogie ENT-MODELE-3D (≥ 1 source).
**Vérification.** La RPC `pin_valider` refuse un pin sans source ; test pgTAP correspondant. Contrôle du contenu : chaque pin de `content/pins/` cite au moins une source.

## INV-06 — Profil anonyme strictement local
**Énoncé.** Les données du profil (préférences, historique) restent sur le terminal. Aucune synchronisation. Il n’y a pas de compte au MVP.
**Portée.** ENT-PROFIL, ENT-HISTORIQUE-DE-VISITE.
**Vérification.** Ces données n’existent que dans la base locale Drift ; aucun appel réseau ne les envoie ; pas de SDK d’analytics.

## INV-07 — Catalogues Catégorie et Époque ouverts
**Énoncé.** Catégories et époques sont des catalogues ouverts : on y ajoute, on n’archive pas. Les identifiants (slugs) restent stables et uniques.
**Portée.** ENT-CATEGORIE, ENT-EPOQUE.
**Vérification.** Unicité du `slug` en base ; aucun statut ni suppression sur ces tables.

## INV-08 — Multi-époques admis dans le modèle
**Énoncé.** Un pin et un parcours peuvent être liés à plusieurs époques (n-n). Au MVP, un pin a exactement une époque et un seul récit (DEC-02) ; un parcours a au moins une époque.
**Portée.** ENT-PIN, ENT-PARCOURS, ENT-EPOQUE.
**Vérification.** Pas de contrainte qui interdise la liaison n-n (`pin_epoque`, `parcours_epoque`). Contrôle du contenu MVP : un pin = une époque.

## INV-09 — Pin localisé pour l’affichage cartographique
**Énoncé.** Un pin sans coordonnées existe mais ne s’affiche pas sur la carte. Il reste accessible hors carte.
**Portée.** ENT-PIN, ENT-ETAPE (un pin sans point n’a pas de repère sur la carte).
**Vérification.** La requête qui alimente la carte exclut les pins dont `localisation` est nulle ; test de widget ou de domaine.
