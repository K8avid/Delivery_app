import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/delivery.dart';
import '../../services/delivery_service.dart';
import 'fastest_route_details.dart';
import 'map_preview_page.dart';

class ParcelDetailsPage extends StatelessWidget {
  final String parcelNumber;
  final bool isSender;

  const ParcelDetailsPage({
    super.key,
    required this.parcelNumber,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Détails du Colis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Delivery>(
        future: DeliveryService.fetchDeliveryDetails(parcelNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Aucun détail trouvé pour ce colis'));
          }

          final delivery = snapshot.data!;
          final parcel = delivery.parcel;
          final trip = delivery.trip;

          return Container(
            color: Colors.grey.shade100,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildQRCodeSection(context, delivery.qrToken),
                  const SizedBox(height: 16),
                  // Bouton placé juste après le QR code
                 Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              // Récupérer l'adresse de l'utilisateur en fonction de isSender
                              final String userAddress = isSender ? parcel.senderAddress : parcel.recipientAddress;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FastestRouteDetails(
                                    isSender: isSender,
                                    trip: trip,
                                    userAddress: userAddress,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              isSender ? "Vers véhicule" : "Vers retrait",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),

                  const SizedBox(height: 16),
                  _buildSection(
                    title: "Informations sur le Colis",
                    content: _buildParcelDetails(parcel),
                  ),
                  _buildSection(
                    title: "Détails du Trajet",
                    content: _buildTripDetails(context, trip),
                  ),
                  _buildSection(
                    title: "Statut de la Livraison",
                    content: _buildTimeline(delivery.status),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQRCodeSection(BuildContext context, String qrToken) {
    return GestureDetector(
      onTap: () {
        _showQRDialog(context, qrToken);
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        child: QrImageView(
          data: qrToken,
          version: QrVersions.auto,
          size: 150,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  void _showQRDialog(BuildContext context, String qrToken) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: qrToken,
                  version: QrVersions.auto,
                  size: 300,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              Divider(color: Colors.grey.shade300, thickness: 1, height: 24),
              content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParcelDetails(parcel) {
    return Column(
      children: [
        _buildDetailRow(Icons.description, "Description", parcel.description),
        _buildDetailRow(Icons.monitor_weight, "Poids", "${parcel.weight} kg"),
        _buildDetailRow(Icons.straighten, "Dimensions",
            "${parcel.length} x ${parcel.width} x ${parcel.height} cm"),
        const SizedBox(height: 16),
        Row(
          children: [
            const Column(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: Colors.blue,
                ),
                SizedBox(height: 4),
                Icon(
                  Icons.place,
                  size: 16,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parcel.senderAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    parcel.recipientAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade800, size: 24),
          const SizedBox(width: 12),
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetails(BuildContext context, trip) {
    final departureTime = DateTime.parse(trip.departureTime);
    final formattedDateTime =
        "${departureTime.day.toString().padLeft(2, '0')}/${departureTime.month.toString().padLeft(2, '0')}/${departureTime.year} - ${departureTime.hour}:${departureTime.minute.toString().padLeft(2, '0')}";
    final formattedDistance = trip.distance.toStringAsFixed(1);
    final int hours = trip.duration ~/ 60;
    final int minutes = trip.duration % 60;
    final formattedDuration = "${hours > 0 ? '$hours h ' : ''}${minutes > 0 ? '$minutes min' : ''}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildAlignedDetailRow(
          icon: Icons.directions_car,
          label: "Numéro de Trajet",
          value: trip.tripNumber,
        ),
        _buildAlignedDetailRow(
          icon: Icons.schedule,
          label: "Date et Heure de Départ",
          value: formattedDateTime,
        ),
        _buildAlignedDetailRow(
          icon: Icons.map,
          label: "Distance",
          value: "$formattedDistance km",
        ),
        _buildAlignedDetailRow(
          icon: Icons.timer,
          label: "Durée",
          value: formattedDuration,
        ),
        _buildAlignedDetailRow(
          icon: Icons.info,
          label: "Statut",
          value: _getTripStatusInFrench(trip.status),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Column(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: Colors.blue,
                ),
                SizedBox(height: 4),
                Icon(
                  Icons.place,
                  size: 16,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          trip.startLocation.address,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapPreviewPage(
                                startLocation: trip.startLocation,
                                endLocation: trip.endLocation,
                                polyline: trip.polyline,
                                focusOnStart: true,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.map,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          trip.endLocation.address,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapPreviewPage(
                                startLocation: trip.startLocation,
                                endLocation: trip.endLocation,
                                polyline: trip.polyline,
                                focusOnStart: false,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.map,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlignedDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTripStatusInFrench(String status) {
    switch (status) {
      case "OPEN":
        return "Ouvert";
      case "IN_PROGRESS":
        return "En cours";
      case "COMPLETED":
        return "Terminé";
      case "CANCELLED":
        return "Annulé";
      case "CLOSED":
        return "Fermé";
      default:
        return "Inconnu";
    }
  }

  Widget _buildTimeline(String currentStatus) {
    final statuses = [
      {"label": "Livraison demandée", "icon": Icons.receipt_long},
      {"label": "En attente de départ", "icon": Icons.hourglass_empty},
      {"label": "En cours de livraison", "icon": Icons.local_shipping},
    ];

    if (currentStatus == "CANCELLED") {
      statuses.add({"label": "Livraison annulée", "icon": Icons.cancel});
    } else {
      statuses.add({"label": "Livraison terminée", "icon": Icons.check_circle});
    }

    final currentIndex = statuses.indexWhere((status) {
      final label = status["label"] as String?;
      return label != null && _getStatusLabelFromEnum(label) == currentStatus;
    });

    return Column(
      children: List.generate(statuses.length, (index) {
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex && index != statuses.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: isCurrent
                      ? Colors.blue
                      : isCompleted
                          ? Colors.green
                          : Colors.grey.shade300,
                  child: Icon(
                    statuses[index]["icon"] as IconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (index != statuses.length - 1)
                  Container(
                    height: 50,
                    width: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isCompleted
                            ? [Colors.green, Colors.green.shade300]
                            : [Colors.grey.shade300, Colors.grey.shade100],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                statuses[index]["label"] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent
                      ? Colors.blue
                      : isCompleted
                          ? Colors.green.shade700
                          : Colors.grey.shade600,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String _getStatusLabelFromEnum(String label) {
    switch (label) {
      case "Livraison demandée":
        return "REQUESTED";
      case "En attente de départ":
        return "PENDING_START";
      case "En cours de livraison":
        return "IN_PROGRESS";
      case "Livraison terminée":
        return "COMPLETED";
      case "Livraison annulée":
        return "CANCELLED";
      default:
        return "UNKNOWN";
    }
  }
}
