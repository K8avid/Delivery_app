import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/location.dart';
import '../../services/location_service.dart';
import 'add_trip_date_page.dart';

class AddTripRouteSelectionPage extends StatefulWidget {
  final Location startLocation;
  final Location endLocation;

  const AddTripRouteSelectionPage({super.key, 
    required this.startLocation,
    required this.endLocation,
  });

  @override
  _AddTripRouteSelectionPageState createState() =>
      _AddTripRouteSelectionPageState();
}

class _AddTripRouteSelectionPageState extends State<AddTripRouteSelectionPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<Map<String, dynamic>> _routes = [];
  int? _selectedRouteIndex;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addMarkers();
    _fetchRoutes();
  }

  void _addMarkers() {
    _markers.add(Marker(
      markerId: const MarkerId('start'),
      position: LatLng(widget.startLocation.latitude, widget.startLocation.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
    _markers.add(Marker(
      markerId: const MarkerId('end'),
      position: LatLng(widget.endLocation.latitude, widget.endLocation.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
  }

  Future<void> _fetchRoutes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final routesData = await LocationService.getRoutes_2(
        startLat: widget.startLocation.latitude,
        startLng: widget.startLocation.longitude,
        endLat: widget.endLocation.latitude,
        endLng: widget.endLocation.longitude,
      );

      final routes = routesData.map<Map<String, dynamic>>((route) {
        final overviewPolyline = route['overview_polyline']['points'];
        final leg = route['legs'][0];

        return {
          'distance': leg['distance']['value'] / 1000,
          'duration': leg['duration']['value'] / 60,
          'encodedPolyline': overviewPolyline,
        };
      }).toList();

      setState(() {
        _routes = routes;
        if (_routes.isNotEmpty) {
          _selectedRouteIndex = 0;
          _updatePolyline(0);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des itinéraires : $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updatePolyline(int index) {
    final route = _routes[index];
    final decodedPoints = _decodePolyline(route['encodedPolyline']);

    setState(() {
      _selectedRouteIndex = index;
      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: PolylineId('route_$index'),
        color: Colors.blue,
        width: 5,
        points: decodedPoints,
      ));
    });

    _centerMap(decodedPoints);
  }

  void _centerMap(List<LatLng> points) {
    if (points.isEmpty || _mapController == null) return;

    LatLngBounds bounds = _getBounds(points);
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (LatLng point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  String _convertDurationToHoursMinutes(double duration) {
    int hours = duration ~/ 60;
    int minutes = (duration % 60).toInt();
    return hours > 0 ? "$hours h $minutes min" : "$minutes min";
  }

  void _confirmRoute() {
    if (_selectedRouteIndex != null) {
      final selectedRoute = _routes[_selectedRouteIndex!];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddTripDatePage(
            startLocation: widget.startLocation,
            endLocation: widget.endLocation,
            polyline: selectedRoute['encodedPolyline'],
            duration: selectedRoute['duration'],
            distance: selectedRoute['distance'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choisir un Itinéraire",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3, // Réduction de l'espace pour la carte
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.startLocation.latitude, widget.startLocation.longitude),
                    zoom: 12,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
                if (_isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          Expanded(
            flex: 2, // Plus d'espace pour les itinéraires
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Itinéraires Disponibles",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _routes.length,
                      itemBuilder: (context, index) {
                        final route = _routes[index];
                        return RadioListTile<int?>(
                          value: index,
                          groupValue: _selectedRouteIndex,
                          onChanged: (value) => _updatePolyline(value!),
                          title: Text(
                            "Itinéraire ${index + 1}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "Distance : ${route['distance'].toStringAsFixed(1)} km, Durée : ${_convertDurationToHoursMinutes(route['duration'])}",
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: ElevatedButton(
                      onPressed: _confirmRoute,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 20, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Confirmer Itinéraire',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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
}
