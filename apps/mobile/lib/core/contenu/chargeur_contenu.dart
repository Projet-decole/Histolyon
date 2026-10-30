import 'dart:convert';

import 'package:flutter/services.dart';

/// Chemin de l'instantané embarqué, généré par
/// `dart run tools/gen_contenu_embarque.dart` (DEC-04). Ne pas l'éditer.
const cheminContenuEmbarque = 'assets/contenu/contenu.json';

/// Le contenu embarqué est absent ou illisible. Le repository (`data/`) la
/// convertit en `Failure` ; elle ne sort jamais de `data/`.
class ContenuIndisponible implements Exception {
  const ContenuIndisponible(this.message);
  final String message;

  @override
  String toString() => 'ContenuIndisponible: $message';
}

final class EpoqueContenu {
  const EpoqueContenu({
    required this.id,
    required this.slug,
    required this.libelle,
    required this.borneDebut,
    required this.borneFin,
    required this.ordre,
  });

  factory EpoqueContenu.depuisJson(Map<String, dynamic> j) => EpoqueContenu(
    id: j['id'] as String,
    slug: j['slug'] as String,
    libelle: j['libelle'] as String,
    borneDebut: j['borne_debut'] as int,
    borneFin: j['borne_fin'] as int,
    ordre: j['ordre'] as int,
  );

  final String id;
  final String slug;
  final String libelle;
  final int borneDebut;
  final int borneFin;
  final int ordre;
}

final class CategorieContenu {
  const CategorieContenu({
    required this.id,
    required this.slug,
    required this.libelle,
    required this.ordre,
  });

  factory CategorieContenu.depuisJson(Map<String, dynamic> j) =>
      CategorieContenu(
        id: j['id'] as String,
        slug: j['slug'] as String,
        libelle: j['libelle'] as String,
        ordre: j['ordre'] as int,
      );

  final String id;
  final String slug;
  final String libelle;
  final int ordre;
}

final class SourceContenu {
  const SourceContenu({
    required this.id,
    required this.slug,
    required this.type,
    required this.reference,
    required this.credit,
    this.lien,
    this.description,
  });

  factory SourceContenu.depuisJson(Map<String, dynamic> j) => SourceContenu(
    id: j['id'] as String,
    slug: j['slug'] as String,
    type: j['type'] as String,
    reference: j['reference'] as String,
    credit: j['credit'] as String,
    lien: j['lien'] as String?,
    description: j['description'] as String?,
  );

  final String id;
  final String slug;
  final String type;
  final String reference;
  final String credit;
  final String? lien;
  final String? description;
}

final class PointContenu {
  const PointContenu({required this.lat, required this.lon});

  final double lat;
  final double lon;
}

/// Encart texte après le récit (« Le saviez-vous »…).
final class EncartContenu {
  const EncartContenu({required this.type, required this.texte});

  final String type;
  final String texte;
}

final class PinContenu {
  const PinContenu({
    required this.id,
    required this.slug,
    required this.titre,
    required this.categorie,
    required this.epoques,
    required this.sources,
    required this.localisation,
    required this.teaser,
    required this.narration,
    required this.postNarratif,
  });

  factory PinContenu.depuisJson(Map<String, dynamic> j) {
    final narratif = j['contenu_narratif'] as Map<String, dynamic>;
    final lieu = j['localisation'] as Map<String, dynamic>?;
    return PinContenu(
      id: j['id'] as String,
      slug: j['slug'] as String,
      titre: j['titre'] as String,
      categorie: j['categorie'] as String,
      epoques: List<String>.from(j['epoques'] as List),
      sources: List<String>.from(j['sources'] as List),
      localisation: lieu == null
          ? null
          : PointContenu(
              lat: (lieu['lat'] as num).toDouble(),
              lon: (lieu['lon'] as num).toDouble(),
            ),
      teaser: narratif['teaser'] as String,
      narration: narratif['narration'] as String,
      postNarratif: [
        for (final e in (narratif['post_narratif'] as List? ?? const []))
          EncartContenu(
            type: (e as Map<String, dynamic>)['type'] as String,
            texte: e['texte'] as String,
          ),
      ],
    );
  }

  final String id;
  final String slug;
  final String titre;

  /// Slug de la catégorie.
  final String categorie;

  /// Slugs des époques (une seule au MVP, DEC-02).
  final List<String> epoques;

  /// Slugs des sources.
  final List<String> sources;

  /// Absente : le pin existe mais ne s'affiche pas sur la carte (INV-09).
  final PointContenu? localisation;
  final String teaser;
  final String narration;
  final List<EncartContenu> postNarratif;
}

/// L'instantané complet : ce que l'app sait de Lyon au MVP.
final class ContenuEmbarque {
  const ContenuEmbarque({
    required this.epoques,
    required this.categories,
    required this.sources,
    required this.pins,
  });

  factory ContenuEmbarque.depuisJson(String texte) {
    final j = jsonDecode(texte) as Map<String, dynamic>;
    List<T> liste<T>(String cle, T Function(Map<String, dynamic>) lire) => [
      for (final e in j[cle] as List) lire(e as Map<String, dynamic>),
    ];
    return ContenuEmbarque(
      epoques: liste('epoques', EpoqueContenu.depuisJson),
      categories: liste('categories', CategorieContenu.depuisJson),
      sources: liste('sources', SourceContenu.depuisJson),
      pins: liste('pins', PinContenu.depuisJson),
    );
  }

  final List<EpoqueContenu> epoques;
  final List<CategorieContenu> categories;
  final List<SourceContenu> sources;
  final List<PinContenu> pins;
}

/// Lit l'instantané embarqué dans les ressources de l'app. Seul le chargeur
/// connaît le format du fichier ; les repositories (`data/`) l'adaptent.
class ChargeurContenu {
  ChargeurContenu({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  ContenuEmbarque? _cache;

  /// Charge une fois, puis sert le cache. Lève [ContenuIndisponible].
  Future<ContenuEmbarque> charger() async {
    final cache = _cache;
    if (cache != null) return cache;
    try {
      final texte = await _bundle.loadString(cheminContenuEmbarque);
      return _cache = ContenuEmbarque.depuisJson(texte);
    } catch (e) {
      throw ContenuIndisponible('contenu embarqué illisible : $e');
    }
  }
}
