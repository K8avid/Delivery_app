import 'package:flutter/material.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Page Trajets",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
