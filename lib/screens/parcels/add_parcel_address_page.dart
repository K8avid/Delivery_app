// //works perfect
// import 'package:flutter/material.dart';
// import '../../services/parcel_service.dart';
// // import '../trips/success_page.dart';
// import 'address_selection_page.dart';
// import 'failure_page.dart';
// import 'parcel_search_results_page.dart';
// import 'success_page.dart';

// class AddParcelAddressPage extends StatefulWidget {
//   final Map<String, dynamic> parcelInfo;

//   const AddParcelAddressPage({super.key, required this.parcelInfo});

//   @override
//   _AddParcelAddressPageState createState() => _AddParcelAddressPageState();
// }

// class _AddParcelAddressPageState extends State<AddParcelAddressPage> {
//   String? senderAddress;
//   String? recipientAddress;
//   DateTime? expiracyDate;

//   Future<void> _selectDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 30)),
//     );
//     if (picked != null) {
//       setState(() {
//         expiracyDate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//         title: const Text(
//           'Adresse et Date',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Colors.grey.shade200],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             children: [
//               // Adresse de l'expéditeur
//               _buildInteractiveCard(
//                 icon: Icons.person_pin_circle_outlined,
//                 title: "Adresse de l'expéditeur",
//                 value: senderAddress,
//                 onTap: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AddressSelectionPage(
//                         title: "Adresse de l'expéditeur",
//                         onAddressSelected: (address) {
//                           setState(() {
//                             senderAddress = address;
//                           });
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),

//               // Adresse du destinataire
//               _buildInteractiveCard(
//                 icon: Icons.location_on_outlined,
//                 title: "Adresse du destinataire",
//                 value: recipientAddress,
//                 onTap: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AddressSelectionPage(
//                         title: "Adresse du destinataire",
//                         onAddressSelected: (address) {
//                           setState(() {
//                             recipientAddress = address;
//                           });
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),

//               // Date de livraison
//               _buildInteractiveCard(
//                 icon: Icons.calendar_today_outlined,
//                 title: "Date limite d'envoi du colis",
//                 value: expiracyDate != null
//                     ? '${expiracyDate!.day}/${expiracyDate!.month}/${expiracyDate!.year}'
//                     : null,
//                 onTap: _selectDate,
//               ),
//               const Spacer(),

//               // Bouton Rechercher
//               ElevatedButton(
//                 onPressed: () {
//                   if (senderAddress != null &&
//                       recipientAddress != null &&
//                       expiracyDate != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ParcelSearchResultsPage(
//                             parcelInfo: {
//                               ...widget.parcelInfo,
//                               'senderAddress': senderAddress,
//                               'recipientAddress': recipientAddress,
//                               'expiracyDate': expiracyDate?.toIso8601String(),

//                             },
//                           ),

//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Veuillez remplir tous les champs')),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: const Text(
//                   'Rechercher',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // Bouton Ne pas rechercher
//               ElevatedButton(
//                   onPressed: () async { //debut onPressed()

//                     try {

//                       final response = await ParcelService.createParcel_sans_delivery({
//                         ...widget.parcelInfo,
//                         'senderAddress': senderAddress,
//                         'recipientAddress': recipientAddress,
//                         'expiracyDate': expiracyDate?.toIso8601String(),
//                       });
                      
//                       if (response.statusCode == 200) {

//                         // Si le statut HTTP est 200, rediriger vers SuccessPage
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => SuccessPage()),
//                         );
//                       } else {

//                         // Sinon, rediriger vers FailurePage
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => FailurePage()),
//                         );
//                       }
//                     } catch (e) {
//                       // Gestion des erreurs réseau ou autres exceptions
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => FailurePage()),
//                       );
//                     }
//                   },
//  //==============fin onPressed

//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: const Text(
//                   'Ne pas rechercher',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInteractiveCard({
//     required IconData icon,
//     required String title,
//     String? value,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               blurRadius: 8,
//               spreadRadius: 4,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.blue.withOpacity(0.1),
//               child: Icon(icon, color: Colors.blue, size: 28),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 value ?? title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: value == null ? Colors.grey : Colors.black,
//                 ),
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 18),
//           ],
//         ),
//       ),
//     );
//   }
// }












import 'package:flutter/material.dart';
import '../../services/parcel_service.dart';
import 'address_selection_page.dart';
import 'failure_page.dart';
import 'parcel_search_results_page.dart';
import 'success_page.dart';

class AddParcelAddressPage extends StatefulWidget {
  final Map<String, dynamic> parcelInfo;

  const AddParcelAddressPage({super.key, required this.parcelInfo});

  @override
  _AddParcelAddressPageState createState() => _AddParcelAddressPageState();
}

class _AddParcelAddressPageState extends State<AddParcelAddressPage> {
  String? senderAddress;
  String? recipientAddress;
  DateTime? expiracyDate;

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    setState(() {
      expiracyDate = picked;
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          'Adresse et Date',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Adresse de l'expéditeur
              _buildInteractiveCard(
                icon: Icons.person_pin_circle_outlined,
                title: "Adresse de l'expéditeur",
                value: senderAddress,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressSelectionPage(
                        title: "Adresse de l'expéditeur",
                        onAddressSelected: (address) {
                          setState(() {
                            senderAddress = address;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Adresse du destinataire
              _buildInteractiveCard(
                icon: Icons.location_on_outlined,
                title: "Adresse du destinataire",
                value: recipientAddress,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressSelectionPage(
                        title: "Adresse du destinataire",
                        onAddressSelected: (address) {
                          setState(() {
                            recipientAddress = address;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Date de livraison
              _buildInteractiveCard(
                icon: Icons.calendar_today_outlined,
                title: "Date limite d'envoi du colis",
                value: expiracyDate != null
                    ? '${expiracyDate!.day}/${expiracyDate!.month}/${expiracyDate!.year}'
                    : null,
                onTap: _selectDate,
              ),
              const Spacer(),

              // Boutons en bas
              Row(
                children: [
                  // Bouton "Trouver un trajet maintenant"
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (senderAddress != null &&
                            recipientAddress != null &&
                            expiracyDate != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ParcelSearchResultsPage(
                                parcelInfo: {
                                  ...widget.parcelInfo,
                                  'senderAddress': senderAddress,
                                  'recipientAddress': recipientAddress,
                                  'expiracyDate': expiracyDate?.toIso8601String(),
                                },
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Veuillez remplir tous les champs')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Couleur bleue pour "maintenant"
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.blue.withOpacity(0.4),
                        elevation: 8,
                      ),
                      child: const Text(
                        'Trouver maintenant',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Espacement entre les boutons

                  // Bouton "Trouver un trajet plus tard"
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final response = await ParcelService.createParcel_sans_delivery({
                            ...widget.parcelInfo,
                            'senderAddress': senderAddress,
                            'recipientAddress': recipientAddress,
                            'expiracyDate': expiracyDate?.toIso8601String(),
                          });

                          if (response.statusCode == 200) {
                            // Si le statut HTTP est 200, rediriger vers SuccessPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SuccessPage()),
                            );
                          } else {
                            // Sinon, rediriger vers FailurePage
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FailurePage()),
                            );
                          }
                        } catch (e) {
                          // Gestion des erreurs réseau ou autres exceptions
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FailurePage()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Couleur orange pour "plus tard"
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.orange.withOpacity(0.4),
                        elevation: 8,
                      ),
                      child: const Text(
                        'Trouver plus tard',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveCard({
    required IconData icon,
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(icon, color: Colors.blue, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value ?? title,
                style: TextStyle(
                  fontSize: 16,
                  color: value == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }
}
