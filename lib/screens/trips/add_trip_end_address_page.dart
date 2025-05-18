import 'package:flutter/material.dart';
import '../../models/location.dart';
import 'add_trip_end_preview_page.dart';
import '../../services/location_service.dart';


class AddTripEndAddressPage extends StatefulWidget {
  final Location startLocation;

  const AddTripEndAddressPage({super.key, required this.startLocation});

  @override
  _AddTripEndAddressPageState createState() => _AddTripEndAddressPageState();
}

class _AddTripEndAddressPageState extends State<AddTripEndAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  List<String> _suggestions = ["Utiliser ma localisation actuelle"];
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _fetchSuggestions(String input) async {
    if (input.trim().isEmpty) {
      setState(() {
        _suggestions = ["Utiliser ma localisation actuelle"];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final placeSuggestions = await LocationService.getPlaceSuggestions(input);
      setState(() {
        _suggestions = ["Utiliser ma localisation actuelle", ...placeSuggestions];
      });
    } catch (error) {
      _showSnackBar("Erreur lors de la récupération des suggestions.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onSuggestionSelected(String suggestion) async {
    if (suggestion == "Utiliser ma localisation actuelle") {
      try {
        final location = await LocationService.getCurrentLocation();
        _navigateToPreviewPage(
          address: "Ma position actuelle",
          location: Location(
            latitude: location.latitude,
            longitude: location.longitude,
            address: "Ma position actuelle",
          ),
        );
      } catch (error) {
        _showSnackBar("Erreur lors de la récupération de la localisation actuelle.");
      }
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        final coordinates = await LocationService.getCoordinates(suggestion);
        if (coordinates != null) {
          _navigateToPreviewPage(
            address: suggestion,
            location: Location(
              latitude: coordinates['latitude']!,
              longitude: coordinates['longitude']!,
              address: suggestion,
            ),
          );
        } else {
          _showSnackBar("Impossible de récupérer les coordonnées de l'adresse.");
        }
      } catch (error) {
        _showSnackBar("Erreur lors de la récupération des coordonnées.");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToPreviewPage({required String address, required Location location}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTripEndPreviewPage(
          address: address,
          endLocation: location,
          startLocation: widget.startLocation,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildCustomInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Icon(Icons.search, color: Colors.blue),
          ),
          Expanded(
            child: TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: "Saisissez une adresse",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: _fetchSuggestions,
            ),
          ),
          if (_addressController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _addressController.clear();
                setState(() {
                  _suggestions = ["Utiliser ma localisation actuelle"];
                });
              },
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
          "Adresse d'Arrivée",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: [
            // Custom Input Field
            _buildCustomInputField(),
            const SizedBox(height: 20),

            // Suggestions or Loading Indicator
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
                    return GestureDetector(
                      onTap: () => _onSuggestionSelected(suggestion),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              suggestion == "Utiliser ma localisation actuelle"
                                  ? Icons.my_location
                                  : Icons.place,
                              color: suggestion == "Utiliser ma localisation actuelle"
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                suggestion,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
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
      ),
    );
  }
}
