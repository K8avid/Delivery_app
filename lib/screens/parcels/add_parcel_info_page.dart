import 'package:flutter/material.dart';
import 'add_parcel_address_page.dart';

class AddParcelInfoPage extends StatefulWidget {

  const AddParcelInfoPage({super.key});

  @override
  _AddParcelInfoPageState createState() => _AddParcelInfoPageState();
}

class _AddParcelInfoPageState extends State<AddParcelInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String description = ''; // Valeur sélectionnée du dropdown
  double length = 0.0, width = 0.0, height = 0.0, weight = 0.0;
  String receiverEmail = '';
  
  // Liste des options de description
  final List<String> descriptionOptions = [
    'Électronique',
    'Vêtements',
    'Meubles',
    'Livres',
    'Jouets',
    'Nourriture',
    'Accessoires',
    'Bijoux',
    'Cosmétiques'
  ];

  String? selectedDescription; // Variable pour la description sélectionnée

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informations du Colis',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carte pour la description avec le menu déroulant
                _buildSectionCard(
                  icon: Icons.description,
                  title: "Description",
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    value: selectedDescription,
                    hint: const Text("Sélectionner une description"),
                    onChanged: (value) {
                      setState(() {
                        selectedDescription = value;
                      });
                    },
                    onSaved: (value) => description = value!,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Veuillez sélectionner une description' : null,
                    items: descriptionOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Carte pour les dimensions
                _buildSectionCard(
                  icon: Icons.straighten,
                  title: "Dimensions (en cm)",
                  child: Column(
                    children: [
                      _buildDimensionField(
                        hintText: "Longueur",
                        onSaved: (value) => length = double.parse(value!),
                      ),
                      const Divider(),
                      _buildDimensionField(
                        hintText: "Largeur",
                        onSaved: (value) => width = double.parse(value!),
                      ),
                      const Divider(),
                      _buildDimensionField(
                        hintText: "Hauteur",
                        onSaved: (value) => height = double.parse(value!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Carte pour le poids
                _buildSectionCard(
                  icon: Icons.scale,
                  title: "Poids (en kg)",
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Exemple : 2.5",
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => weight = double.parse(value!),
                    validator: (value) =>
                        value!.isEmpty ? 'Veuillez saisir le poids' : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Carte pour l'email du destinataire
                _buildSectionCard(
                  icon: Icons.email,
                  title: "Email du Destinataire",
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Exemple : destinataire@example.com",
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => receiverEmail = value!,
                    validator: (value) => value!.isEmpty
                        ? 'Veuillez saisir un email'
                        : (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)
                            ? 'Veuillez saisir un email valide'
                            : null),
                  ),
                ),
                const SizedBox(height: 30),

                // Bouton Suivant
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddParcelAddressPage(
                              parcelInfo: {
                                'description': description,
                                'length': length,
                                'width': width,
                                'height': height,
                                'weight': weight,
                                'receiverEmail': receiverEmail,
                              },
                              
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Suivant',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Construction des cartes pour les sections
  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  // Construction des champs pour les dimensions
  Widget _buildDimensionField({
    required String hintText,
    required Function(String?) onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.number,
      onSaved: onSaved,
      validator: (value) => value!.isEmpty ? 'Champ requis' : null,
    );
  }
}
