// import 'package:flutter/material.dart';

// import '../../models/parcel.dart';
// import '../../services/parcel_service.dart';
// import 'parcel_search_result_for_existing_parcel.dart';

// class ParcelAloneDetailsPage extends StatefulWidget {
//   final String parcelNumber;

//   const ParcelAloneDetailsPage({super.key, required this.parcelNumber});

//   @override
//   _ParcelAloneDetailsPageState createState() =>
//       _ParcelAloneDetailsPageState();
// }

// class _ParcelAloneDetailsPageState extends State<ParcelAloneDetailsPage> {
//   late Future<Parcel> _parcelFuture;
//   final Map<String, dynamic> parcelInfo = {};

//   @override
//   void initState() {
//     super.initState();

//     _parcelFuture = ParcelService.fetchParcelDetails(widget.parcelNumber);

//     _parcelFuture.then((parcel) {
//       setState(() {
//         parcelInfo['senderAddress'] = parcel.senderAddress;
//         parcelInfo['recipientAddress'] = parcel.recipientAddress;
//         parcelInfo['expiracyDate'] = parcel.expiracyDate.toIso8601String();
//         parcelInfo['parcelNumber'] = parcel.parcelNumber;
//       });
//     }).catchError((error) {
//       print('Erreur lors de la récupération du colis : $error');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.blue),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text(
//           'Détails du Colis',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<Parcel>(
//         future: _parcelFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Erreur : ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return const Center(child: Text('Aucun détail trouvé pour ce colis'));
//           }

//           final parcel = snapshot.data!;

//           return Container(
//             color: Colors.grey.shade100,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildSection(
//                     title: "Informations sur le Colis",
//                     content: _buildParcelDetails(parcel),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       // Ajouter un bouton flottant avec un texte "Trouver un trajet"
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
//         child: FloatingActionButton.extended(
//           onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ParcelSearchResultsWithExistingParcel(parcelInfo: parcelInfo),
//           ),
//         );
//       },
//           backgroundColor: Colors.blue,
//           icon: Icon(
//             Icons.directions, // Icône d'une flèche de direction
//             size: 30,
//           ),
//           label: Text(
//             "Trouver un trajet",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSection({required String title, required Widget content}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Card(
//         elevation: 6,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue.shade800,
//                 ),
//               ),
//               Divider(color: Colors.grey.shade300, thickness: 1, height: 24),
//               content,
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildParcelDetails(parcel) {
//     return Column(
//       children: [
//         _buildDetailRow(Icons.description, "Description", parcel.description),
//         _buildDetailRow(Icons.monitor_weight, "Poids", "${parcel.weight} kg"),
//         _buildDetailRow(Icons.straighten, "Dimensions",
//             "${parcel.length} x ${parcel.width} x ${parcel.height} cm"),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Column(
//               children: [
//                 const Icon(
//                   Icons.circle,
//                   size: 12,
//                   color: Colors.blue,
//                 ),
//                 Container(
//                   height: 30,
//                   width: 3,
//                   color: Colors.grey,
//                 ),
//                 const Icon(
//                   Icons.place,
//                   size: 16,
//                   color: Colors.red,
//                 ),
//               ],
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     parcel.senderAddress,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     parcel.recipientAddress,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAlignedDetailRow({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 24, color: Colors.blue),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getTripStatusInFrench(String status) {
//     switch (status) {
//       case "OPEN":
//         return "Ouvert";
//       case "IN_PROGRESS":
//         return "En cours";
//       case "COMPLETED":
//         return "Terminé";
//       case "CANCELLED":
//         return "Annulé";
//       case "CLOSED":
//         return "Fermé";
//       default:
//         return "Inconnu";
//     }
//   }

//   Widget _buildDetailRow(IconData icon, String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blue.shade800, size: 24),
//           const SizedBox(width: 12),
//           Text(
//             "$title : ",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: Colors.black87,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade700,
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
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
import 'parcel_search_result_for_existing_parcel.dart';

class ParcelAloneDetailsPage extends StatefulWidget {
  final String parcelNumber;
  final bool isSender; // Paramètre pour vérifier si l'utilisateur est l'expéditeur

  const ParcelAloneDetailsPage({
    super.key,
    required this.parcelNumber,
    required this.isSender,
  });

  @override
  _ParcelAloneDetailsPageState createState() => _ParcelAloneDetailsPageState();
}

class _ParcelAloneDetailsPageState extends State<ParcelAloneDetailsPage> {
  late Future<Parcel> _parcelFuture;
  final Map<String, dynamic> parcelInfo = {};

  @override
  void initState() {
    super.initState();

    _parcelFuture = ParcelService.fetchParcelDetails(widget.parcelNumber);

    _parcelFuture.then((parcel) {
      // setState(() {
      //   parcelInfo['senderAddress'] = parcel.senderAddress;
      //   parcelInfo['recipientAddress'] = parcel.recipientAddress;
      //   parcelInfo['expiracyDate'] = parcel.expiracyDate.toIso8601String();
      //   parcelInfo['parcelNumber'] = parcel.parcelNumber;
      // });

      setState(() {
        parcelInfo['senderAddress'] = parcel.senderAddress;
        parcelInfo['recipientAddress'] = parcel.recipientAddress;
        parcelInfo['expiracyDate'] = parcel.expiracyDate.toIso8601String();
        parcelInfo['parcelNumber'] = parcel.parcelNumber;

        // Champs supplémentaires
        parcelInfo['description'] = parcel.description;
        parcelInfo['weight'] = parcel.weight;
        parcelInfo['length'] = parcel.length;
        parcelInfo['width'] = parcel.width;
        parcelInfo['height'] = parcel.height;
      });
    }).catchError((error) {
      print('Erreur lors de la récupération du colis : $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Détails du Colis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Parcel>(
        future: _parcelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text('Aucun détail trouvé pour ce colis'));
          }

          final parcel = snapshot.data!;

          return Container(
            color: Colors.grey.shade100,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSection(
                    title: "Informations sur le Colis",
                    content: _buildParcelDetails(parcel),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: widget.isSender
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ParcelSearchResultsWithExistingParcel(
                              parcelInfo: parcelInfo),
                    ),
                  );
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.blue, width: 1),
                ),
                elevation: 4,
                icon: const Icon(Icons.directions, size: 24),
                label: const Text(
                  "Trouver un trajet",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null, // Si l'utilisateur n'est pas l'expéditeur, ne rien afficher
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              Divider(color: Colors.grey.shade300, thickness: 1, height: 24),
              content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParcelDetails(Parcel parcel) {
    final formattedDate =
        "${parcel.expiracyDate.day.toString().padLeft(2, '0')}/${parcel.expiracyDate.month.toString().padLeft(2, '0')}/${parcel.expiracyDate.year}";

    return Column(
      children: [
        _buildDetailRow(Icons.description, "Description", parcel.description),
        _buildDetailRow(Icons.monitor_weight, "Poids", "${parcel.weight} kg"),
        _buildDetailRow(Icons.straighten, "Dimensions",
            "${parcel.length} x ${parcel.width} x ${parcel.height} cm"),
        _buildDetailRow(Icons.date_range, "Date limite", formattedDate),
        const SizedBox(height: 16),
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
                  width: 3,
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
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade800, size: 24),
          const SizedBox(width: 12),
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
