import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import 'carte_ecran.dart';

/// Routes exportées par la feature `carte`. Seul `app/router.dart` les
/// assemble (AD-5). Ajouter ici les sous-routes de la feature.
final List<RouteBase> carteRoutes = [
  GoRoute(
    path: RouteNames.cartePath,
    name: RouteNames.carte,
    builder: (context, state) => const CarteEcran(),
  ),
];
