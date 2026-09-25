import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/router/route_names.dart';
import '../features/carte/presentation/carte_routes.dart';
import '../features/immersion/presentation/immersion_routes.dart';
import '../features/parcours/presentation/parcours_routes.dart';
import '../features/pins/presentation/pins_routes.dart';
import '../features/profil/presentation/profil_routes.dart';
import 'coquille.dart';

part 'router.g.dart';

/// Unique point d'assemblage des routes (AD-5) : `app/` importe les routes
/// exportées par chaque feature. Une feature n'a jamais besoin de modifier ce
/// fichier pour ajouter une sous-route : elle l'ajoute dans son propre
/// `<slug>_routes.dart`.
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: RouteNames.cartePath,
    routes: [
      // Les trois onglets, chacun avec sa propre pile de navigation.
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => Coquille(shell: shell),
        branches: [
          StatefulShellBranch(routes: carteRoutes),
          StatefulShellBranch(routes: parcoursRoutes),
          StatefulShellBranch(routes: profilRoutes),
        ],
      ),
      // Écrans plein écran, au-dessus des onglets.
      ...pinsRoutes,
      ...immersionRoutes,
    ],
  );
}
