import 'package:api_types/generated_classes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/log/app_logger.dart';
import '../../../core/models/failure.dart';
import '../../../core/supabase/supabase_provider.dart';

export 'package:api_types/generated_classes.dart'
    show Parcours, Epoque, PROVENANCE_PARCOURS;

part 'parcours_repository.g.dart';

const _log = AppLogger('parcours');

/// Un parcours du catalogue : la ligne `parcours` (type généré) avec ses
/// époques (triées par `ordre`) et son nombre d'étapes.
final class ParcoursCatalogue {
  const ParcoursCatalogue({
    required this.parcours,
    required this.epoques,
    required this.nombreEtapes,
  });

  /// Construit depuis une ligne de la requête de [ParcoursRepository]
  /// (`parcours_epoque(epoque(*))` et `etape(count)` imbriqués).
  factory ParcoursCatalogue.depuisLigne(Map<String, dynamic> ligne) {
    final epoques = [
      for (final lien in (ligne['parcours_epoque'] as List? ?? const []))
        Epoque.fromJson(
          (lien as Map<String, dynamic>)['epoque'] as Map<String, dynamic>,
        ),
    ]..sort((a, b) => a.ordre.compareTo(b.ordre));
    final comptes = ligne['etape'] as List? ?? const [];
    final nombreEtapes = comptes.isEmpty
        ? 0
        : ((comptes.first as Map<String, dynamic>)['count'] as num).toInt();
    return ParcoursCatalogue(
      parcours: Parcours.fromJson(ligne),
      epoques: epoques,
      nombreEtapes: nombreEtapes,
    );
  }

  final Parcours parcours;
  final List<Epoque> epoques;
  final int nombreEtapes;

  bool get estCommunautaire =>
      parcours.provenance == PROVENANCE_PARCOURS.communautaire;
}

/// Lit le catalogue des parcours publiés dans Supabase (D3.2). La RLS ne
/// laisse voir au public que les parcours publiés ; le filtre `statut` le
/// garantit aussi pour un membre de l'équipe.
class ParcoursRepository {
  ParcoursRepository(this._client);

  final SupabaseClient _client;

  /// Parcours publiés : éditoriaux puis communautaires (ordre de l'enum
  /// `provenance_parcours`), puis par titre.
  Future<Result<List<ParcoursCatalogue>>> catalogue() async {
    try {
      final lignes = await _client
          .from(Parcours.table_name)
          .select('*, parcours_epoque(epoque(*)), etape(count)')
          .eq(Parcours.c_statut, 'publie')
          .order(Parcours.c_provenance, ascending: true)
          .order(Parcours.c_titre, ascending: true);
      return Ok([for (final l in lignes) ParcoursCatalogue.depuisLigne(l)]);
    } on PostgrestException catch (e, pile) {
      _log.erreur('lecture du catalogue', e, pile);
      return Err(ServeurFailure(e.message));
    } catch (e, pile) {
      _log.erreur('lecture du catalogue', e, pile);
      return Err(InconnueFailure('$e'));
    }
  }
}

@riverpod
ParcoursRepository parcoursRepository(Ref ref) =>
    ParcoursRepository(ref.watch(supabaseClientProvider));
