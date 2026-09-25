// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// État de session (AD-20) : liste **fermée** de six providers. N'en ajouter
/// aucun ici sans amender AD-20 — un comportement transverse supplémentaire
/// vit dans un service de `core/`, pas dans un septième provider de session.
/// Époque actuellement sélectionnée sur le slider (identifiant, ou `null`
/// avant toute sélection).

@ProviderFor(EpoqueSelectionnee)
final epoqueSelectionneeProvider = EpoqueSelectionneeProvider._();

/// État de session (AD-20) : liste **fermée** de six providers. N'en ajouter
/// aucun ici sans amender AD-20 — un comportement transverse supplémentaire
/// vit dans un service de `core/`, pas dans un septième provider de session.
/// Époque actuellement sélectionnée sur le slider (identifiant, ou `null`
/// avant toute sélection).
final class EpoqueSelectionneeProvider
    extends $NotifierProvider<EpoqueSelectionnee, String?> {
  /// État de session (AD-20) : liste **fermée** de six providers. N'en ajouter
  /// aucun ici sans amender AD-20 — un comportement transverse supplémentaire
  /// vit dans un service de `core/`, pas dans un septième provider de session.
  /// Époque actuellement sélectionnée sur le slider (identifiant, ou `null`
  /// avant toute sélection).
  EpoqueSelectionneeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'epoqueSelectionneeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$epoqueSelectionneeHash();

  @$internal
  @override
  EpoqueSelectionnee create() => EpoqueSelectionnee();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$epoqueSelectionneeHash() =>
    r'9a8820fe9a331938d291c5b04fff1c9a71ae1342';

/// État de session (AD-20) : liste **fermée** de six providers. N'en ajouter
/// aucun ici sans amender AD-20 — un comportement transverse supplémentaire
/// vit dans un service de `core/`, pas dans un septième provider de session.
/// Époque actuellement sélectionnée sur le slider (identifiant, ou `null`
/// avant toute sélection).

abstract class _$EpoqueSelectionnee extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Parcours en cours (identifiant), ou `null` hors parcours.

@ProviderFor(ParcoursActif)
final parcoursActifProvider = ParcoursActifProvider._();

/// Parcours en cours (identifiant), ou `null` hors parcours.
final class ParcoursActifProvider
    extends $NotifierProvider<ParcoursActif, String?> {
  /// Parcours en cours (identifiant), ou `null` hors parcours.
  ParcoursActifProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parcoursActifProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parcoursActifHash();

  @$internal
  @override
  ParcoursActif create() => ParcoursActif();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$parcoursActifHash() => r'1d4796c7374336fa0f4c16059e36e743fa6bd27f';

/// Parcours en cours (identifiant), ou `null` hors parcours.

abstract class _$ParcoursActif extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Index de l'étape courante dans le parcours actif.

@ProviderFor(EtapeCourante)
final etapeCouranteProvider = EtapeCouranteProvider._();

/// Index de l'étape courante dans le parcours actif.
final class EtapeCouranteProvider
    extends $NotifierProvider<EtapeCourante, int?> {
  /// Index de l'étape courante dans le parcours actif.
  EtapeCouranteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'etapeCouranteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$etapeCouranteHash();

  @$internal
  @override
  EtapeCourante create() => EtapeCourante();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$etapeCouranteHash() => r'083d6bd77b7f85245d3f5074b12eb819dca044c9';

/// Index de l'étape courante dans le parcours actif.

abstract class _$EtapeCourante extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Pin actuellement consulté (identifiant), ou `null`.

@ProviderFor(PinCourant)
final pinCourantProvider = PinCourantProvider._();

/// Pin actuellement consulté (identifiant), ou `null`.
final class PinCourantProvider extends $NotifierProvider<PinCourant, String?> {
  /// Pin actuellement consulté (identifiant), ou `null`.
  PinCourantProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinCourantProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinCourantHash();

  @$internal
  @override
  PinCourant create() => PinCourant();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pinCourantHash() => r'b37811f30f6c7d70e4f9c4dae5896aca44291bef';

/// Pin actuellement consulté (identifiant), ou `null`.

abstract class _$PinCourant extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Mode présentation sans chrome (démonstration, ex. carte projetée en classe).

@ProviderFor(ModePresentation)
final modePresentationProvider = ModePresentationProvider._();

/// Mode présentation sans chrome (démonstration, ex. carte projetée en classe).
final class ModePresentationProvider
    extends $NotifierProvider<ModePresentation, bool> {
  /// Mode présentation sans chrome (démonstration, ex. carte projetée en classe).
  ModePresentationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modePresentationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modePresentationHash();

  @$internal
  @override
  ModePresentation create() => ModePresentation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$modePresentationHash() => r'492682c1d88ad1e151730b72e3fe8aeb3f668b01';

/// Mode présentation sans chrome (démonstration, ex. carte projetée en classe).

abstract class _$ModePresentation extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Narration audio en cours de lecture.

@ProviderFor(LectureAudio)
final lectureAudioProvider = LectureAudioProvider._();

/// Narration audio en cours de lecture.
final class LectureAudioProvider extends $NotifierProvider<LectureAudio, bool> {
  /// Narration audio en cours de lecture.
  LectureAudioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lectureAudioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lectureAudioHash();

  @$internal
  @override
  LectureAudio create() => LectureAudio();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$lectureAudioHash() => r'371c9b1924cc3ce796a5f4fdf1ea51ea5b8d64cb';

/// Narration audio en cours de lecture.

abstract class _$LectureAudio extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
