// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcours_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(parcoursRepository)
final parcoursRepositoryProvider = ParcoursRepositoryProvider._();

final class ParcoursRepositoryProvider
    extends
        $FunctionalProvider<
          ParcoursRepository,
          ParcoursRepository,
          ParcoursRepository
        >
    with $Provider<ParcoursRepository> {
  ParcoursRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parcoursRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parcoursRepositoryHash();

  @$internal
  @override
  $ProviderElement<ParcoursRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ParcoursRepository create(Ref ref) {
    return parcoursRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ParcoursRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ParcoursRepository>(value),
    );
  }
}

String _$parcoursRepositoryHash() =>
    r'19297ef5e3cc72778859a4fb05695830aa2780b6';
