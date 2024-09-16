import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:qr_flutter/qr_flutter.dart'; 

class GenerateQR extends StatefulWidget {
  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  String? qrData; 
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  void _fetchProfileData() async {
    User? user = FirebaseAuth.instance.currentUser; 
    if (user != null) {
      setState(() {
        userId = user.uid; 
        qrData = "http://localhost:3000/profile/$userId"; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Profile QR Code")),
      ),
      body: Center(
        child: qrData == null
            ? CircularProgressIndicator() 
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: qrData!, 
                    size: 200.0,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Scan this QR to verify profile",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Profile URL: $qrData",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
      ),
    );
  }
}
