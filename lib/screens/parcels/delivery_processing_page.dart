import 'package:flutter/material.dart';
import 'success_page.dart';
import 'failure_page.dart';
import '../../services/delivery_service.dart';

class DeliveryProcessingPage extends StatelessWidget {
  final Map<String, dynamic> requestPayload;

  const DeliveryProcessingPage({super.key, required this.requestPayload});

  @override
  Widget build(BuildContext context) {
    // Lancer le traitement de la livraison dès que la page est affichée
    Future.microtask(() async {
      try {
        final isSuccess = await DeliveryService.processDelivery(requestPayload);

        if (isSuccess) {
          // Naviguer vers la page de succès
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SuccessPage()),
          );
        } else {
          // Naviguer vers la page d'échec
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FailurePage()),
          );
        }
      } catch (e) {
        // En cas d'erreur, naviguer vers la page d'échec
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FailurePage()),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              "Traitement de votre demande...",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
