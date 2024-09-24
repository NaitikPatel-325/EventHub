import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final DatabaseReference _eventsRef = FirebaseDatabase.instance.ref().child('events');
  List<Map<dynamic, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() {
    _eventsRef.once().then((DatabaseEvent event) {
      final snapshot = event.snapshot;
      final Map<dynamic, dynamic>? events = snapshot.value as Map?;
      if (events != null) {
        setState(() {
          _events = events.entries.map((entry) => entry.value as Map).toList();
        });
      }
    }).catchError((error) {
      print('Error fetching events: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register for Events'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text('Registration form will go here.'),
      ),
    );
  }
}
