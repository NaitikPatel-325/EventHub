import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _emailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _profileImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    final url = Uri.parse('http://192.168.1.147:3000/user/profile'); 
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final profileData = jsonDecode(response.body);
        setState(() {
          _emailController.text = profileData['email'];
          _profileImageUrl = profileData['profileImageUrl']; // Assuming your backend returns the profile image URL
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _uploadImageToFirebase(File(pickedFile.path));
    }
  }

  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('profile_pics/${FirebaseAuth.instance.currentUser!.uid}.jpg');
      await storageRef.putFile(imageFile);
      // Get the download URL
      final downloadUrl = await storageRef.getDownloadURL();
      // Update the profile image URL in your database
      _updateProfileImageUrl(downloadUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while uploading image')),
      );
    }
  }

  Future<void> _updateProfileImageUrl(String downloadUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    final url = Uri.parse('http://192.168.1.147:3000/user/updateProfile'); 
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };

    try {
      await http.patch(url, headers: headers, body: jsonEncode({'profileImageUrl': downloadUrl}));
      setState(() {
        _profileImageUrl = downloadUrl; // Update the local variable
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating profile image')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
                      child: _profileImageUrl == null ? const Icon(Icons.add_a_photo, size: 50) : null,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    hintText: 'Enter your email',
                    icon: Icons.email,
                    isReadOnly: true,  // Email is read-only for now
                  ),
                  const SizedBox(height: 16.0),
                  const Text('More profile details coming soon...', style: TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool isReadOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
