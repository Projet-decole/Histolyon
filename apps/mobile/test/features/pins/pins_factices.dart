import 'package:mobile/core/models/failure.dart';
import 'package:mobile/features/pins/data/pins_repository.dart';

/// Repository factice : renvoie toujours le même résultat pour `pinParSlug`.
class RepositoryFactice implements PinsRepository {
  RepositoryFactice(this.resultat);

  Result<Pin> resultat;
  int appels = 0;

  @override
  Future<Result<Pin>> pinParSlug(String slug) async {
    appels++;
    return resultat;
  }

  @override
  Future<Result<List<Pin>>> pinsParEpoque(String epoqueSlug) async =>
      const Ok([]);
}

Pin pinFactice({
  List<EncartContenu> postNarratif = const [],
  List<SourceContenu> sources = const [
    SourceContenu(
      id: 's1',
      slug: 'wikipedia-canuts',
      type: 'page_web',
      reference: 'Canut — Wikipédia',
      credit: 'Wikipédia, CC BY-SA',
    ),
  ],
}) => Pin(
  id: 'p1',
  slug: 'cour-des-voraces',
  titre: 'La Cour des Voraces',
  categorie: 'Architecture',
  epoques: const ['xixe_siecle'],
  epoqueLibelles: const ['XIXe siècle'],
  sources: sources,
  localisation: const PointContenu(lat: 45.77, lon: 4.83),
  teaser: 'Une porte cochère.',
  narration:
      'Tu pousses la porte.\n\nAu XIXe siècle, le quartier vivait de la soie.',
  postNarratif: postNarratif,
);
