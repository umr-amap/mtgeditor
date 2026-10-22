import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final LatLng position;

  const MapScreen({super.key, required this.position});

  /// Construit le widget [FlutterMap]
  /// Réprésente le trajet par une courbe de Bezier et des icons au positions des aéroports
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: FlutterMap(
        options: MapOptions(initialCenter: position, initialZoom: 13),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.cirad.mesure_plante',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: position,
                child: const Icon(Icons.location_pin, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
