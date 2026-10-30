import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/contenu/chargeur_contenu.dart';
import '../../../core/contenu/chargeur_contenu_provider.dart';
import '../../../core/log/app_logger.dart';
import '../../../core/models/failure.dart';

export '../../../core/contenu/chargeur_contenu.dart'
    show PointContenu, SourceContenu, EncartContenu;

part 'pins_repository.g.dart';

const _log = AppLogger('pins');

/// Un pin tel que la feature le lit : catégorie en libellé, sources résolues.
final class Pin {
  const Pin({
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

  final String id;
  final String slug;
  final String titre;

  /// Libellé de la catégorie (ex. « Anecdote »).
  final String categorie;

  /// Slugs des époques.
  final List<String> epoques;
  final List<SourceContenu> sources;

  /// Absente : le pin n'est pas affiché sur la carte (INV-09).
  final PointContenu? localisation;
  final String teaser;
  final String narration;
  final List<EncartContenu> postNarratif;
}

/// Lit les pins dans le contenu embarqué (DEC-04). Un pin sans catégorie ou
/// sans époque connue est écarté (CAP-D2.1 R1).
class PinsRepository {
  PinsRepository(this._chargeur);

  final ChargeurContenu _chargeur;

  Future<Result<List<Pin>>> pinsParEpoque(String epoqueSlug) async {
    try {
      final contenu = await _chargeur.charger();
      final pins = [
        for (final p in contenu.pins)
          if (p.epoques.contains(epoqueSlug)) ?_adapter(p, contenu),
      ];
      return Ok(pins);
    } catch (e, pile) {
      return _echec(e, pile);
    }
  }

  Future<Result<Pin>> pinParSlug(String slug) async {
    try {
      final contenu = await _chargeur.charger();
      for (final p in contenu.pins) {
        if (p.slug != slug) continue;
        final pin = _adapter(p, contenu);
        if (pin != null) return Ok(pin);
      }
      return Err(ValidationFailure("Pin introuvable : '$slug'"));
    } catch (e, pile) {
      return _echec(e, pile);
    }
  }

  Pin? _adapter(PinContenu p, ContenuEmbarque contenu) {
    final categorie = contenu.categories
        .where((c) => c.slug == p.categorie)
        .firstOrNull;
    final epoqueConnue = p.epoques.any(
      (s) => contenu.epoques.any((e) => e.slug == s),
    );
    if (categorie == null || !epoqueConnue) return null;
    return Pin(
      id: p.id,
      slug: p.slug,
      titre: p.titre,
      categorie: categorie.libelle,
      epoques: p.epoques,
      sources: [
        for (final s in p.sources)
          ?contenu.sources.where((x) => x.slug == s).firstOrNull,
      ],
      localisation: p.localisation,
      teaser: p.teaser,
      narration: p.narration,
      postNarratif: p.postNarratif,
    );
  }

  Result<T> _echec<T>(Object e, StackTrace pile) {
    _log.erreur('lecture du contenu embarqué', e, pile);
    return Err(InconnueFailure('$e'));
  }
}

@riverpod
PinsRepository pinsRepository(Ref ref) =>
    PinsRepository(ref.watch(chargeurContenuProvider));
