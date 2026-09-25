import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Coquille de l'app : barre de navigation entre les trois surfaces
/// principales (Carte, Parcours, Profil). L'ordre des destinations suit
/// l'ordre des branches dans `router.dart`.
class Coquille extends StatelessWidget {
  const Coquille({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Carte'),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            label: 'Parcours',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
