import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'chargeur_contenu.dart';

part 'chargeur_contenu_provider.g.dart';

/// Chargeur unique du contenu embarqué (DEC-04), lu par les couches `data/`.
/// En test : `chargeurContenuProvider.overrideWithValue(...)`.
@Riverpod(keepAlive: true)
ChargeurContenu chargeurContenu(Ref ref) => ChargeurContenu();
