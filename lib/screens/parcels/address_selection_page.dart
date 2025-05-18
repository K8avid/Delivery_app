

import 'package:flutter/material.dart';
import '../../services/location_service.dart';

class AddressSelectionPage extends StatefulWidget {
  final String title;
  final Function(String) onAddressSelected;

  const AddressSelectionPage({
    super.key,
    required this.title,
    required this.onAddressSelected,
  });

  @override
  _AddressSelectionPageState createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  final _addressController = TextEditingController();
  List<String> _suggestions = [];

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<List<String>> _fetchPlaceSuggestions(String input) async {
    if (input.isEmpty) return [];
    try {
      final response = await LocationService.getPlaceSuggestions(input);
      return response;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return [];
    }
  }

  Future<void> _useCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      final address = await LocationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
      widget.onAddressSelected(address);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: "Saisissez une adresse",
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) async {
                  final suggestions = await _fetchPlaceSuggestions(value);
                  setState(() {
                    _suggestions = suggestions;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _suggestions.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: const Icon(Icons.my_location, color: Colors.blue),
                    title: const Text(
                      "Utiliser ma localisation actuelle",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onTap: _useCurrentLocation,
                  );
                }
                final suggestion = _suggestions[index - 1];
                return ListTile(
                  leading: const Icon(Icons.place, color: Colors.grey),
                  title: Text(
                    suggestion,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    widget.onAddressSelected(suggestion);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
