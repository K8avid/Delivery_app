import 'package:flutter/material.dart';
import 'package:coligo/services/user_service.dart'; // Assure-toi que le chemin est correct

class UserManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Utilisateurs'),
        backgroundColor: Colors.blueAccent, 
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: UserService.fetchUsers(), // Appelle la méthode fetchUsers() pour récupérer les utilisateurs
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun utilisateur trouvé.'));
          }

          // Si les utilisateurs sont récupérés avec succès, les afficher
          List<Map<String, dynamic>> users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    user['firstName'] + ' ' + user['lastName'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user['email']),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      user['firstName'][0], // Utiliser la première lettre du prénom
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bouton de modification
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Action lors du clic sur "modifier"
                          // Tu peux naviguer vers une page d'édition de l'utilisateur
                          // Exemple : Navigator.push() pour afficher un écran d'édition
                        },
                      ),
                      // Bouton de suppression
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          // Confirmer la suppression avant de procéder
                          bool? confirm = await _showConfirmationDialog(context);
                          if (confirm != null && confirm) {
                            // Si l'utilisateur confirme la suppression, appelle la méthode de suppression
                            await UserService.deleteUserProfile(user['id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Utilisateur supprimé avec succès.')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Action lors du clic sur un utilisateur (par exemple, afficher des détails)
                    // Exemple : Navigator.push() pour afficher un écran de détails
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fonction pour afficher un dialogue de confirmation
  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // L'utilisateur doit choisir oui ou non
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer cet utilisateur ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Supprimer', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
