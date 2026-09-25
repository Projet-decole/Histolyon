import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import 'profil_ecran.dart';

/// Routes exportées par la feature `profil`. Seul `app/router.dart` les
/// assemble (AD-5). Ajouter ici les sous-routes de la feature.
final List<RouteBase> profilRoutes = [
  GoRoute(
    path: RouteNames.profilPath,
    name: RouteNames.profil,
    builder: (context, state) => const ProfilEcran(),
  ),
];
