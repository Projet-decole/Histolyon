import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/failure.dart';
import '../data/parcours_repository.dart';

export '../data/parcours_repository.dart'
    show ParcoursCatalogue, Parcours, Epoque, PROVENANCE_PARCOURS;

part 'catalogue_provider.g.dart';

/// Catalogue des parcours publiés (D3.2).
@riverpod
Future<Result<List<ParcoursCatalogue>>> catalogue(Ref ref) =>
    ref.watch(parcoursRepositoryProvider).catalogue();
