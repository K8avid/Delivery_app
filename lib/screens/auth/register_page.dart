import 'package:flutter/material.dart';
import 'package:coligo/services/user_service.dart';
import 'package:coligo/providers/language_provider.dart'; // Import du LanguageProvider
import 'package:provider/provider.dart'; // Pour utiliser Consumer



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  DateTime? selectedDate;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white, // Couleur blanche pour l'AppBar
            foregroundColor: Colors.black, // Couleur des icônes et du texte
            elevation: 1, // Légère ombre sous l'AppBar
            centerTitle: true, // Titre centré
            title: Text(
              languageProvider.isFrench ? 'Inscription' : 'Register',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        languageProvider.isFrench ? 'Créer un compte' : 'Create an account',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(firstNameController, languageProvider.isFrench ? 'Prénom' : 'First Name', Icons.person),
                      _buildTextField(lastNameController, languageProvider.isFrench ? 'Nom' : 'Last Name', Icons.person),
                      _buildTextField(emailController, languageProvider.isFrench ? 'Email' : 'Email', Icons.email),
                      _buildPasswordField(passwordController, languageProvider.isFrench ? 'Mot de passe' : 'Password'),
                      _buildDatePicker(context, languageProvider),
                      _buildTextField(phoneNumberController, languageProvider.isFrench ? 'Téléphone' : 'Phone', Icons.phone),
                      _buildTextField(vehicleController, languageProvider.isFrench ? 'Véhicule' : 'Vehicle', Icons.directions_car),
                      _buildTextField(addressController, languageProvider.isFrench ? 'Adresse' : 'Address', Icons.location_on),
                      _buildTextField(cityController, languageProvider.isFrench ? 'Ville' : 'City', Icons.location_city),
                      _buildTextField(countryController, languageProvider.isFrench ? 'Pays' : 'Country', Icons.flag),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_isValidEmail(emailController.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(languageProvider.isFrench ? 'Veuillez entrer un email valide' : 'Please enter a valid email')),
                            );
                            return;
                          }

                          if (selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(languageProvider.isFrench ? 'Veuillez sélectionner une date de naissance' : 'Please select a date of birth')),
                            );
                            return;
                          }

                          try {
                            final response = await UserService.saveUser(
                              firstNameController.text,
                              lastNameController.text,
                              emailController.text,
                              passwordController.text,
                              selectedDate?.toIso8601String().split('T')[0] ?? '',
                              phoneNumberController.text,
                              vehicleController.text,
                              addressController.text,
                              cityController.text,
                              countryController.text,
                            );

                            if (response.statusCode == 200) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(languageProvider.isFrench ? 'Utilisateur enregistré avec succès!' : 'User registered successfully!')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(languageProvider.isFrench ? 'Erreur lors de l\'inscription' : 'Error during registration: ${response.body}')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(languageProvider.isFrench ? 'Erreur de connexion ou d\'API' : 'Connection or API error: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(languageProvider.isFrench ? 'S\'inscrire' : 'Register', style: const TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock, color: Colors.blue),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.blue,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, LanguageProvider languageProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          setState(() {
            selectedDate = date;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            selectedDate != null
                ? '${languageProvider.isFrench ? 'Date de naissance' : 'Date of Birth'}: ${selectedDate!.toIso8601String().split('T')[0]}'
                : languageProvider.isFrench ? 'Sélectionnez une date de naissance' : 'Select a date of birth',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}
