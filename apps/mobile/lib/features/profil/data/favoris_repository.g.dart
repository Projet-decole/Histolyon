// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoris_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favorisRepository)
final favorisRepositoryProvider = FavorisRepositoryProvider._();

final class FavorisRepositoryProvider
    extends
        $FunctionalProvider<
          FavorisRepository,
          FavorisRepository,
          FavorisRepository
        >
    with $Provider<FavorisRepository> {
  FavorisRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favorisRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favorisRepositoryHash();

  @$internal
  @override
  $ProviderElement<FavorisRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FavorisRepository create(Ref ref) {
    return favorisRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavorisRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavorisRepository>(value),
    );
  }
}

String _$favorisRepositoryHash() => r'c268ce3a54cfb456d2aff9d22199d5f6eadad826';
