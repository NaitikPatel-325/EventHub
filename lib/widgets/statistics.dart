import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<Statistics> {
  Map<String, dynamic> _statistics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    final url = Uri.parse('http://192.168.1.167:3000/user/statastic'); // Replace with your statistics endpoint
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> statistics = jsonDecode(response.body);
        setState(() {
          _statistics = statistics;
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load statistics')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while fetching statistics')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.deepPurpleAccent)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Overall Statistics',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPieChart(),  // Pie chart
                      const SizedBox(width: 20),
                      _buildLegend(),    // Legend beside the chart
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPieChart() {
    // Sample data for the pie chart
    final totalEvents = _statistics['totalEvents'] ?? 0;
    final totalUsers = _statistics['totalUsers'] ?? 0;

    return SizedBox(
      height: 200, // Set a fixed height for the pie chart
      width: 200,  // Set a fixed width for the pie chart
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: totalEvents.toDouble(),
              title: totalEvents.toString(), // Show the value inside the chart
              color: Colors.blue,
              radius: 50,
              titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: totalUsers.toDouble(),
              title: totalUsers.toString(), // Show the value inside the chart
              color: Colors.orange,
              radius: 50,
              titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 30,
          sectionsSpace: 0, // No space between sections
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegendItem(Colors.blue, 'Total Events'),
        const SizedBox(height: 8),
        _buildLegendItem(Colors.orange, 'Registered Users'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
