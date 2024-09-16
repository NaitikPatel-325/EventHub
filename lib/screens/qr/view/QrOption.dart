import 'package:flutter/material.dart';
import 'generateqr.dart';
import 'qrscanner.dart';

class QrOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Options'),
        backgroundColor: Colors.indigo[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenerateQR(),
                  ),
                );
              },
              child: Text('Generate QR Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[900],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRViewExample(),
                  ),
                );
              },
              child: Text('Scan QR Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[900],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

