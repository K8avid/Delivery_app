

// import 'package:flutter/material.dart';
// import '../../models/parcel.dart';
// import '../../services/parcel_service.dart';
// import 'add_parcel_info_page.dart';
// import 'parcel_alone_details_page.dart';
// import 'parcel_details_page.dart';

// class ParcelPage extends StatefulWidget {
//   const ParcelPage({super.key});

//   @override
//   _ParcelPageState createState() => _ParcelPageState();
// }

// class _ParcelPageState extends State<ParcelPage> {
//   late Future<Map<String, List<Parcel>>> _parcels;
//   late Future<void> _delayedLoad; 

//   @override
//   void initState() {
//     super.initState();
    
//     _delayedLoad = _simulateDelay(); // Attendre 1 seconde avant de charger les colis
    
//     _refreshParcels();
//   }
//     Future<void> _simulateDelay() async {
//     await Future.delayed(const Duration(seconds: 1)); // Simuler un délai de 1 seconde
//   }

//   // Méthode pour actualiser les colis
//   Future<void> _refreshParcels() async {
//     setState(() {
//       _parcels = ParcelService.fetchUserParcels(); // Retourne une Map<String, List<Parcel>>
//     });
//   }

//   // Obtenir la couleur, le texte, et l'icône en fonction du statut
//   Map<String, dynamic> _getStatusInfo(String status) {
//     switch (status) {
//       case "NO_TRIP":
//         return {
//           "color": const Color.fromARGB(255, 86, 84, 84),
//           "icon": Icons.pending_actions,
//           "text": "non-assigné a un trajet"
//         };
//       case "CREATED":
//         return {
//           "color": Colors.orange,
//           "icon": Icons.pending_actions,
//           "text": "En attente de confirmation"
//         };
//       case "IN_TRANSIT":
//         return {
//           "color": Colors.blue,
//           "icon": Icons.local_shipping,
//           "text": "En cours de livraison"
//         };
//       case "DELIVERED":
//         return {
//           "color": Colors.green,
//           "icon": Icons.check_circle,
//           "text": "Livré"
//         };
//       case "CANCELLED":
//         return {
//           "color": Colors.red,
//           "icon": Icons.cancel,
//           "text": "Annulé"
//         };
//       default:
//         return {
//           "color": Colors.grey,
//           "icon": Icons.help_outline,
//           "text": "Statut inconnu"
//         };
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Mes Colis',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1.0,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Column(
//         children: [
//           // Bouton Ajouter
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddParcelInfoPage(),
//                   ),
//                 );
//               },
//               icon: const Icon(Icons.add, color: Colors.white),
//               label: const Text(
//                 "Ajouter un colis",
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue.shade700,
//                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),

//           // Liste des colis avec RefreshIndicator
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: _refreshParcels,
//               child: FutureBuilder<Map<String, List<Parcel>>>(
//                 future: _parcels,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return _buildMessage(
//                       "Erreur : ${snapshot.error}",
//                       "Vérifiez votre connexion Internet.",
//                       isError: true,
//                     );
//                   } else if (!snapshot.hasData ||
//                       (snapshot.data!['sent']!.isEmpty &&
//                           snapshot.data!['received']!.isEmpty)) {
//                     return _buildMessage(
//                       "Aucun colis trouvé",
//                       "Ajoutez votre premier colis en cliquant sur le bouton ci-dessus.",
//                       isError: false,
//                     );
//                   }

//                   final sentParcels = snapshot.data!['sent']!;
//                   final receivedParcels = snapshot.data!['received']!;

//                   // Fusionner sent et received en une seule liste, avec un marqueur de type
//                   final allParcels = [
//                     ...sentParcels.map((parcel) => {"parcel": parcel, "type": "sent"}),
//                     ...receivedParcels.map((parcel) => {"parcel": parcel, "type": "received"}),
//                   ];

