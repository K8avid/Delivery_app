import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/environment.dart';
import '../models/notification.dart';
import 'token_service.dart';

class NotificationService {
  static const String baseUrl = '${Environment.baseUrl}/notifications';
  static final TokenService _tokenService = TokenService();

  static Future<List<NotificationModel>> fetchNotifications() async {
    final token = await _tokenService.getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Décodage UTF-8 de la réponse
      final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
      // Transformation en liste de NotificationModel
      return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des notifications : ${response.statusCode}');
    }
  }


}
