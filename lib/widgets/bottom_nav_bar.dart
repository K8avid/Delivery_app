// import 'package:flutter/material.dart';

// class BottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;

//   const BottomNavBar({super.key, 
//     required this.selectedIndex,
//     required this.onItemTapped,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: selectedIndex,
//       onTap: onItemTapped,
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: Colors.blue,
//       unselectedItemColor: Colors.grey,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.inventory),
//           label: 'Colis',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.route),
//           label: 'Trajets',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.notifications),
//           label: 'Notifications',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Profil',
//         ),
//       ],
//     );
//   }
// }



// import 'package:flutter/material.dart';

// class BottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final ValueChanged<int> onItemTapped;
//   final List<String> labels;

//   const BottomNavBar({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//     required this.labels,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: selectedIndex,
//       onTap: onItemTapped,
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: Colors.blue[800], // Couleur de fond
//       selectedItemColor: Colors.white, // Couleur de l'élément actif
//       unselectedItemColor: Colors.blue[200], // Couleur des éléments inactifs
//       showSelectedLabels: true,
//       showUnselectedLabels: true,
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.inbox),
//           label: labels[0], // Label localisé pour "Parcels"
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.directions_car),
//           label: labels[1], // Label localisé pour "Trips"
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.notifications),
//           label: labels[2], // Label localisé pour "Notifications"
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: labels[3], // Label localisé pour "Profile"
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<String> labels;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.transparent, // Transparence gérée par le container parent
        elevation: 0, // Pas d'ombre supplémentaire
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.inbox),
            label: labels[0], // Label localisé pour "Parcels"
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_car),
            label: labels[1], // Label localisé pour "Trips"
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: labels[2], // Label localisé pour "Notifications"
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: labels[3], // Label localisé pour "Profile"
          ),
        ],
      ),
    );
  }
}