//                   return ListView.builder(
//                     padding: const EdgeInsets.all(12.0),
//                     itemCount: allParcels.length,
//                     itemBuilder: (context, index) {
//                       final parcel = allParcels[index]["parcel"] as Parcel;
//                       final type = allParcels[index]["type"] as String;

//                       return _buildParcelCard(parcel, type);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Construire une carte de colis
//   Widget _buildParcelCard(Parcel parcel, String type) {
//     final statusInfo = _getStatusInfo(parcel.currentStatus);

//     return GestureDetector(
//         onTap: () { //switch case sur les page de detail
//           switch (parcel.currentStatus) {
//             case "NO_TRIP":
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ParcelAloneDetailsPage(
//                     parcelNumber: parcel.parcelNumber,
//                   ),
//                 ),
//               );
//               break;

//             default:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ParcelDetailsPage(
//                     parcelNumber: parcel.parcelNumber,
//                   ),
//                 ),
//               );
//               break;
//           }
//         },

//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8.0),
//         elevation: 6.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Logo du colis
//                   CircleAvatar(
//                     radius: 28,
//                     backgroundColor: Colors.blue.withOpacity(0.1),
//                     child: const Icon(
//                       Icons.inventory_2,
//                       size: 32,
//                       color: Colors.blue,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   // Flèche indiquant le type
//                   Icon(
//                     type == "sent" ? Icons.arrow_upward : Icons.arrow_downward,
//                     size: 32,
//                     color: type == "sent" ? Colors.green : Colors.red,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           parcel.description,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "N° : ${parcel.parcelNumber}",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 16,
//                     color: Colors.grey,
//                   ),
//                 ],
//               ),
//               Divider(height: 20, color: Colors.grey[300]),
//               // Timeline des adresses
//               Row(
//                 children: [
//                   Column(
//                     children: [
//                       // Point pour l'adresse de l'expéditeur
//                       const Icon(
//                         Icons.circle,
//                         size: 12,
//                         color: Colors.blue,
//                       ),
//                       // Ligne verticale
//                       Container(
//                         height: 30,
//                         width: 2,
//                         color: Colors.grey,
//                       ),
//                       // Point pour l'adresse du destinataire
//                       const Icon(
//                         Icons.place,
//                         size: 16,
//                         color: Colors.red,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 12),
//                   // Adresses
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           parcel.senderAddress,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           parcel.recipientAddress,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Icon(
//                     statusInfo['icon'],
//                     size: 18,
//                     color: statusInfo['color'],
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     statusInfo['text'],
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: statusInfo['color'],
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMessage(String title, String subtitle, {bool isError = false}) {
//     return RefreshIndicator(
//       onRefresh: _refreshParcels,
//       child: ListView(
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(
//                     isError ? Icons.error_outline : Icons.info_outline,
//                     size: 64,
//                     color: isError ? Colors.redAccent : Colors.blueAccent,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[700],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
































import 'package:flutter/material.dart';
import '../../models/parcel.dart';
import '../../services/parcel_service.dart';
import 'add_parcel_info_page.dart';
import 'parcel_alone_details_page.dart';
import 'parcel_details_page.dart';

class ParcelPage extends StatefulWidget {
  const ParcelPage({super.key});

  @override
  _ParcelPageState createState() => _ParcelPageState();
}

class _ParcelPageState extends State<ParcelPage> {
  late Future<Map<String, List<Parcel>>> _parcels;
  late Future<void> _delayedLoad;

  @override
  void initState() {
    super.initState();
    _delayedLoad = _simulateDelay(); // Attendre 1 seconde avant de charger les colis
    _refreshParcels();
  }

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(seconds: 1)); // Simuler un délai de 1 seconde
  }

  // Méthode pour actualiser les colis
  Future<void> _refreshParcels() async {
    setState(() {
      _parcels = ParcelService.fetchUserParcels(); // Retourne une Map<String, List<Parcel>>
    });
  }

  // Obtenir la couleur, le texte, et l'icône en fonction du statut
  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status) {
      case "NO_TRIP":
        return {
          "color": const Color.fromARGB(255, 86, 84, 84),
          "icon": Icons.pending_actions,
          "text": "Non-assigné à un trajet"
        };
      case "CREATED":
        return {
          "color": Colors.orange,
          "icon": Icons.pending_actions,
          "text": "En attente de confirmation"
        };
      case "IN_TRANSIT":
        return {
          "color": Colors.blue,
          "icon": Icons.local_shipping,
          "text": "En cours de livraison"
        };
      case "DELIVERED":
        return {
          "color": Colors.green,
          "icon": Icons.check_circle,
          "text": "Livré"
        };
      case "CANCELLED":
        return {
          "color": Colors.red,
          "icon": Icons.cancel,
          "text": "Annulé"
        };
    case "WAIT_PICK_UP":
      return {
        "color": Colors.amber,
        "icon": Icons.access_time,
        "text": "En attente de la récupération du colis"
      };
      default:
        return {
          "color": Colors.grey,
          "icon": Icons.help_outline,
          "text": "Statut inconnu"
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Colis',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Bouton Ajouter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddParcelInfoPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Ajouter un colis",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Liste des colis avec RefreshIndicator
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshParcels,
              child: FutureBuilder<Map<String, List<Parcel>>>(
                future: _parcels,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return _buildMessage(
                      "Erreur : ${snapshot.error}",
                      "Vérifiez votre connexion Internet.",
                      isError: true,
                    );
                  } else if (!snapshot.hasData ||
                      (snapshot.data!['sent']!.isEmpty &&
                          snapshot.data!['received']!.isEmpty)) {
                    return _buildMessage(
                      "Aucun colis trouvé",
                      "Ajoutez votre premier colis en cliquant sur le bouton ci-dessus.",
                      isError: false,
                    );
                  }

                  final sentParcels = snapshot.data!['sent']!;
                  final receivedParcels = snapshot.data!['received']!;

                  // Fusionner sent et received en une seule liste, avec un marqueur de type
                  final allParcels = [
                    ...sentParcels.map((parcel) => {"parcel": parcel, "type": "sent"}),
                    ...receivedParcels.map((parcel) => {"parcel": parcel, "type": "received"}),
                  ];

                  return ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: allParcels.length,
                    itemBuilder: (context, index) {
                      final parcel = allParcels[index]["parcel"] as Parcel;
                      final type = allParcels[index]["type"] as String;

                      return _buildParcelCard(parcel, type);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Construire une carte de colis
  Widget _buildParcelCard(Parcel parcel, String type) {
    final statusInfo = _getStatusInfo(parcel.currentStatus);

    return GestureDetector(
      onTap: () {
        if (parcel.currentStatus == "NO_TRIP") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParcelAloneDetailsPage(
                parcelNumber: parcel.parcelNumber,
                isSender: type == "sent",
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParcelDetailsPage(
                parcelNumber: parcel.parcelNumber,
                isSender: type == "sent",
              ),
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: const Icon(
                      Icons.inventory_2,
                      size: 32,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    type == "sent" ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 32,
                    color: type == "sent" ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parcel.description,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "N° : ${parcel.parcelNumber}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
              Divider(height: 20, color: Colors.grey[300]),
              Row(
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 12,
                        color: Colors.blue,
                      ),
                      Container(
                        height: 30,
                        width: 2,
                        color: Colors.grey,
                      ),
                      const Icon(
                        Icons.place,
                        size: 16,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parcel.senderAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          parcel.recipientAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    statusInfo['icon'],
                    size: 18,
                    color: statusInfo['color'],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    statusInfo['text'],
                    style: TextStyle(
                      fontSize: 14,
                      color: statusInfo['color'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(String title, String subtitle, {bool isError = false}) {
    return RefreshIndicator(
      onRefresh: _refreshParcels,
      child: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    isError ? Icons.error_outline : Icons.info_outline,
                    size: 64,
                    color: isError ? Colors.redAccent : Colors.blueAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

