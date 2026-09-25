import 'package:flutter/material.dart';

/// Surface S2 (D3) : catalogue et mes parcours.
///
/// Écran provisoire posé par le squelette : à remplacer par la vraie
/// implémentation (voir l'issue GitHub de la feature).
class ParcoursEcran extends StatelessWidget {
  const ParcoursEcran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parcours')),
      body: Center(child: const Text('Parcours — à venir')),
    );
  }
}
