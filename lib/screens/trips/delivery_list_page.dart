import 'package:flutter/material.dart';
import '../../services/delivery_service.dart';
import 'delivery_details_page.dart';

class DeliveryListPage extends StatefulWidget {
  final String tripNumber;

  const DeliveryListPage({super.key, required this.tripNumber});

  @override
  _DeliveryListPageState createState() => _DeliveryListPageState();
}

class _DeliveryListPageState extends State<DeliveryListPage> {
  List<dynamic> deliveries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDeliveries();
  }

  Future<void> fetchDeliveries() async {
    try {
      final fetchedDeliveries =
          await DeliveryService.fetchParcelsByTripExcludingStatuses(widget.tripNumber);
      setState(() {
        deliveries = fetchedDeliveries;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des livraisons : $error')),
      );
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'REQUESTED':
        return 'Demandée';
      case 'PENDING_START':
        return 'En attente de récupération du colis';
      case 'IN_PROGRESS':
        return 'En cours';
      case 'COMPLETED':
        return 'Terminée';
      case 'CANCELLED':
        return 'Annulée';
      default:
        return 'Statut inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Livraisons pour le voyage ${widget.tripNumber}',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : deliveries.isEmpty
              ? const Center(
                  child: Text(
                    'Aucune livraison trouvée',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchDeliveries,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: deliveries.length,
                    itemBuilder: (context, index) {
                      final delivery = deliveries[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: const Icon(
                              Icons.inventory_2, // Icône de colis
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            'Colis : ${delivery['parcel']['parcelNumber']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                _getStatusText(delivery['deliveryStatus']),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryDetailsPage(
                                  delivery: delivery,
                                  tripNumber: widget.tripNumber,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
