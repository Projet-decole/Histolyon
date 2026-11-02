import 'package:design_tokens/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../domain/fiche_pin.dart';

/// Consultation approfondie d'un pin (CAP-D2.5, ECR-PIN-CONSULTATION-APPROFONDIE),
/// ouverte au-dessus des onglets : en-tête, récit, encarts, puis « Sources »,
/// en un seul défilement (DEC-32).
///
/// Pas encore ici : l'accès « Voir en 3D » (le contenu embarqué ne porte pas
/// de modèle 3D, ticket du pin 3D) et « Étape suivante » (parcours pas à pas).
class PinEcran extends ConsumerStatefulWidget {
  const PinEcran({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<PinEcran> createState() => _PinEcranState();
}

class _PinEcranState extends ConsumerState<PinEcran> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(fichePinProvider(widget.slug), (_, suivant) {
      if (suivant.value is FicheRetiree) _fermerPinRetire();
    }, fireImmediately: true);
  }

  /// R9 : message éphémère puis retour gracieux à la carte.
  void _fermerPinRetire() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ce pin a été retiré. Retour à la carte.'),
        ),
      );
      context.goNamed(RouteNames.carte);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fiche = ref.watch(fichePinProvider(widget.slug));
    return Scaffold(
      appBar: AppBar(),
      body: switch (fiche) {
        AsyncData(value: FicheDisponible() && final f) => _Fiche(f),
        AsyncError() => _Erreur(
          onReessayer: () => ref.invalidate(fichePinProvider(widget.slug)),
        ),
        _ => const _Chargement(),
      },
    );
  }
}

class _Chargement extends StatelessWidget {
  const _Chargement();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: TOK_SPACE_MD),
          Text('Chargement', style: TOK_TYPO_UI_MD),
        ],
      ),
    );
  }
}

class _Erreur extends StatelessWidget {
  const _Erreur({required this.onReessayer});

  final VoidCallback onReessayer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Erreur de chargement', style: TOK_TYPO_UI_LG),
          const SizedBox(height: TOK_SPACE_MD),
          OutlinedButton(
            onPressed: onReessayer,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}

class _Fiche extends StatelessWidget {
  const _Fiche(this.fiche);

  final FicheDisponible fiche;

  @override
  Widget build(BuildContext context) {
    final pin = fiche.pin;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        TOK_SPACE_LG,
        TOK_SPACE_SM,
        TOK_SPACE_LG,
        TOK_SPACE_XXL,
      ),
      children: [
        // En-tête : titre sans préfixe, catégorie, époque.
        Text(pin.titre, style: TOK_TYPO_DISPLAY_LG),
        const SizedBox(height: TOK_SPACE_MD),
        Wrap(
          spacing: TOK_SPACE_SM,
          runSpacing: TOK_SPACE_SM,
          children: [
            _Chip(pin.categorie),
            for (final e in pin.epoqueLibelles) _Chip(e),
          ],
        ),
        const SizedBox(height: TOK_SPACE_XL),
        // Récit : pas de libellé de section, le récit est l'écran.
        for (final paragraphe in _paragraphes(pin.narration))
          Padding(
            padding: const EdgeInsets.only(bottom: TOK_SPACE_LG),
            child: Text(paragraphe, style: TOK_TYPO_BODY_LG),
          ),
        for (final fait in fiche.leSaviezVous) ...[
          _SaviezVous(fait),
          const SizedBox(height: TOK_SPACE_LG),
        ],
        const SizedBox(height: TOK_SPACE_MD),
        _Sources(pin.sources),
      ],
    );
  }

  /// Les paragraphes sont séparés par une ligne vide ; les retours à la ligne
  /// simples viennent du YAML et ne sont pas des coupures voulues.
  static List<String> _paragraphes(String texte) => [
    for (final p in texte.split(RegExp(r'\n\s*\n')))
      if (p.trim().isNotEmpty) p.trim().replaceAll(RegExp(r'\s*\n\s*'), ' '),
  ];
}

/// COMP-CHIP-CATEGORIE / COMP-CHIP-EPOQUE, en affichage seul au MVP.
class _Chip extends StatelessWidget {
  const _Chip(this.libelle);

  final String libelle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TOK_SPACE_MD,
        vertical: TOK_SPACE_XS,
      ),
      decoration: BoxDecoration(
        color: TOK_COLOR_FOND_SECONDAIRE,
        borderRadius: BorderRadius.circular(TOK_RADIUS_PILL),
      ),
      child: Text(libelle, style: TOK_TYPO_UI_MD),
    );
  }
}

/// COMP-SAVIEZ-VOUS : encart distinct du récit (CAP-D2.6 R2).
class _SaviezVous extends StatelessWidget {
  const _SaviezVous(this.fait);

  final String fait;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TOK_SPACE_LG),
      decoration: BoxDecoration(
        color: TOK_COLOR_FOND_SECONDAIRE,
        borderRadius: BorderRadius.circular(TOK_RADIUS_MD),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: TOK_COLOR_OR_ACCENT),
              const SizedBox(width: TOK_SPACE_SM),
              Text('Le saviez-vous', style: TOK_TYPO_UI_LG),
            ],
          ),
          const SizedBox(height: TOK_SPACE_SM),
          Text(fait, style: TOK_TYPO_BODY_MD),
        ],
      ),
    );
  }
}

/// COMP-ZONE-SOURCES en consultation : chaque source avec son crédit (R6).
class _Sources extends StatelessWidget {
  const _Sources(this.sources);

  final List<SourceContenu> sources;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: TOK_SPACE_SM),
        Text('Sources', style: TOK_TYPO_DISPLAY_SM),
        const SizedBox(height: TOK_SPACE_SM),
        for (final s in sources)
          Padding(
            padding: const EdgeInsets.only(bottom: TOK_SPACE_SM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.reference, style: TOK_TYPO_BODY_SM),
                Text(
                  s.credit,
                  style: TOK_TYPO_BODY_SM.copyWith(
                    color: TOK_COLOR_TEXTE_SECONDAIRE,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
