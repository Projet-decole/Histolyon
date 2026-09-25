import 'package:flutter/material.dart';

/// Surface S1 (D1) : carte de Lyon, slider d'époques, pins.
///
/// Écran provisoire posé par le squelette : à remplacer par la vraie
/// implémentation (voir l'issue GitHub de la feature).
class CarteEcran extends StatelessWidget {
  const CarteEcran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carte')),
      body: Center(child: const Text('Carte — à venir')),
    );
  }
}
