import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import de flutter_svg
import 'package:intl/intl.dart';
import '../../models/location.dart';
import 'add_trip_confirmation_page.dart';

class AddTripTimePage extends StatefulWidget {
  final Location startLocation;
  final Location endLocation;
  final String polyline;
  final double duration;
  final double distance;
  final DateTime selectedDate;

  const AddTripTimePage({super.key, 
    required this.startLocation,
    required this.endLocation,
    required this.polyline,
    required this.duration,
    required this.distance,
    required this.selectedDate,
  });

  @override
  _AddTripTimePageState createState() => _AddTripTimePageState();
}

class _AddTripTimePageState extends State<AddTripTimePage> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _confirmTime() {
    final DateTime selectedDateTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTripConfirmationPage(
          startLocation: widget.startLocation,
          endLocation: widget.endLocation,
          polyline: widget.polyline,
          duration: widget.duration,
          distance: widget.distance,
          selectedDateTime: selectedDateTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMd().format(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choisir une Heure",
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Display
            Center(
              child: Column(
                children: [
                  Text(
                    "Trajet prévu le",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Time Selector
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      "Heure sélectionnée : ${_selectedTime.format(context)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Illustration
            Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/clock.svg', // Remplacez par votre fichier SVG local
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Veuillez choisir une heure\npour votre trajet",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Confirm Button
            ElevatedButton(
              onPressed: _confirmTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Confirmer l'heure",
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
