import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alarm_provider.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Alarms",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.orangeAccent, size: 30),
            onPressed: () {
              // Navigate to Add Alarm Screen
              Navigator.pushNamed(context, '/add_alarm');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.bed_rounded, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  "Sleep | Wake Up",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "No Alarm",
                  style: TextStyle(fontSize: 25, color: Colors.white38),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  ),
                  onPressed: () {
                    // Future: Implement a sleep alarm system
                  },
                  child: const Text(
                    "CHANGE",
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Other",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: alarmProvider.alarms.isEmpty
                  ? const Center(
                      child: Text(
                        "No alarms set",
                        style: TextStyle(color: Colors.white60, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: alarmProvider.alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = alarmProvider.alarms[index];
                        return AlarmTile(
                          time: "${alarm.time.hour}:${alarm.time.minute.toString().padLeft(2, '0')}",
                          isOn: alarm.isActive,
                          onChanged: (value) {
                            if (value) {
                              alarmProvider.activateAlarm(alarm.id); // Activate the alarm
                            } else {
                              alarmProvider.deactivateAlarm(); // Deactivate the alarm
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.white60,
        currentIndex: 1, // Default to "Alarms"
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.public), label: "World Clock"),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Alarms"),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Stopwatch"),
          BottomNavigationBarItem(icon: Icon(Icons.hourglass_empty), label: "Timers"),
        ],
      ),
    );
  }
}

class AlarmTile extends StatelessWidget {
  final String time;
  final bool isOn;
  final Function(bool) onChanged;

  const AlarmTile({
    Key? key,
    required this.time,
    required this.isOn,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
          Switch(
            value: isOn,
            onChanged: onChanged,
            activeColor: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }
}
