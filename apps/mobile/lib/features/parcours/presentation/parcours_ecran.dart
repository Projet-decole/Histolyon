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
      appBar: AppBar(
        title: const Text('Parcours'),
        backgroundColor: TOK_COLOR_FOND_PRINCIPAL,
      ),
      body: switch (catalogue) {
        AsyncData(value: Ok(:final value)) when value.isEmpty => const _Message(
          'Aucun parcours publié pour l’instant. Revenez bientôt.',
        ),
        AsyncData(value: Ok(:final value)) => ListView.separated(
          padding: const EdgeInsets.all(TOK_SPACE_LG),
          itemCount: value.length,
          separatorBuilder: (_, _) => const SizedBox(height: TOK_SPACE_LG),
          itemBuilder: (_, i) => _CarteParcours(
            parcours: value[i],
            // Préparé : la fiche parcours (D3.3) fait l'objet d'une autre
            // issue ; le tap ne mène nulle part pour l'instant.
            onOuvrir: () {},
          ),
        ),
        AsyncData(value: Err()) || AsyncError() => const _Message(
          'Le catalogue n’a pas pu être chargé. Réessayez plus tard.',
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _CarteParcours extends StatelessWidget {
  const _CarteParcours({required this.parcours, required this.onOuvrir});

  final ParcoursCatalogue parcours;
  final VoidCallback onOuvrir;

  @override
  Widget build(BuildContext context) {
    final p = parcours.parcours;
    final duree = p.dureeEstimeeMinutes;
    final distance = p.distanceEstimeeMetres;
    final teaser = p.teaserNarratif;
    return Material(
      color: TOK_COLOR_BLANC_NARRATIF,
      borderRadius: BorderRadius.circular(TOK_RADIUS_LG),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOuvrir,
        child: Padding(
          padding: const EdgeInsets.all(TOK_SPACE_LG),
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
                spacing: TOK_SPACE_LG,
                runSpacing: TOK_SPACE_XS,
                children: [
                  if (duree != null)
                    _Metadonnee(Icons.schedule, formaterDuree(duree)),
                  if (distance != null)
                    _Metadonnee(
                      Icons.route_outlined,
                      formaterDistance(distance),
                    ),
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
                  _Tag(
                    parcours.estCommunautaire ? 'Communautaire' : 'Éditorial',
                    icone: parcours.estCommunautaire
                        ? Icons.groups_outlined
                        : Icons.verified_outlined,
                    couleur: parcours.estCommunautaire
                        ? TOK_COLOR_PIN_COMMUNAUTAIRE
                        : TOK_COLOR_PRIMARY_FONCE,
                  ),
                  for (final e in parcours.epoques)
                    _Tag(e.libelle, couleur: TOK_COLOR_TEXTE_SECONDAIRE),
                ],
              ),
            ],
          ),
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

/// « 2,4 km », « 800 m ».
String formaterDistance(int metres) {
  if (metres < 1000) return '$metres m';
  final km = (metres / 1000).toStringAsFixed(1).replaceAll('.', ',');
  return '${km.endsWith(',0') ? km.substring(0, km.length - 2) : km} km';
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
        Text(
          texte,
          semanticsLabel: semantique,
          style: TOK_TYPO_UI_MD.copyWith(color: TOK_COLOR_TEXTE_SECONDAIRE),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.texte, {required this.couleur, this.icone});

  final String texte;
  final Color couleur;
  final IconData? icone;

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
            Icon(icone, size: TOK_SPACE_LG, color: couleur),
            const SizedBox(width: TOK_SPACE_XS),
          ],
          Text(texte, style: TOK_TYPO_UI_SM.copyWith(color: couleur)),
        ],
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
