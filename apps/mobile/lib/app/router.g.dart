// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Unique point d'assemblage des routes (AD-5) : `app/` importe les routes
/// exportées par chaque feature. Une feature n'a jamais besoin de modifier ce
/// fichier pour ajouter une sous-route : elle l'ajoute dans son propre
/// `<slug>_routes.dart`.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Unique point d'assemblage des routes (AD-5) : `app/` importe les routes
/// exportées par chaque feature. Une feature n'a jamais besoin de modifier ce
/// fichier pour ajouter une sous-route : elle l'ajoute dans son propre
/// `<slug>_routes.dart`.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Unique point d'assemblage des routes (AD-5) : `app/` importe les routes
  /// exportées par chaque feature. Une feature n'a jamais besoin de modifier ce
  /// fichier pour ajouter une sous-route : elle l'ajoute dans son propre
  /// `<slug>_routes.dart`.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'bb4ad1455d9da034d70343dab042356d226b7e1f';
