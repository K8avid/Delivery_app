import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/location.dart';
import '../../services/location_service.dart';
import 'add_trip_route_selection_page.dart'; // Importez votre page suivante

class AddTripEndPreviewPage extends StatefulWidget {
  final String address;
  final Location startLocation; // Ajout de la position de départ
  final Location endLocation;

  const AddTripEndPreviewPage({super.key, 
    required this.address,
    required this.startLocation, // Position de départ transmise
    required this.endLocation,
  });

  @override
  _AddTripEndPreviewPageState createState() => _AddTripEndPreviewPageState();
}

class _AddTripEndPreviewPageState extends State<AddTripEndPreviewPage>
    with SingleTickerProviderStateMixin {
  LatLng? _currentPosition;
  GoogleMapController? _mapController;
  String _currentAddress = '';
  bool _isLoadingAddress = false;

  // Animation
  late AnimationController _animationController;
  late Animation<double> _latitudeAnimation;
  late Animation<double> _longitudeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialiser la position
    _currentPosition = LatLng(widget.endLocation.latitude, widget.endLocation.longitude);
    _currentAddress = widget.address;

    // Configurer l'animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animationController.addListener(() {
      setState(() {
        // Mettre à jour la position avec les valeurs interpolées
        _currentPosition = LatLng(
          _latitudeAnimation.value,
          _longitudeAnimation.value,
        );
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _moveMarker(LatLng newPosition) async {
    // Configurer les animations pour latitude et longitude
    _latitudeAnimation = Tween<double>(
      begin: _currentPosition!.latitude,
      end: newPosition.latitude,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _longitudeAnimation = Tween<double>(
      begin: _currentPosition!.longitude,
      end: newPosition.longitude,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Démarrer l'animation
    _animationController.reset();
    await _animationController.forward();

    // Une fois l'animation terminée, mettre à jour l'adresse
    setState(() {
      _isLoadingAddress = true;
    });
    String updatedAddress = await _reverseGeocode(newPosition.latitude, newPosition.longitude);

    setState(() {
      _currentAddress = updatedAddress;
      _isLoadingAddress = false;
    });
  }

  Future<String> _reverseGeocode(double latitude, double longitude) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulez un délai réseau
    return LocationService.getAddressFromCoordinates(latitude, longitude);
  }

  void _confirmLocation() {
    if (_currentPosition != null) {
      // Créer un objet endLocation mis à jour
      Location updatedEndLocation = Location(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        address: _currentAddress,
      );

      // Naviguer vers la page add_trip_route_selection_page avec startLocation et endLocation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddTripRouteSelectionPage(
            startLocation: widget.startLocation,
            endLocation: updatedEndLocation,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Prévisualisation de l\'adresse d\'arrivée',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Carte Google Maps
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition!,
              zoom: 16,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (LatLng position) {
              setState(() {
                _isLoadingAddress = true;
              });
              _moveMarker(position); // Déplace le marqueur
            },
            markers: {
              Marker(
                markerId: const MarkerId('endMarker'),
                position: _currentPosition!,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              ),
            },
          ),
          // Afficher l'adresse en bas de l'écran
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Adresse actuelle :',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _isLoadingAddress
                      ? Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Chargement...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          _currentAddress,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _confirmLocation,
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
                          'Confirmer l\'adresse',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
