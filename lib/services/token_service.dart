import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Clé utilisée pour stocker le token
  static const String _tokenKey = "jwt";

  // Sauvegarder le token JWT
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Récupérer le token JWT
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Supprimer le token JWT
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Vérifier si un token existe
  Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }
}
