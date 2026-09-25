import 'package:flutter/material.dart';

/// Consultation 3D / AR d'un modèle (D8), ouverte au-dessus des onglets.
///
/// Écran provisoire posé par le squelette : à remplacer par la vraie
/// implémentation (voir l'issue GitHub de la feature).
class Modele3dEcran extends StatelessWidget {
  const Modele3dEcran({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modèle 3D')),
      body: Center(child: Text(slug)),
    );
  }
}
