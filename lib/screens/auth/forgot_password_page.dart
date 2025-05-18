import 'package:flutter/material.dart';
import 'package:coligo/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:coligo/providers/language_provider.dart'; // Assurez-vous que LanguageProvider est importé

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController(); // Contrôleur pour l'email
  final AuthService authService = AuthService(); // Instance du service d'authentification

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
              languageProvider.selectedLanguage == 'fr' ? 'Mot de passe oublié' : 'Forgot Password',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          languageProvider.selectedLanguage == 'fr'
                              ? "Réinitialisez votre mot de passe"
                              : "Reset your password",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          languageProvider.selectedLanguage == 'fr'
                              ? "Entrez votre adresse email ci-dessous. Nous vous enverrons un lien pour réinitialiser votre mot de passe."
                              : "Enter your email address below. We will send you a link to reset your password.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 30),
                        // Champ de texte pour l'email
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: languageProvider.selectedLanguage == 'fr' ? 'Adresse Email' : 'Email Address',
                            prefixIcon: const Icon(Icons.email, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Boutons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  String email = emailController.text;

                                  if (email.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          languageProvider.selectedLanguage == 'fr'
                                              ? 'Veuillez entrer un email valide.'
                                              : 'Please enter a valid email.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  // Appeler la méthode forgotPassword du service
                                  bool success = await authService.forgotPassword(email);

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          languageProvider.selectedLanguage == 'fr'
                                              ? 'Un email a été envoyé pour réinitialiser votre mot de passe.'
                                              : 'An email has been sent to reset your password.',
                                        ),
                                      ),
                                    );
                                    Navigator.pop(context); // Retourner à la page précédente
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          languageProvider.selectedLanguage == 'fr'
                                              ? 'Échec de l\'envoi. Vérifiez l\'email saisi.'
                                              : 'Failed to send. Check the email entered.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  languageProvider.selectedLanguage == 'fr' ? 'Envoyer' : 'Send',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context); // Retour à la page précédente
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  side: const BorderSide(color: Colors.blue),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  languageProvider.selectedLanguage == 'fr' ? 'Annuler' : 'Cancel',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
