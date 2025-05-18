// import 'package:flutter/material.dart';
// import '../../services/delivery_service.dart';

// class DeliveryRequestsPage extends StatefulWidget {
//   final String tripNumber;

//   const DeliveryRequestsPage({Key? key, required this.tripNumber}) : super(key: key);

//   @override
//   _DeliveryRequestsPageState createState() => _DeliveryRequestsPageState();
// }

// class _DeliveryRequestsPageState extends State<DeliveryRequestsPage> {
//   List<Map<String, dynamic>> parcels = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchParcels();
//   }

//   Future<void> fetchParcels() async {
//     try {
//       final fetchedParcels =
//           await DeliveryService.fetchParcelsByTripAndStatus(widget.tripNumber, 'REQUESTED');
//       setState(() {
//         parcels = fetchedParcels;
//         isLoading = false;
//       });
//     } catch (error) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur lors de la récupération des colis: $error')),
//       );
//     }
//   }



//   Future<void> updateDeliveryStatus(String deliveryNumber, String action) async {
//   try {
//     String newStatus;
//     String actionMessage;

//     if (action == 'accept') {
//       newStatus = 'PENDING_START';
//       actionMessage = 'acceptée';
//     } else if (action == 'refuse') {
//       newStatus = 'REFUSED';
//       actionMessage = 'refusée';
//     } else {
//       throw Exception('Action invalide');
//     }

//     await DeliveryService.patchDeliveryStatus(deliveryNumber, newStatus);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'La livraison a été $actionMessage avec succès.',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.only(top: 50, left: 16, right: 16), // Position en haut
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//     fetchParcels(); // Rafraîchit les données
//   } catch (error) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Une erreur s\'est produite lors de la mise à jour. Veuillez réessayer.',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.only(top: 50, left: 16, right: 16), // Position en haut
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Demandes de livraison',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : parcels.isEmpty
//               ? const Center(
//                   child: Text(
//                     'Aucune demande de livraison trouvée',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 )
//               : RefreshIndicator(
//                   onRefresh: fetchParcels,
//                   child: ListView.builder(
//                     padding: const EdgeInsets.all(10),
//                     itemCount: parcels.length,
//                     itemBuilder: (context, index) {
//                       final parcel = parcels[index];
//                       final parcelData = parcel['parcel'] ?? {};
//                       final description = parcelData['description'] ?? 'Description non disponible';
//                       final weight = parcelData['weight'] ?? 'Non spécifié';
//                       final senderFirstName = parcel['senderFirstName'] ?? 'Inconnu';
//                       final senderLastName = parcel['senderLastName'] ?? 'Inconnu';
//                       final senderPhone = parcel['senderPhoneNumber'] ?? 'Non spécifié';
//                       final senderEmail = parcel['senderEmail'] ?? 'Non spécifié';
//                       final deliveryNumber = parcel['deliveryNumber'] ?? 'Non spécifié';

