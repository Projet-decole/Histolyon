// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Unique point d'assemblage des routes (AD-5) : `app/` importe les features
/// pour composer les `GoRoute` qu'elles exportent. Aucune feature n'existe
/// encore (squelette de l'Epic 6) — seul un écran vide est câblé ici, pas une
/// feature, pour que l'app démarre sur quelque chose de visible.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Unique point d'assemblage des routes (AD-5) : `app/` importe les features
/// pour composer les `GoRoute` qu'elles exportent. Aucune feature n'existe
/// encore (squelette de l'Epic 6) — seul un écran vide est câblé ici, pas une
/// feature, pour que l'app démarre sur quelque chose de visible.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Unique point d'assemblage des routes (AD-5) : `app/` importe les features
  /// pour composer les `GoRoute` qu'elles exportent. Aucune feature n'existe
  /// encore (squelette de l'Epic 6) — seul un écran vide est câblé ici, pas une
  /// feature, pour que l'app démarre sur quelque chose de visible.
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

String _$appRouterHash() => r'dacb8446bbe4bd7ffd3300cb6e55f43af65f7063';
