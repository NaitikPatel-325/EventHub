import 'package:flutter/material.dart';

class LiveUpdatesPage extends StatelessWidget {
  const LiveUpdatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Updates'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text('Live updates will be displayed here.'),
      ),
    );
  }
}
