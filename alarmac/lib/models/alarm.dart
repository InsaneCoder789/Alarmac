class Alarm {
  final int id;
  DateTime _time;  // Make time private
  bool isActive;
  final bool requiresMath;
  final String sound; // Added sound field to store the selected sound
  final int snoozeDurationMinutes; // Store snooze duration for each alarm

  Alarm({
    required this.id,
    required DateTime time,
    required this.isActive,
    this.requiresMath = false, // Default to false if not specified
    this.sound = "Opening", // Default sound if not specified
    this.snoozeDurationMinutes = 10, // Default snooze duration if not specified
  }) : _time = time;

  // Getter and Setter for time
  DateTime get time => _time;

  set time(DateTime newTime) {
    _time = newTime;
  }
}
