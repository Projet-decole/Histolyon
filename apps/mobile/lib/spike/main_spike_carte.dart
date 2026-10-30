// Spike #129 : fond de carte de Lyon lu depuis un fichier PMTiles embarqué.
// Lancer avec : flutter run -t lib/spike/main_spike_carte.dart
// Code jetable : ne pas importer depuis l'app (voir produit/decisions/DEC-110.md).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:maplibre/maplibre.dart';
import 'package:path_provider/path_provider.dart';

const _assetPmtiles = 'assets/spike/lyon.pmtiles';

// Bellecour ; emprise de test, à remplacer par celle du fichier extrait.
const _bellecour = Geographic(lon: 4.8320, lat: 45.7578);
const _emprise = LngLatBounds(
  longitudeWest: 4.77,
  longitudeEast: 4.93,
  latitudeSouth: 45.70,
  latitudeNorth: 45.80,
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _SpikeCarte());
}

/// MapLibre Native 13.5 ne lit pas `pmtiles://asset://` : on copie l'asset
/// dans le stockage de l'app une fois, puis on lit `pmtiles://file://`.
Future<String> _cheminPmtiles() async {
  final dossier = await getApplicationSupportDirectory();
  final fichier = File('${dossier.path}/lyon.pmtiles');
  final data = await rootBundle.load(_assetPmtiles);
  if (!fichier.existsSync() || fichier.lengthSync() != data.lengthInBytes) {
    await fichier.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
  }
  return fichier.path;
}

String _style(String chemin) => jsonEncode({
  'version': 8,
  'sources': {
    'protomaps': {
      'type': 'vector',
      'url': 'pmtiles://file://$chemin',
      'attribution': '© OpenStreetMap contributors · Protomaps',
    },
  },
  'layers': [
    {
      'id': 'fond',
      'type': 'background',
      'paint': {'background-color': '#f2efe9'},
    },
    {
      'id': 'eau',
      'type': 'fill',
      'source': 'protomaps',
      'source-layer': 'water',
      'paint': {'fill-color': '#a7c7e7'},
    },
    {
      'id': 'parcs',
      'type': 'fill',
      'source': 'protomaps',
      'source-layer': 'landuse',
      'paint': {'fill-color': '#cfe3c0'},
    },
    {
      'id': 'batiments',
      'type': 'fill',
      'source': 'protomaps',
      'source-layer': 'buildings',
      'paint': {'fill-color': '#d9d2c5'},
    },
    {
      'id': 'routes',
      'type': 'line',
      'source': 'protomaps',
      'source-layer': 'roads',
      'paint': {'line-color': '#ffffff', 'line-width': 1.5},
    },
  ],
});

class _SpikeCarte extends StatelessWidget {
  const _SpikeCarte();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FutureBuilder<String>(
        future: _cheminPmtiles(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Erreur : ${snap.error}'));
          }
          if (!snap.hasData) return const SizedBox.shrink();
          return Stack(
            children: [
              MapLibreMap(
                options: MapOptions(
                  initCenter: _bellecour,
                  initZoom: 13,
                  minZoom: 11,
                  maxBounds: _emprise,
                  initStyle: _style(snap.data!),
                ),
              ),
              const Positioned(
                left: 8,
                bottom: 8,
                child: Text(
                  '© OpenStreetMap contributors · Protomaps',
                  style: TextStyle(fontSize: 11, color: Color(0xFF000000)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
