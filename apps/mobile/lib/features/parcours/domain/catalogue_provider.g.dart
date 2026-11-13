// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalogue_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Catalogue des parcours publiés (D3.2).

@ProviderFor(catalogue)
final catalogueProvider = CatalogueProvider._();

/// Catalogue des parcours publiés (D3.2).

final class CatalogueProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<ParcoursCatalogue>>>,
          Result<List<ParcoursCatalogue>>,
          FutureOr<Result<List<ParcoursCatalogue>>>
        >
    with
        $FutureModifier<Result<List<ParcoursCatalogue>>>,
        $FutureProvider<Result<List<ParcoursCatalogue>>> {
  /// Catalogue des parcours publiés (D3.2).
  CatalogueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogueHash();

  @$internal
  @override
  $FutureProviderElement<Result<List<ParcoursCatalogue>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<ParcoursCatalogue>>> create(Ref ref) {
    return catalogue(ref);
  }
}

String _$catalogueHash() => r'7096ee45e2c97502c040910320ad6360ad34d6c1';
