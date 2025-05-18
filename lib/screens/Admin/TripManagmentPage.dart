import 'package:coligo/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:coligo/models/trip.dart'; // Importer le service TripService

class TripManagementPage extends StatelessWidget {
  // Fonction pour récupérer les trajets de l'utilisateur actuel
  Future<List<dynamic>> _fetchTrips() async {
    try {
      return await TripService.fetchTripsOfCurrentUser(); // Appel à la méthode du service
    } catch (error) {
      throw Exception("Erreur lors de la récupération des trajets : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Trajets'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: _fetchTrips(), // Appel à la fonction pour récupérer les trajets
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Affichage d'un indicateur de chargement
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur : ${snapshot.error}')); // Affichage en cas d'erreur
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun trajet disponible.')); // Si aucun trajet n'est trouvé
            } else {
              // Affichage de la liste des trajets
              List<dynamic> trips = snapshot.data!;
              return ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  var trip = trips[index];

                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Trajet ${trip['tripId']}'),
                      subtitle: Text(
                        'De: ${trip['origin']} à ${trip['destination']}\n'
                        'Date: ${trip['date']}\n'
                        'Statut: ${trip['status']}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.info),
                            onPressed: () {
                              // Action lors du clic sur l'icône info
                              _showTripDetails(context, trip);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Action lors du clic sur le bouton modifier
                              _editTrip(context, trip);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Action lors du clic sur le bouton supprimer
                              _deleteTrip(context, trip);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Action lors du clic sur le trajet
                        _showTripDetails(context, trip);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  // Fonction pour afficher les détails d'un trajet
  void _showTripDetails(BuildContext context, dynamic trip) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Détails du Trajet ${trip['tripId']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Origine: ${trip['origin']}'),
              Text('Destination: ${trip['destination']}'),
              Text('Date: ${trip['date']}'),
              Text('Statut: ${trip['status']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour modifier un trajet
  void _editTrip(BuildContext context, dynamic trip) {
    // Vous pouvez afficher un formulaire de modification ici ou naviguer vers une autre page pour modifier le trajet
    // Exemple : Afficher un formulaire de modification ou une page dédiée
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le Trajet ${trip['tripId']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ajoutez ici les champs du formulaire de modification
              Text('Formulaire pour modifier le trajet ${trip['tripId']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Ajoutez ici la logique pour envoyer les modifications
                Navigator.of(context).pop();
              },
              child: Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour supprimer un trajet
  void _deleteTrip(BuildContext context, dynamic trip) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer le Trajet ${trip['tripId']}'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce trajet ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Appelez la méthode du service pour supprimer le trajet
                  await TripService.deleteTrip(trip['tripId']);
                  Navigator.of(context).pop();
                  // Mettre à jour l'UI après la suppression
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trajet supprimé avec succès')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : ${e.toString()}')));
                }
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
