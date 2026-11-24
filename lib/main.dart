import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'theme/theme_notifier.dart';

void main() {
  runApp(const GymRoutineApp());
}

class GymRoutineApp extends StatelessWidget {
  const GymRoutineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LiftIQ',
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF4F5F9),
            primaryColor: Colors.deepPurple,
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              surface: Colors.white,
              secondary: Colors.amber,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0F0F12),
            primaryColor: Colors.deepPurpleAccent,
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurpleAccent,
              surface: Color(0xFF1E1E24),
              secondary: Colors.amberAccent,
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E1E24),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            useMaterial3: true,
          ),
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
