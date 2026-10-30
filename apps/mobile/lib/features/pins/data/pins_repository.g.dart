// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pins_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pinsRepository)
final pinsRepositoryProvider = PinsRepositoryProvider._();

final class PinsRepositoryProvider
    extends $FunctionalProvider<PinsRepository, PinsRepository, PinsRepository>
    with $Provider<PinsRepository> {
  PinsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PinsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PinsRepository create(Ref ref) {
    return pinsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinsRepository>(value),
    );
  }
}

String _$pinsRepositoryHash() => r'51f77a4b78ecf3b1cb576ea4af6a55cf07b08ff6';
