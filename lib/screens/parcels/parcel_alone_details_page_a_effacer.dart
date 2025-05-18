// import 'package:appli/screens/parcels/parcel_search_result_for_existing_parcel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/parcel.dart';
import '../../services/parcel_service.dart';
import 'parcel_search_result_for_existing_parcel.dart';

class ParcelAloneDetailsPage extends StatefulWidget {
  final String parcelNumber;

  const ParcelAloneDetailsPage({super.key, required this.parcelNumber});

  @override
  _ParcelAloneDetailsPageState createState() => _ParcelAloneDetailsPageState();
}

class _ParcelAloneDetailsPageState extends State<ParcelAloneDetailsPage> {
  late Future<Parcel> _parcelFuture;
  final Map<String, dynamic> parcelInfo = {};

  @override
  void initState() {
    super.initState();

    _parcelFuture = ParcelService.fetchParcelDetails(widget.parcelNumber);

    _parcelFuture.then((parcel) {
      setState(() {
        parcelInfo['senderAddress'] = parcel.senderAddress;
        parcelInfo['recipientAddress'] = parcel.recipientAddress;
        parcelInfo['expiracyDate'] = parcel.expiracyDate.toIso8601String();
        parcelInfo['parcelNumber'] = parcel.parcelNumber;
      });
    }).catchError((error) {
      print('Erreur lors de la récupération du colis : $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Fond clair
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Détails du colis',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Parcel>(
        future: _parcelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final parcel = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildParcelCard(parcel),
                  const SizedBox(height: 16.0),
                  _buildParcelDetails(parcel),  // Bloc "Informations sur le colis"
                  const SizedBox(height: 16.0),
                  _buildAssignTripButton(parcelInfo),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Colis introuvable.'));
          }
        },
      ),
    );
  }

  Widget _buildParcelCard(Parcel parcel) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Numéro de colis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Text(parcel.parcelNumber, style: const TextStyle(fontSize: 18, color: Colors.blue)),
          const SizedBox(height: 16.0),
          const Text('Statut actuel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Text(parcel.currentStatus, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // Bloc "Informations sur le colis" avec les icônes
  Widget _buildParcelDetails(Parcel parcel) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations sur le colis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          _buildDetailRow('Description', parcel.description, Icons.description),
          const Divider(),
          _buildDetailRow('Poids', '${parcel.weight} kg', Icons.fitness_center),
          const Divider(),
          _buildDetailRow(
              'Dimensions', '${parcel.length} x ${parcel.width} x ${parcel.height} cm', Icons.aspect_ratio),
          const Divider(),
          _buildDetailRow('Adresse expéditeur', parcel.senderAddress, Icons.location_on),
          const Divider(),
          _buildDetailRow('Adresse destinataire', parcel.recipientAddress, Icons.home),
          const Divider(),
          _buildDetailRow('Créé le', DateFormat.yMMMd().format(parcel.createdAt), Icons.date_range),
          const Divider(),
          _buildDetailRow('Dernière mise à jour', DateFormat.yMMMd().format(parcel.updatedAt), Icons.update),
          const Divider(),
          _buildDetailRow('Date d’expiration', DateFormat.yMMMd().format(parcel.expiracyDate), Icons.timer),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue, size: 24.0),
          const SizedBox(width: 12.0),
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 5,
            child: Text(value, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignTripButton(Map<String, dynamic> parcelInfo) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParcelSearchResultsWithExistingParcel(parcelInfo: parcelInfo),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 5.0,
      ),
      child: const Text('Assigner un trajet', style: TextStyle(fontSize: 16)),
    );
  }
}
