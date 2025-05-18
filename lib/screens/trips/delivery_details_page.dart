// import 'package:flutter/material.dart';
// import '../../services/delivery_service.dart';
// import 'qr_code_scanner_page.dart';

// class DeliveryDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> delivery;
//   final String tripNumber;

//   DeliveryDetailsPage({required this.delivery, required this.tripNumber});

//   @override
//   _DeliveryDetailsPageState createState() => _DeliveryDetailsPageState();
// }

// class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
//   late Map<String, dynamic> delivery;

//   @override
//   void initState() {
//     super.initState();
//     delivery = widget.delivery; // Initialize the local delivery data
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Détails de la Livraison',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionTitle(context, 'Informations du Colis'),
//             const SizedBox(height: 12),
//             _buildCard(
//               children: [
//                 _buildInfoRow('Numéro de Livraison', delivery['deliveryNumber'] ?? 'Non disponible'),
//                 _buildInfoRow('Description', delivery['parcel']['description'] ?? 'Non disponible'),
//                 _buildInfoRow('Poids', '${delivery['parcel']['weight'] ?? 'N/A'} kg'),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildSectionTitle(context, 'Informations de l\'Expéditeur'),
//             const SizedBox(height: 12),
//             _buildCard(
//               children: [
//                 _buildInfoRow('Nom', '${delivery['senderFirstName']} ${delivery['senderLastName']}'),
//                 _buildInfoRow('Téléphone', delivery['senderPhoneNumber'] ?? 'Non disponible'),
//                 _buildInfoRow('Email', delivery['senderEmail'] ?? 'Non disponible'),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildSectionTitle(context, 'Progression de la Livraison'),
//             const SizedBox(height: 12),
//             _buildCard(children: [_buildTimeline()]),
//             const SizedBox(height: 20),
//             if (delivery['deliveryStatus'] == 'PENDING_START')
//               _buildActionButton(
//                 context,
//                 label: 'Récupérer le Colis',
//                 icon: Icons.qr_code_scanner,
//                 color: Colors.green,
//                 onPressed: () => _handlePickup(context),
//               ),
//             if (delivery['deliveryStatus'] == 'IN_PROGRESS')
//               _buildActionButton(
//                 context,
//                 label: 'Livrer le Colis',
//                 icon: Icons.qr_code_scanner,
//                 color: Colors.blueAccent,
//                 onPressed: () => _handleDelivery(context),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(BuildContext context, String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: Colors.blueAccent,
//       ),
//     );
//   }

//   Widget _buildCard({required List<Widget> children}) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: children,
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 140,
//             child: Text(
//               '$label :',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeline() {
//     final statusTimeline = [
//       'REQUESTED',
//       'PENDING_START',
//       'IN_PROGRESS',
//     ];

//     if (delivery['deliveryStatus'] == 'CANCELLED') {
//       statusTimeline.add('CANCELLED');
//     } else {
//       statusTimeline.add('COMPLETED');
//     }

//     final currentStatusIndex = _getCurrentStatusIndex(delivery['deliveryStatus'] ?? '');

//     return Column(
//       children: List.generate(statusTimeline.length, (index) {
//         final isCompleted = index < currentStatusIndex;
//         final isCurrent = index == currentStatusIndex;

//         return Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               children: [
//                 CircleAvatar(
//                   radius: 22,
//                   backgroundColor: isCurrent
//                       ? Colors.blue
//                       : isCompleted
//                           ? Colors.green
//                           : Colors.grey.shade300,
//                   child: Icon(
//                     _getStatusIcon(statusTimeline[index]),
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//                 if (index < statusTimeline.length - 1)
//                   Container(
//                     width: 3,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: isCompleted
//                             ? [Colors.green, Colors.green.shade300]
//                             : [Colors.grey.shade300, Colors.grey.shade100],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 _translateStatusToFrench(statusTimeline[index]),
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
//                   color: isCurrent
//                       ? Colors.blue
//                       : isCompleted
//                           ? Colors.green.shade700
//                           : Colors.grey.shade600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case 'REQUESTED':
//         return Icons.receipt_long;
//       case 'PENDING_START':
//         return Icons.hourglass_empty;
//       case 'IN_PROGRESS':
//         return Icons.local_shipping;
//       case 'COMPLETED':
//         return Icons.check_circle;
//       case 'CANCELLED':
//         return Icons.cancel;
//       default:
//         return Icons.info_outline;
//     }
//   }

