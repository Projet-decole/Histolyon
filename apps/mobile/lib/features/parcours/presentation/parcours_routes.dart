import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import 'parcours_ecran.dart';

/// Routes exportées par la feature `parcours`. Seul `app/router.dart` les
/// assemble (AD-5). Ajouter ici les sous-routes de la feature.
final List<RouteBase> parcoursRoutes = [
  GoRoute(
    path: RouteNames.parcoursPath,
    name: RouteNames.parcours,
    builder: (context, state) => const ParcoursEcran(),
  ),
];
