import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'screen/result_screen.dart';
import 'screen/error_screen.dart';

void main() {
  runApp(BMIApp());
}

class BMIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          accentColor: Colors.orangeAccent,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          headlineSmall: TextStyle(color: Colors.teal[800], fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.grey[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.teal[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/result': (context) => ResultScreen(),
        '/error': (context) => ErrorScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/result') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ResultScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        }
        return null;
      },
    );
  }
}
