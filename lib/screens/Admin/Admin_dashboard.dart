import 'package:coligo/screens/Admin/TripManagmentPage.dart';
import 'package:coligo/screens/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:coligo/services/admin_service.dart';
import 'package:coligo/screens/Admin/user_management.dart';
import 'package:coligo/screens/Admin/parcel_management.dart';
import 'package:coligo/screens/profile/profile_page.dart'; // Importer la ProfilePage

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<Map<String, dynamic>> stats;

  @override
  void initState() {
    super.initState();
    stats = AdminService().getAdminStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin'),
        centerTitle: true, // Centrer le titre de l'AppBar
        backgroundColor: Colors.white, // Change la couleur de l'AppBar
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: stats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Aucune donnée disponible.'));
          }

          var data = snapshot.data!;
          return SingleChildScrollView( // Ajout de SingleChildScrollView pour éviter le débordement
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistiques Générales',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statCard(
                        context,
                        Icons.person,
                        'Total Utilisateurs',
                        data['totalUsers'].toString(),
                        Colors.grey,
                      ),
                      _statCard(
                        context,
                        Icons.local_shipping,  // Remplacer par une icône de transport local
                        'Total Colis',
                        data['totalParcels'].toString(),
                        Colors.grey,
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _statCard(
                        context,
                        Icons.directions_car,
                        'Total Trajets',
                        data['totalTrips'].toString(),
                        Colors.blue,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  _actionButton(
                    context,
                    'Gérer les utilisateurs',
                    UserManagementPage(),
                    Colors.blueAccent,
                  ),
                  SizedBox(height: 10),
                  _actionButton(
                    context,
                    'Gérer les colis',
                    ParcelManagementPage(),
                    Colors.blueAccent,
                  ),
                  SizedBox(height: 10),
                  // Nouveau bouton pour voir les trajets
                  _actionButton(
                    context,
                    'Gérer les trajets',
                    TripManagementPage(),
                    Colors.blueAccent,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
      // Icône de profil en haut à droite
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop, // Placer le bouton en haut à droite
      floatingActionButton: GestureDetector(
        onTap: () {
          // Navigation vers la page de profil
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
        child: CircleAvatar(
          radius: 25, // Ajustez la taille de l'icône
          backgroundColor: Colors.blueAccent,
          child: Icon(
            Icons.person,
            size: 30, // Taille de l'icône
            color: Colors.white, // Icône blanche
          ),
        ),
      ),
    );
  }

  Widget _statCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30.0, color: color),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    String label,
    Widget targetPage,
    Color color,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Remplacer `primary` par `backgroundColor`
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
