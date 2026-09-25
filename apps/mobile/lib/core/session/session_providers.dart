import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_providers.g.dart';

/// État de session (AD-20) : liste **fermée** de six providers. N'en ajouter
/// aucun ici sans amender AD-20 — un comportement transverse supplémentaire
/// vit dans un service de `core/`, pas dans un septième provider de session.

/// Époque actuellement sélectionnée sur le slider (identifiant, ou `null`
/// avant toute sélection).
@riverpod
class EpoqueSelectionnee extends _$EpoqueSelectionnee {
  @override
  String? build() => null;

  void definir(String? epoqueId) => state = epoqueId;
}

/// Parcours en cours (identifiant), ou `null` hors parcours.
@riverpod
class ParcoursActif extends _$ParcoursActif {
  @override
  String? build() => null;

  /// Changer de parcours (ou en sortir) invalide l'étape courante.
  void definir(String? parcoursId) {
    if (parcoursId != state) {
      ref.read(etapeCouranteProvider.notifier).definir(null);
    }
    state = parcoursId;
  }
}

/// Index de l'étape courante dans le parcours actif.
@riverpod
class EtapeCourante extends _$EtapeCourante {
  @override
  int? build() => null;

  void definir(int? index) => state = index;
}

/// Pin actuellement consulté (identifiant), ou `null`.
@riverpod
class PinCourant extends _$PinCourant {
  @override
  String? build() => null;

  void definir(String? pinId) => state = pinId;
}

/// Mode présentation sans chrome (démonstration, ex. carte projetée en classe).
@riverpod
class ModePresentation extends _$ModePresentation {
  @override
  bool build() => false;

  void basculer() => state = !state;
}

/// Narration audio en cours de lecture.
@riverpod
class LectureAudio extends _$LectureAudio {
  @override
  bool build() => false;

  void definir(bool enCours) => state = enCours;
}
