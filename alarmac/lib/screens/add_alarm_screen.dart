import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../providers/alarm_provider.dart';
import 'home_screen.dart';

class AddAlarmScreen extends StatefulWidget {
  @override
  _AddAlarmScreenState createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  DateTime _selectedTime = DateTime.now();
  bool _snoozeEnabled = true;
  bool _mathProblemRequired = false;
  String _selectedSound = "Opening"; // Default sound
  final AudioPlayer _audioPlayer = AudioPlayer(); // For playing sounds

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.black, // Set the navigation bar to black
        leading: GestureDetector(
          child: Text("Cancel", style: TextStyle(color: Colors.orange)),
          onTap: () => Navigator.pop(context),
        ),
        middle: Text(
          "Add Alarm",
          style: TextStyle(fontSize: 24, color: Colors.white), // Larger text size
        ),
        trailing: GestureDetector(
          child: Text("Save", style: TextStyle(color: Colors.orange)),
          onTap: () {
            _saveAlarm(context);
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Time Picker
            SizedBox(
              height: 300,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: _selectedTime,
                onDateTimeChanged: (DateTime newTime) {
                  setState(() => _selectedTime = newTime);
                },
              ),
            ),
            
            // Alarm settings
            CupertinoFormSection.insetGrouped(
              children: [
                _buildTile("Repeat", "Never", onTap: () {}),
                _buildTile("Label", "Alarm", onTap: () {}),
                _buildTile("Sound", _selectedSound, onTap: _selectSound),
                CupertinoListTile(
                  title: Text("Snooze", style: TextStyle(color: Colors.white)),
                  trailing: CupertinoSwitch(
                    value: _snoozeEnabled,
                    onChanged: (bool value) {
                      setState(() => _snoozeEnabled = value);
                    },
                  ),
                ),
                CupertinoListTile(
                  title: Text("Require Math Problem", style: TextStyle(color: Colors.white)),
                  trailing: CupertinoSwitch(
                    value: _mathProblemRequired,
                    onChanged: (bool value) {
                      setState(() => _mathProblemRequired = value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String title, String subtitle, {VoidCallback? onTap}) {
    return CupertinoListTile(
      title: Text(title, style: TextStyle(color: Colors.white)), // White text
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white)), // White text
      trailing: Icon(CupertinoIcons.forward, color: Colors.white),
      onTap: onTap,
      backgroundColor: Colors.black, // Same background color for consistency
    );
  }

  // **Save Alarm Function with Slide Transition**
  void _saveAlarm(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);

    DateTime now = DateTime.now();
    DateTime alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // If the selected time is earlier than the current time, schedule it for the next day
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(Duration(days: 1));
    }

    // Add alarm to provider with sound and math settings
    alarmProvider.addAlarm(alarmTime, requiresMath: _mathProblemRequired, sound: _selectedSound);

    // Handle snooze logic if enabled
    if (_snoozeEnabled) {
      alarmProvider.enableSnooze();
    }

    print("Alarm set for: $alarmTime (Math Required: $_mathProblemRequired)");

    // Slide transition back to the home screen
    Navigator.of(context).pushReplacement(
      _createSlideTransition(),
    );
  }

  // Create the slide transition
  PageRouteBuilder _createSlideTransition() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Start from below
        const end = Offset.zero; // End at the default position
        const curve = Curves.easeInOut; // Smooth transition

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  // Function to open the sound picker (for simplicity, assume static options)
  void _selectSound() async {
    // You can use the system's built-in music picker or a package like `assets_audio_player`
    String? selected = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("Select Sound"),
        actions: [
          CupertinoActionSheetAction(
            child: Text("Opening"),
            onPressed: () => Navigator.pop(context, "Opening"),
          ),
          CupertinoActionSheetAction(
            child: Text("Morning Alarm"),
            onPressed: () => Navigator.pop(context, "Morning Alarm"),
          ),
          CupertinoActionSheetAction(
            child: Text("Classic Sound"),
            onPressed: () => Navigator.pop(context, "Classic Sound"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        _selectedSound = selected;
      });
    }
  }
}
