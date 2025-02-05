import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_alarm_screen.dart';
import 'providers/alarm_provider.dart';
import 'screens/math_challenge_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AlarmProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Global navigator key to control navigation outside the context
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Set the global navigator key
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add_alarm': (context) => AddAlarmScreen(),
        // Pass a dummy function for onSolved, as the provider should handle this logic
        '/math_challenge': (context) => MathChallengeScreen(
          onSolved: (isSolved) {
            if (isSolved) {
              // Handle the solution logic
              final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
              alarmProvider.deactivateAlarm();
            }
          },
        ),
      },
    );
  }
}
