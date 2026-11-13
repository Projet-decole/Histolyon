// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fiche_pin.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fiche d'un pin. Un pin introuvable devient [FicheRetiree] ; tout autre
/// échec est levé en `Failure` (état d'erreur de l'écran, « Réessayer »).
///
/// Seuls les encarts `le_saviez_vous` sont retenus : le format d'une
/// `citation_historique` n'est pas fixé (QO-902) et une citation sans source
/// n'est pas affichée (CAP-D2.6 R3).
///
/// Pas de nouvel essai automatique : relire le même contenu embarqué donnerait
/// le même échec, c'est l'utilisateur qui relance (« Réessayer »).

@ProviderFor(fichePin)
final fichePinProvider = FichePinFamily._();

/// Fiche d'un pin. Un pin introuvable devient [FicheRetiree] ; tout autre
/// échec est levé en `Failure` (état d'erreur de l'écran, « Réessayer »).
///
/// Seuls les encarts `le_saviez_vous` sont retenus : le format d'une
/// `citation_historique` n'est pas fixé (QO-902) et une citation sans source
/// n'est pas affichée (CAP-D2.6 R3).
///
/// Pas de nouvel essai automatique : relire le même contenu embarqué donnerait
/// le même échec, c'est l'utilisateur qui relance (« Réessayer »).

final class FichePinProvider
    extends
        $FunctionalProvider<
          AsyncValue<EtatFichePin>,
          EtatFichePin,
          FutureOr<EtatFichePin>
        >
    with $FutureModifier<EtatFichePin>, $FutureProvider<EtatFichePin> {
  /// Fiche d'un pin. Un pin introuvable devient [FicheRetiree] ; tout autre
  /// échec est levé en `Failure` (état d'erreur de l'écran, « Réessayer »).
  ///
  /// Seuls les encarts `le_saviez_vous` sont retenus : le format d'une
  /// `citation_historique` n'est pas fixé (QO-902) et une citation sans source
  /// n'est pas affichée (CAP-D2.6 R3).
  ///
  /// Pas de nouvel essai automatique : relire le même contenu embarqué donnerait
  /// le même échec, c'est l'utilisateur qui relance (« Réessayer »).
  FichePinProvider._({
    required FichePinFamily super.from,
    required String super.argument,
  }) : super(
         retry: _sansNouvelEssai,
         name: r'fichePinProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fichePinHash();

  @override
  String toString() {
    return r'fichePinProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EtatFichePin> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EtatFichePin> create(Ref ref) {
    final argument = this.argument as String;
    return fichePin(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FichePinProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fichePinHash() => r'd54bf265ade13f2de1ee4f0eae766a897c395482';

/// Fiche d'un pin. Un pin introuvable devient [FicheRetiree] ; tout autre
/// échec est levé en `Failure` (état d'erreur de l'écran, « Réessayer »).
///
/// Seuls les encarts `le_saviez_vous` sont retenus : le format d'une
/// `citation_historique` n'est pas fixé (QO-902) et une citation sans source
/// n'est pas affichée (CAP-D2.6 R3).
///
/// Pas de nouvel essai automatique : relire le même contenu embarqué donnerait
/// le même échec, c'est l'utilisateur qui relance (« Réessayer »).

final class FichePinFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EtatFichePin>, String> {
  FichePinFamily._()
    : super(
        retry: _sansNouvelEssai,
        name: r'fichePinProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fiche d'un pin. Un pin introuvable devient [FicheRetiree] ; tout autre
  /// échec est levé en `Failure` (état d'erreur de l'écran, « Réessayer »).
  ///
  /// Seuls les encarts `le_saviez_vous` sont retenus : le format d'une
  /// `citation_historique` n'est pas fixé (QO-902) et une citation sans source
  /// n'est pas affichée (CAP-D2.6 R3).
  ///
  /// Pas de nouvel essai automatique : relire le même contenu embarqué donnerait
  /// le même échec, c'est l'utilisateur qui relance (« Réessayer »).

  FichePinProvider call(String slug) =>
      FichePinProvider._(argument: slug, from: this);

  @override
  String toString() => r'fichePinProvider';
}
