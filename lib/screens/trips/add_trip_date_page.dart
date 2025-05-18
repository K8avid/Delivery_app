import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/location.dart';
import 'add_trip_time_page.dart';

class AddTripDatePage extends StatefulWidget {
  final Location startLocation;
  final Location endLocation;
  final String polyline;
  final double duration;
  final double distance;

  const AddTripDatePage({super.key, 
    required this.startLocation,
    required this.endLocation,
    required this.polyline,
    required this.duration,
    required this.distance,
  });

  @override
  _AddTripDatePageState createState() => _AddTripDatePageState();
}

class _AddTripDatePageState extends State<AddTripDatePage> {
  DateTime _selectedDate = DateTime.now();
  final DateTime _currentDate = DateTime.now();
  final List<String> _weekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  void _confirmDate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTripTimePage(
          startLocation: widget.startLocation,
          endLocation: widget.endLocation,
          polyline: widget.polyline,
          duration: widget.duration,
          distance: widget.distance,
          selectedDate: _selectedDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choisir une Date",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2, // Subtile ombre
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sélectionnez une date pour votre trajet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(6, (index) {
                    DateTime currentMonth = DateTime(
                      _currentDate.year,
                      _currentDate.month + index,
                      1,
                    );
                    return _buildMonthCalendar(currentMonth);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _confirmDate,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: const Text(
            "Confirmer la date",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthCalendar(DateTime month) {
    String formattedMonth = DateFormat.yMMMM().format(month);

    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    int firstWeekday = DateTime(month.year, month.month, 1).weekday;

    // Ajustement pour aligner les jours correctement
    List<Widget> dayWidgets = List.generate(
      firstWeekday - 1,
      (index) => Container(),
    );

    dayWidgets.addAll(List.generate(daysInMonth, (index) {
      DateTime currentDate = DateTime(month.year, month.month, index + 1);
      bool isBeforeToday = currentDate.isBefore(_currentDate) &&
          currentDate.day != _currentDate.day; // Permettre la sélection du jour actuel
      bool isSelected = _selectedDate.year == currentDate.year &&
          _selectedDate.month == currentDate.month &&
          _selectedDate.day == currentDate.day;

      return GestureDetector(
        onTap: isBeforeToday
            ? null
            : () {
                setState(() {
                  _selectedDate = currentDate;
                });
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue
                : isBeforeToday
                    ? Colors.grey.shade300
                    : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2)
                : Border.all(color: Colors.grey.shade300),
          ),
          alignment: Alignment.center,
          child: Text(
            "${index + 1}",
            style: TextStyle(
              color: isBeforeToday
                  ? Colors.grey
                  : isSelected
                      ? Colors.white
                      : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      );
    }));

    return Card(
      elevation: 2, // Subtile ombre
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedMonth,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _weekDays
                  .map((day) => Expanded(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: dayWidgets,
            ),
          ],
        ),
      ),
    );
  }
}
