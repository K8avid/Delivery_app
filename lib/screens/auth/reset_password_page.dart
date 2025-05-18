// import 'package:flutter/material.dart';
// import 'package:coligo/services/auth_service.dart';
// import 'package:provider/provider.dart'; // Pour utiliser le Consumer
// import 'package:coligo/providers/language_provider.dart'; // Assurez-vous que LanguageProvider est importé

// class ResetPasswordPage extends StatefulWidget {
//   final String token; // Le token de réinitialisation

//   const ResetPasswordPage({Key? key, required this.token}) : super(key: key);

//   @override
//   _ResetPasswordPageState createState() => _ResetPasswordPageState();
// }

// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//   final TextEditingController newPasswordController = TextEditingController(); // Contrôleur pour le mot de passe
//   final AuthService authService = AuthService(); // Instance du service d'authentification

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LanguageProvider>(
//       builder: (context, languageProvider, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text(
//               languageProvider.selectedLanguage == 'fr' ? 'Réinitialiser le mot de passe' : 'Reset Password',
//             ),
//             backgroundColor: Colors.blue,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   languageProvider.selectedLanguage == 'fr'
//                       ? "Entrez votre nouveau mot de passe :"
//                       : "Enter your new password:",
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 10),
//                 // Champ pour saisir le nouveau mot de passe
//                 TextField(
//                   controller: newPasswordController,
//                   obscureText: true, // Masquer le texte pour la sécurité
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     hintText: languageProvider.selectedLanguage == 'fr' ? 'Nouveau mot de passe' : 'New password',
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Bouton pour soumettre le nouveau mot de passe
//                 ElevatedButton(
//                   onPressed: () async {
//                     String newPassword = newPasswordController.text;

//                     if (newPassword.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             languageProvider.selectedLanguage == 'fr'
//                                 ? 'Veuillez entrer un mot de passe.'
//                                 : 'Please enter a password.',
//                           ),
//                         ),
//                       );
//                       return;
//                     }

//                     // Appeler le service pour réinitialiser le mot de passe
//                     bool success = await authService.resetPassword(newPassword);

//                     if (success) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             languageProvider.selectedLanguage == 'fr'
//                                 ? 'Mot de passe réinitialisé avec succès.'
//                                 : 'Password successfully reset.',
//                           ),
//                         ),
//                       );
//                       Navigator.pop(context); // Retourner à la page de connexion
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             languageProvider.selectedLanguage == 'fr'
//                                 ? 'Échec de la réinitialisation. Veuillez réessayer.'
//                                 : 'Failed to reset. Please try again.',
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                   ),
//                   child: Text(
//                     languageProvider.selectedLanguage == 'fr' ? 'Enregistrer' : 'Save',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }









import 'package:flutter/material.dart';
import 'package:coligo/services/auth_service.dart';
import 'package:provider/provider.dart'; // Pour utiliser le Consumer
import 'package:coligo/providers/language_provider.dart'; // Assurez-vous que LanguageProvider est importé

class ResetPasswordPage extends StatefulWidget {
  final String token; // Le token de réinitialisation

  const ResetPasswordPage({super.key, required this.token});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController(); // Contrôleur pour le mot de passe
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
            centerTitle: true, // Centrer le titre
            title: Text(
              languageProvider.selectedLanguage == 'fr'
                  ? 'Réinitialiser le mot de passe'
                  : 'Reset Password',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageProvider.selectedLanguage == 'fr'
                      ? "Entrez votre nouveau mot de passe :"
                      : "Enter your new password:",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                // Champ pour saisir le nouveau mot de passe
                TextField(
                  controller: newPasswordController,
                  obscureText: true, // Masquer le texte pour la sécurité
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: languageProvider.selectedLanguage == 'fr'
                        ? 'Nouveau mot de passe'
                        : 'New password',
                  ),
                ),
                const SizedBox(height: 20),
                // Bouton pour soumettre le nouveau mot de passe
                ElevatedButton(
                  onPressed: () async {
                    String newPassword = newPasswordController.text;

                    if (newPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            languageProvider.selectedLanguage == 'fr'
                                ? 'Veuillez entrer un mot de passe.'
                                : 'Please enter a password.',
                          ),
                        ),
                      );
                      return;
                    }

                    // Appeler le service pour réinitialiser le mot de passe
                    bool success = await authService.resetPassword(newPassword);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            languageProvider.selectedLanguage == 'fr'
                                ? 'Mot de passe réinitialisé avec succès.'
                                : 'Password successfully reset.',
                          ),
                        ),
                      );
                      Navigator.pop(context); // Retourner à la page de connexion
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            languageProvider.selectedLanguage == 'fr'
                                ? 'Échec de la réinitialisation. Veuillez réessayer.'
                                : 'Failed to reset. Please try again.',
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
                    languageProvider.selectedLanguage == 'fr' ? 'Enregistrer' : 'Save',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
