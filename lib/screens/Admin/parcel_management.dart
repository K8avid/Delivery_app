import 'package:flutter/material.dart';
import 'package:coligo/services/parcel_service.dart'; // Assurez-vous que le chemin est correct
import 'package:coligo/models/parcel.dart'; // Assurez-vous que le modèle Parcel est correctement importé

class ParcelManagementPage extends StatelessWidget {
  // Fonction pour supprimer un colis (simulation, il faudrait appeler une méthode du service)
  void deleteParcel(BuildContext context, Parcel parcel) {
    // Ici tu peux ajouter la logique pour supprimer le colis via le service ParcelService
    // Exemple : ParcelService.deleteParcel(parcel.parcelNumber);

    // Affiche une notification de suppression
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Colis ${parcel.parcelNumber} supprimé'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Fonction pour modifier un colis (simulation, il faudrait appeler une méthode du service)
  void editParcel(BuildContext context, Parcel parcel) {
    // Ajouter la logique de modification (ex: ouvrir un formulaire de modification)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modification du colis ${parcel.parcelNumber}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Colis'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Map<String, List<Parcel>>>(
        future: ParcelService.fetchUserParcels(), // Appel à la méthode fetchUserParcels pour obtenir les colis
        builder: (context, snapshot) {
          // Si l'appel est en attente, afficher un indicateur de chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Si une erreur se produit pendant la récupération des données
          else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          // Si les données sont récupérées avec succès
          else if (snapshot.hasData) {
            // Récupère les colis envoyés et reçus
            var sentParcels = snapshot.data!['sent'] ?? [];
            var receivedParcels = snapshot.data!['received'] ?? [];

            // Retourner un affichage des colis envoyés et reçus
            return ListView(
              children: [
                // Affichage des colis envoyés
                if (sentParcels.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Colis envoyés', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ...sentParcels.map((parcel) {
                    return Dismissible(
                      key: Key(parcel.parcelNumber), // Utilise le parcelNumber pour l'identifier de manière unique
                      onDismissed: (direction) {
                        // Appelle la fonction pour supprimer un colis
                        deleteParcel(context, parcel);
                      },
                      background: Container(color: Colors.red),
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 5,
                        child: ListTile(
                          title: Text(parcel.parcelNumber, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Expéditeur: ${parcel.senderAddress}\nStatut: ${parcel.currentStatus}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Bouton de modification
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  editParcel(context, parcel);
                                },
                              ),
                              // Bouton de suppression
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  deleteParcel(context, parcel);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // Action lors du clic sur un colis (par exemple, afficher les détails)
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ],

                // Affichage des colis reçus
                if (receivedParcels.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Colis reçus', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ...receivedParcels.map((parcel) {
                    return Dismissible(
                      key: Key(parcel.parcelNumber), // Utilise le parcelNumber pour l'identifier de manière unique
                      onDismissed: (direction) {
                        // Appelle la fonction pour supprimer un colis
                        deleteParcel(context, parcel);
                      },
                      background: Container(color: Colors.red),
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 5,
                        child: ListTile(
                          title: Text(parcel.parcelNumber, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Destinataire: ${parcel.recipientAddress}\nStatut: ${parcel.currentStatus}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Bouton de modification
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  editParcel(context, parcel);
                                },
                              ),
                              // Bouton de suppression
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  deleteParcel(context, parcel);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // Action lors du clic sur un colis
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ],
            );
          }

          // Si aucune donnée n'est retournée, affiche un message
          else {
            return Center(child: Text('Aucun colis trouvé.'));
          }
        },
      ),
    );
  }
}
