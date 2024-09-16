import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 

class ProfilePage extends StatelessWidget {
  final String profileId;

  ProfilePage({required this.profileId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Details"),
      ),
      body: FutureBuilder(
        future: _fetchProfileData(profileId), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          } else if (snapshot.hasData) {
            var profileData = snapshot.data as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Profile Name: ${profileData['name'] ?? 'N/A'}"),
                Text("Profile Email: ${profileData['email'] ?? 'N/A'}"),
              ],
            );
          } else {
            return Center(child: Text("No data found"));
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchProfileData(String profileId) async {
    final url = Uri.parse("http://localhost:3000/profile/$profileId");  
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile data");
    }
  }
}
