import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/next_day_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomeScreen(),
      routes: {
        NextDayScreen.routeName: (_) => const NextDayScreen(forecastData: {}), // Placeholder, replace with actual data
      },
    );
  }
}
