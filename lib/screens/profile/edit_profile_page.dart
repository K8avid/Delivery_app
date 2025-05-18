// import 'package:coligo/services/ProfileService.dart';
import 'package:coligo/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:coligo/providers/language_provider.dart';  // Import du LanguageProvider
import 'package:provider/provider.dart'; // Pour utiliser Consumer

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String token;  // Ajoutez le token JWT pour l'authentification

  // Constructor to accept userData and token
  const EditProfilePage({super.key, required this.userData, required this.token});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController dateOfBirthController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController countryController;
  late TextEditingController vehicleController;


  @override
  void initState() {
    super.initState();

    // Initialize controllers with the current user data passed from ProfilePage
    firstNameController = TextEditingController(text: widget.userData['firstName']);
    lastNameController = TextEditingController(text: widget.userData['lastName']);
    emailController = TextEditingController(text: widget.userData['email']);
    dateOfBirthController = TextEditingController(text: widget.userData['dateOfBirth']);
    phoneNumberController = TextEditingController(text: widget.userData['phoneNumber']);
    addressController = TextEditingController(text: widget.userData['address']);
    cityController = TextEditingController(text: widget.userData['city']);
    countryController = TextEditingController(text: widget.userData['country']);
    vehicleController = TextEditingController(text: widget.userData['vehicle']);
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the tree
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    cityController.dispose();
    countryController.dispose();
    vehicleController.dispose();
    super.dispose();
  }

  // Function to handle saving the updated data
  void _saveProfile() async {
    // Prepare the updated user data
    final updatedUserData = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'dateOfBirth': dateOfBirthController.text,
      'phoneNumber': phoneNumberController.text,
      'address': addressController.text,
      'city': cityController.text,
      'country': countryController.text,
      'vehicle': vehicleController.text,
    };

    try {
      // Call the method from ProfileService to update the user profile
      await UserService.updateUserProfile(widget.token, updatedUserData);

      // If the update is successful, return to the previous screen with the updated data
      Navigator.pop(context, updatedUserData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès')),
      );
    } catch (e) {
      // If there's an error, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de la mise à jour du profil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(languageProvider.isFrench ? 'Modifier le profil' : 'Edit Profile'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white, // Couleur du texte
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // First Name
                _buildTextField(
                  controller: firstNameController,
                  label: languageProvider.isFrench ? 'Prénom' : 'First Name',
                  icon: Icons.person,
                ),
                // Last Name
                _buildTextField(
                  controller: lastNameController,
                  label: languageProvider.isFrench ? 'Nom' : 'Last Name',
                  icon: Icons.person_outline,
                ),
                // Email
                _buildTextField(
                  controller: emailController,
                  label: languageProvider.isFrench ? 'Email' : 'Email',
                  icon: Icons.email,
                ),
                // Date of Birth
                _buildTextField(
                  controller: dateOfBirthController,
                  label: languageProvider.isFrench ? 'Date de naissance' : 'Date of Birth',
                  icon: Icons.calendar_today,
                ),
                // Phone Number
                _buildTextField(
                  controller: phoneNumberController,
                  label: languageProvider.isFrench ? 'Numéro de téléphone' : 'Phone Number',
                  icon: Icons.phone,
                ),
                // Address
                _buildTextField(
                  controller: addressController,
                  label: languageProvider.isFrench ? 'Adresse' : 'Address',
                  icon: Icons.home,
                ),
                // City
                _buildTextField(
                  controller: cityController,
                  label: languageProvider.isFrench ? 'Ville' : 'City',
                  icon: Icons.location_city,
                ),
                // Country
                _buildTextField(
                  controller: countryController,
                  label: languageProvider.isFrench ? 'Pays' : 'Country',
                  icon: Icons.flag,
                ),
                // Vehicle
                _buildTextField(
                  controller: vehicleController,
                  label: languageProvider.isFrench ? 'Véhicule' : 'Vehicle',
                  icon: Icons.car_rental,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Couleur de fond
                    foregroundColor: Colors.white, // Couleur du texte
                    padding: const EdgeInsets.symmetric(vertical: 15), // Padding du bouton
                    textStyle: const TextStyle(fontSize: 18), // Taille du texte
                  ),
                  child: Text(languageProvider.isFrench ? 'Enregistrer' : 'Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper function to build the text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
