import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser; // Get the current user
    if (user != null) {
      _emailController.text = user!.email!; // Set the current email to the controller
    }
  }

  void _updateEmail() async {
    try {
      await user!.updateEmail(_emailController.text);
      await user!.reload(); // Reload the user to get updated info
      user = _auth.currentUser; // Refresh the user instance
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email updated successfully!')),
      );
      setState(() {}); // Update the UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/image3.png'), // Example image
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                'User Name',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'user@example.com',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
             
              
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to edit profile page or settings
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
