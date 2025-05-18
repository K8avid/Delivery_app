import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  _QRCodeScannerPageState createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  bool isProcessing = false; // Flag pour éviter plusieurs scans

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner le QR Code'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          // Scanner de QR Code
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null && !isProcessing) {
                  setState(() {
                    isProcessing = true; // Empêche les scans multiples
                  });
                  final String code = barcode.rawValue!;
                  Navigator.pop(context, code); // Retourne le code scanné
                  break;
                }
              }
            },
          ),
          // Overlay pour le cadre et les indications
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Cadre pour le QR Code
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blueAccent,
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          // Texte d'indication
                          const Positioned(
                            bottom: 20,
                            child: Text(
                              'Placez le QR Code dans le cadre',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
