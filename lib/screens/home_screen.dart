// import 'package:flutter/material.dart';
// import 'package:myapp/screens/trips/trips_screen.dart';
// import 'notifications/notifications_page.dart';
// import 'parcels/parcel_page.dart';
// import 'profile/profile_page.dart';
// import '../widgets/bottom_nav_bar.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   // Liste des pages
//   final List<Widget> _pages = [
//     ParcelPage(),
//     // TripsPage(),
//     TripsScreen(),
//     // MessageriePage(),
//     NotificationsPage(),
//     ProfileScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text("Home")),
//       body: _pages[_selectedIndex], // Affiche la page active
//       bottomNavigationBar: BottomNavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }














// import 'package:flutter/material.dart';
// import 'notifications/notifications_page.dart';
// import 'parcels/parcel_page.dart';
// import 'profile/profile_page.dart';
// import '../widgets/bottom_nav_bar.dart';
// import 'trips/trips_screen.dart';

// enum HomePage {
//   parcel,
//   trips,
//   notifications,
//   profile,
// }

// class HomeScreen extends StatefulWidget {
//   final HomePage initialPage;

//   const HomeScreen({super.key, this.initialPage = HomePage.parcel});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late HomePage _selectedPage;

//   @override
//   void initState() {
//     super.initState();
//     _selectedPage = widget.initialPage; // Initialisez la page active à partir de l'argument
//   }

//   final Map<HomePage, Widget> _pages = {
//     HomePage.parcel: ParcelPage(),
//     HomePage.trips: TripsScreen(),
//     HomePage.notifications: NotificationsPage(),
//     HomePage.profile: ProfileScreen(),
//   };

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedPage = HomePage.values[index];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedPage], // Affiche la page active
//       bottomNavigationBar: BottomNavBar(
//         selectedIndex: HomePage.values.indexOf(_selectedPage),
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import des traductions
import 'notifications/notifications_page.dart';
import 'parcels/parcel_page.dart';
import 'profile/profile_page.dart';
import '../widgets/bottom_nav_bar.dart';
import 'trips/trips_screen.dart';

enum HomePage {
  parcel,
  trips,
  notifications,
  profile,
}

class HomeScreen extends StatefulWidget {
  final HomePage initialPage;

  const HomeScreen({super.key, this.initialPage = HomePage.parcel});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomePage _selectedPage;

  @override
  void initState() {
    super.initState();
    _selectedPage = widget.initialPage;
  }

  final Map<HomePage, Widget> _pages = {
    HomePage.parcel: const ParcelPage(),
    HomePage.trips: const TripsScreen(),
    HomePage.notifications: const NotificationsPage(),
    HomePage.profile: const ProfilePage(),
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = HomePage.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage], // Affiche la page active
      bottomNavigationBar: BottomNavBar(
        selectedIndex: HomePage.values.indexOf(_selectedPage),
        onItemTapped: _onItemTapped,
        labels: [
          AppLocalizations.of(context)!.nav_parcels,
          AppLocalizations.of(context)!.nav_trips,
          AppLocalizations.of(context)!.nav_notifications,
          AppLocalizations.of(context)!.nav_profile,
        ],
      ),
    );
  }
}
