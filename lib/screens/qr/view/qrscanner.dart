import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'profileview.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (scannedData != null)
                  ? Text('Scanned: $scannedData')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedData = scanData.code;
      });

      // After scanning, navigate to the profile page with the extracted profileId
      if (scannedData != null) {
        // Assuming the scannedData contains the full URL "http://localhost:3000/profile/{profileId}"
        String profileId = extractProfileId(scannedData!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(profileId: profileId),
          ),
        );
      }
    });
  }

  String extractProfileId(String scannedUrl) {
    Uri uri = Uri.parse(scannedUrl);
    return uri.pathSegments.last;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
