// import 'package:flutter/material.dart';
// import '../../models/location.dart';
// import '../parcels/map_preview_page.dart';
// import 'delivery_list_page.dart';
// import 'delivery_requests_screen.dart';

// class TripDetailScreen extends StatelessWidget {
//   final dynamic trip;

//   const TripDetailScreen({Key? key, required this.trip}) : super(key: key);

//   String formatDuration(dynamic duration) {
//     double totalMinutes = duration is int ? duration.toDouble() : duration;
//     int hours = totalMinutes ~/ 60;
//     int minutes = (totalMinutes % 60).toInt();
//     return hours > 0 ? "$hours h $minutes min" : "$minutes min";
//   }

//   String formatDistance(double distance) {
//     return "${distance.toStringAsFixed(1)} km";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Détails du Voyage',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1.0,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Trip Overview Card
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 elevation: 4,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _tripDetailRow(
//                         context,
//                         title: 'Départ',
//                         value: trip["startLocation"]["address"],
//                         icon: Icons.location_on,
//                         color: Colors.green,
//                         onMapPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MapPreviewPage(
//                                 startLocation: Location.fromJson(
//                                     trip["startLocation"]),
//                                 endLocation:
//                                     Location.fromJson(trip["startLocation"]),
//                                 polyline: trip["polyline"],
//                                 focusOnStart: true,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       const Divider(),
//                       _tripDetailRow(
//                         context,
//                         title: 'Destination',
//                         value: trip["endLocation"]["address"],
//                         icon: Icons.flag,
//                         color: Colors.red,
//                         onMapPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MapPreviewPage(
//                                 startLocation:
//                                     Location.fromJson(trip["endLocation"]),
//                                 endLocation: Location.fromJson(
//                                     trip["endLocation"]),
//                                 polyline: trip["polyline"],
//                                 focusOnStart: false,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       const Divider(),
//                       _tripDetailRow(
//                         context,
//                         title: 'Distance',
//                         value: formatDistance(trip["distance"]),
//                         icon: Icons.route,
//                         color: Colors.deepOrange,
//                       ),
//                       const Divider(),
//                       _tripDetailRow(
//                         context,
//                         title: 'Durée estimée',
//                         value: formatDuration(trip["duration"]),
//                         icon: Icons.timer,
//                         color: Colors.blue,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Action Buttons
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DeliveryRequestsPage(
//                         tripNumber: trip['tripNumber'],
//                       ),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.local_shipping, color: Colors.white),
//                     SizedBox(width: 10),
//                     Text(
//                       'Demandes de livraison',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DeliveryListPage(
//                         tripNumber: trip['tripNumber'],
//                       ),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.list, color: Colors.white),
//                     SizedBox(width: 10),
//                     Text(
//                       'Liste des livraisons',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _tripDetailRow(
//     BuildContext context, {
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//     void Function()? onMapPressed,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CircleAvatar(
//           radius: 20,
//           backgroundColor: color.withOpacity(0.1),
//           child: Icon(icon, color: color),
//         ),
//         const SizedBox(width: 15),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600],
//                     ),
//               ),
//               Text(
//                 value,
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//               ),
//             ],
//           ),
//         ),
//         if (onMapPressed != null)
//           IconButton(
//             icon: Icon(Icons.map, color: color),
//             onPressed: onMapPressed,
//           ),
//       ],
//     );
//   }
// }















import 'package:flutter/material.dart';
import '../../models/location.dart';
import '../parcels/map_preview_page.dart';
import 'delivery_list_page.dart';
import 'delivery_requests_screen.dart';

class TripDetailScreen extends StatelessWidget {
  final dynamic trip;

  const TripDetailScreen({super.key, required this.trip});

  String formatDuration(dynamic duration) {
    double totalMinutes = duration is int ? duration.toDouble() : duration;
    int hours = totalMinutes ~/ 60;
    int minutes = (totalMinutes % 60).toInt();
    return hours > 0 ? "$hours h $minutes min" : "$minutes min";
  }

  String formatDistance(double distance) {
    return "${distance.toStringAsFixed(1)} km";
  }

  void cancelTrip(BuildContext context) {
    // Fonction pour annuler le trajet (ajouter votre logique ici)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Êtes-vous sûr de vouloir annuler ce trajet ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () {
              // Ajoutez ici la logique pour annuler le trajet
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Le trajet a été annulé.'),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Oui', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails du Voyage',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Numéro du trajet
              Center(
                child: Text(
                  "#${trip['tripNumber']}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Trip Overview Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tripDetailRow(
                        context,
                        title: 'Départ',
                        value: trip["startLocation"]["address"],
                        icon: Icons.location_on,
                        color: Colors.green,
                        onMapPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapPreviewPage(
                                startLocation: Location.fromJson(
                                    trip["startLocation"]),
                                endLocation:
                                    Location.fromJson(trip["startLocation"]),
                                polyline: trip["polyline"],
                                focusOnStart: true,
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      _tripDetailRow(
                        context,
                        title: 'Destination',
                        value: trip["endLocation"]["address"],
                        icon: Icons.flag,
                        color: Colors.red,
                        onMapPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapPreviewPage(
                                startLocation:
                                    Location.fromJson(trip["endLocation"]),
                                endLocation: Location.fromJson(
                                    trip["endLocation"]),
                                polyline: trip["polyline"],
                                focusOnStart: false,
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      _tripDetailRow(
                        context,
                        title: 'Distance',
                        value: formatDistance(trip["distance"]),
                        icon: Icons.route,
                        color: Colors.deepOrange,
                      ),
                      const Divider(),
                      _tripDetailRow(
                        context,
                        title: 'Durée estimée',
                        value: formatDuration(trip["duration"]),
                        icon: Icons.timer,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),

              // Action Buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeliveryRequestsPage(
                        tripNumber: trip['tripNumber'],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_shipping, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Demandes de livraison',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeliveryListPage(
                        tripNumber: trip['tripNumber'],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Liste des livraisons',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Cancel Trip Button
              ElevatedButton(
                onPressed: () => cancelTrip(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Annuler le trajet',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tripDetailRow(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    void Function()? onMapPressed,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
        if (onMapPressed != null)
          IconButton(
            icon: Icon(Icons.map, color: color),
            onPressed: onMapPressed,
          ),
      ],
    );
  }
}
