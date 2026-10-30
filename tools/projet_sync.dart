// Remise d'équerre du tableau de projet GitHub (ticket #168).
// Squelette : les tests sont rouges, l'implémentation suit.

class ElementProjet {
  const ElementProjet({
    required this.numero,
    required this.titre,
    required this.ouvert,
    required this.statut,
    required this.etiquettes,
    required this.assignes,
    required this.jalon,
    required this.charge,
    required this.priorite,
    required this.nature,
    required this.semaine,
    required this.misAJour,
  });

  final int numero;
  final String titre;
  final bool ouvert;
  final String statut;
  final List<String> etiquettes;
  final List<String> assignes;
  final String? jalon;
  final num? charge;
  final String? priorite;
  final String? nature;
  final String? semaine;
  final DateTime misAJour;
}

enum TypeAnomalie {
  chargeIncoherente,
  prioriteManquante,
  natureManquante,
  sansAssigne,
  statutIncoherent,
  sansMouvement,
  sansSemaine,
}

class Anomalie {
  const Anomalie(this.type, this.numero, this.titre);

  final TypeAnomalie type;
  final int numero;
  final String titre;
}

int? chargeDepuisEtiquettes(List<String> etiquettes) =>
    throw UnimplementedError();

List<Anomalie> analyser(List<ElementProjet> elements, DateTime maintenant) =>
    throw UnimplementedError();

Map<int, int> chargesACorriger(List<ElementProjet> elements) =>
    throw UnimplementedError();

String formaterRapport(List<Anomalie> anomalies) => throw UnimplementedError();
