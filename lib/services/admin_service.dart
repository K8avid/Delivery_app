import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coligo/services/auth_service.dart';

class AdminService {
  final String baseUrl = 'http://192.168.56.1:8080/api/v1/admin'; // Remplace par ton URL de base

  // Méthode pour récupérer les statistiques admin
  Future<Map<String, dynamic>> getAdminStats() async {
    final token = await AuthService().getToken(); // Méthode pour récupérer le token JWT
    final response = await http.get(
      Uri.parse('$baseUrl/stats'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des statistiques');
    }
  }

  // Méthode pour récupérer tous les utilisateurs
  Future<List<dynamic>> getAllUsers() async {
    final token = await AuthService().getToken(); // Assure-toi d'avoir une méthode pour récupérer le token
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des utilisateurs');
    }
  }

  // Méthode pour modifier un utilisateur
  Future<String> updateUser(int userId, Map<String, dynamic> updatedUserData) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedUserData),
    );

    if (response.statusCode == 200) {
      return 'Utilisateur mis à jour avec succès';
    } else {
      throw Exception('Erreur lors de la mise à jour de l\'utilisateur');
    }
  }

  // Méthode pour supprimer un utilisateur
  Future<String> deleteUser(int userId) async {
    final token = await AuthService().getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return 'Utilisateur supprimé avec succès';
    } else {
      throw Exception('Erreur lors de la suppression de l\'utilisateur');
    }
  }

  // Méthode pour récupérer les colis
  Future<List<dynamic>> getAllParcels() async {
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/parcels'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des colis');
    }
  }

  // Méthode pour récupérer les colis d'un utilisateur spécifique
  Future<List<dynamic>> getParcelsByUser(int userId) async {
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/parcels'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des colis de l\'utilisateur');
    }
  }

  // Méthode pour modifier un colis
  Future<String> updateParcel(int userId, int parcelId, Map<String, dynamic> updatedParcelData) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId/parcels/$parcelId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedParcelData),
    );

    if (response.statusCode == 200) {
      return 'Colis mis à jour avec succès';
    } else {
      throw Exception('Erreur lors de la mise à jour du colis');
    }
  }

  // Méthode pour supprimer un colis
  Future<String> deleteParcel(int userId, int parcelId) async {
    final token = await AuthService().getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId/parcels/$parcelId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return 'Colis supprimé avec succès';
    } else {
      throw Exception('Erreur lors de la suppression du colis');
    }
  }

  // Méthode pour récupérer les trajets
  Future<List<dynamic>> getAllTrips() async {
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/trips'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des trajets');
    }
  }

  // Méthode pour récupérer les trajets d'un utilisateur spécifique
  Future<List<dynamic>> getTripsByUser(int userId) async {
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/trips'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des trajets de l\'utilisateur');
    }
  }

  // Méthode pour modifier un trajet
  Future<String> updateTrip(int userId, int tripId, Map<String, dynamic> updatedTripData) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId/trips/$tripId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedTripData),
    );

    if (response.statusCode == 200) {
      return 'Trajet mis à jour avec succès';
    } else {
      throw Exception('Erreur lors de la mise à jour du trajet');
    }
  }

  // Méthode pour supprimer un trajet
  Future<String> deleteTrip(int userId, int tripId) async {
    final token = await AuthService().getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId/trips/$tripId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return 'Trajet supprimé avec succès';
    } else {
      throw Exception('Erreur lors de la suppression du trajet');
    }
  }

  // Méthode pour marquer une notification comme lue
  Future<String> markNotificationAsRead(int notificationId) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/notifications/$notificationId/read'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return 'Notification marquée comme lue';
    } else {
      throw Exception('Erreur lors de la mise à jour de la notification');
    }
  }
}
