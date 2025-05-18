import 'location.dart';

class Trip {
  final String tripNumber;
  final Location startLocation;
  final Location endLocation;
  final String departureTime;
  final double distance;
  final int duration;
  final String polyline;
  final String status;
  final String createdAt;
  final String updatedAt;

  Trip({
    required this.tripNumber,
    required this.startLocation,
    required this.endLocation,
    required this.departureTime,
    required this.distance,
    required this.duration,
    required this.polyline,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripNumber: json['tripNumber'],
      startLocation: Location.fromJson(json['startLocation']),
      endLocation: Location.fromJson(json['endLocation']),
      departureTime: json['departureTime'],
      distance: json['distance'],
      duration: json['duration'],
      polyline: json['polyline'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}