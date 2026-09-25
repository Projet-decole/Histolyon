import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import 'immersion_ecran.dart';

/// Routes exportées par la feature `immersion`. Seul `app/router.dart` les
/// assemble (AD-5). Ajouter ici les sous-routes de la feature.
final List<RouteBase> immersionRoutes = [
  GoRoute(
    path: RouteNames.modele3dPath,
    name: RouteNames.modele3d,
    builder: (context, state) =>
        Modele3dEcran(slug: state.pathParameters['slug']!),
  ),
];
