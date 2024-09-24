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
        title: Text('Profile Page'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: user != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Logged in as:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              user!.email ?? 'No Email',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Edit Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _updateEmail(); // Call the update email function
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Update Email',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Text('No user is currently logged in.'),
      ),
    );
  }
}
