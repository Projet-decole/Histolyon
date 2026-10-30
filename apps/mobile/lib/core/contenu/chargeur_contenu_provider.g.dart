// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chargeur_contenu_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Chargeur unique du contenu embarqué (DEC-04), lu par les couches `data/`.
/// En test : `chargeurContenuProvider.overrideWithValue(...)`.

@ProviderFor(chargeurContenu)
final chargeurContenuProvider = ChargeurContenuProvider._();

/// Chargeur unique du contenu embarqué (DEC-04), lu par les couches `data/`.
/// En test : `chargeurContenuProvider.overrideWithValue(...)`.

final class ChargeurContenuProvider
    extends
        $FunctionalProvider<ChargeurContenu, ChargeurContenu, ChargeurContenu>
    with $Provider<ChargeurContenu> {
  /// Chargeur unique du contenu embarqué (DEC-04), lu par les couches `data/`.
  /// En test : `chargeurContenuProvider.overrideWithValue(...)`.
  ChargeurContenuProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chargeurContenuProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chargeurContenuHash();

  @$internal
  @override
  $ProviderElement<ChargeurContenu> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChargeurContenu create(Ref ref) {
    return chargeurContenu(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChargeurContenu value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChargeurContenu>(value),
    );
  }
}

String _$chargeurContenuHash() => r'26283ecfffe788492c20f13eb6aa533c9f07447b';
