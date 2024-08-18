import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Color.fromARGB(255, 184, 216, 243),
      ),
      body: Center(
        child: Text(
          'No notifications at the moment.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
