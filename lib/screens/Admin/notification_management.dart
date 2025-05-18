// import 'package:flutter/material.dart';
// import 'package:coligo/services/admin_service.dart';

// class NotificationManagementPage extends StatelessWidget {
//   final Future<List<dynamic>> notifications = AdminService().getNotifications();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gestion des Notifications'),
//       ),
//       body: FutureBuilder<List<dynamic>>(
//         future: notifications,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Erreur: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return Center(child: Text('Aucune notification disponible.'));
//           }

//           var notificationsList = snapshot.data!;
//           return ListView.builder(
//             itemCount: notificationsList.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text('Notification ${notificationsList[index]['id']}'),
//                 subtitle: Text(notificationsList[index]['message']),
//                 trailing: IconButton(
//                   icon: Icon(Icons.check),
//                   onPressed: () {
//                     AdminService().markNotificationAsRead(notificationsList[index]['id']);
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
