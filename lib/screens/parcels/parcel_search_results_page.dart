
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../services/trip_service.dart';
// import 'trip_details_page.dart';
// // import '../../services/trips_service_yassine.dart';

// class ParcelSearchResultsPage extends StatefulWidget {
//   final Map<String, dynamic> parcelInfo;

//   const ParcelSearchResultsPage({super.key, required this.parcelInfo});

//   @override
//   _ParcelSearchResultsPageState createState() =>
//       _ParcelSearchResultsPageState();
// }

// class _ParcelSearchResultsPageState extends State<ParcelSearchResultsPage> {
//   late Future<List<dynamic>> _trips;
//   late String _formattedDate;

//   @override
//   void initState() {
//     super.initState();
//     // Initialisation des données
//     //_trips = TripService.searchTrips(widget.parcelInfo);
//     _trips = TripService.searchTrips_3(widget.parcelInfo);

//     // Formatage de la date sélectionnée
//     final selectedDate = DateTime.parse(widget.parcelInfo['expiracyDate']);
//     _formattedDate = DateFormat('EEEE, d MMMM yyyy', 'fr_FR').format(selectedDate);
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("parcel_search_result_page__________________________________________________");
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         title: Column(
//           children: [
//             const Text(
//               'Résultats de Recherche',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               _formattedDate,
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           ],
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         color: Colors.white, // Arrière-plan blanc
//         child: FutureBuilder<List<dynamic>>(
//           future: _trips,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.error_outline, color: Colors.red, size: 60),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Erreur : ${snapshot.error}',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.search_off, color: Colors.grey, size: 100),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Aucun trajet trouvé',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey.shade800,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Essayez de modifier vos critères de recherche.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                       ),
//                       child: const Text(
//                         'Modifier la recherche',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             final trips = snapshot.data!;
//             return ListView.builder(
//               padding: const EdgeInsets.all(16.0),
//               itemCount: trips.length,
//               itemBuilder: (context, index) {
//                 final trip = trips[index];
//                 return _buildTripCard(context, trip);
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // Construction d'une carte pour un trajet
//   Widget _buildTripCard(BuildContext context, Map<String, dynamic> trip) {
//     final departureTime = DateTime.parse(trip['departureTime']);
//     final formattedTime =
//         "${departureTime.hour}:${departureTime.minute.toString().padLeft(2, '0')}";

//     final durationHours = (trip['duration']) ~/3600;
//     final durationMinutes = (trip['duration'] % 3600) ~/60;
    

//     final depart = fixAccents(trip['startLocation']['address'].toString());
//     final arrive = fixAccents(trip['endLocation']['address'].toString());



