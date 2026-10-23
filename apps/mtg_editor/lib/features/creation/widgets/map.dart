import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final LatLng position;

  const MapScreen({super.key, required this.position});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  late final AnimationController _animationController;
  late LatLng _displayedPosition;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _displayedPosition = widget.position;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..addListener(_updateMapPosition);
  }

  @override
  void didUpdateWidget(covariant MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) {
      _animateTo(widget.position);
    }
  }

  void _animateTo(LatLng target) {
    if (!_isMapReady) {
      _displayedPosition = target;
      return;
    }

    _animationController
      ..stop()
      ..reset()
      ..forward();
  }

  void _updateMapPosition() {
    if (!_isMapReady) {
      return;
    }

    final start = _displayedPosition;
    final target = widget.position;
    final progress = Curves.easeInOutCubic.transform(
      _animationController.value,
    );
    final position = LatLng(
      start.latitude + (target.latitude - start.latitude) * progress,
      start.longitude + (target.longitude - start.longitude) * progress,
    );

    _displayedPosition = position;
    _mapController.move(position, _mapController.camera.zoom);
    setState(() {});
  }

  void _onMapReady() {
    _isMapReady = true;
    if (_displayedPosition != widget.position) {
      _animateTo(widget.position);
    }
  }

  @override
  void dispose() {
    _animationController
      ..removeListener(_updateMapPosition)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _displayedPosition,
          initialZoom: 13,
          onMapReady: _onMapReady,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.cirad.mesure_plante',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _displayedPosition,
                child: const Icon(Icons.location_pin, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
