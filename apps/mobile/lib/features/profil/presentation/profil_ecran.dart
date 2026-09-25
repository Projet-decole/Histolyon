import 'package:flutter/material.dart';

/// Surface S3 (D6) : profil local, favoris, historique, réglages.
///
/// Écran provisoire posé par le squelette : à remplacer par la vraie
/// implémentation (voir l'issue GitHub de la feature).
class ProfilEcran extends StatelessWidget {
  const ProfilEcran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(child: const Text('Profil — à venir')),
    );
  }
}