//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TripDetailsPage(
//               trip: trip,
//               parcel: widget.parcelInfo,
//             ),
//           ),
//         );
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         elevation: 8,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     formattedTime,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue.shade900,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Icon(Icons.directions_car, color: Colors.blue.shade700, size: 36),
//                 ],
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.circle, size: 12, color: Colors.green),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             depart,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Container(
//                           width: 2,
//                           height: 30,
//                           color: Colors.grey.shade400,
//                         ),
//                         const SizedBox(width: 16),
//                         Text(
//                           "$durationHours h $durationMinutes min",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Icon(Icons.circle, size: 12, color: Colors.red),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             arrive,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black87,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
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
// }
// String fixAccents(String input) {
//   return input.replaceAll('Ã©', 'é');
// }

















import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/trip_service.dart';
import '../../services/location_service.dart';
import 'trip_details_page.dart';


class ParcelSearchResultsPage extends StatefulWidget {
  final Map<String, dynamic> parcelInfo;

  const ParcelSearchResultsPage({super.key, required this.parcelInfo});

  @override
  _ParcelSearchResultsPageState createState() =>
      _ParcelSearchResultsPageState();
}

class _ParcelSearchResultsPageState extends State<ParcelSearchResultsPage> {
  late Future<List<dynamic>> _trips;
  late String _formattedDate;

  @override
  void initState() {
    super.initState();
    _trips = TripService.searchTrips_3(widget.parcelInfo);

    final selectedDate = DateTime.parse(widget.parcelInfo['expiracyDate']);
    _formattedDate = DateFormat('EEEE, d MMMM yyyy', 'fr_FR').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Résultats de Recherche',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),


      body: Container(
        color: Colors.grey.shade100,
        child: FutureBuilder<List<dynamic>>(
          future: _trips,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur : ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, color: Colors.grey, size: 100),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun trajet trouvé',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Essayez de modifier vos critères de recherche.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Modifier la recherche',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            final trips = snapshot.data!;
            trips.sort((a, b) => DateTime.parse(b['departureTime'])
                .compareTo(DateTime.parse(a['departureTime'])));

            final groupedTrips = _groupTripsByDate(trips);

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: groupedTrips.length,
              itemBuilder: (context, index) {
                final date = groupedTrips.keys.elementAt(index);
                final tripsForDate = groupedTrips[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            DateFormat('EEEE, d MMMM yyyy', 'fr_FR').format(date),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ...tripsForDate.map((trip) => _buildTripCard(context, trip)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Map<DateTime, List<dynamic>> _groupTripsByDate(List<dynamic> trips) {
    final Map<DateTime, List<dynamic>> groupedTrips = {};
    for (var trip in trips) {
      final date = DateTime.parse(trip['departureTime']).toLocal();
      final normalizedDate = DateTime(date.year, date.month, date.day);
      if (!groupedTrips.containsKey(normalizedDate)) {
        groupedTrips[normalizedDate] = [];
      }
      groupedTrips[normalizedDate]!.add(trip);
    }
    return groupedTrips;
  }


//========================== build trip card ============================

Widget _buildTripCard(BuildContext context, Map<String, dynamic> trip) {
  final departureTime = DateTime.parse(trip['departureTime']);
  final formattedTime = "${departureTime.hour}:${departureTime.minute.toString().padLeft(2, '0')}";
  final durationSeconds = trip['duration'] ?? 0;
  final durationHours = (durationSeconds / 60).floor();
  final durationMinutes = durationSeconds % 60;
  
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripDetailsPage(
            trip: trip,
            parcel: widget.parcelInfo,
          ),
        ),
      );
    },
    child: Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(Icons.directions_car, color: Colors.blue.shade700, size: 36),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.circle, size: 12, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              trip['startLocation']['address'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            "$durationHours h $durationMinutes min",
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.circle, size: 12, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              trip['endLocation']['address'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<Map<String, dynamic>>(
                        future: _fetchAccessTimes(trip),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Calcul en cours...", style: TextStyle(fontSize: 12, color: Colors.grey));
                          } else if (snapshot.hasError) {
                            return const Text("Erreur d'accès", style: TextStyle(fontSize: 12, color: Colors.red));
                          } else if (snapshot.hasData) {
                            final senderData = snapshot.data!['sender'];
                            final recipientData = snapshot.data!['recipient'];
                            final senderMinutes = (senderData['duration'] / 60).ceil();
                            final recipientMinutes = (recipientData['duration'] / 60).ceil();
                            final senderMode = senderData['mode'];
                            final recipientMode = recipientData['mode'];
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Accès expéditeur : $senderMinutes min ($senderMode)",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  "Accès destinataire : $recipientMinutes min ($recipientMode)",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
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

//========================= Trajet plus court walking/transit ======================================
Future<Map<String, dynamic>> _fetchAccessTimes(Map<String, dynamic> trip) async {
  final senderAddress = widget.parcelInfo['senderAddress'];
  final recipientAddress = widget.parcelInfo['recipientAddress'];
  
  // Récupérer les coordonnées de départ et d'arrivée du trajet
  final startLocation = trip['startLocation'];
  final endLocation = trip['endLocation'];
  
  // Appeler l'API pour obtenir le temps d'accès pour l'expéditeur (de senderAddress vers startLocation)
  final senderFuture = LocationService.getFastestRoute(
    senderAddress,
    startLocation['latitude'],
    startLocation['longitude'],
  );
  
  // Appeler l'API pour obtenir le temps d'accès pour le destinataire (de recipientAddress vers endLocation)
  final recipientFuture = LocationService.getFastestRoute(
    recipientAddress,
    endLocation['latitude'],
    endLocation['longitude'],
  );
  
  final results = await Future.wait([senderFuture, recipientFuture]);
  
  return {
    'sender': results[0],     // Ex. : { "duration": 600, "mode": "walking" }
    'recipient': results[1],
  };
}







}

String fixAccents(String input) {
  return input.replaceAll('Ã©', 'é');
}
