import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/failure.dart';
import '../data/pins_repository.dart';

export '../data/pins_repository.dart' show Pin, SourceContenu;

part 'fiche_pin.g.dart';

/// Ce que la consultation approfondie (CAP-D2.5) sait afficher.
sealed class EtatFichePin {
  const EtatFichePin();
}

final class FicheDisponible extends EtatFichePin {
  const FicheDisponible(this.pin, {required this.leSaviezVous});

  final Pin pin;

  /// Faits des encarts « Le saviez-vous », sans l'ouverture « Le saviez-vous. »
  /// que le gabarit fait écrire en tête du texte (l'encart l'affiche déjà).
  final List<String> leSaviezVous;
}

/// Le pin n'est pas (ou plus) publié : la fiche se ferme (R9).
final class FicheRetiree extends EtatFichePin {
  const FicheRetiree();
}

const _ouvertureSaviezVous = 'Le saviez-vous.';

/// Fiche d'un pin. Un pin introuvable devient [FicheRetiree] ; tout autre
/// échec est levé en `Failure` (état d'erreur de l'écran, « Réessayer »).
///
/// Seuls les encarts `le_saviez_vous` sont retenus : le format d'une
/// `citation_historique` n'est pas fixé (QO-902) et une citation sans source
/// n'est pas affichée (CAP-D2.6 R3).
///
/// Pas de nouvel essai automatique : relire le même contenu embarqué donnerait
/// le même échec, c'est l'utilisateur qui relance (« Réessayer »).
@Riverpod(retry: _sansNouvelEssai)
Future<EtatFichePin> fichePin(Ref ref, String slug) async {
  final resultat = await ref.watch(pinsRepositoryProvider).pinParSlug(slug);
  return switch (resultat) {
    Ok(value: final pin) => FicheDisponible(
      pin,
      leSaviezVous: [
        for (final e in pin.postNarratif)
          if (e.type == 'le_saviez_vous') _sansOuverture(e.texte),
      ],
    ),
    Err(failure: ValidationFailure()) => const FicheRetiree(),
    Err(:final failure) => throw failure,
  };
}

Duration? _sansNouvelEssai(int essai, Object erreur) => null;

String _sansOuverture(String texte) {
  final t = texte.trim();
  return t.startsWith(_ouvertureSaviezVous)
      ? t.substring(_ouvertureSaviezVous.length).trimLeft()
      : t;
}
