import 'package:design_tokens/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/failure.dart';
import '../domain/catalogue_provider.dart';

/// Surface S2 (D3.2) : catalogue des parcours publiés.
class ParcoursEcran extends ConsumerWidget {
  const ParcoursEcran({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogue = ref.watch(catalogueProvider);
    return Scaffold(
      backgroundColor: TOK_COLOR_FOND_PRINCIPAL,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TOK_SPACE_LG,
                TOK_SPACE_XL,
                TOK_SPACE_LG,
                TOK_SPACE_SM,
              ),
              child: Semantics(
                header: true,
                child: Text(
                  'Parcours',
                  style: TOK_TYPO_DISPLAY_XL.copyWith(
                    color: TOK_COLOR_TEXTE_PRINCIPAL,
                  ),
                ),
              ),
            ),
            Expanded(
              child: switch (catalogue) {
                AsyncValue(value: Ok(:final value)) when value.isEmpty =>
                  const _Message(
                    'Aucun parcours publié pour l’instant. Revenez bientôt.',
                  ),
                AsyncValue(value: Ok(:final value)) => ListView.separated(
                  padding: const EdgeInsets.all(TOK_SPACE_LG),
                  itemCount: value.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: TOK_SPACE_LG),
                  itemBuilder: (_, i) => _CarteParcours(
                    parcours: value[i],
                    // Préparé : la fiche parcours (D3.3) fait l'objet d'une
                    // autre issue ; « Découvrir » ne mène nulle part pour
                    // l'instant.
                    onDecouvrir: () {},
                  ),
                ),
                AsyncValue(isLoading: true) => const Center(
                  child: CircularProgressIndicator(),
                ),
                AsyncValue(value: Err()) || AsyncError() => _Message(
                  'Le catalogue n’a pas pu être chargé.',
                  action: OutlinedButton(
                    onPressed: () => ref.invalidate(catalogueProvider),
                    child: const Text('Réessayer'),
                  ),
                ),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CarteParcours extends StatelessWidget {
  const _CarteParcours({required this.parcours, required this.onDecouvrir});

  final ParcoursCatalogue parcours;
  final VoidCallback onDecouvrir;

  @override
  Widget build(BuildContext context) {
    final p = parcours.parcours;
    final duree = p.dureeEstimeeMinutes;
    final distance = p.distanceEstimeeMetres;
    final teaser = p.teaserNarratif;
    return Container(
      decoration: BoxDecoration(
        color: TOK_COLOR_BLANC_NARRATIF,
        borderRadius: BorderRadius.circular(TOK_RADIUS_LG),
        boxShadow: const [TOK_SHADOW_SM],
      ),
      padding: const EdgeInsets.all(TOK_SPACE_LG),
      child: Semantics(
        container: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              p.titre,
              style: TOK_TYPO_DISPLAY_MD.copyWith(
                color: TOK_COLOR_TEXTE_PRINCIPAL,
              ),
            ),
            const SizedBox(height: TOK_SPACE_SM),
            Wrap(
              spacing: TOK_SPACE_MD,
              runSpacing: TOK_SPACE_XS,
              children: [
                if (duree != null)
                  _Metadonnee(Icons.schedule, formaterDuree(duree)),
                if (distance != null)
                  _Metadonnee(Icons.route_outlined, formaterDistance(distance)),
                _Metadonnee(
                  Icons.signpost_outlined,
                  '${parcours.nombreEtapes} ét.',
                  semantique: '${parcours.nombreEtapes} étapes',
                ),
              ],
            ),
            if (teaser != null && teaser.isNotEmpty) ...[
              const SizedBox(height: TOK_SPACE_SM),
              Text(
                teaser,
                style: TOK_TYPO_BODY_MD.copyWith(
                  color: TOK_COLOR_TEXTE_PRINCIPAL,
                ),
              ),
            ],
            const SizedBox(height: TOK_SPACE_MD),
            Wrap(
              spacing: TOK_SPACE_SM,
              runSpacing: TOK_SPACE_XS,
              children: [
                // Texte toujours lisible (contraste AA) ; seule l'icône
                // porte la couleur de provenance.
                parcours.estCommunautaire
                    ? const _Tag(
                        'Communautaire',
                        icone: Icons.groups_outlined,
                        couleurIcone: TOK_COLOR_PIN_COMMUNAUTAIRE,
                        couleurTexte: TOK_COLOR_TEXTE_SECONDAIRE,
                      )
                    : const _Tag(
                        'Éditorial',
                        icone: Icons.verified_outlined,
                        couleurIcone: TOK_COLOR_PIN_EDITORIAL,
                        couleurTexte: TOK_COLOR_PRIMARY_FONCE,
                      ),
                for (final e in parcours.epoques)
                  _Tag(e.libelle, couleurTexte: TOK_COLOR_TEXTE_SECONDAIRE),
              ],
            ),
            const SizedBox(height: TOK_SPACE_LG),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onDecouvrir,
                style: FilledButton.styleFrom(
                  backgroundColor: TOK_COLOR_PRIMARY,
                  foregroundColor: TOK_COLOR_BLANC_NARRATIF,
                  textStyle: TOK_TYPO_UI_LG,
                  padding: const EdgeInsets.all(TOK_SPACE_LG),
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TOK_RADIUS_MD),
                  ),
                ),
                child: Text(
                  'Découvrir',
                  semanticsLabel: 'Découvrir ${p.titre}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// « 1 h 30 », « 2 h », « 45 min ».
String formaterDuree(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '$m min';
  if (m == 0) return '$h h';
  return '$h h ${m.toString().padLeft(2, '0')}';
}

/// « 800 m », « 2,4 km », « 2 km » (arrondi au dixième, demi vers le haut).
String formaterDistance(int metres) {
  if (metres < 1000) return '$metres m';
  final dixiemes = (metres + 50) ~/ 100;
  final entiers = dixiemes ~/ 10;
  final reste = dixiemes % 10;
  return reste == 0 ? '$entiers km' : '$entiers,$reste km';
}

class _Metadonnee extends StatelessWidget {
  const _Metadonnee(this.icone, this.texte, {this.semantique});

  final IconData icone;
  final String texte;
  final String? semantique;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, size: TOK_SPACE_LG, color: TOK_COLOR_TEXTE_SECONDAIRE),
        const SizedBox(width: TOK_SPACE_XS),
        Flexible(
          child: Text(
            texte,
            semanticsLabel: semantique,
            style: TOK_TYPO_UI_SM.copyWith(color: TOK_COLOR_TEXTE_SECONDAIRE),
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(
    this.texte, {
    required this.couleurTexte,
    this.icone,
    this.couleurIcone,
  });

  final String texte;
  final Color couleurTexte;
  final IconData? icone;
  final Color? couleurIcone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TOK_SPACE_SM,
        vertical: TOK_SPACE_XS,
      ),
      decoration: BoxDecoration(
        color: TOK_COLOR_FOND_SECONDAIRE,
        borderRadius: BorderRadius.circular(TOK_RADIUS_SM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone != null) ...[
            Icon(icone, size: TOK_SPACE_LG, color: couleurIcone),
            const SizedBox(width: TOK_SPACE_XS),
          ],
          Flexible(
            child: Text(
              texte,
              style: TOK_TYPO_UI_MD.copyWith(color: couleurTexte),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.texte, {this.action});

  final String texte;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final action = this.action;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TOK_SPACE_XL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              texte,
              textAlign: TextAlign.center,
              style: TOK_TYPO_BODY_MD.copyWith(
                color: TOK_COLOR_TEXTE_SECONDAIRE,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: TOK_SPACE_LG),
              action,
            ],
          ],
        ),
      ),
    );
  }
}
