
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'delivery_processing_page.dart';
// import 'preview_page.dart';

// class TripDetailsPage extends StatelessWidget {
//   final Map<String, dynamic> trip;
//   final Map<String, dynamic> parcel;

//   const TripDetailsPage({super.key, required this.trip, required this.parcel});

//   @override
//   Widget build(BuildContext context) {
    
//     final departureDate = DateTime.parse(trip['departureTime']);
//     final durationMinutes = trip['duration'] as int;
//     final arrivalDate = departureDate.add(Duration(minutes: durationMinutes));
//     final formattedDepartureDate = DateFormat('EEEE, d MMMM y', 'fr_FR').format(departureDate);
//     final formattedDepartureTime = DateFormat.Hm().format(departureDate);
//     final formattedArrivalTime = DateFormat.Hm().format(arrivalDate);

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.blue.shade700),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Column(
//           children: [
//             Text(
//               formattedDepartureDate,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             Text(
//               'Départ à $formattedDepartureTime',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         color: Colors.white,
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildItineraryCard(context, formattedArrivalTime),
//                     const SizedBox(height: 16),
//                     _buildParcelDetailsCard(),
//                     const SizedBox(height: 16),
//                     _buildDriverInfoCard(),
//                   ],
//                 ),
//               ),
//             ),

//             // Bouton Réserver
//             Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.white,
//               child: ElevatedButton(
//                 onPressed: () {
//                   _handleBooking(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue.shade700,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.payment, size: 24, color: Colors.white),
//                     SizedBox(width: 8),
//                     Text(
//                       "Réserver Maintenant",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Carte Itinéraire
//   Widget _buildItineraryCard(BuildContext context, String arrivalTime) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildTimelinePoint(
//               title: "Départ",
//               time: DateFormat.Hm().format(DateTime.parse(trip['departureTime'])),
//               address: trip['startLocation']['address'],
//               color: Colors.blue.shade700,
//               icon: Icons.place,
//               onPreview: () => _openPreviewPage(context, trip['startLocation'], true),
//             ),
//             Divider(
//               height: 24,
//               thickness: 1,
//               color: Colors.grey.shade300,
//             ),
//             _buildTimelinePoint(
//               title: "Arrivée",
//               time: arrivalTime,
//               address: trip['endLocation']['address'],
//               color: Colors.blue.shade700,
//               icon: Icons.location_on,
//               onPreview: () => _openPreviewPage(context, trip['endLocation'], false),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Point Itinéraire
//   Widget _buildTimelinePoint({
//     required String title,
//     required String time,
//     required String address,
//     required Color color,
//     required IconData icon,
//     required VoidCallback onPreview,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CircleAvatar(
//           backgroundColor: color.withOpacity(0.1),
//           radius: 24,
//           child: Icon(icon, size: 28, color: color),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 time,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               Text(
//                 address,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade700,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//         ElevatedButton.icon(
//           onPressed: onPreview,
//           icon: const Icon(Icons.map, size: 18, color: Colors.white),
//           label: const Text("Voir", style: TextStyle(fontSize: 12, color: Colors.white)),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: color,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Carte Détails du Colis
//   Widget _buildParcelDetailsCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.inventory_2, color: Colors.blue.shade700, size: 24),
//                 const SizedBox(width: 8),
//                 const Text(
//                   "Détails du Colis",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//             Divider(
//               height: 20,
//               thickness: 1,
//               color: Colors.grey.shade300,
//             ),
//             ..._buildParcelDetailItems(),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildParcelDetailItems() {
//     final details = [
//       {
//         "title": "Description",
//         "value": parcel['description'],
//         "icon": Icons.description,
//       },
//       {
//         "title": "Poids",
//         "value": "${parcel['weight']} kg",
//         "icon": Icons.scale,
//       },
//       {
//         "title": "Dimensions",
//         "value": "${parcel['length']} x ${parcel['width']} x ${parcel['height']} cm",
//         "icon": Icons.straighten,
//       },
//       {
//         "title": "Adresse Expéditeur",
//         "value": parcel['senderAddress'],
//         "icon": Icons.person,
//       },
//       {
//         "title": "Adresse Destinataire",
//         "value": parcel['recipientAddress'],
//         "icon": Icons.person_outline,
//       },
//     ];

//     return details.map((detail) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(detail['icon'], color: Colors.black87, size: 20),
//             const SizedBox(width: 8),
//             Expanded(
//               child: RichText(
//                 text: TextSpan(
//                   text: "${detail['title']} : ",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                     color: Colors.black87,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: detail['value'],
//                       style: TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 14,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }


//   // Carte Conducteur
//   Widget _buildDriverInfoCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             const CircleAvatar(
//               radius: 30,
//               backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Mamadou Saliou",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.star, size: 16, color: Colors.yellow.shade700),
//                     const SizedBox(width: 4),
//                     Text(
//                       "4,7/5 - 12 avis",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _openPreviewPage(BuildContext context, Map<String, dynamic> location,
//       bool isDeparture) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PreviewPage(
//           location: trip['startLocation'],
//           destination: trip['endLocation'],
//           isDeparture: isDeparture,
//           polyline: trip['polyline'],
//         ),
//       ),
//     );
//   }

//   void _handleBooking(BuildContext context) {
//     final requestPayload = {
//       "parcel": parcel,
//       "tripNumber": trip['tripNumber'],
//     };

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             DeliveryProcessingPage(requestPayload: requestPayload),
//       ),
//     );
//   }
// }












import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'delivery_processing_page.dart';
import 'preview_page.dart';

class TripDetailsPage extends StatelessWidget {
  final Map<String, dynamic> trip;
  final Map<String, dynamic> parcel;

  const TripDetailsPage({super.key, required this.trip, required this.parcel});

  @override
  Widget build(BuildContext context) {
    final departureDate = DateTime.parse(trip['departureTime']);
    final durationMinutes = trip['duration'] as int;
    final arrivalDate = departureDate.add(Duration(minutes: durationMinutes));
    final formattedDepartureDate = DateFormat('EEEE, d MMMM y', 'fr_FR').format(departureDate);
    final formattedDepartureTime = DateFormat.Hm().format(departureDate);
    final formattedArrivalTime = DateFormat.Hm().format(arrivalDate);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue.shade700),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text(
              formattedDepartureDate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Départ à $formattedDepartureTime',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildItineraryCard(context, formattedArrivalTime),
                    const SizedBox(height: 16),
                    _buildParcelDetailsCard(),
                    const SizedBox(height: 16),
                    _buildDriverInfoCard(),
                  ],
                ),
              ),
            ),

            // Bouton Réserver
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () {
                  _handleBooking(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, size: 24, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Réserver Maintenant",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Carte Itinéraire
  Widget _buildItineraryCard(BuildContext context, String arrivalTime) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTimelinePoint(
              title: "Départ",
              time: DateFormat.Hm().format(DateTime.parse(trip['departureTime'])),
              address: trip['startLocation']['address'],
              color: Colors.blue.shade700,
              icon: Icons.place,
              onPreview: () => _openPreviewPage(context, trip['startLocation'], true),
            ),
            Divider(
              height: 24,
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            _buildTimelinePoint(
              title: "Arrivée",
              time: arrivalTime,
              address: trip['endLocation']['address'],
              color: Colors.blue.shade700,
              icon: Icons.location_on,
              onPreview: () => _openPreviewPage(context, trip['endLocation'], false),
            ),
          ],
        ),
      ),
    );
  }

  // Point Itinéraire
  Widget _buildTimelinePoint({
    required String title,
    required String time,
    required String address,
    required Color color,
    required IconData icon,
    required VoidCallback onPreview,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          radius: 24,
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                address,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: onPreview,
          icon: const Icon(Icons.map, size: 18, color: Colors.white),
          label: const Text("Voir", style: TextStyle(fontSize: 12, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  // Carte Détails du Colis
  Widget _buildParcelDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory_2, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 8),
                const Text(
                  "Détails du Colis",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            ..._buildParcelDetailItems(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildParcelDetailItems() {
    final details = [
      {
        "title": "Description",
        "value": parcel['description'],
        "icon": Icons.description,
      },
      {
        "title": "Poids",
        "value": "${parcel['weight']} kg",
        "icon": Icons.scale,
      },
      {
        "title": "Dimensions",
        "value": "${parcel['length']} x ${parcel['width']} x ${parcel['height']} cm",
        "icon": Icons.straighten,
      },
      {
        "title": "Adresse Expéditeur",
        "value": parcel['senderAddress'],
        "icon": Icons.person,
      },
      {
        "title": "Adresse Destinataire",
        "value": parcel['recipientAddress'],
        "icon": Icons.person_outline,
      },
    ];

    return details.map((detail) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(detail['icon'], color: Colors.black87, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: "${detail['title']} : ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: detail['value'],
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }


  // Carte Conducteur
  Widget _buildDriverInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mamadou Saliou",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.yellow.shade700),
                    const SizedBox(width: 4),
                    Text(
                      "4,7/5 - 12 avis",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openPreviewPage(BuildContext context, Map<String, dynamic> location,
      bool isDeparture) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewPage(
          location: trip['startLocation'],
          destination: trip['endLocation'],
          isDeparture: isDeparture,
          polyline: trip['polyline'],
        ),
      ),
    );
  }

  void _handleBooking(BuildContext context) {
    final requestPayload = {
      "parcel": parcel,
      "tripNumber": trip['tripNumber'],
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DeliveryProcessingPage(requestPayload: requestPayload),
      ),
    );
  }
}
