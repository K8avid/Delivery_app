import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/delivery.dart';
import '../config/environment.dart';
import 'token_service.dart';


class DeliveryService {
  static const String baseUrl = '${Environment.baseUrl}/deliveries';
  static final TokenService _tokenService = TokenService();

  /// Récupérer les détails d'une livraison
  static Future<Delivery> fetchDeliveryDetails(String parcelNumber) async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/parcel/$parcelNumber'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final utf8DecodedBody = utf8.decode(response.bodyBytes);
        return Delivery.fromJson(jsonDecode(utf8DecodedBody));
      } else {
        throw Exception('Erreur lors de la récupération des détails : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }


  /// Traiter une livraison
  static Future<bool> processDelivery(Map<String, dynamic> requestPayload) async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        return true; // Succès
      } else {
        return false; // Échec
      }

    } catch (e) {
      throw Exception('Erreur lors du traitement de la livraison : $e');
    }
  }







//  static Future<List<Map<String, dynamic>>> fetchParcelsByTripAndStatus(String tripNumber, String status) async {
//     final token = await _tokenService.getToken();
//     final url = Uri.parse('$baseUrl/trip/$tripNumber/parcels-request?status=$status');
//     final response = await http.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         if (token != null) 'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> body = json.decode(response.body);
//       return body.map((e) => e as Map<String, dynamic>).toList();
//     } else if (response.statusCode == 204) {
//       return [];
//     } else {
//       throw Exception('Failed to load parcels: ${response.statusCode}');
//     }
//   }




static Future<List<Map<String, dynamic>>> fetchParcelsByTripAndStatus(
    String tripNumber, String status) async {
  final token = await _tokenService.getToken();
  final url = Uri.parse('$baseUrl/trip/$tripNumber/parcels-request?status=$status');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // Décoder correctement la réponse en UTF-8
    final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
    return body.map((e) => e as Map<String, dynamic>).toList();
  } else if (response.statusCode == 204) {
    return [];
  } else {
    throw Exception('Failed to load parcels: ${response.statusCode}');
  }
}



  static Future<void> patchDeliveryStatus(String deliveryNumber, String newStatus) async {
    final token = await _tokenService.getToken();
    final url = Uri.parse('$baseUrl/$deliveryNumber/status');

    print('$baseUrl/$deliveryNumber/status');
    print("🔹 Bearer Token : ${token ?? 'Aucun token'}");  // Afficher le token (ou 'Aucun token' s'il est null)
    
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode({'status': newStatus}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to patch delivery status: ${response.statusCode}');
    }
  }






  // static Future<List<dynamic>> fetchParcelsByTripExcludingStatuses(String tripNumber) async {
  //   final token = await _tokenService.getToken();
  //   final url = Uri.parse('$baseUrl/trip/$tripNumber/parcels-trip');
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final List<dynamic> body = json.decode(response.body);
  //     return body;
  //   } else if (response.statusCode == 204) {
  //     return [];
  //   } else {
  //     throw Exception('Failed to fetch deliveries: ${response.statusCode}');
  //   }
  // }


  static Future<List<dynamic>> fetchParcelsByTripExcludingStatuses(String tripNumber) async {
    final token = await _tokenService.getToken();
    final url = Uri.parse('$baseUrl/trip/$tripNumber/parcels-trip');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Décoder correctement la réponse en UTF-8
      final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body;
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Failed to fetch deliveries: ${response.statusCode}');
    }
  }


  


  static Future<String> pickupParcel(String pickupToken, String tripNumber) async {
    final token = await _tokenService.getToken();
    final url = Uri.parse('$baseUrl/pickup');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'pickupToken': pickupToken,
        'tripNumber': tripNumber,
      }),
    );

    if (response.statusCode == 200) {
      return "Colis récupéré avec succès !";
    } else if (response.statusCode == 403) {
      throw Exception("Accès refusé : ${response.body}");
    } else if (response.statusCode == 400) {
      throw Exception("Erreur : ${response.body}");
    } else {
      throw Exception("Erreur serveur : ${response.body}");
    }
  }




  // Fonction pour livrer un colis
  static Future<String> deliverParcel(String qrToken, String tripNumber) async {
    final token = await _tokenService.getToken();
    final url = Uri.parse('$baseUrl/deliver');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'qrToken': qrToken,
        'tripNumber': tripNumber,
      }),
    );

    if (response.statusCode == 200) {
      return "Colis livré avec succès !";
    } else if (response.statusCode == 403) {
      throw Exception("Accès refusé : ${response.body}");
    } else if (response.statusCode == 400) {
      throw Exception("Erreur : ${response.body}");
    } else {
      throw Exception("Erreur serveur : ${response.body}");
    }
  }





  static Future<bool> processDelivery_with_existing_parcel(Map<String, dynamic> requestPayload) async {
    try {
      final token = await _tokenService.getToken();
      print('$baseUrl/existing_parcel');
      final response = await http.post(
        Uri.parse('$baseUrl/existing_parcel'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        return true; // Succèsp
      } else {
        return false; // Échec
      }
    } catch (e) {
      throw Exception('Erreur lors du traitement de la livraison : $e');
    }
  }
  

}
