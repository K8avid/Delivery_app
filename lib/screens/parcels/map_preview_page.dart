
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/location.dart';

class MapPreviewPage extends StatefulWidget {
  final Location startLocation;
  final Location endLocation;
  final String polyline;
  final bool focusOnStart;

  const MapPreviewPage({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.polyline,
    required this.focusOnStart,
  });

  @override
  _MapPreviewPageState createState() => _MapPreviewPageState();
}

class _MapPreviewPageState extends State<MapPreviewPage> {
  late GoogleMapController _mapController;
  late LatLng _currentLatLng;
  late String _currentAddress;
  Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];
  bool _isMapLoading = true;
  bool _isMarkersSet = false;

  @override
  void initState() {
    super.initState();

    // Initialisation en fonction du point focal
    _currentLatLng = widget.focusOnStart
        ? LatLng(widget.startLocation.latitude, widget.startLocation.longitude)
        : LatLng(widget.endLocation.latitude, widget.endLocation.longitude);

    _currentAddress = widget.focusOnStart
        ? widget.startLocation.address
        : widget.endLocation.address;

    // Définir les marqueurs et tracer le polyline
    _decodePolyline(widget.polyline);
    _setMarkers();
  }

  void _setMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId("start"),
        position: LatLng(
          widget.startLocation.latitude,
          widget.startLocation.longitude,
        ),
        infoWindow: InfoWindow(
          title: "Départ",
          snippet: widget.startLocation.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId("end"),
        position: LatLng(
          widget.endLocation.latitude,
          widget.endLocation.longitude,
        ),
        infoWindow: InfoWindow(
          title: "Arrivée",
          snippet: widget.endLocation.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    setState(() {
      _isMarkersSet = true;
    });
  }

  /// Décodage manuel de la polyline
  void _decodePolyline(String polyline) {
    List<LatLng> coordinates = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;

      int b;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      coordinates.add(LatLng(lat / 1e5, lng / 1e5));
    }

    setState(() {
      _polylineCoordinates = coordinates;
    });
  }

  /// Fonction pour ouvrir Google Maps avec l'emplacement
  void _openInGoogleMaps(LatLng position) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Impossible d\'ouvrir Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Supprime l'ombre
        title: const Text(
          "Prévisualisation du Trajet",
          style: TextStyle(
            color: Colors.black, // Texte noir
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black), // Icônes noires
      ),
      body: Stack(
        children: [
          if (_isMarkersSet)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLatLng,
                zoom: 14,
              ),
              markers: _markers,
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: _polylineCoordinates,
                  color: Colors.blue,
                  width: 5,
                ),
              },
              onMapCreated: (controller) {
                _mapController = controller;
                setState(() {
                  _isMapLoading = false;
                });
              },
            ),
          if (_isMapLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          _buildCurrentAddressInfo(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            _openInGoogleMaps(_currentLatLng);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Ouvrir dans Google Maps",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// Widget pour afficher l'adresse actuelle
  Widget _buildCurrentAddressInfo() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                widget.focusOnStart ? Icons.place : Icons.flag,
                color: widget.focusOnStart ? Colors.blue : Colors.red,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _currentAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
