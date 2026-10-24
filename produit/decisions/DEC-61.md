---
id: DEC-61
type: decision
titre: "Identifiants d’écran inexistants dans 10-composants : table ancien vers bon"
statut: mvp
liens: {}
anciens_ids: []
sources:
  - conception/07-ecrans/00-index.yaml:101
  - conception/10-composants/01-atomes.yaml:136
  - conception/10-composants/04-shell.yaml:566
derniere_verif: 2026-10-24
---

## Décision proposée
Dans `produit/`, remplacer chaque identifiant d’écran erroné de `10-composants` par l’écran existant du tableau. Les écrans écartés du MVP restent cités seulement en « Hors MVP ». Constat : 17 identifiants ne figurent pas dans l’index des écrans, plus trois motifs génériques (`E-ONBOARDING-*`, `E-PARCOURS-EN-COURS-*`, `E-PROFIL-*`).

## Sources en conflit
Index des écrans (les écrans hors MVP sont cités par leur identifiant d’index `E-…`, faute de fiche `ECR-…`) : `conception/07-ecrans/00-index.yaml:101`. Les citations erronées sont dans les `ancrage.ecrans` des quatre fichiers lus (atomes, molécules, fonctionnels, shell).

| Ancien (erroné) | Bon identifiant | Remarque |
|---|---|---|
| `E-VIEWER-3D` | ECR-PIN-CONSULTATION-3D | MVP |
| `E-CARTE-INVITATION-MICROPARCOURS` | `E-TRANSVERSES-INVITATION-MICROPARCOURS` | hors MVP |
| `E-COMMUNAUTE-COMMENTAIRES` | `E-COMMUNAUTE-REDACTION-COMMENTAIRE` | probable ; hors MVP |
| `E-COMMUNAUTE-SIGNALEMENT-PIN` | `E-COMMUNAUTE-REDACTION-SIGNALEMENT` | hors MVP |
| `E-COMMUNAUTE-RETOUR-DETAIL` | `E-COMMUNAUTE-REDACTION-RETOUR-PARCOURS` | probable ; hors MVP |
| `E-COMMUNAUTE-FILE-MODERATION` | `E-ADMIN-MODERATION-COMMUNAUTAIRE` | probable ; back-office |
| `E-COMMUNAUTE-FICHE-CONTRIBUTEUR` | aucun | pas d’écran équivalent |
| `E-ONBOARDING-PAS-1` | `E-TRANSVERSES-INDICATION-ONBOARDING` | aucun écran d’onboarding en pas ; hors MVP |
| `E-PARCOURS-CONFIRMATION-ABANDON` | ECR-TRANSVERSES-DIALOGUE-CONFIRMATION | MVP |
| `E-PARCOURS-CONFIRMATION-SUPPRESSION-PERSO` | ECR-TRANSVERSES-DIALOGUE-CONFIRMATION | hors MVP (parcours personnels) |
| `E-PROFIL-CONFIRMATION-SUPPRESSION-COMPTE` | ECR-TRANSVERSES-DIALOGUE-CONFIRMATION | hors MVP |
| `E-PROFIL-CONFIRMATION-EFFACEMENT-HISTORIQUE` | ECR-TRANSVERSES-DIALOGUE-CONFIRMATION | hors MVP |
| `E-PIN-PARTAGE` | `E-PARTAGE-CODE-VISUEL` | probable ; hors MVP |
| `E-PARCOURS-PARTAGE` | `E-PARTAGE-CODE-VISUEL` | probable ; hors MVP |
| `E-PROFIL-COMPTE` | `E-PROFIL-PARAMETRES-COMPTE` | hors MVP |
| `E-PROFIL-CONTRIBUTIONS` | `E-COMMUNAUTE-SUIVI-SOUMISSIONS` | probable ; hors MVP |
| `E-PROFIL-NOTIFICATIONS` | aucun | pas d’écran équivalent |
| `E-PARCOURS-EN-COURS-*` (motif) | ECR-PARCOURS-EN-COURS-TERRAIN (le seul du MVP) | le canapé est écarté (DEC-05) |
| `E-PROFIL-*`, `E-ONBOARDING-*` (motifs) | écrans profil et onboarding existants, tous hors MVP | |

## Conséquence
Les correspondances marquées « probable » sont des déductions d’après le nom ; elles n’affectent pas la tranche MVP (tous ces écrans sont hors MVP) et sont à confirmer à l’intégration. Seules trois lignes touchent le MVP : le viewer 3D, la confirmation d’abandon et le motif des parcours en cours.