//   Widget _buildActionButton(BuildContext context,
//       {required String label, required IconData icon, required Color color, required VoidCallback onPressed}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 5,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: Colors.white, size: 22),
//             const SizedBox(width: 12),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handlePickup(BuildContext context) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => QRCodeScannerPage(),
//       ),
//     ).then((scannedToken) async {
//       if (scannedToken != null) {
//         try {
//           final message = await DeliveryService.pickupParcel(
//             scannedToken,
//             widget.tripNumber,
//           );

//           setState(() {
//             delivery['deliveryStatus'] = 'IN_PROGRESS'; // Update status locally
//           });
//           _showCustomSnackBar(context, message, Colors.green);
//         } catch (e) {
//           _showCustomSnackBar(context, 'Erreur : ${e.toString()}', Colors.red);
//         }
//       }
//     });
//   }

//   void _handleDelivery(BuildContext context) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => QRCodeScannerPage(),
//       ),
//     ).then((scannedToken) async {
//       if (scannedToken != null) {
//         try {
//           final message = await DeliveryService.deliverParcel(
//             scannedToken,
//             widget.tripNumber,
//           );

//           setState(() {
//             delivery['deliveryStatus'] = 'COMPLETED'; // Update status locally
//           });
//           _showCustomSnackBar(context, message, Colors.green);
//         } catch (e) {
//           _showCustomSnackBar(context, 'Erreur : ${e.toString()}', Colors.red);
//         }
//       }
//     });
//   }



//   void _showCustomSnackBar(BuildContext context, String message, Color color) {
//     final overlay = Overlay.of(context);
//     final overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: MediaQuery.of(context).padding.top + 10,
//         left: 16,
//         right: 16,
//         child: Material(
//           elevation: 5,
//           borderRadius: BorderRadius.circular(8),
//           color: color,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               message,
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ),
//     );

//     overlay?.insert(overlayEntry);

//     Future.delayed(const Duration(seconds: 3), () {
//       overlayEntry.remove();
//     });
//   }

//   int _getCurrentStatusIndex(String status) {
//     switch (status) {
//       case 'REQUESTED':
//         return 0;
//       case 'PENDING_START':
//         return 1;
//       case 'IN_PROGRESS':
//         return 2;
//       case 'COMPLETED':
//         return 3;
//       case 'CANCELLED':
//         return 4;
//       default:
//         return 0;
//     }
//   }

//   String _translateStatusToFrench(String status) {
//     switch (status) {
//       case 'REQUESTED':
//         return 'Livraison acceptée';
//       case 'PENDING_START':
//         return 'En attente de récupération';
//       case 'IN_PROGRESS':
//         return 'En cours de livraison';
//       case 'COMPLETED':
//         return 'Livraison terminée';
//       case 'CANCELLED':
//         return 'Livraison annulée';
//       default:
//         return 'Statut inconnu';
//     }
//   }
// }












// import 'package:flutter/material.dart';
// import '../../services/delivery_service.dart';
// import 'qr_code_scanner_page.dart';

// class DeliveryDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> delivery;
//   final String tripNumber;

//   DeliveryDetailsPage({required this.delivery, required this.tripNumber});

//   @override
//   _DeliveryDetailsPageState createState() => _DeliveryDetailsPageState();
// }

// class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
//   late Map<String, dynamic> delivery;

