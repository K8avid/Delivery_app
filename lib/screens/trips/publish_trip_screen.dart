
import 'package:flutter/material.dart';

class PublishTripScreen extends StatelessWidget {
  const PublishTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publier un trajet'),
      ),
      body: const Center(
        child: Text('Écran de publication de trajet'),
      ),
    );
  }
}