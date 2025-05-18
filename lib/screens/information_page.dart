import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:coligo/providers/language_provider.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Créer un AnimationController pour l'animation de défilement
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Durée de l'animation
      vsync: this,
    );

    // Définir l'animation pour déplacer l'élément de droite à gauche
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Commence à droite hors écran
      end: const Offset(-1.0, 0.0),   // Finit à gauche hors écran
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Lancer l'animation en boucle
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.forward(from: 0.0);  // Réinitialiser l'animation lorsqu'elle est terminée
      }
    });

    _controller.forward();  // Démarre l'animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          languageProvider.selectedLanguage == 'fr' ? "Informations" : "Information",
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.blue.shade50, // Fond légèrement coloré
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildInfoSection(
                      context,
                      icon: Icons.monetization_on,
                      titleFr: "Vos envois de colis à petits prix",
                      titleEn: "Your low-cost parcel shipments",
                      descriptionFr:
                          "C'est une application gratuite pour envoyer vos colis en utilisant le covoiturage, tout en réduisant l'empreinte écologique.",
                      descriptionEn:
                          "It's a free app to send your parcels at a low price using carpooling, while reducing your ecological footprint.",
                      languageProvider: languageProvider,
                    ),
                    _buildInfoSection(
                      context,
                      icon: Icons.directions_car,
                      titleFr: "Envoyez avec confiance",
                      titleEn: "Send with confidence",
                      descriptionFr:
                          "Nous vérifions les profils des bénévoles pour assurer une livraison en toute sécurité.",
                      descriptionEn:
                          "We verify volunteer profiles to ensure a secure delivery.",
                      languageProvider: languageProvider,
                    ),
                    _buildInfoSection(
                      context,
                      icon: Icons.phone_android,
                      titleFr: "Réservez facilement votre trajet",
                      titleEn: "Easily book your trip",
                      descriptionFr:
                          "Réservez un envoi rapide et abordable grâce à notre interface conviviale.",
                      descriptionEn:
                          "Book a quick and affordable delivery through our user-friendly interface.",
                      languageProvider: languageProvider,
                    ),
                  ],
                ),
              ),
            ),
            // Ajout du SVG en bas de la page avec animation de défilement
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SlideTransition(
                position: _offsetAnimation,
                child: SvgPicture.asset(
                  'assets/undraw_delivery-truck_mjui.svg',
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required IconData icon,
    required String titleFr,
    required String titleEn,
    required String descriptionFr,
    required String descriptionEn,
    required LanguageProvider languageProvider,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: Colors.blue),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageProvider.selectedLanguage == 'fr' ? titleFr : titleEn,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    languageProvider.selectedLanguage == 'fr' ? descriptionFr : descriptionEn,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
