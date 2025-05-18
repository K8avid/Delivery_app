import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../config/environment.dart';
import '../models/location.dart';
import '../services/token_service.dart';

class TripService {
  static const String backendUrl = '${Environment.baseUrl}/trips';
  static final TokenService _tokenService = TokenService();

  static Future<List<dynamic>> searchTrips(Map<String, dynamic> parcelInfo) async {
    try {
      // Récupération du token JWT
      final token = await _tokenService.getToken();

      // Vérification et formatage de la date au format yyyy-MM-dd
      String formattedDate;
      try {
        DateTime parsedDate = DateTime.parse(parcelInfo['date']);
        formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (e) {
        throw Exception('Le format de la date est invalide : ${parcelInfo['date']}');
      }

      // Génération de l'URL avec les paramètres de recherche
      final Uri url = Uri.parse('$backendUrl/search').replace(queryParameters: {
        'departureAddress': parcelInfo['senderAddress'],
        'arrivalAddress': parcelInfo['recipientAddress'],
        'date': formattedDate,
      });

      // Envoi de la requête GET avec le token d'authentification
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      // Gestion des réponses HTTP
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data;
        } else {
          throw Exception('Format de réponse inattendu');
        }
      } else if (response.statusCode == 404) {
        // Aucun trajet trouvé (No Content)
        return []; // Retourner une liste vide
      } else {
        throw Exception(
            'Erreur lors de la récupération des trajets : ${response.statusCode}');
      }
    } catch (error) {
      // Gestion des exceptions réseau ou JSON
      throw Exception('Une erreur est survenue : $error');
    }
  }





  static Future<List<dynamic>> fetchTripsOfCurrentUser() async {
    try {
      // Récupération du token JWT
      final token = await _tokenService.getToken();

      final url = Uri.parse('$backendUrl/my-trips');

      // Envoi de la requête GET avec le token d'authentification
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        return jsonDecode(utf8Body);
      } else {
        throw Exception(
          'Erreur lors de la récupération des trajets : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur : $e');
    }
  }





  static Future<bool> addTrip({
    required Location startLocation,
    required Location endLocation,
    required String polyline,
    required double duration,
    required double distance,
    required DateTime departureTime,
  }) async {
    try {
      
      final token = await _tokenService.getToken();
      final url = Uri.parse(backendUrl);

      // Construction du body
      final Map<String, dynamic> body = {
        'startLocation': {
          'latitude': double.parse(startLocation.latitude.toString()),
          'longitude': double.parse(startLocation.longitude.toString()),
          'address': startLocation.address,
        },
        'endLocation': {
          'latitude': double.parse(endLocation.latitude.toString()),
          'longitude': double.parse(endLocation.longitude.toString()),
          'address': endLocation.address,
        },
        'polyline': polyline,
        'duration': double.parse(duration.toString()),
        'distance': double.parse(distance.toString()),
        'departureTime': departureTime.toIso8601String(),
      };

      // Afficher le body encodé avant l'envoi
      final String encodedBody = jsonEncode(body);
      print("Body Encodé : $encodedBody");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: encodedBody,
      );

      // Console log de la réponse
      print("Statut de la réponse : ${response.statusCode}");
      print("Corps de la réponse : ${response.body}");

      if (response.statusCode == 200) {
        return true; // Requête réussie
      } else {
        throw Exception("Erreur du serveur : ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print("Erreur : $error");
      throw Exception("Erreur réseau : $error");
    }
  }



// //recherche de trip par rayon et par date d'expiration
//  static Future<List<dynamic>> searchTrips_by_radius_by_expiracy(Map<String, dynamic> parcelInfo) async {

    
//     final token = await _tokenService.getToken();
//     try {
//       // Récupérer les coordonnées de l'adresse de départ et d'arrivée
//       final senderCoordinates = await LocationService.getCoordinates_dv(parcelInfo['senderAddress']);
      
//       final recipientCoordinates = await LocationService.getCoordinates_dv(parcelInfo['recipientAddress']);
      
//       // Récupérer la date d'expiration de parcelInfo
//       DateTime expiracyDate = DateTime.parse(parcelInfo['expiracyDate']);
      
//       // Formater la date d'expiration au format yyyy-MM-dd
//       String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(expiracyDate);


//       // Rayon (radius) : à définir dans le parcelInfo ou comme paramètre
//       double radius = Environment.rayonTripParcel; // Par défaut 10 km si non précisé
//       //print('$backendUrl/trips_in_range_$radius/before_$formattedDate/debut_${senderCoordinates[1]}_${senderCoordinates[0]}/fin_${recipientCoordinates[1]}_${recipientCoordinates[0]}');
//       // Construire l'URL de l'API Spring Boot
//       final Uri url = Uri.parse('$backendUrl/trips_in_range_$radius/before_$formattedDate/debut_${senderCoordinates[1]}_${senderCoordinates[0]}/fin_${recipientCoordinates[1]}_${recipientCoordinates[0]}');

//       // Envoi de la requête GET
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//            if (token != null) 'Authorization': 'Bearer $token',
//         },
//       );

//       // Gestion des réponses HTTP
//       if (response.statusCode == 200) {
        
//         final data = jsonDecode(response.body);
//         if (data is List) {
          
//           return data; // Retourner la liste des trajets
//         } else {
//           throw Exception('Format de réponse inattendu');
//         }
//       } else if (response.statusCode == 404) {
        
//         // Aucun trajet trouvé
//         return []; // Retourner une liste vide
//       } else {
//         throw Exception('Erreur lors de la récupération des trajets : ${response.statusCode}');
//       }
//     } catch (error) {
//       // Gestion des exceptions
//       throw Exception('Une erreur est survenue : $error');
//     }
//   }



// // Recherche de trip par rayon et par date d'expiration
// static Future<List<dynamic>> searchTrips_by_radius_by_expiracy(Map<String, dynamic> parcelInfo) async {
//   final token = await _tokenService.getToken();

//   try {
//     // Récupérer les coordonnées de l'adresse de départ et d'arrivée
//     final senderCoordinates = await LocationService.getCoordinates_dv(parcelInfo['senderAddress']);
//     final recipientCoordinates = await LocationService.getCoordinates_dv(parcelInfo['recipientAddress']);

//     // Récupérer et formater la date d'expiration
//     DateTime expiracyDate = DateTime.parse(parcelInfo['expiracyDate']);
//     String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(expiracyDate);

//     // Rayon (radius) : récupéré depuis l'environnement ou un paramètre par défaut
//     double radius = parcelInfo['radius'] ?? Environment.rayonTripParcel;

//     // Construire l'URL de l'API avec query parameters
//     // final Uri url = Uri.parse('$backendUrl/trips_in_range').replace(queryParameters: {
//     //   'radius': radius.toString(),
//     //   'expiracyDate': formattedDate,
//     //   'longitudeDebut': senderCoordinates[1].toString(),
//     //   'latitudeDebut': senderCoordinates[0].toString(),
//     //   'longitudeFin': recipientCoordinates[1].toString(),
//     //   'latitudeFin': recipientCoordinates[0].toString(),
//     // });


//     final Uri url = Uri.parse(backendUrl);

    

//     // Envoi de la requête GET
//     final response = await http.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         if (token != null) 'Authorization': 'Bearer $token',
//       },
//     );

//     // Gestion des réponses HTTP
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data is List) {
//         return data; // Retourner la liste des trajets
//       } else {
//         throw Exception('Format de réponse inattendu');
//       }
//     } else if (response.statusCode == 404) {
//       return []; // Aucun trajet trouvé
//     } else {
//       throw Exception('Erreur lors de la récupération des trajets : ${response.statusCode}');
//     }
//   } catch (error) {
//     // Gestion des exceptions
//     throw Exception('Une erreur est survenue : $error');
//   }
// }




 /// Recherche des trajets
  static Future<List<dynamic>> searchTrips_3(Map<String, dynamic> parcelInfo) async {
    // Vérification des paramètres requis
    if (!parcelInfo.containsKey('senderAddress') ||
        !parcelInfo.containsKey('recipientAddress') ||
        !parcelInfo.containsKey('expiracyDate')) {
      throw Exception('Les paramètres senderAddress, recipientAddress et expiracyDate sont requis.');
    }

    // Formatage de la date
    String formattedDate;
    try {
      DateTime parsedDate = DateTime.parse(parcelInfo['expiracyDate']);
      formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      throw Exception('Le format de la date est invalide : ${parcelInfo['expiracyDate']}');
    }

    // Génération de l'URL
    final Uri url = Uri.parse('$backendUrl/search3').replace(queryParameters: {
      'departureAddress': parcelInfo['senderAddress'],
      'arrivalAddress': parcelInfo['recipientAddress'],
      'dateLimit': formattedDate,
    });

    // Récupération du token JWT
    final token = await _tokenService.getToken();

    try {
      // Envoi de la requête GET
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      // // Analyse de la réponse
      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   if (data is List) {
      //     return data;
      //   } else {
      //     throw Exception('Format de réponse inattendu : ${response.body}');
      //   }
      // } else if (response.statusCode == 404) {
      //   // Aucun trajet trouvé
      //   return [];
      // } else {
      //   // Erreur côté serveur
      //   throw Exception(
      //       'Erreur lors de la récupération des trajets : Code ${response.statusCode}, Message: ${response.body}');
      // }


      // Analyse de la réponse
if (response.statusCode == 200) {
  // Décodage de la réponse en UTF-8
  final decodedBody = utf8.decode(response.bodyBytes);
  final data = jsonDecode(decodedBody);

  if (data is List) {
    return data;
  } else {
    throw Exception('Format de réponse inattendu : $decodedBody');
  }
} else if (response.statusCode == 404) {
  // Aucun trajet trouvé
  return [];
} else {
  // Erreur côté serveur
  final decodedBody = utf8.decode(response.bodyBytes);
  throw Exception(
      'Erreur lors de la récupération des trajets : Code ${response.statusCode}, Message: $decodedBody');
}
    } catch (error) {
      // Gestion des exceptions réseau ou JSON
      throw Exception('Une erreur est survenue lors de la requête : $error');
    }
  }


  static Future<bool> deleteTrip(String tripId) async {
    try {
      final token = await _tokenService.getToken();
      final url = Uri.parse('$backendUrl/$tripId'); // URL pour supprimer le trajet par son ID

      // Envoi de la requête DELETE avec le token d'authentification
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      // Vérification du statut de la réponse
      if (response.statusCode == 200) {
        // Si la suppression est réussie, on retourne true
        return true;
      } else {
        throw Exception('Erreur lors de la suppression du trajet : ${response.statusCode}');
      }
    } catch (error) {
      // Gestion des erreurs
      print('Erreur lors de la suppression du trajet : $error');
      throw Exception('Une erreur est survenue lors de la suppression : $error');
    }
  }



}
