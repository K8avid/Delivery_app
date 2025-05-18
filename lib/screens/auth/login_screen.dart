// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'register_screen.dart';
// import '../../services/auth_service.dart';
// import '../home_screen.dart';
// import 'reset_password_page.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final AuthService _authService = AuthService();

//   late AnimationController _animationController;
//   late Animation<Offset> _snackbarAnimation;
//   bool _isSnackbarVisible = false;
//   String _snackbarMessage = '';
//   Color _snackbarColor = Colors.blue;

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300), // Animation rapide
//       vsync: this,
//     );
//     _snackbarAnimation =
//         Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0.1))
//             .animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOutBack, // Courbe dynamique
//     ));
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _showAnimatedSnackbar(String message, {Color backgroundColor = Colors.blue}) {
//     setState(() {
//       _snackbarMessage = message; // Définit le message de la snackbar
//       _snackbarColor = backgroundColor; // Définit la couleur de fond
//       _isSnackbarVisible = true; // Active la visibilité
//     });

//     _animationController.forward(); // Démarre l'animation

//     Future.delayed(const Duration(seconds: 3), () {
//       _animationController.reverse().then((_) {
//         setState(() {
//           _isSnackbarVisible = false; // Désactive la visibilité après l'animation
//         });
//       });
//     });
//   }

//   void _login() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//         _showAnimatedSnackbar(
//           "Please fill all fields.",
//           backgroundColor: Colors.orange,
//         );
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       final token = await _authService.login(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//       );
//       print("Login successful! Token: $token");

//       _showAnimatedSnackbar(
//         'Login successful! Redirecting...',
//         backgroundColor: Colors.green,
//       );

//       // Naviguer vers la HomeScreen après un délai
//       Future.delayed(const Duration(seconds: 1), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       });
//     } catch (e) {
//       _showAnimatedSnackbar(
//         "Error: ${e.toString()}",
//         backgroundColor: Colors.red,
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Widget _buildCustomInputField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     bool obscureText = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 12),
//             child: Icon(icon, color: Colors.blue),
//           ),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               obscureText: obscureText,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: hintText,
//                 hintStyle: const TextStyle(color: Colors.grey),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // SVG Illustration
//                     SvgPicture.asset(
//                       'assets/login.svg', // Assurez-vous que ce fichier SVG est dans le dossier assets
//                       height: 150,
//                       fit: BoxFit.contain,
//                     ),
//                     const SizedBox(height: 32),

//                     // Title
//                     const Text(
//                       "Login",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blueAccent,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Please login to continue.",
//                       style: TextStyle(fontSize: 16, color: Colors.black54),
//                     ),
//                     const SizedBox(height: 32),

//                     // Email Input
//                     _buildCustomInputField(
//                       controller: _emailController,
//                       hintText: "Enter your email",
//                       icon: Icons.email_outlined,
//                     ),
//                     const SizedBox(height: 16),

//                     // Password Input
//                     _buildCustomInputField(
//                       controller: _passwordController,
//                       hintText: "Enter your password",
//                       icon: Icons.lock_outline,
//                       obscureText: true,
//                     ),
//                     const SizedBox(height: 32),

//                     // Login Button
//                     _isLoading
//                         ? const CircularProgressIndicator()
//                         : ElevatedButton(
//                             onPressed: _login,
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 15),
//                               minimumSize: const Size(double.infinity, 50),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               elevation: 5,
//                               backgroundColor: Colors.blue, // Bouton moderne
//                             ),
//                             child: const Text(
//                               "Login",
//                               style: TextStyle(fontSize: 18, color: Colors.white),
//                             ),
//                           ),
//                     const SizedBox(height: 16),

//                     // Reset Password Link
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>  ResetPasswordPage(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "Forgot your password?",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 32),

//                     // Footer (Sign Up Link)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Don't have an account? "),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const RegisterScreen(),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Snackbar Animé
//             if (_isSnackbarVisible)
//               SlideTransition(
//                 position: _snackbarAnimation,
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: _snackbarColor,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.info, color: Colors.white),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _snackbarMessage,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'register_screen.dart';
import '../../services/auth_service.dart';
import '../home_screen.dart';
import 'reset_password_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  late AnimationController _animationController;
  late Animation<Offset> _snackbarAnimation;
  bool _isSnackbarVisible = false;
  String _snackbarMessage = '';
  Color _snackbarColor = Colors.blue;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _snackbarAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0.1))
            .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutBack,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showAnimatedSnackbar(String message, {Color backgroundColor = Colors.blue}) {
    setState(() {
      _snackbarMessage = message;
      _snackbarColor = backgroundColor;
      _isSnackbarVisible = true;
    });

    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      _animationController.reverse().then((_) {
        setState(() {
          _isSnackbarVisible = false;
        });
      });
    });
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        _showAnimatedSnackbar(
          AppLocalizations.of(context)!.fill_all_fields,
          backgroundColor: Colors.orange,
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final token = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      print("Login successful! Token: $token");

      _showAnimatedSnackbar(
        AppLocalizations.of(context)!.login_successful,
        backgroundColor: Colors.green,
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    } catch (e) {
      _showAnimatedSnackbar(
        AppLocalizations.of(context)!.login_error(

              e.toString(),
            ),
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildCustomInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(icon, color: Colors.blue),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/login.svg',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)!.login_title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.login_subtitle,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 32),
                    _buildCustomInputField(
                      controller: _emailController,
                      hintText: AppLocalizations.of(context)!.email_hint,
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildCustomInputField(
                      controller: _passwordController,
                      hintText: AppLocalizations.of(context)!.password_hint,
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 32),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              backgroundColor: Colors.blue,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.login_button,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      
                      onTap: () async {
                        String? token = await _authService.getToken(); // Récupérer le token depuis AuthService ou storage

                        if (token != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordPage(token: token), // ✅ Passer le token
                            ),
                          );
                        } else {
                          _showAnimatedSnackbar(
                            AppLocalizations.of(context)!.token_not_found,
                            backgroundColor: Colors.red,
                          );
                        }
                      },

                      child: Text(
                        AppLocalizations.of(context)!.forgot_password,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.no_account),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.sign_up,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isSnackbarVisible)
              SlideTransition(
                position: _snackbarAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _snackbarColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _snackbarMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}







