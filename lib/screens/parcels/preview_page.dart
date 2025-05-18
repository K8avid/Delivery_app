import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PreviewPage extends StatefulWidget {
  final Map<String, dynamic> location;
  final Map<String, dynamic> destination;
  final bool isDeparture;
  final String polyline;

  const PreviewPage({
    super.key,
    required this.location,
    required this.destination,
    required this.isDeparture,
    required this.polyline,
  });

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkersAndPolyline();

    // Initialiser le focus en fonction de `isDeparture`
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setInitialFocus();
    });
  }

  void _setMarkersAndPolyline() {
    LatLng startCoordinates = LatLng(
      widget.location['latitude'],
      widget.location['longitude'],
    );

    LatLng endCoordinates = LatLng(
      widget.destination['latitude'],
      widget.destination['longitude'],
    );

    // Ajouter les marqueurs pour le départ et l'arrivée
    _markers.add(
      Marker(
        markerId: const MarkerId('start'),
        position: startCoordinates,
        infoWindow: InfoWindow(
          title: "Point de Départ",
          snippet: widget.location['address'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onTap: () {
          _focusOnPoint(startCoordinates);
        },
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('end'),
        position: endCoordinates,
        infoWindow: InfoWindow(
          title: "Point d'Arrivée",
          snippet: widget.destination['address'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: () {
          _focusOnPoint(endCoordinates);
        },
      ),
    );

    // Décoder le polyline encodé pour afficher l'itinéraire
    if (widget.polyline.isNotEmpty) {
      List<LatLng> polylineCoordinates = _decodePolyline(widget.polyline);
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 4,
        ),
      );
    }
  }

  void _setInitialFocus() {
    // Focus sur le point initial basé sur `isDeparture`
    LatLng initialFocus = widget.isDeparture
        ? LatLng(
            widget.location['latitude'],
            widget.location['longitude'],
          )
        : LatLng(
            widget.destination['latitude'],
            widget.destination['longitude'],
          );

    _focusOnPoint(initialFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.isDeparture ? "Prévisualisation - Départ" : "Prévisualisation - Arrivée",
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          // Google Map Widget
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.isDeparture
                    ? widget.location['latitude']
                    : widget.destination['latitude'],
                widget.isDeparture
                    ? widget.location['longitude']
                    : widget.destination['longitude'],
              ),
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
          ),
          // Adresse affichée en haut
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: widget.isDeparture ? Colors.blue : Colors.red,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.isDeparture
                          ? widget.location['address']
                          : widget.destination['address'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mettre le focus sur un point sélectionné
  void _focusOnPoint(LatLng point) {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: point, zoom: 16),
    ));
  }

  // Décoder le polyline encodé
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    if (encoded.isEmpty) {
      return polyline; // Retourne une liste vide si la chaîne est vide
    }

    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }
}
