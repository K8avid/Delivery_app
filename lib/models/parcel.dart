// class Parcel {
//   final String description;
//   final double weight;
//   final double length;
//   final double width;
//   final double height;
//   final String senderAddress;
//   final String recipientAddress;
//   final String parcelNumber;
//   final String currentStatus;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   Parcel({
//     required this.description,
//     required this.weight,
//     required this.length,
//     required this.width,
//     required this.height,
//     required this.senderAddress,
//     required this.recipientAddress,
//     required this.parcelNumber,
//     required this.currentStatus,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   // Convert JSON to Parcel
//   factory Parcel.fromJson(Map<String, dynamic> json) {
//     return Parcel(
//       description: json['description'],
//       weight: json['weight'],
//       length: json['length'],
//       width: json['width'],
//       height: json['height'],
//       senderAddress: json['senderAddress'],
//       recipientAddress: json['recipientAddress'],
//       parcelNumber: json['parcelNumber'],
//       currentStatus: json['currentStatus'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }

//   // Convert Parcel to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'description': description,
//       'weight': weight,
//       'length': length,
//       'width': width,
//       'height': height,
//       'senderAddress': senderAddress,
//       'recipientAddress': recipientAddress,
//       'parcelNumber': parcelNumber,
//       'currentStatus': currentStatus,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }




class Parcel {
  final String description;
  final double weight;
  final double length;
  final double width;
  final double height;
  final String senderAddress;
  final String recipientAddress;
  final String parcelNumber;
  final String currentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime expiracyDate;

  Parcel({
    required this.description,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.senderAddress,
    required this.recipientAddress,
    required this.parcelNumber,
    required this.currentStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.expiracyDate
  });

  // Convert JSON to Parcel
  factory Parcel.fromJson(Map<String, dynamic> json) {
    return Parcel(
      description: json['description'],
      weight: json['weight'],
      length: json['length'],
      width: json['width'],
      height: json['height'],
      senderAddress: json['senderAddress'],
      recipientAddress: json['recipientAddress'],
      parcelNumber: json['parcelNumber'],
      currentStatus: json['currentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      expiracyDate: DateTime.parse(json['expiracyDate']),
    );
  }

  // Convert Parcel to JSON
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'senderAddress': senderAddress,
      'recipientAddress': recipientAddress,
      'parcelNumber': parcelNumber,
      'currentStatus': currentStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'expiracyDate': expiracyDate.toIso8601String()
    };
  }
}
