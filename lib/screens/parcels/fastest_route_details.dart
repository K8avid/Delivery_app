import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../models/location.dart';
import '../../models/trip.dart';
import '../../services/location_service.dart';
import 'map_preview_page.dart';

class FastestRouteDetails extends StatefulWidget {
  final bool isSender;
  final Trip trip; // Utilisation de la classe Trip
  final String userAddress; // Adresse de l'utilisateur fournie explicitement

  const FastestRouteDetails({
    super.key,
    required this.isSender,
    required this.trip,
    required this.userAddress,
  });

  @override
  _FastestRouteDetailsState createState() => _FastestRouteDetailsState();
}

class _FastestRouteDetailsState extends State<FastestRouteDetails> {
  late Future<Map<String, dynamic>> _routeDataFuture;

  @override
  void initState() {
    super.initState();
    // Utiliser directement l'adresse passée en paramètre
    _routeDataFuture = Future.delayed(Duration.zero, () async {
      final String userAddress = widget.userAddress;

      // Déterminer la destination selon isSender :
      // Si isSender est vrai, on prend la localisation de départ du trajet,
      // sinon, celle d'arrivée.
      final Location destinationLocation = widget.isSender
          ? widget.trip.startLocation
          : widget.trip.endLocation;

      final double destLat = destinationLocation.latitude;
      final double destLng = destinationLocation.longitude;

      // Appeler l'API backend pour obtenir la durée et le mode optimal
      final fastestRoute = await LocationService.getFastestRoute(userAddress, destLat, destLng);
      final String mode = fastestRoute['mode'] as String;

      // Convertir l'adresse d'origine en coordonnées
      final originCoordinates = await LocationService.getCoordinates(userAddress);
      if (originCoordinates == null) {
        throw Exception("Impossible de récupérer les coordonnées d'origine");
      }
      final originLocation = Location(
        latitude: originCoordinates['latitude']!,
        longitude: originCoordinates['longitude']!,
        address: userAddress,
      );

      // Appeler l'API Google Directions pour obtenir la polyline
      final String googleDirectionsUrl =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${originLocation.latitude},${originLocation.longitude}&destination=${destinationLocation.latitude},${destinationLocation.longitude}&mode=$mode&key=AIzaSyC9SHD0T9A3wABYMdE-tOfZWHZ6mcbH9fI";
      final directionsResponse = await http.get(Uri.parse(googleDirectionsUrl));
      if (directionsResponse.statusCode == 200) {
        final directionsJson = jsonDecode(directionsResponse.body);
        final String polyline = directionsJson['routes'][0]['overview_polyline']['points'];
        return {
          'originLocation': originLocation,
          'destinationLocation': destinationLocation,
          'polyline': polyline,
        };
      } else {
        throw Exception("Erreur lors de l'appel aux directions API: ${directionsResponse.statusCode}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trajet optimal"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _routeDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Aucune donnée"));
          }
          final routeData = snapshot.data!;
          final originLocation = routeData['originLocation'] as Location;
          final destinationLocation = routeData['destinationLocation'] as Location;
          final String polyline = routeData['polyline'];

          // Focus initial : si isSender est vrai, focus sur l'origine, sinon sur la destination
          final bool focusOnStart = widget.isSender;
          return MapPreviewPage(
            startLocation: originLocation,
            endLocation: destinationLocation,
            polyline: polyline,
            focusOnStart: focusOnStart,
          );
        },
      ),
    );
  }
}
