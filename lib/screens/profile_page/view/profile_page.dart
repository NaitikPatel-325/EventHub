import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _email;
  String? _phone;
  String? _username;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    final url = Uri.parse('http://192.168.32.58:3000/user/profile'); 
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final profileData = jsonDecode(response.body);
        setState(() {
          _email = profileData['email'];
          _phone = profileData['phone'];
          _username = profileData['username'];
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while fetching profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: ${_username ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16.0),
                  Text('Email: ${_email ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16.0),
                  Text('Phone: ${_phone ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
    );
  }
}
