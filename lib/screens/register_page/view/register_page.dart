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
      appBar: AppBar(title: const Text('Registered Events')),
      body: _events.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return ListTile(
                  title: Text(event['eventName'] ?? 'Unnamed Event'),
                  subtitle: Text('Location: ${event['eventLocation']}'),
                  trailing: Text('Date: ${event['eventDate']}, Time: ${event['eventTime']}'),
                );
              },
            ),
    );
  }
}
