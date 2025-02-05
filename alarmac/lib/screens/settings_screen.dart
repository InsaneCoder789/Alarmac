// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Sound'),
              subtitle: const Text('Select an alarm sound'),
              trailing: IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () {
                  // Logic for sound selection
                },
              ),
            ),
            ListTile(
              title: const Text('Vibration'),
              trailing: Switch(
                value: true, // Here you can manage vibration state
                onChanged: (bool value) {
                  // Logic for vibration toggle
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