//   @override
//   void initState() {
//     super.initState();
//     delivery = widget.delivery; // Initialize the local delivery data
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Détails de la Livraison',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionTitle(context, 'Informations du Colis'),
//             const SizedBox(height: 12),
//             _buildCard(
//               children: [
//                 _buildInfoRow('Numéro de Livraison', delivery['deliveryNumber'] ?? 'Non disponible'),
//                 _buildInfoRow('Description', delivery['parcel']['description'] ?? 'Non disponible'),
//                 _buildInfoRow('Poids', '${delivery['parcel']['weight'] ?? 'N/A'} kg'),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildSectionTitle(context, 'Informations de l\'Expéditeur'),
//             const SizedBox(height: 12),
//             _buildCard(
//               children: [
//                 _buildInfoRow('Nom', '${delivery['senderFirstName']} ${delivery['senderLastName']}'),
//                 _buildInfoRow('Téléphone', delivery['senderPhoneNumber'] ?? 'Non disponible'),
//                 _buildInfoRow('Email', delivery['senderEmail'] ?? 'Non disponible'),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildSectionTitle(context, 'Progression de la Livraison'),
//             const SizedBox(height: 12),
//             _buildCard(children: [_buildTimeline()]),
//             const SizedBox(height: 20),
//             if (delivery['deliveryStatus'] == 'PENDING_START')
//               _buildActionButton(
//                 context,
//                 label: 'Récupérer le Colis',
//                 icon: Icons.qr_code_scanner,
//                 color: Colors.green,
//                 onPressed: () => _handlePickup(context),
//               ),
//             if (delivery['deliveryStatus'] == 'IN_PROGRESS')
//               _buildActionButton(
//                 context,
//                 label: 'Livrer le Colis',
//                 icon: Icons.qr_code_scanner,
//                 color: Colors.blueAccent,
//                 onPressed: () => _handleDelivery(context),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(BuildContext context, String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: Colors.blueAccent,
//       ),
//     );
//   }

//   Widget _buildCard({required List<Widget> children}) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: children,
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 140,
//             child: Text(
//               '$label :',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeline() {
//     final statusTimeline = [
//       'REQUESTED',
//       'PENDING_START',
//       'IN_PROGRESS',
//     ];

//     if (delivery['deliveryStatus'] == 'CANCELLED') {
//       statusTimeline.add('CANCELLED');
//     } else {
//       statusTimeline.add('COMPLETED');
//     }

//     final currentStatusIndex = _getCurrentStatusIndex(delivery['deliveryStatus'] ?? '');

//     return Column(
//       children: List.generate(statusTimeline.length, (index) {
//         final isCompleted = index < currentStatusIndex;
//         final isCurrent = index == currentStatusIndex;

//         return Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               children: [
//                 CircleAvatar(
//                   radius: 22,
//                   backgroundColor: isCurrent
//                       ? Colors.blue
//                       : isCompleted
//                           ? Colors.green
//                           : Colors.grey.shade300,
//                   child: Icon(
//                     _getStatusIcon(statusTimeline[index]),
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//                 if (index < statusTimeline.length - 1)
//                   Container(
//                     width: 3,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: isCompleted
//                             ? [Colors.green, Colors.green.shade300]
//                             : [Colors.grey.shade300, Colors.grey.shade100],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 _translateStatusToFrench(statusTimeline[index]),
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
//                   color: isCurrent
//                       ? Colors.blue
//                       : isCompleted
//                           ? Colors.green.shade700
//                           : Colors.grey.shade600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case 'REQUESTED':
//         return Icons.receipt_long;
//       case 'PENDING_START':
//         return Icons.hourglass_empty;
//       case 'IN_PROGRESS':
//         return Icons.local_shipping;
//       case 'COMPLETED':
//         return Icons.check_circle;
//       case 'CANCELLED':
//         return Icons.cancel;
//       default:
//         return Icons.info_outline;
//     }
//   }

//   Widget _buildActionButton(BuildContext context,
//       {required String label, required IconData icon, required Color color, required VoidCallback onPressed}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 5,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: Colors.white, size: 22),
//             const SizedBox(width: 12),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handlePickup(BuildContext context) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => QRCodeScannerPage(),
//       ),
//     ).then((scannedToken) async {
//       if (scannedToken != null) {
//         try {
//           final message = await DeliveryService.pickupParcel(
//             scannedToken,
//             widget.tripNumber,
//           );

//           setState(() {
//             delivery['deliveryStatus'] = 'IN_PROGRESS'; // Update status locally
//           });

