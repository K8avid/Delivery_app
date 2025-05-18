// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../services/trip_service.dart';
// import 'add_trip_start_address_page.dart';
// import 'trip_detail_screen.dart';

// class TripsScreen extends StatefulWidget {
//   @override
//   _TripsScreenState createState() => _TripsScreenState();
// }

// class _TripsScreenState extends State<TripsScreen> {
//   List<dynamic> trips = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadTrips();
//   }

//   Future<void> loadTrips() async {
//     try {
//       final fetchedTrips = await TripService.fetchTripsOfCurrentUser();
//       setState(() {
//         trips = fetchedTrips;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Erreur : $e');
//     }
//   }

//   String formatDate(String dateTime) {
//     final parsedDate = DateTime.parse(dateTime);
//     return DateFormat.yMMMMd().format(parsedDate);
//   }

//   String formatTime(String dateTime) {
//     final parsedDate = DateTime.parse(dateTime);
//     return DateFormat.Hm().format(parsedDate);
//   }

//   String calculateArrivalTime(String departureTime, dynamic duration) {
//     final departureDate = DateTime.parse(departureTime);
//     final minutes = duration is int ? duration : duration.toInt();
//     final arrivalDate = departureDate.add(Duration(minutes: minutes));
//     return DateFormat.Hm().format(arrivalDate);
//   }

//   String formatDuration(dynamic duration) {
//     double totalMinutes = duration is int ? duration.toDouble() : duration;
//     int hours = totalMinutes ~/ 60;
//     int minutes = (totalMinutes % 60).toInt();
//     return hours > 0 ? "$hours h $minutes min" : "$minutes min";
//   }

//   void publishTrip() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => AddTripStartAddressPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Mes Trajets',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 1,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),

//       backgroundColor: Colors.grey[100],
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: publishTrip,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.add, color: Colors.white),
//                   SizedBox(width: 8),
//                   Text(
//                     'Publier un Nouveau Trajet',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : trips.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.directions_car,
//                               size: 100,
//                               color: Colors.grey.shade400,
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               'Aucun trajet disponible',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: trips.length,
//                         itemBuilder: (context, index) {
//                           final trip = trips[index];
//                           return Container(
//                             margin: EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.1),
//                                   blurRadius: 10,
//                                   offset: Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => TripDetailScreen(
//                                       trip: trip,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Row(
//                                   children: [
//                                     // Timeline Column
//                                     Column(
//                                       children: [
//                                         Text(
//                                           formatDate(trip["departureTime"]),
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.blueGrey,
//                                           ),
//                                         ),
//                                         SizedBox(height: 4),
//                                         Text(
//                                           formatTime(trip["departureTime"]),
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.blue,
//                                           ),
//                                         ),
//                                         SizedBox(height: 4),
//                                         Icon(Icons.circle,
//                                             color: Colors.blue, size: 10),
//                                         Container(
//                                           width: 1.5,
//                                           height: 12, // Réduction de la hauteur
//                                           color: Colors.blue,
//                                         ),
//                                         Text(
//                                           formatDuration(trip["duration"]),
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black54,
//                                           ),
//                                         ),
//                                         Container(
//                                           width: 1.5,
//                                           height: 12, // Réduction de la hauteur
//                                           color: Colors.blue,
//                                         ),
//                                         Icon(Icons.circle,
//                                             color: Colors.blue, size: 10),
//                                         SizedBox(height: 4),
//                                         Text(
//                                           calculateArrivalTime(
//                                               trip["departureTime"],
//                                               trip["duration"]),
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.blue,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(width: 16),

//                                     // Align Addresses
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             alignment: Alignment.centerLeft,
//                                             margin: EdgeInsets.only(top: 34),
//                                             child: Text(
//                                               trip["startLocation"]["address"],
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 24), // Distance ajustée
//                                           Container(
//                                             alignment: Alignment.centerLeft,
//                                             margin: EdgeInsets.only(bottom: 8),
//                                             child: Text(
//                                               trip["endLocation"]["address"],
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Icon(Icons.arrow_forward_ios,
//                                         color: Colors.grey, size: 20),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/trip_service.dart';
import 'add_trip_start_address_page.dart';
import 'trip_detail_screen.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  List<dynamic> trips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTrips();
  }

  Future<void> loadTrips() async {
    try {
      final fetchedTrips = await TripService.fetchTripsOfCurrentUser();
      setState(() {
        trips = fetchedTrips;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur : $e');
    }
  }

  String formatDate(String dateTime) {
    final parsedDate = DateTime.parse(dateTime);
    return DateFormat.yMMMMd().format(parsedDate);
  }

  String formatTime(String dateTime) {
    final parsedDate = DateTime.parse(dateTime);
    return DateFormat.Hm().format(parsedDate);
  }

  String calculateArrivalTime(String departureTime, dynamic duration) {
    final departureDate = DateTime.parse(departureTime);
    final minutes = duration is int ? duration : duration.toInt();
    final arrivalDate = departureDate.add(Duration(minutes: minutes));
    return DateFormat.Hm().format(arrivalDate);
  }

  String formatDuration(dynamic duration) {
    double totalMinutes = duration is int ? duration.toDouble() : duration;
    int hours = totalMinutes ~/ 60;
    int minutes = (totalMinutes % 60).toInt();
    return hours > 0 ? "$hours h $minutes min" : "$minutes min";
  }

  void publishTrip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTripStartAddressPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Trajets',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: publishTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Publier un Nouveau Trajet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : trips.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_car,
                              size: 100,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Aucun trajet disponible',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TripDetailScreen(
                                      trip: trip,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  // Trip Number
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8),
                                    child: Text(
                                      "#${trip["tripNumber"]}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        // Timeline Column
                                        Column(
                                          children: [
                                            Text(
                                              formatDate(
                                                  trip["departureTime"]),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              formatTime(
                                                  trip["departureTime"]),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Icon(Icons.circle,
                                                color: Colors.blue, size: 10),
                                            Container(
                                              width: 1.5,
                                              height: 12,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                              formatDuration(trip["duration"]),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Container(
                                              width: 1.5,
                                              height: 12,
                                              color: Colors.blue,
                                            ),
                                            const Icon(Icons.circle,
                                                color: Colors.blue, size: 10),
                                            const SizedBox(height: 4),
                                            Text(
                                              calculateArrivalTime(
                                                  trip["departureTime"],
                                                  trip["duration"]),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 16),

                                        // Align Addresses
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                margin: const EdgeInsets.only(
                                                    top: 34),
                                                child: Text(
                                                  trip["startLocation"]
                                                      ["address"],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: 24), // Distance ajustée
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                margin: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: Text(
                                                  trip["endLocation"]
                                                      ["address"],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios,
                                            color: Colors.grey, size: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
