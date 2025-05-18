import 'parcel.dart';
import 'trip.dart';

class Delivery {
  final String deliveryNumber;
  final Parcel parcel;
  final Trip trip;
  final String status;
  final String qrToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  Delivery({
    required this.deliveryNumber,
    required this.parcel,
    required this.trip,
    required this.status,
    required this.qrToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      deliveryNumber: json['deliveryNumber'],
      parcel: Parcel.fromJson(json['parcel']),
      trip: Trip.fromJson(json['trip']),
      status: json['status'],
      qrToken: json['qrToken'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}