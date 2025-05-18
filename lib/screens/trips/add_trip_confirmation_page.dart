import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/location.dart';
import '../../services/trip_service.dart';
import 'success_page.dart';
import 'error_page.dart';

class AddTripConfirmationPage extends StatefulWidget {
  final Location startLocation;
  final Location endLocation;
  final String polyline;
  final double duration;
  final double distance;
  final DateTime selectedDateTime;

  const AddTripConfirmationPage({super.key, 
    required this.startLocation,
    required this.endLocation,
    required this.polyline,
    required this.duration,
    required this.distance,
    required this.selectedDateTime,
  });

  @override
  _AddTripConfirmationPageState createState() =>
      _AddTripConfirmationPageState();
}

class _AddTripConfirmationPageState extends State<AddTripConfirmationPage> {
  bool _isSubmitting = false;

  Future<void> _confirmTrip() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      bool success = await TripService.addTrip(
        startLocation: widget.startLocation,
        endLocation: widget.endLocation,
        polyline: widget.polyline,
        duration: widget.duration,
        distance: widget.distance,
        departureTime: widget.selectedDateTime,
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessPage(
              message: "Trajet ajouté avec succès!",
            ),
          ),
        );
      } else {
        throw Exception("Erreur lors de l'ajout du trajet.");
      }
    } catch (error) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorPage(
            errorMessage: "Erreur : $error",
          ),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  String _convertDurationToHoursMinutes(double duration) {
    int hours = duration ~/ 60;
    int minutes = (duration % 60).toInt();
    return hours > 0 ? "$hours h $minutes min" : "$minutes min";
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateTime =
        "${DateFormat.yMMMMd().format(widget.selectedDateTime)} à ${DateFormat.Hm().format(widget.selectedDateTime)}";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Confirmation du Trajet",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Information Cards
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: const Text(
                  "Départ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(widget.startLocation.address),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.flag, color: Colors.red),
                title: const Text(
                  "Arrivée",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(widget.endLocation.address),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.directions_car, color: Colors.green),
                title: const Text(
                  "Distance",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("${widget.distance.toStringAsFixed(2)} km"),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.access_time, color: Colors.orange),
                title: const Text(
                  "Durée estimée",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_convertDurationToHoursMinutes(widget.duration)),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.purple),
                title: const Text(
                  "Date et heure",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(formattedDateTime),
              ),
            ),
            const Spacer(),

            // Confirm Button
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _confirmTrip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "Confirmer le Trajet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