//                       return Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 6,
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Description prominently displayed with a title
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     "Description du colis :",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       description,
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blueAccent,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const Divider(thickness: 1.2, color: Colors.grey),
//                               const SizedBox(height: 8),
//                               // Weight
//                               _buildInfoRow(
//                                 icon: Icons.scale,
//                                 label: '$weight kg',
//                                 color: Colors.grey,
//                               ),
//                               // Sender Name
//                               _buildInfoRow(
//                                 icon: Icons.person,
//                                 label: '$senderFirstName $senderLastName',
//                                 color: Colors.grey,
//                               ),
//                               // Sender Phone
//                               _buildInfoRow(
//                                 icon: Icons.phone,
//                                 label: senderPhone,
//                                 color: Colors.grey,
//                               ),
//                               // Sender Email
//                               _buildInfoRow(
//                                 icon: Icons.email,
//                                 label: senderEmail,
//                                 color: Colors.grey,
//                               ),
//                               const SizedBox(height: 16),
//                               // Action Buttons
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   ElevatedButton.icon(
//                                     onPressed: () =>
//                                         updateDeliveryStatus(deliveryNumber, 'accept'),
//                                     icon: const Icon(Icons.check, color: Colors.white),
//                                     label: const Text('Accepter'),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.green,
//                                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   ElevatedButton.icon(
//                                     onPressed: () =>
//                                         updateDeliveryStatus(deliveryNumber, 'refuse'),
//                                     icon: const Icon(Icons.close, color: Colors.white),
//                                     label: const Text('Refuser'),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.red,
//                                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//     );
//   }

//   Widget _buildInfoRow({required IconData icon, required String label, required Color color}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: 20),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import '../../services/delivery_service.dart';

class DeliveryRequestsPage extends StatefulWidget {
  final String tripNumber;

  const DeliveryRequestsPage({super.key, required this.tripNumber});

  @override
  _DeliveryRequestsPageState createState() => _DeliveryRequestsPageState();
}

class _DeliveryRequestsPageState extends State<DeliveryRequestsPage> {
  List<Map<String, dynamic>> parcels = [];
  bool isLoading = true;
  bool isProcessing = false; // Ajout de l'état pour le traitement réseau

  @override
  void initState() {
    super.initState();
    fetchParcels();
  }

  Future<void> fetchParcels() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedParcels =
          await DeliveryService.fetchParcelsByTripAndStatus(widget.tripNumber, 'REQUESTED');
      setState(() {
        parcels = fetchedParcels;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _showCustomSnackBar(
        'Erreur lors de la récupération des colis: $error',
        Colors.red,
      );
    }
  }

  Future<void> updateDeliveryStatus(String deliveryNumber, String action) async {
    setState(() {
      isProcessing = true; // Indique que le traitement commence
    });

    try {
      String newStatus;
      String actionMessage;

      if (action == 'accept') {
        newStatus = 'PENDING_START';
        actionMessage = 'acceptée';
      } else if (action == 'refuse') {
        newStatus = 'REFUSED';
        actionMessage = 'refusée';
      } else {
        throw Exception('Action invalide');
      }

      await DeliveryService.patchDeliveryStatus(deliveryNumber, newStatus);
      _showCustomSnackBar(
        'La livraison a été $actionMessage avec succès.',
        Colors.green,
      );

      await fetchParcels(); // Rafraîchit les données après l'action
    } catch (error) {
      _showCustomSnackBar(
        'Une erreur s\'est produite lors de la mise à jour. Veuillez réessayer.',
        Colors.red,
      );
    } finally {
      setState(() {
        isProcessing = false; // Terminé
      });
    }
  }

  void _showCustomSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 50, left: 16, right: 16), // Position en haut
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Demandes de livraison',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : parcels.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucune demande de livraison trouvée',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchParcels,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: parcels.length,
                        itemBuilder: (context, index) {
                          final parcel = parcels[index];
                          final parcelData = parcel['parcel'] ?? {};
                          final description =
                              parcelData['description'] ?? 'Description non disponible';
                          final weight = parcelData['weight'] ?? 'Non spécifié';
                          final senderFirstName = parcel['senderFirstName'] ?? 'Inconnu';
                          final senderLastName = parcel['senderLastName'] ?? 'Inconnu';
                          final senderPhone = parcel['senderPhoneNumber'] ?? 'Non spécifié';
                          final senderEmail = parcel['senderEmail'] ?? 'Non spécifié';
                          final deliveryNumber = parcel['deliveryNumber'] ?? 'Non spécifié';

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 6,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Description du colis :",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          description,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(thickness: 1.2, color: Colors.grey),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    icon: Icons.scale,
                                    label: '$weight kg',
                                    color: Colors.grey,
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.person,
                                    label: '$senderFirstName $senderLastName',
                                    color: Colors.grey,
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.phone,
                                    label: senderPhone,
                                    color: Colors.grey,
                                  ),
                                  _buildInfoRow(
                                    icon: Icons.email,
                                    label: senderEmail,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: isProcessing
                                            ? null
                                            : () => updateDeliveryStatus(
                                                deliveryNumber, 'accept'),
                                        icon: const Icon(Icons.check, color: Colors.white),
                                        label: const Text('Accepter'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton.icon(
                                        onPressed: isProcessing
                                            ? null
                                            : () => updateDeliveryStatus(
                                                deliveryNumber, 'refuse'),
                                        icon: const Icon(Icons.close, color: Colors.white),
                                        label: const Text('Refuser'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          if (isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
