// class Notification {
//   final int id;
//   final String title;
//   final String message;
//   final bool isRead;
//   final DateTime createdAt;

//   Notification({
//     required this.id,
//     required this.title,
//     required this.message,
//     required this.isRead,
//     required this.createdAt,
//   });

//   // Factory pour convertir un objet JSON en instance de NotificationResponseDTO
//   factory Notification.fromJson(Map<String, dynamic> json) {
//     return Notification(
//       id: json['id'],
//       title: json['title'],
//       message: json['message'],
//       isRead: json['isRead'],
//       createdAt: DateTime.parse(json['createdAt']),
//     );
//   }
// }




// class NotificationModel {
//   final int id;
//   final String title;
//   final String message;
//   final bool isRead;
//   final DateTime createdAt;

//   NotificationModel({
//     required this.id,
//     required this.title,
//     required this.message,
//     required this.isRead,
//     required this.createdAt,
//   });

//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     return NotificationModel(
//       id: json['id'],
//       title: json['title'],
//       message: json['message'],
//       isRead: json['isRead'],
//       createdAt: DateTime.parse(json['createdAt']),
//     );
//   }
// }




class NotificationModel {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
