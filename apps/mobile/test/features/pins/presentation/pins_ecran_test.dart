import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/core/models/failure.dart';
import 'package:mobile/core/router/route_names.dart';
import 'package:mobile/features/pins/data/pins_repository.dart';
import 'package:mobile/features/pins/presentation/pins_ecran.dart';

import '../pins_factices.dart';

/// Monte la fiche au-dessus d'une carte factice, comme dans l'app (pushNamed).
Future<GoRouter> _monter(
  WidgetTester tester,
  RepositoryFactice repo, {
  bool lienDirect = false,
}) async {
  final routeur = GoRouter(
    initialLocation: lienDirect ? '/pin/pin-a' : RouteNames.cartePath,
    routes: [
      GoRoute(
        path: RouteNames.cartePath,
        name: RouteNames.carte,
        builder: (_, _) => const Scaffold(body: Text('carte factice')),
      ),
      GoRoute(
        path: RouteNames.pinPath,
        name: RouteNames.pin,
        builder: (_, state) => PinEcran(slug: state.pathParameters['slug']!),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [pinsRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(routerConfig: routeur),
    ),
  );
  if (!lienDirect) {
    routeur.pushNamed(RouteNames.pin, pathParameters: {'slug': 'pin-a'});
  }
  await tester.pumpAndSettle();
  return routeur;
}

void main() {
  testWidgets(
    'nominal : titre, catégorie, époque, récit, encart puis sources (R3)',
    (tester) async {
      await _monter(
        tester,
        RepositoryFactice(
          Ok(
            pinFactice(
              postNarratif: const [
                EncartContenu(
                  type: 'le_saviez_vous',
                  texte:
                      'Le saviez-vous. Lyon compte des centaines de traboules.',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('La Cour des Voraces'), findsOneWidget);
      expect(find.text('Architecture'), findsOneWidget);
      expect(find.text('XIXe siècle'), findsOneWidget);
      expect(find.textContaining('Tu pousses la porte.'), findsOneWidget);
      expect(find.text('Le saviez-vous'), findsOneWidget);
      expect(
        find.text('Lyon compte des centaines de traboules.'),
        findsOneWidget,
      );
      expect(find.text('Sources'), findsOneWidget);
      expect(find.textContaining('Canut — Wikipédia'), findsOneWidget);
      expect(find.textContaining('Wikipédia, CC BY-SA'), findsOneWidget);

      // Un seul défilement, sans onglets (CF6) ; pas d'accès 3D sans modèle (R5).
      expect(find.byType(TabBar), findsNothing);
      expect(find.text('Voir en 3D'), findsNothing);
    },
  );

  testWidgets('sans encart, le récit enchaîne sur les sources (R6 de D2.6)', (
    tester,
  ) async {
    await _monter(tester, RepositoryFactice(Ok(pinFactice())));

    expect(find.text('Le saviez-vous'), findsNothing);
    expect(find.text('Sources'), findsOneWidget);
  });

  testWidgets('erreur : message et « Réessayer » relance la lecture', (
    tester,
  ) async {
    final repo = RepositoryFactice(const Err(InconnueFailure('illisible')));
    await _monter(tester, repo);

    expect(find.text('Erreur de chargement'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);

    repo.resultat = Ok(pinFactice());
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(find.text('La Cour des Voraces'), findsOneWidget);
    expect(repo.appels, 2);
  });

  testWidgets('pin retiré : message puis retour à la carte (CF7)', (
    tester,
  ) async {
    await _monter(
      tester,
      RepositoryFactice(const Err(ValidationFailure('introuvable'))),
    );

    expect(
      find.text('Ce pin a été retiré. Retour à la carte.'),
      findsOneWidget,
    );
    expect(find.text('carte factice'), findsOneWidget);
    expect(find.byType(PinEcran), findsNothing);
  });

  testWidgets(
    'lien vers un pin retiré depuis une fiche ouverte : retour à la carte',
    (tester) async {
      final repo = RepositoryFactice(Ok(pinFactice()));
      final routeur = await _monter(tester, repo, lienDirect: true);
      expect(find.text('La Cour des Voraces'), findsOneWidget);

      // Même route, autre slug : l'écran peut être réutilisé (lien web).
      repo.resultat = const Err(ValidationFailure('introuvable'));
      routeur.goNamed(RouteNames.pin, pathParameters: {'slug': 'pin-retire'});
      await tester.pumpAndSettle();

      expect(find.text('carte factice'), findsOneWidget);
      expect(find.byType(PinEcran), findsNothing);
    },
  );
}
