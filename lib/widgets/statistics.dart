import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  int totalEvents = 0;
  int totalUsers = 0;
  bool isLoading = true;
  bool fetchFailed = false;  // New flag to check if fetch failed

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    try {
      // Reference to Firebase Realtime Database
      final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

      // Fetch total number of events
      final DataSnapshot eventsSnapshot = await databaseRef.child('events').get();
      final int totalEventsCount = eventsSnapshot.children.length;

      // Fetch total number of users
      final DataSnapshot usersSnapshot = await databaseRef.child('users').get();
      final int totalUsersCount = usersSnapshot.children.length;

      setState(() {
        totalEvents = totalEventsCount;
        totalUsers = totalUsersCount;
        isLoading = false;
        fetchFailed = false;  // Fetch was successful
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
        fetchFailed = true;  // Fetch failed, fallback to dummy data
      });
    }
  }

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
        isLoading
            ? const CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildPieChart()), // Pie chart on the left
                  const SizedBox(width: 16.0), // Space between chart and legend
                  _buildLegend(), // Legend on the right
                ],
              ),
      ],
    );
  }

  Widget _buildPieChart() {
    return Container(
      height: 200, // Adjust the height as needed
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: fetchFailed ? 10.0 : totalEvents.toDouble(),  // Use dummy if fetch failed
              title: 'Total Events',
              color: Colors.blue,
              radius: 50,
            ),
            PieChartSectionData(
              value: fetchFailed ? 5.0 : totalUsers.toDouble(),  // Use dummy if fetch failed
              title: 'Total Users',
              color: Colors.green,
              radius: 50,
            ),
          ],
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 30,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegendItem(Colors.blue, 'Total Events'),
        _buildLegendItem(Colors.green, 'Total Users'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Adjust padding as needed
    child: Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(title),
      ],
    ),
  );
}

}
