import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<dynamic> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    final url = Uri.parse('http://192.168.146.251:3000/user/allevent');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> events = jsonDecode(response.body);
        setState(() {
          _events = events;
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load events')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while fetching events')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openMap(String location) async {
    final Uri mapUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$location');
    if (await canLaunchUrl(mapUrl)) {
      await launchUrl(mapUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open map')),
      );
    }
  }

  Future<void> _registerForEvent(String eventId) async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    final url = Uri.parse('http://192.168.146.251:3000/user/eventregister');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };
    print(eventId);
    final body = jsonEncode({
      'eventId': eventId,
      'userId': user?.uid,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to register')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred during registration')),
      );
    }
  }

  void _confirmRegistration(String eventId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Registration'),
          content: const Text('Are you sure you want to register for this event?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _registerForEvent(eventId); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
          : _events.isEmpty
              ? const Center(child: Text('No events available', style: TextStyle(fontSize: 18)))
              : ListView.builder(
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                  final event = _events[index];
                  return GestureDetector(
                    onTap: () => _confirmRegistration(event['id'] ?? ''), 
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['name'] ?? 'No name available', 
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.date_range, color: Colors.white70),
                                const SizedBox(width: 10),
                                Text(
                                  'Date: ${event['date'] ?? 'Unknown'}', 
                                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time, color: Colors.white70),
                                const SizedBox(width: 10),
                                Text(
                                  'Time: ${event['time'] ?? 'Unknown'}', 
                                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_pin, color: Colors.white70),
                                const SizedBox(width: 10),
                                Text(
                                  'Location: ${event['location'] ?? 'Unknown'}',
                                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.map),
                                  onPressed: () => _openMap(event['location'] ?? 'Unknown'),
                                  tooltip: 'View on Map',
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              event['description'] ?? 'No description available',
                              style: const TextStyle(fontSize: 14, color: Colors.white60),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () => _confirmRegistration(event['eventId'] ?? ''),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Register', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
    );
  }
}
