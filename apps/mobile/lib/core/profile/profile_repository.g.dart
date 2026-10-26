// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Identifiant du Profil local de l'appareil (créé au premier accès) : la clé
/// `profil_id` des préférences, favoris et historique. Expose l'id plutôt que
/// `ProfilData`, type généré par Drift que riverpod_generator ne peut pas
/// résoudre dans le même build.

@ProviderFor(profilLocalId)
final profilLocalIdProvider = ProfilLocalIdProvider._();

/// Identifiant du Profil local de l'appareil (créé au premier accès) : la clé
/// `profil_id` des préférences, favoris et historique. Expose l'id plutôt que
/// `ProfilData`, type généré par Drift que riverpod_generator ne peut pas
/// résoudre dans le même build.

final class ProfilLocalIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<String>>,
          Result<String>,
          FutureOr<Result<String>>
        >
    with $FutureModifier<Result<String>>, $FutureProvider<Result<String>> {
  /// Identifiant du Profil local de l'appareil (créé au premier accès) : la clé
  /// `profil_id` des préférences, favoris et historique. Expose l'id plutôt que
  /// `ProfilData`, type généré par Drift que riverpod_generator ne peut pas
  /// résoudre dans le même build.
  ProfilLocalIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profilLocalIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profilLocalIdHash();

  @$internal
  @override
  $FutureProviderElement<Result<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<String>> create(Ref ref) {
    return profilLocalId(ref);
  }
}

String _$profilLocalIdHash() => r'4c100d1a21da8ce6a945f0497eef99e9f3434ec8';
