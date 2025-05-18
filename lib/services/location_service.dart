import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../config/environment.dart';

class LocationService {

  
  static const backendUrl = '${Environment.baseUrl}/maps';

  static Future<List<String>> getPlaceSuggestions(String input) async {
    final url = Uri.parse('$backendUrl/autocomplete?input=$input&language=fr');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['predictions'] as List)
          .map((item) => item['description'] as String)
          .toList();
    } else {
      throw Exception('Erreur lors de la récupération des suggestions : ${response.statusCode}');
    }
  }



  static Future<Position> getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Permission de localisation refusée.");
    }

    // Paramètres spécifiques par plateforme
    final locationSettings = Platform.isAndroid
        ? AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
            forceLocationManager: true,
          )
        : Platform.isIOS
            ? AppleSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter: 10,
                activityType: ActivityType.fitness,
              )
            : WebSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter: 10,
              );

    return await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  }




  /// Récupère une adresse à partir des coordonnées géographiques.
  /// Utilise l'API de géocodage du backend.
  static Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    final url = '$backendUrl/geocode?lat=$latitude&lng=$longitude';

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } on http.ClientException {
      throw NetworkException("Erreur lors de la connexion au serveur.");
    } on TimeoutException {
      throw NetworkException("La requête a expiré.");
    }
  }





static Future<Map<String, double>?> getCoordinates(String address) async {
  print('adress : $address');
    const String url = '$backendUrl/get-coordinates';
    final Uri uri = Uri.parse(
      '$url?address=${Uri.encodeComponent(address)}',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          return {
            'latitude': location['lat'],
            'longitude': location['lng'],
          };
        } else {
          throw Exception('Erreur API : ${data['status']}');
        }
      } else {
        throw Exception('Erreur HTTP : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur : $e');
      return null;
    }
  }





  /// Gère la réponse HTTP et renvoie l'adresse ou lance une exception en cas d'erreur.
  static String _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if ((jsonResponse['results'] as List).isNotEmpty) {
        return jsonResponse['results'][0]['formatted_address'];
      } else {
        throw NoAddressFoundException("Aucune adresse trouvée pour ces coordonnées.");
      }
    } else {
      throw NetworkException("Erreur réseau : ${response.statusCode}");
    }
  }








static Future<List<Map<String, double>>> getRouteBetweenPoints({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      final url = Uri.parse(
          '$backendUrl/directions?originLat=$startLat&originLng=$startLng&destLat=$endLat&destLng=$endLng');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Si la réponse est valide, parsez les données JSON en une liste de points
        final List<dynamic> routeData = jsonDecode(response.body);
        return routeData
            .map((point) => {
                  'lat': point['lat'] as double,
                  'lng': point['lng'] as double,
                })
            .toList();
      } else {
        throw Exception('Erreur lors de la récupération de l\'itinéraire');
      }
    } catch (error) {
      throw Exception('Erreur réseau : $error');
    }
  }









  static Future<List<Map<String, dynamic>>> getRoutesBetweenPoints({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      final url = Uri.parse(
          '$backendUrl/directions?originLat=$startLat&originLng=$startLng&destLat=$endLat&destLng=$endLng');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Analysez les itinéraires renvoyés par l'API
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((route) => {
                  'points': route['points']
                      .map((point) => {
                            'lat': point['lat'] as double,
                            'lng': point['lng'] as double,
                          })
                      .toList(),
                })
            .toList();
      } else {
        throw Exception(
            'Erreur ${response.statusCode}: Impossible de récupérer les itinéraires.');
      }
    } catch (error) {
      throw Exception('Erreur réseau : $error');
    }
  }
  




  // Méthode pour récupérer les données brutes des itinéraires
  static Future<List<dynamic>> getRoutes_2({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    final url = Uri.parse(
        '$backendUrl/directions?originLat=$startLat&originLng=$startLng&destLat=$endLat&destLng=$endLng');
    //print( '$backendUrl/directions?originLat=$startLat&originLng=$startLng&destLat=$endLat&destLng=$endLng');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] != 'OK') {
        throw Exception('Google Directions API error: ${data['status']}');
      }

      return data['routes'] as List<dynamic>;
    } else {
      throw Exception('HTTP Error: ${response.statusCode}');
    }
  }


  static Future<List<double>> getCoordinates_dv(String address) async {
  try {
    final response = await http.get(
      Uri.parse('$backendUrl/get-coordinates-nogeo-$address'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final utf8DecodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> coordinates = jsonDecode(utf8DecodedBody);

      if (coordinates.length == 2 &&
          coordinates[0] is num &&
          coordinates[1] is num) {
        return [coordinates[0].toDouble(), coordinates[1].toDouble()];
      } else {
        throw Exception('Les données JSON ne contiennent pas exactement deux valeurs numériques.');
      }
    } else {
      throw Exception('Erreur lors de la récupération des coordonnées : ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur réseau : $e');
  }
}

static Future<Map<String, dynamic>> getFastestRoute(  //pour recup le trajet le plus court
    String origin, double destLat, double destLng) async { //entre a pied et transport en commun
  final uri = Uri.parse(
    '$backendUrl/fastest-route?origin=${Uri.encodeComponent(origin)}&destLat=$destLat&destLng=$destLng',
  );
  final response = await http.get(uri);

  if (response.statusCode == 200) {

    final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
    print("Duration: ${data['duration']}, Mode: ${data['mode']}");
    return data;
    
  } else {
    throw Exception('Erreur lors de la récupération de l\'itinéraire rapide : ${response.statusCode}');
  }
}




}

//================================== fin class LocationService ================================



/// Exception levée en cas de problème de permissions.
class PermissionDeniedException implements Exception {
  final String message;
  PermissionDeniedException(this.message);
  @override
  String toString() => message;
}


/// Exception levée en cas de problème réseau.
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}


/// Exception levée si aucune adresse n'est trouvée.
class NoAddressFoundException implements Exception {
  final String message;
  NoAddressFoundException(this.message);
  @override
  String toString() => message;
}
