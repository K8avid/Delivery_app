import 'package:coligo/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:coligo/providers/language_provider.dart';

import '../home_screen.dart';
import '../landing_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> userProfile;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    userProfile = _getUserProfile();
  }

  Future<Map<String, dynamic>> _getUserProfile() async {
    String? token = await _storage.read(key: 'jwt');
    return UserService.getUserProfile();
    }

 
 Future<void> _logout() async {
  try {
    await _storage.delete(key: 'jwt'); // Supprimer le token stocké
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Déconnexion réussie.')),
    );

    // Naviguer vers la Landing Page et vider la pile
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()), // Remplacez `LandingPage` par le nom réel de votre Landing Page
      (route) => false, // Supprime toutes les routes de la pile
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la déconnexion : $e')),
    );
  }
}


  String _getDisplayValue(String? value) {
    return value == null || value.isEmpty ? 'Non renseigné' : value;
  }

  String _formatDateOfBirth(String? birthDate) {
    if (birthDate == null || birthDate.isEmpty) {
      return 'Non renseigné';
    }
    DateTime date = DateTime.parse(birthDate);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _deleteAccount() async {
    try {
      String? token = await _storage.read(key: 'jwt');

      //await UserService.deleteUserProfile(token);
      await _storage.delete(key: 'jwt');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte supprimé avec succès.')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen(initialPage: HomePage.profile)),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du compte : $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            centerTitle: true,
            title: Text(
              languageProvider.isFrench ? 'Mon Profil' : 'My Profile',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            elevation: 1,
          ),
          body: FutureBuilder<Map<String, dynamic>>(
            future: userProfile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('Aucune donnée disponible'));
              } else {
                final userData = snapshot.data!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${userData['firstName']} ${userData['lastName']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  languageProvider.isFrench ? 'Utilisateur' : 'User',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                            onPressed: () async {
                              final String? token = await _storage.read(key: 'jwt');
                              final updatedUserData = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(
                                    userData: userData,
                                    token: token ?? '',
                                  ),
                                ),
                              );
                              if (updatedUserData != null) {
                                setState(() {
                                  userProfile = Future.value(updatedUserData);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 30, thickness: 1, color: Colors.grey),
                      _buildUserInfoRow(Icons.email, languageProvider.isFrench ? 'Email' : 'Email', userData['email']),
                      _buildUserInfoRow(Icons.calendar_today, languageProvider.isFrench ? 'Date de Naissance' : 'Date of Birth', _formatDateOfBirth(userData['dateOfBirth'])),
                      _buildUserInfoRow(Icons.phone, languageProvider.isFrench ? 'Téléphone' : 'Phone', userData['phoneNumber']),
                      _buildUserInfoRow(Icons.car_rental, languageProvider.isFrench ? 'Véhicule' : 'Vehicle', userData['vehicle']),
                      _buildUserInfoRow(Icons.home, languageProvider.isFrench ? 'Adresse' : 'Address', userData['address']),
                      _buildUserInfoRow(Icons.location_city, languageProvider.isFrench ? 'Ville' : 'City', userData['city']),
                      _buildUserInfoRow(Icons.flag, languageProvider.isFrench ? 'Pays' : 'Country', userData['country']),
                      const Divider(height: 30, thickness: 1, color: Colors.grey),
                      GestureDetector(
                        onTap: _logout,
                        child: Row(
                          children: [
                            const Icon(Icons.logout, size: 30, color: Colors.blue),
                            const SizedBox(width: 16),
                            Text(
                              languageProvider.isFrench ? 'Déconnexion' : 'Logout',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _showDeleteConfirmationDialog,
                        child: Row(
                          children: [
                            const Icon(Icons.delete_forever, size: 30, color: Colors.red),
                            const SizedBox(width: 16),
                            Text(
                              languageProvider.isFrench ? 'Fermer mon compte' : 'Close my account',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildUserInfoRow(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getDisplayValue(value),
                  style: TextStyle(
                    fontSize: 14,
                    color: (value == null || value.isEmpty) ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
