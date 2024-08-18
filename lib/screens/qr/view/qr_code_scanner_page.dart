import 'package:flutter/material.dart';

class QRCodeScannerPage extends StatelessWidget {
  const QRCodeScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Center(
        child: const Text('QR Code scanner functionality will go here.'),
      ),
    );
  }
}
