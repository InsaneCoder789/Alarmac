import 'package:flutter/material.dart';
import 'dart:math';

class MathChallengeScreen extends StatefulWidget {
  final Function(bool) onSolved; // Callback to handle solving challenge
  MathChallengeScreen({required this.onSolved});

  @override
  _MathChallengeScreenState createState() => _MathChallengeScreenState();
}

class _MathChallengeScreenState extends State<MathChallengeScreen> {
  int num1 = Random().nextInt(20);
  int num2 = Random().nextInt(20);
  late int correctAnswer;
  TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    correctAnswer = num1 + num2; // For example, addition
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(answerController.text);
    if (userAnswer == correctAnswer) {
      widget.onSolved(true); // Correct answer, deactivate the alarm
      Navigator.pop(context); // Close the math challenge screen
    } else {
      widget.onSolved(false); // Incorrect answer, keep the alarm on
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Solve the Math Problem'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$num1 + $num2 = ?",
                style: const TextStyle(color: Colors.white, fontSize: 40),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: answerController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter your answer',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
                child: const Text('Submit Answer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
