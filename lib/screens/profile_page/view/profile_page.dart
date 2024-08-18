import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile_picture.png'), // Example image
            ),
            const SizedBox(height: 16),
            Text('User Name', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('user@example.com', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit profile page or settings
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
