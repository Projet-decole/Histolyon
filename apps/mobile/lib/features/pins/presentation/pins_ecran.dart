import 'package:flutter/material.dart';

/// Consultation approfondie d'un pin (D2), ouverte au-dessus des onglets.
///
/// Écran provisoire posé par le squelette : à remplacer par la vraie
/// implémentation (voir l'issue GitHub de la feature).
class PinEcran extends StatelessWidget {
  const PinEcran({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pin')),
      body: Center(child: Text(slug)),
    );
  }
}
