// import 'package:flutter/material.dart';

// class AnimatedSnackbar extends StatefulWidget {
//   final String message;
//   final Color backgroundColor;
//   final Duration duration;

//   const AnimatedSnackbar({
//     Key? key,
//     required this.message,
//     this.backgroundColor = Colors.blue,
//     this.duration = const Duration(seconds: 3),
//   }) : super(key: key);

//   @override
//   _AnimatedSnackbarState createState() => _AnimatedSnackbarState();
// }

// class _AnimatedSnackbarState extends State<AnimatedSnackbar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<Offset> _snackbarAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _snackbarAnimation =
//         Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0.1))
//             .animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOutBack,
//     ));

//     // Start the animation
//     _animationController.forward();

//     // Dismiss the snackbar after the duration
//     Future.delayed(widget.duration, () {
//       if (mounted) {
//         _animationController.reverse().then((_) {
//           if (mounted) Navigator.of(context).pop();
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       position: _snackbarAnimation,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: widget.backgroundColor,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.info, color: Colors.white),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 widget.message,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }












import 'package:flutter/material.dart';

class AnimatedSnackbar extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Duration duration;

  const AnimatedSnackbar({
    super.key,
    required this.message,
    this.backgroundColor = Colors.blue,
    this.duration = const Duration(seconds: 3),
  });

  @override
  _AnimatedSnackbarState createState() => _AnimatedSnackbarState();
}

class _AnimatedSnackbarState extends State<AnimatedSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _snackbarAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // Animation rapide
      vsync: this,
    );

    _snackbarAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0.05))
            .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic, // Courbe pour des transitions douces
    ));

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // Apparaît
    await _animationController.forward();
    // Attend la durée spécifiée
    await Future.delayed(widget.duration);
    // Disparaît
    if (mounted) {
      await _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _snackbarAnimation,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // Limite de largeur
          margin: const EdgeInsets.only(top: 20), // Position légèrement plus haut
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.backgroundColor, // Couleur pleine, pas transparente
            borderRadius: BorderRadius.circular(16), // Coins arrondis
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
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
