import 'package:flutter/material.dart';

class EventDetailsPage extends StatelessWidget {
  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: Center(
        child: Text('Details for event ID: $eventId'),
      ),
    );
  }
}
