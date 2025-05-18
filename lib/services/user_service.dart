import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/environment.dart';
import 'token_service.dart';

class UserService {
  static const String baseUrl = '${Environment.baseUrl}/auth';
  static final TokenService _tokenService = TokenService();




  /// Récupérer le profil de l'utilisateur actuel
  static Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      // Récupérer le token JWT
      final token = await _tokenService.getToken();

      // Vérifiez que le token existe
      if (token == null || token.isEmpty) {
        throw Exception("Token JWT non disponible");
      }

      // Faire une requête GET pour récupérer le profil
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Inclure le token JWT
        },
      );

      if (response.statusCode == 200) {
        // Décoder la réponse en UTF-8
        final utf8DecodedBody = utf8.decode(response.bodyBytes);
        return jsonDecode(
            utf8DecodedBody); // Retourner le JSON sous forme de Map
      } else {
        throw Exception(
            'Erreur lors de la récupération du profil utilisateur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau ou serveur : $e');
    }
  }







  static Future<http.Response> saveUser(
    String firstName,
    String lastName,
    String email,
    String password,
    String dateOfBirth, // Utilisez une chaîne au format 'YYYY-MM-DD' pour simplifie
    String phoneNumber,
    String vehicle,
    String address,
    String city,
    String country,
  ) async {
    // var uri = Uri.parse("http://10.10.44.147:8080/api/v1/auth/register");
    var uri = Uri.parse('$baseUrl/register');
    Map<String, String> headers = {"Content-Type": "application/json"};

    // Données à envoyer dans la requête
    Map data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'dateOfBirth': dateOfBirth, // Format: 'YYYY-MM-DD'
      'phoneNumber': phoneNumber,
      'vehicle': vehicle,
      'address': address,
      'city': city,
      'country': country,
    };

    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);
    print(
        "Réponse du serveur : ${response.body}"); // Affiche la réponse du serveur

    return response;
  }







  

  // Méthode pour récupérer le profil utilisateur
  static Future<Map<String, dynamic>> getUserProfile() async {
    final token = await _tokenService.getToken();
    final url = Uri.parse('$baseUrl/me');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return json.decode(decodedBody);
    } else {
      throw Exception('Failed to load user profile');
    }
  }








  // Méthode pour supprimer le compte utilisateur
  static Future<void> deleteUserProfile(String tokenp) async {

    final token = await _tokenService.getToken();
    final url = Uri.parse('$baseUrl/delete');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
         if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // La suppression a réussi
      print('Compte supprimé avec succès.');
    } else if (response.statusCode == 404) {
      // Si l'utilisateur n'est pas trouvé
      throw Exception('Utilisateur non trouvé.');
    } else {
      // En cas d'erreur serveur ou autre erreur
      throw Exception('Échec de la suppression du compte.');
    }
  }





  //methode pour mettre a jours les informations de l'utilisateur authentifie (a l'aide du token jwt)
  static Future<void> updateUserProfile(String token, Map<String, dynamic> updatedData) async {
      final url = Uri.parse('$baseUrl/update');

      final token = await _tokenService.getToken();

  
      
      final response = await http.put(
        url,
        headers: {
           if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedData), // Envoi des nouvelles données sous forme JSON
      );

      if (response.statusCode == 200) {
        // Mise à jour réussie
        print('Profil mis à jour avec succès.');
      } else if (response.statusCode == 400) {
        // Si les données envoyées sont invalides
        throw Exception('Données invalides pour la mise à jour.');
      } else if (response.statusCode == 404) {
        // Si l'utilisateur n'est pas trouvé
        throw Exception('Utilisateur non trouvé.');
      } else {
        // En cas d'erreur serveur ou autre erreur
        throw Exception('Échec de la mise à jour du profil.');
      }
    }


// Ajoute cette méthode dans UserService pour récupérer la liste des utilisateurs
static Future<List<Map<String, dynamic>>> fetchUsers() async {
  try {
    // Récupérer le token JWT
    final token = await _tokenService.getToken();

    // Vérifiez que le token existe
    if (token == null || token.isEmpty) {
      throw Exception("Token JWT non disponible");
    }

    // Faire une requête GET pour récupérer la liste des utilisateurs
    final response = await http.get(
      Uri.parse('http://192.168.1.20:8080/api/v1/users'), // L'URL à adapter selon l'API
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Inclure le token JWT
      },
    );

    if (response.statusCode == 200) {
      // Décoder la réponse en UTF-8
      final utf8DecodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(utf8DecodedBody);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Erreur lors de la récupération des utilisateurs : ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur réseau ou serveur : $e');
  }
}



}
