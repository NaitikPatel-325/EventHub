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

    final url = Uri.parse('http://192.168.146.251:3000/user/profile'); 
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
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Image
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.deepPurpleAccent,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Username, Email, Phone inside cards
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.deepPurpleAccent),
                        title: Text('Username'),
                        subtitle: Text(_username ?? 'N/A'),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListTile(
                        leading: Icon(Icons.email, color: Colors.deepPurpleAccent),
                        title: Text('Email'),
                        subtitle: Text(_email ?? 'N/A'),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListTile(
                        leading: Icon(Icons.phone, color: Colors.deepPurpleAccent),
                        title: Text('Phone'),
                        subtitle: Text(_phone ?? 'N/A'),
                      ),
                    ),
                    
                    // Logout button
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
