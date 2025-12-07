import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(NumberGameApp());
}

class NumberGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Guessing Game',
      theme: ThemeData(
        primaryColor: Color(0xFF6A1B9A), // Deep purple
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFFFFC107), // Amber
        ),
        scaffoldBackgroundColor: Color(0xFFF3E5F5), // Light purple background
        textTheme: TextTheme(
          headlineSmall: TextStyle(color: Color(0xFF4A148C), fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Color(0xFF6A1B9A)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6A1B9A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            shadowColor: Color(0xFF6A1B9A).withOpacity(0.3),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF6A1B9A),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFF6A1B9A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFFFFC107), width: 2),
          ),
          labelStyle: TextStyle(color: Color(0xFF6A1B9A)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/result': (context) => ResultScreen(),
        '/history': (context) => HistoryScreen(),
      },
    );
  }
}
