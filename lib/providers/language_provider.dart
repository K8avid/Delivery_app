import 'package:flutter/material.dart';

// class LanguageProvider with ChangeNotifier {
//   // Langue par défaut
//   String _selectedLanguage = 'fr'; 

//   // Getter pour accéder à la langue sélectionnée
//   String get selectedLanguage => _selectedLanguage;

//   // Méthode pour vérifier si la langue est le français
//   bool get isFrench => _selectedLanguage == 'fr';

//   // Changer la langue
//   void changeLanguage(String languageCode) {
//     _selectedLanguage = languageCode;
//     notifyListeners(); // Avertir les widgets abonnés que la langue a changé
//   }

//   // Retourne la Locale pour la langue sélectionnée
//   Locale get locale {
//     switch (_selectedLanguage) {
//       case 'en':
//         return Locale('en', '');
//       case 'fr':
//       default:
//         return Locale('fr', '');
//     }
//   }
// }



class LanguageProvider with ChangeNotifier {
  // Langue par défaut
  String _selectedLanguage = 'fr'; 

  // Getter pour accéder à la langue sélectionnée
  String get selectedLanguage => _selectedLanguage;

  // Méthode pour vérifier si la langue est le français
  bool get isFrench => _selectedLanguage == 'fr';

  // Changer la langue
  void changeLanguage(String languageCode) {
    _selectedLanguage = languageCode;
    notifyListeners(); // Avertir les widgets abonnés que la langue a changé
  }

  // Retourne la Locale pour la langue sélectionnée
  Locale get locale {
    switch (_selectedLanguage) {
      case 'en':
        return const Locale('en', '');
      case 'fr':
      default:
        return const Locale('fr', '');
    }
  }
}
