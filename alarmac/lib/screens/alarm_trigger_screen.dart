// lib/screens/alarm_trigger_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alarm_provider.dart';

class AlarmTriggerScreen extends StatelessWidget {
  const AlarmTriggerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);
    final activeAlarm = alarmProvider.activeAlarm;

    if (activeAlarm == null || !activeAlarm.isActive) {
      return Scaffold(
        body: Center(child: Text("No Active Alarm")),
      );
    }

    final num1 = 5; 
    final num2 = 3;
    final correctAnswer = num1 + num2;
    TextEditingController _answerController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solve to Stop Alarm'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Solve: $num1 + $num2 = ?', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _answerController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter answer',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (int.tryParse(_answerController.text) == correctAnswer) {
                    alarmProvider.deactivateAlarm();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incorrect answer. Try again!')));
                  }
                },
                child: const Text('Stop Alarm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
