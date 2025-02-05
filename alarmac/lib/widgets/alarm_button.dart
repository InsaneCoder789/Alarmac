import 'package:flutter/material.dart';

class AlarmButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  const AlarmButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(label),
    );
  }
}
