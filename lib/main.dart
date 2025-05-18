import 'package:coligo/screens/Admin/Admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'providers/language_provider.dart';
import 'screens/home_screen.dart';
import 'screens/landing_page.dart';
import 'services/auth_service.dart';
import 'themes/app_theme.dart';


// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import généré par flutter gen-l10n
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'fr_FR'; // Changez selon vos besoins (par ex. : en_US)
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, provider, child) {
          
          return MaterialApp(
            title: 'Home',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme, // Utilisation du thème clair
            darkTheme: AppTheme.darkTheme, // Utilisation du thème sombre
            themeMode: ThemeMode.light, // Définit le mode par défaut (light, dark 

            locale: provider.locale,
            supportedLocales: AppLocalizations.supportedLocales, // Langues supportées
            localizationsDelegates: const [
              AppLocalizations.delegate, // Délégation des traductions
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            home: const AuthWrapper(), // Vérifie l'état d'authentification
          );


        },
      ),
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Simulez une vérification d'authentification
//     final bool isAuthenticated = AuthService.isUserAuthenticated();

//     // Si l'utilisateur est authentifié, afficher HomeScreen
//     if (isAuthenticated) {
//       return HomeScreen();
//     } else {
//       // Sinon, afficher LoginScreen
//       return LoginScreen();
//     }
//   }
// }






 class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isAuthenticated = false;  // Variable pour l'état d'authentification

  @override
  void initState() {
    super.initState();
    _checkAuthentication();  // Vérifie l'authentification au démarrage
  }

  // Fonction pour vérifier si l'utilisateur est authentifié
  Future<void> _checkAuthentication() async {
    final authService = AuthService();
    bool authenticated = await authService.isUserAuthenticated();
    setState(() {
      isAuthenticated = authenticated;  // Mettez à jour l'état avec la valeur d'authentification
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return FutureBuilder<bool>(
      future: authService.isUserAuthenticated(),  // Vérifie l'authentification
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authSnapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Erreur: ${authSnapshot.error}')),
          );
        }

        if (authSnapshot.data == true) {
          // Vérifie si l'utilisateur est administrateur
          return FutureBuilder<bool>(
            future: authService.isAdmin(),
            builder: (context, adminSnapshot) {
              if (adminSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (adminSnapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Erreur de rôle: ${adminSnapshot.error}')),
                );
              }

              return adminSnapshot.data == true
                  ? AdminDashboard() // Si l'utilisateur est admin
                  : const HomeScreen(); // Sinon, afficher la page d'accueil
            },
          );
        } else {
          return const LandingPage(); // Si l'utilisateur n'est pas authentifié
        }
      },
    );
  }
}
