import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(BuildContext context) {
  return AppBar(
    title: const Text(
      'Event Management',
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: Colors.blue,
    centerTitle: true,
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications),
        color: Colors.black,
        onPressed: () {
          Navigator.pushNamed(context, '/notifications');
        },
      ),
    ],
  );
}
