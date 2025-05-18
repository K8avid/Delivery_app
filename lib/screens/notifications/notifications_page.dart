
// import 'package:flutter/material.dart';
// import '../../models/notification.dart';
// import '../../services/notification_service.dart';


// class NotificationsPage extends StatefulWidget {
//   const NotificationsPage({super.key});

//   @override
//   _NotificationsPageState createState() => _NotificationsPageState();
// }

// class _NotificationsPageState extends State<NotificationsPage> {
//   late Future<List<NotificationModel>> _notificationsFuture;

//   @override
//   void initState() {
//     super.initState();
//     // Charge les notifications via le service
//     _notificationsFuture = NotificationService.fetchNotifications();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Notifications')),
//       body: FutureBuilder<List<NotificationModel>>(
//         future: _notificationsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Erreur: ${snapshot.error}'),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('Aucune notification disponible.'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final notification = snapshot.data![index];
//                 return NotificationCard(notification: notification);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class NotificationCard extends StatelessWidget {
//   final NotificationModel notification;

//   const NotificationCard({super.key, required this.notification});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       child: ListTile(
//         leading: Icon(
//           notification.isRead ? Icons.notifications : Icons.notifications_active,
//           color: notification.isRead ? Colors.grey : Colors.blue,
//         ),
//         title: Text(
//           notification.title,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: notification.isRead ? Colors.grey : Colors.black,
//           ),
//         ),
//         subtitle: Text(notification.message),
//         trailing: Text(
//           _formatDate(notification.createdAt),
//           style: const TextStyle(fontSize: 12.0, color: Colors.grey),
//         ),
//         onTap: () {
//           // Affiche une boîte de dialogue avec les détails de la notification
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text(notification.title),
//               content: Text(notification.message),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Fermer'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
//   }
// }







import 'package:flutter/material.dart';
import '../../models/notification.dart';
import '../../services/notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    // Charger les notifications via le service
    _notificationsFuture = NotificationService.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur : ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aucune notification disponible.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data![index];
                return NotificationCard(notification: notification);
              },
            );
          }
        },
      ),
    );
  }
}


class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: notification.isRead ? Colors.grey.shade200 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              notification.isRead ? Icons.notifications : Icons.notifications_active,
              color: notification.isRead ? Colors.grey.shade600 : Colors.blue.shade600,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: notification.isRead ? Colors.grey.shade800 : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(notification.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
