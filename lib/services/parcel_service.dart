import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment.dart';
import '../models/parcel.dart';
import 'token_service.dart';




class ParcelService {
  static const String baseUrl = '${Environment.baseUrl}/parcels';
  static final TokenService _tokenService = TokenService();


  static Future<Map<String, List<Parcel>>> fetchUserParcels() async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/current-user-parcels'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Décoder en UTF-8 avant de traiter les données JSON
        final utf8DecodedBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = jsonDecode(utf8DecodedBody);

        // Extraire les colis envoyés et reçus
        final List<Parcel> sentParcels = (data['sent'] as List)
            .map((json) => Parcel.fromJson(json))
            .toList();
        final List<Parcel> receivedParcels = (data['received'] as List)
            .map((json) => Parcel.fromJson(json))
            .toList();

        return {
          'sent': sentParcels,
          'received': receivedParcels,
        };
      } else {
        throw Exception('Erreur lors de la récupération des colis : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }


  /// Récupérer les détails d'un colis par son parcelNumber
  static Future<Parcel> fetchParcelDetails(String parcelNumber) async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/$parcelNumber'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final utf8DecodedBody = utf8.decode(response.bodyBytes);
        return Parcel.fromJson(jsonDecode(utf8DecodedBody));
      } else {
        throw Exception('Erreur lors de la récupération des détails du colis : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }


  // Future<Map<String, String>> _buildHeaders() async {
  //   final token = await storage.read(key: 'jwt');
  //   return {
  //     'Content-Type': 'application/json',
  //     if (token != null) 'Authorization': 'Bearer $token',
  //   };
  // }



   /// Créer un nouveau colis en envoyant les données via une requête POST
  static Future<http.Response> createParcel_sans_delivery(Map<String, dynamic> parcelInfo) async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(parcelInfo),
      );
      
      return response; //ici le return 

    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
    
  }
  
}