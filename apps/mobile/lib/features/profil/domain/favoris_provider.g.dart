// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoris_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Liste des Favoris du Profil local (D6.2), les plus récents en tête.

@ProviderFor(Favoris)
final favorisProvider = FavorisProvider._();

/// Liste des Favoris du Profil local (D6.2), les plus récents en tête.
final class FavorisProvider
    extends $AsyncNotifierProvider<Favoris, Result<List<FavoriProfil>>> {
  /// Liste des Favoris du Profil local (D6.2), les plus récents en tête.
  FavorisProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favorisProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favorisHash();

  @$internal
  @override
  Favoris create() => Favoris();
}

String _$favorisHash() => r'1eb6f899fd3befa84c03093694c465ce600927b8';

/// Liste des Favoris du Profil local (D6.2), les plus récents en tête.

abstract class _$Favoris extends $AsyncNotifier<Result<List<FavoriProfil>>> {
  FutureOr<Result<List<FavoriProfil>>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Result<List<FavoriProfil>>>,
              Result<List<FavoriProfil>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Result<List<FavoriProfil>>>,
                Result<List<FavoriProfil>>
              >,
              AsyncValue<Result<List<FavoriProfil>>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
