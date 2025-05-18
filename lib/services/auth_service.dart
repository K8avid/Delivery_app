import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../config/environment.dart';

class AuthService {

  static const String baseUrl = '${Environment.baseUrl}/auth';
  final storage = const FlutterSecureStorage();



  Future<bool> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/authenticate'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    String token = json.decode(response.body)['token'];
    await storage.write(key: 'jwt', value: token);

    // 🔹 Décodage du token
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String role = decodedToken['role'] ?? 'ROLE_USER'; // Par défaut, utilisateur normal
    
    // 🔹 Affichage du rôle pour le debug
    print("🔹 Rôle reçu depuis le token : $role");
    
    // 🔹 Stockage du rôle
    await storage.write(key: 'user_role', value: role);

    return true;
  } else {
    return false;
  }
}



  // Future<String> login(String email, String password) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/authenticate'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': email, 'password': password}),
  //   );

  //   if (response.statusCode == 200) {
  //     final token = jsonDecode(response.body)['token'];
  //     await storage.write(key: 'jwt', value: token); // Store token securely
  //     return token;
  //   } else {
  //     throw Exception('Failed to login');
  //   }
  // }




  Future<String> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to register');
    }
  }

  //methode pour le mot de passe oublie (envoyer par mail un lien pour modifier le mot de passe)
 Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: '{"email": "$email"}',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }


  // Get stored JWT
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt');
  }

  // Logout (clear JWT)
  Future<void> logout() async {
    await storage.delete(key: 'jwt');
  }


   Future<bool> isUserAuthenticated() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt');

    if (token == null || token.isEmpty) {
      return false; // Pas de token
    }

    final isExpired = JwtDecoder.isExpired(token);
    return !isExpired;
  }

  Future<bool> isAdmin() async {
      final token = await storage.read(key: 'jwt');
      //print(token);
      if (token == null) return false;
      
      try {
        final decodedToken = JwtDecoder.decode(token);
        final roles = decodedToken['role']; // Supposons que le token contient un champ 'roles'
        //print(roles);
        return roles != null && roles.contains('ROLE_ADMIN');
      } catch (e) {
        print('Error decoding token: $e');
        return false;
      }
    }


  //methode pour modifier le mot de passe
  Future<bool> resetPassword(String newPassword) async {
    final token = await storage.read(key: 'jwt');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: '{"token": "$token", "newPassword": "$newPassword"}',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

}















// class AuthService {
//   // Instancier Flutter Secure Storage pour stocker le token JWT
//   final FlutterSecureStorage secureStorage = FlutterSecureStorage();

//   // URL de l'API backend pour l'authentification et la déconnexion
//   final String apiUrl = "http://10.10.44.147:8080/api/v1/auth"; // Remplacez par votre URL API

//   // Méthode pour se connecter et obtenir un token
//   Future<bool> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse('$apiUrl/authenticate'), // L'URL d'authentification
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'email': email,
//         'password': password,
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Si la connexion est réussie, obtenir le token JWT et le stocker
//       String token = json.decode(response.body)['token'];
//       await secureStorage.write(key: 'jwt_token', value: token);  // Stocker le token
//       return true;
//     } else {
//       // Si l'authentification échoue, retourner false
//       return false;
//     }
//   }

//   // Méthode pour récupérer le token JWT depuis le stockage sécurisé
//   Future<String?> getToken() async {
//     return await secureStorage.read(key: 'jwt_token');
//   }

//   Future<bool> isAuthenticated() async {
//     String? token = await getToken();

//     if (token != null && token.isNotEmpty) {
//       // Vérifiez si le token est expiré
//       bool isExpired = JwtDecoder.isExpired(token);
//       return !isExpired; // Authentifié seulement si le token est valide
//     }

//     return false; // Si le token est null ou vide, retournez false
//   }
  

//   // Méthode pour se déconnecter (supprimer le token et informer le serveur si nécessaire)
//   Future<void> logout() async {
//     String? token = await getToken();
    
//     if (token != null) {
//       try {
//         // Envoi de la requête de déconnexion au backend pour invalider le token
//         final response = await http.post(
//           Uri.parse('$apiUrl/logout'), // L'URL pour la déconnexion
//           headers: {
//             'Authorization': 'Bearer $token', // Ajouter le token dans l'entête
//             'Content-Type': 'application/json',
//           },
//         );

//         if (response.statusCode == 200) {
//           // Si la déconnexion est réussie, supprimer le token du stockage local
//           await secureStorage.delete(key: 'jwt_token');
//         } else {
//           // Si la déconnexion échoue, afficher un message d'erreur
//           throw Exception('Échec de la déconnexion');
//         }
//       } catch (e) {
//         print('Erreur lors de la déconnexion: $e');
//         throw Exception('Erreur lors de la déconnexion');
//       }
//     }
//   }
 

// //methode pour le mot de passe oublie (envoyer par mail un lien pour modifier le mot de passe)
//  Future<bool> forgotPassword(String email) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$apiUrl/forgot-password'),
//         headers: {'Content-Type': 'application/json'},
//         body: '{"email": "$email"}',
//       );

//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         print('Erreur: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       print('Exception: $e');
//       return false;
//     }
//   }


// //methode pour modifier le mot de passe
//   Future<bool> resetPassword(String token, String newPassword) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$apiUrl/reset-password'),
//         headers: {'Content-Type': 'application/json'},
//         body: '{"token": "$token", "newPassword": "$newPassword"}',
//       );

//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         print('Erreur: ${response.body}');
//         return false;
//       }
//     } catch (e) {
//       print('Exception: $e');
//       return false;
//     }
//   }

  
// }