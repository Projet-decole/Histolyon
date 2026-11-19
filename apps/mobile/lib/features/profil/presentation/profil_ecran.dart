import 'package:design_tokens/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/failure.dart';
import '../../../core/router/route_names.dart';
import '../domain/favoris_provider.dart';

/// Surface S3 (D6.1) : profil local sans compte. Liste les Favoris (D6.2),
/// les plus récents en tête, et permet d'en retirer un.
class ProfilEcran extends ConsumerWidget {
  const ProfilEcran({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoris = ref.watch(favorisProvider);
    return Scaffold(
      backgroundColor: TOK_COLOR_FOND_PRINCIPAL,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: TOK_COLOR_FOND_PRINCIPAL,
      ),
      body: switch (favoris) {
        // `AsyncValue(value: …)` garde la dernière liste connue pendant une
        // relecture (après un retrait en échec) : pas de clignotement.
        AsyncValue(value: Ok(:final value)) when value.isEmpty =>
          const _FavorisVides(),
        AsyncValue(value: Ok(:final value)) => _ListeFavoris(favoris: value),
        AsyncValue(isLoading: true) => const Center(
          child: CircularProgressIndicator(),
        ),
        AsyncValue(value: Err()) || AsyncError() => const _Message(
          'Vos favoris n’ont pas pu être lus. Réessayez plus tard.',
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _ListeFavoris extends ConsumerWidget {
  const _ListeFavoris({required this.favoris});

  final List<FavoriProfil> favoris;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = favoris.length;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: TOK_SPACE_LG),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TOK_SPACE_LG),
          child: Text(
            '$n ${n > 1 ? 'favoris' : 'favori'} · les plus récents en tête',
            style: TOK_TYPO_UI_MD.copyWith(color: TOK_COLOR_TEXTE_SECONDAIRE),
          ),
        ),
        const SizedBox(height: TOK_SPACE_SM),
        for (final f in favoris)
          _RangeeFavori(
            key: ValueKey(f.id),
            favori: f,
            onRetirer: () => _retirer(context, ref, f.id),
          ),
      ],
    );
  }
}

/// Retire le favori ; en cas d'échec, il revient dans la liste et un message
/// éphémère le signale.
Future<void> _retirer(BuildContext context, WidgetRef ref, String id) async {
  final messager = ScaffoldMessenger.of(context);
  final resultat = await ref.read(favorisProvider.notifier).retirer(id);
  if (resultat is Err) {
    messager.showSnackBar(
      const SnackBar(content: Text('Le favori n’a pas pu être retiré.')),
    );
  }
}

class _RangeeFavori extends StatelessWidget {
  const _RangeeFavori({
    super.key,
    required this.favori,
    required this.onRetirer,
  });

  final FavoriProfil favori;
  final VoidCallback onRetirer;

  @override
  Widget build(BuildContext context) {
    final estPin = favori.typeDeCible == TypeCible.pin;
    return Dismissible(
      key: ValueKey('glisser-${favori.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRetirer(),
      background: Container(
        color: TOK_COLOR_FONCTIONNEL_ERREUR,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: TOK_SPACE_XL),
        child: const Icon(
          Icons.delete_outline,
          color: TOK_COLOR_BLANC_NARRATIF,
          semanticLabel: 'Retirer',
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TOK_SPACE_LG,
          vertical: TOK_SPACE_XS,
        ),
        leading: Icon(
          estPin ? Icons.place_outlined : Icons.route_outlined,
          color: TOK_COLOR_TEXTE_SECONDAIRE,
        ),
        title: Text(
          favori.cibleId,
          style: TOK_TYPO_DISPLAY_SM.copyWith(color: TOK_COLOR_TEXTE_PRINCIPAL),
        ),
        subtitle: Wrap(
          spacing: TOK_SPACE_SM,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              estPin ? 'Pin' : 'Parcours',
              style: TOK_TYPO_UI_MD.copyWith(color: TOK_COLOR_PRIMARY_FONCE),
            ),
            Text(
              'ajouté le ${_date(favori.ajouteLe)}',
              style: TOK_TYPO_UI_SM.copyWith(color: TOK_COLOR_TEXTE_SECONDAIRE),
            ),
          ],
        ),
        trailing: IconButton(
          tooltip: 'Retirer des favoris',
          icon: const Icon(Icons.favorite_border, color: TOK_COLOR_PRIMARY),
          onPressed: onRetirer,
        ),
      ),
    );
  }

  static String _date(DateTime d) {
    final l = d.toLocal();
    String deux(int v) => v.toString().padLeft(2, '0');
    return '${deux(l.day)}/${deux(l.month)}/${l.year}';
  }
}

class _FavorisVides extends StatelessWidget {
  const _FavorisVides();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TOK_SPACE_XL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_border,
              size: TOK_SPACE_XXXL,
              color: TOK_COLOR_TEXTE_TERTIAIRE,
            ),
            const SizedBox(height: TOK_SPACE_LG),
            Text(
              'Aucun favori pour l’instant. Touchez le cœur sur un lieu ou un '
              'parcours pour le retrouver ici.',
              textAlign: TextAlign.center,
              style: TOK_TYPO_BODY_MD.copyWith(
                color: TOK_COLOR_TEXTE_PRINCIPAL,
              ),
            ),
            const SizedBox(height: TOK_SPACE_LG),
            OutlinedButton(
              onPressed: () => context.goNamed(RouteNames.carte),
              style: OutlinedButton.styleFrom(
                foregroundColor: TOK_COLOR_PRIMARY,
                side: const BorderSide(color: TOK_COLOR_PRIMARY),
                textStyle: TOK_TYPO_UI_LG,
                padding: const EdgeInsets.symmetric(
                  horizontal: TOK_SPACE_XL,
                  vertical: TOK_SPACE_MD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TOK_RADIUS_MD),
                ),
              ),
              child: const Text('Explorer la carte'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.texte);

  final String texte;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TOK_SPACE_XL),
        child: Text(
          texte,
          textAlign: TextAlign.center,
          style: TOK_TYPO_BODY_MD.copyWith(color: TOK_COLOR_TEXTE_SECONDAIRE),
        ),
      ),
    );
  }
}
