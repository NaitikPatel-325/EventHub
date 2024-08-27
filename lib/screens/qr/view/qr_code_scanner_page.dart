import 'package:flutter/material.dart';

class QrCodeScannerPage extends StatelessWidget {
  const QrCodeScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QrCodeScannerPage'),
        backgroundColor: Color.fromARGB(255, 184, 216, 243),
      ),
      body: Center(
        child: Text(
          'QrCodeScannerPage',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