//           // Navigator.pop(context);
//           _showCustomSnackBar(context, message, Colors.green);
//         } catch (e) {
//           // Navigator.pop(context);
//           _showCustomSnackBar(context, 'Erreur : ${e.toString()}', Colors.red);
//         }
//       } else {
//         Navigator.pop(context);
//       }
//     });
//   }

//   void _handleDelivery(BuildContext context) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => QRCodeScannerPage(),
//       ),
//     ).then((scannedToken) async {
//       if (scannedToken != null) {
//         try {
//           final message = await DeliveryService.deliverParcel(
//             scannedToken,
//             widget.tripNumber,
//           );

//           setState(() {
//             delivery['deliveryStatus'] = 'COMPLETED'; // Update status locally
//           });

//           // Navigator.pop(context);
//           _showCustomSnackBar(context, message, Colors.green);
//         } catch (e) {
//           // Navigator.pop(context);
//           _showCustomSnackBar(context, 'Erreur : ${e.toString()}', Colors.red);
//         }
//       } else {
//         Navigator.pop(context);
//       }
//     });
//   }

//   void _showCustomSnackBar(BuildContext context, String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: color,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   int _getCurrentStatusIndex(String status) {
//     switch (status) {
//       case 'REQUESTED':
//         return 0;
//       case 'PENDING_START':
//         return 1;
//       case 'IN_PROGRESS':
//         return 2;
//       case 'COMPLETED':
//         return 3;
//       case 'CANCELLED':
//         return 4;
//       default:
//         return 0;
//     }
//   }

//   String _translateStatusToFrench(String status) {
//     switch (status) {
//       case 'REQUESTED':
//         return 'Livraison acceptée';
//       case 'PENDING_START':
//         return 'En attente de récupération';
//       case 'IN_PROGRESS':
//         return 'En cours de livraison';
//       case 'COMPLETED':
//         return 'Livraison terminée';
//       case 'CANCELLED':
//         return 'Livraison annulée';
//       default:
//         return 'Statut inconnu';
//     }
//   }
// }












import 'package:flutter/material.dart';
import '../../services/delivery_service.dart';
import 'qr_code_scanner_page.dart';

class DeliveryDetailsPage extends StatefulWidget {
  final Map<String, dynamic> delivery;
  final String tripNumber;

  const DeliveryDetailsPage({super.key, required this.delivery, required this.tripNumber});

  @override
  _DeliveryDetailsPageState createState() => _DeliveryDetailsPageState();
}

