import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import 'pins_ecran.dart';

/// Routes exportées par la feature `pins`. Seul `app/router.dart` les
/// assemble (AD-5). Ajouter ici les sous-routes de la feature.
final List<RouteBase> pinsRoutes = [
  GoRoute(
    path: RouteNames.pinPath,
    name: RouteNames.pin,
    builder: (context, state) => PinEcran(slug: state.pathParameters['slug']!),
  ),
];
