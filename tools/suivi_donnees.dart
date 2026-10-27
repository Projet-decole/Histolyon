// Lecture des données du suivi hebdomadaire (ticket #125) : conversion du JSON
// de `gh` vers les types de `tools/suivi_calculs.dart`, et lecture d'un rapport
// de couverture lcov. Fonctions pures : l'appel de `gh` est dans
// `tools/suivi.dart`.

import 'suivi_calculs.dart';

Ticket ticketDepuisJson(Map<String, dynamic> json) =>
    throw UnimplementedError();

PrData prDepuisJson(Map<String, dynamic> json) => throw UnimplementedError();

/// Date d'ouverture de chaque jalon (clé = titre) : sa création plus une
/// tolérance, au-delà de laquelle un ticket créé compte comme un ajout.
Map<String, DateTime> ouverturesJalons(
  List<dynamic> jalons, {
  int toleranceJours = 2,
}) => throw UnimplementedError();

/// Pourcentage de lignes couvertes par les tests, pour les fichiers de `lib/`
/// hors code généré (`*.g.dart`), ou `null` s'il n'y en a aucun.
double? couvertureLcov(String lcov) => throw UnimplementedError();
