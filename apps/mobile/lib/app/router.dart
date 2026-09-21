import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/router/route_names.dart';

part 'router.g.dart';

/// Unique point d'assemblage des routes (AD-5) : `app/` importe les features
/// pour composer les `GoRoute` qu'elles exportent. Aucune feature n'existe
/// encore (squelette de l'Epic 6) — seul un écran vide est câblé ici, pas une
/// feature, pour que l'app démarre sur quelque chose de visible.
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: RouteNames.cartePath,
    routes: [
      GoRoute(
        path: RouteNames.cartePath,
        name: RouteNames.carte,
        builder: (context, state) => const _EcranVide(),
      ),
    ],
  );
}

class _EcranVide extends StatelessWidget {
  const _EcranVide();

  @override
  Widget build(BuildContext context) => const Scaffold();
}