class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
  late Map<String, dynamic> delivery;

  @override
  void initState() {
    super.initState();
    delivery = widget.delivery; // Initialize the local delivery data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails de la Livraison',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Informations du Colis'),
            const SizedBox(height: 12),
            _buildCard(
              children: [
                _buildInfoRow('Numéro de Livraison', delivery['deliveryNumber'] ?? 'Non disponible'),
                _buildInfoRow('Description', delivery['parcel']['description'] ?? 'Non disponible'),
                _buildInfoRow('Poids', '${delivery['parcel']['weight'] ?? 'N/A'} kg'),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Informations de l\'Expéditeur'),
            const SizedBox(height: 12),
            _buildCard(
              children: [
                _buildInfoRow('Nom', '${delivery['senderFirstName']} ${delivery['senderLastName']}'),
                _buildInfoRow('Téléphone', delivery['senderPhoneNumber'] ?? 'Non disponible'),
                _buildInfoRow('Email', delivery['senderEmail'] ?? 'Non disponible'),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Progression de la Livraison'),
            const SizedBox(height: 12),
            _buildCard(children: [_buildTimeline()]),
            const SizedBox(height: 20),
            if (delivery['deliveryStatus'] == 'PENDING_START')
              _buildActionButton(
                context,
                label: 'Récupérer le Colis',
                icon: Icons.qr_code_scanner,
                color: Colors.green,
                onPressed: () => _handlePickup(context),
              ),
            if (delivery['deliveryStatus'] == 'IN_PROGRESS')
              _buildActionButton(
                context,
                label: 'Livrer le Colis',
                icon: Icons.qr_code_scanner,
                color: Colors.blueAccent,
                onPressed: () => _handleDelivery(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label :',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final statusTimeline = [
      'REQUESTED',
      'PENDING_START',
      'IN_PROGRESS',
    ];

    if (delivery['deliveryStatus'] == 'CANCELLED') {
      statusTimeline.add('CANCELLED');
    } else {
      statusTimeline.add('COMPLETED');
    }

    final currentStatusIndex = _getCurrentStatusIndex(delivery['deliveryStatus'] ?? '');

    return Column(
      children: List.generate(statusTimeline.length, (index) {
        final isCompleted = index < currentStatusIndex;
        final isCurrent = index == currentStatusIndex;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: isCurrent
                      ? Colors.blue
                      : isCompleted
                          ? Colors.green
                          : Colors.grey.shade300,
                  child: Icon(
                    _getStatusIcon(statusTimeline[index]),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (index < statusTimeline.length - 1)
                  Container(
                    width: 3,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isCompleted
                            ? [Colors.green, Colors.green.shade300]
                            : [Colors.grey.shade300, Colors.grey.shade100],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _translateStatusToFrench(statusTimeline[index]),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent
                      ? Colors.blue
                      : isCompleted
                          ? Colors.green.shade700
                          : Colors.grey.shade600,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'REQUESTED':
        return Icons.receipt_long;
      case 'PENDING_START':
        return Icons.hourglass_empty;
      case 'IN_PROGRESS':
        return Icons.local_shipping;
      case 'COMPLETED':
        return Icons.check_circle;
      case 'CANCELLED':
        return Icons.cancel;
      default:
        return Icons.info_outline;
    }
  }

  Widget _buildActionButton(BuildContext context,
      {required String label, required IconData icon, required Color color, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePickup(BuildContext context) async {
    final scannedToken = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRCodeScannerPage()),
    );

    if (scannedToken != null) {
      try {
        final message = await DeliveryService.pickupParcel(
          scannedToken,
          widget.tripNumber,
        );

        setState(() {
          delivery['deliveryStatus'] = 'IN_PROGRESS'; // Update status locally
        });
        _showCustomSnackBar(context, message, Colors.green);
      } catch (e) {
        _showCustomSnackBar(context, 'Erreur : ${e.toString()}', Colors.red);
      }
    }
  }

  void _handleDelivery(BuildContext context) async {
    final scannedToken = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRCodeScannerPage()),
    );

    if (scannedToken != null) {
      try {
        final message = await DeliveryService.deliverParcel(
          scannedToken,
          widget.tripNumber,
        );

        setState(() {
          delivery['deliveryStatus'] = 'COMPLETED'; // Update status locally
        });
        _showCustomSnackBar(context, message, Colors.green);
      } catch (e) {
        _showCustomSnackBar(context, 'Erreur : ${e.toString()}', Colors.red);
      }
    }
  }

  // void _showCustomSnackBar(BuildContext context, String message, Color color) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         message,
  //         style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  //         textAlign: TextAlign.center,
  //       ),
  //       backgroundColor: color,
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       duration: const Duration(seconds: 3),
  //     ),
  //   );
  // }


  void _showCustomSnackBar(BuildContext context, String message, Color color) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10, // Juste en dessous de la barre de statut
      left: 16,
      right: 16,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(8),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove(); // Retire l'overlay après 3 secondes
  });
}


  int _getCurrentStatusIndex(String status) {
    switch (status) {
      case 'REQUESTED':
        return 0;
      case 'PENDING_START':
        return 1;
      case 'IN_PROGRESS':
        return 2;
      case 'COMPLETED':
        return 3;
      case 'CANCELLED':
        return 4;
      default:
        return 0;
    }
  }

  String _translateStatusToFrench(String status) {
    switch (status) {
      case 'REQUESTED':
        return 'Livraison acceptée';
      case 'PENDING_START':
        return 'En attente de récupération';
      case 'IN_PROGRESS':
        return 'En cours de livraison';
      case 'COMPLETED':
        return 'Livraison terminée';
      case 'CANCELLED':
        return 'Livraison annulée';
      default:
        return 'Statut inconnu';
    }
  }
}
