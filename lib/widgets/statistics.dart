import 'package:flutter/material.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Event Statistics',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16.0),
        _buildCard('Total Events', '15', Icons.event),
        const SizedBox(height: 8.0),
        _buildCard('Upcoming Registrations', '25', Icons.person_add),
        const SizedBox(height: 8.0),
        _buildCard('QR Codes Scanned', '8', Icons.qr_code_scanner),
        const SizedBox(height: 8.0),
        _buildCard('Live Updates Sent', '5', Icons.notifications),
      ],
    );
  }

  Widget _buildCard(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(icon, color: Colors.blue),
      ),
    );
  }
}
