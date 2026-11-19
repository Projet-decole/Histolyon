import 'package:mobile/features/parcours/data/parcours_repository.dart';

/// Ligne telle que la renvoie la requête du catalogue (PostgREST).
Map<String, dynamic> ligneParcours({
  required String slug,
  required String titre,
  String provenance = 'editorial',
  int? dureeMinutes = 90,
  int? distanceMetres = 2400,
  int etapes = 5,
  List<(String, String, int)> epoques = const [
    ('xixe-siecle', 'XIXe siècle', 7),
  ],
}) => {
  'id': 'id-$slug',
  'slug': slug,
  'titre': titre,
  'provenance': provenance,
  'statut': 'publie',
  'teaser_narratif': 'Teaser de $titre',
  'conclusion_narrative': null,
  'signature_editoriale': null,
  'auteur_communautaire_id': null,
  'badge_id': null,
  'image_ouverture_media_id': null,
  'duree_estimee_minutes': dureeMinutes,
  'distance_estimee_metres': distanceMetres,
  'densite': 'intermediaire',
  'retours_actifs': true,
  'created_at': '2026-11-01T10:00:00Z',
  'updated_at': '2026-11-01T10:00:00Z',
  'parcours_epoque': [
    for (final (s, libelle, ordre) in epoques)
      {
        'epoque': {
          'id': 'id-$s',
          'slug': s,
          'libelle': libelle,
          'borne_debut': 1800,
          'borne_fin': 1900,
          'ordre': ordre,
          'created_at': '2026-11-01T10:00:00Z',
        },
      },
  ],
  'etape': [
    {'count': etapes},
  ],
};

ParcoursCatalogue parcoursFactice({
  required String slug,
  required String titre,
  String provenance = 'editorial',
  int? dureeMinutes = 90,
  int? distanceMetres = 2400,
  int etapes = 5,
}) => ParcoursCatalogue.depuisLigne(
  ligneParcours(
    slug: slug,
    titre: titre,
    provenance: provenance,
    dureeMinutes: dureeMinutes,
    distanceMetres: distanceMetres,
    etapes: etapes,
  ),
);
