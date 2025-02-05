import 'package:flutter/material.dart';
import 'dart:async';
import '../models/alarm.dart';
import '../screens/math_challenge_screen.dart'; // Import math challenge screen

class AlarmProvider with ChangeNotifier {
  final List<Alarm> _alarms = []; // List of all alarms
  Alarm? _activeAlarm; // Currently active alarm
  Timer? _timer; // Timer for scheduled alarms

  List<Alarm> get alarms => _alarms;
  Alarm? get activeAlarm => _activeAlarm;

  // Global key for navigation
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Add a new alarm and schedule it
  Future<void> addAlarm(DateTime time, {bool requiresMath = false, String sound = "Opening", int snoozeDurationMinutes = 10}) async {
    final newAlarm = Alarm(
      id: DateTime.now().millisecondsSinceEpoch,
      time: time,
      isActive: false, // Alarm should not be active until it triggers
      requiresMath: requiresMath,
      sound: sound, // Store the selected sound
      snoozeDurationMinutes: snoozeDurationMinutes, // Store the snooze duration
    );
    _alarms.add(newAlarm);
    notifyListeners();
    _scheduleAlarm(newAlarm);
  }

  // Schedule an alarm to trigger at the correct time
  void _scheduleAlarm(Alarm alarm) {
    final now = DateTime.now();
    Duration duration = alarm.time.difference(now);

    if (duration.isNegative) {
      alarm.time = alarm.time.add(const Duration(days: 1)); // Set for the next day if the time has passed
      duration = alarm.time.difference(now);
    }

    // Cancel any existing timer before scheduling a new one
    _timer?.cancel();

    _timer = Timer(duration, () {
      activateAlarm(alarm.id);
    });
  }

  // Activate the alarm and trigger math challenge if needed
  void activateAlarm(int id) {
    final alarmIndex = _alarms.indexWhere((alarm) => alarm.id == id);

    if (alarmIndex != -1) {
      _activeAlarm = _alarms[alarmIndex];
      _activeAlarm!.isActive = true;

      if (_activeAlarm!.requiresMath) {
        // Trigger math challenge screen when the alarm goes off
        _showMathChallengeScreen();
      } else {
        // No math challenge, just notify listeners
        notifyListeners();
      }
    }
  }

  // Show math challenge screen
  void _showMathChallengeScreen() {
    final context = navigatorKey.currentState?.context;
    if (context != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MathChallengeScreen(
            onSolved: (isSolved) {
              if (isSolved) {
                deactivateAlarm();
              } else {
                // Maybe play a sound or give feedback
              }
            },
          ),
        ),
      );
    }
  }

  // Deactivate the current alarm
  void deactivateAlarm() {
    if (_activeAlarm != null) {
      _activeAlarm!.isActive = false;
      _activeAlarm = null;
      _timer?.cancel();
      notifyListeners();
    }
  }

  // Remove an alarm
  void removeAlarm(int id) {
    _alarms.removeWhere((alarm) => alarm.id == id);
    notifyListeners();
  }

  // Handle snooze functionality
  void enableSnooze() {
    if (_activeAlarm != null) {
      // Add snooze duration to the current alarm time
      final newTime = _activeAlarm!.time.add(Duration(minutes: _activeAlarm!.snoozeDurationMinutes));
      _activeAlarm!.time = newTime;

      // Re-schedule the alarm with the updated time
      _scheduleAlarm(_activeAlarm!);

      print("Alarm snoozed to: $newTime");
    }
  }
}
