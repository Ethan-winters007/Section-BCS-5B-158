import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  // Fixed metallic-seaweed seed color for the app (no runtime dark-mode toggle)
  Color _seedColor = const Color(0xFF0A7E8B); // Metallic Seaweed (0xFF0A7E8B) - use as single app color

  Color get seedColor => _seedColor;

  ThemeProvider() {
    _loadSeedColor();
  }

  Future<void> _loadSeedColor() async {
    final prefs = await SharedPreferences.getInstance();
    final hex = prefs.getInt('seedColor');
    if (hex != null) _seedColor = Color(hex);
    notifyListeners();
  }

  Future<void> setSeedColor(Color color) async {
    _seedColor = color;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('seedColor', color.value);
    notifyListeners();
  }

  ThemeData themeData() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
      scaffoldBackgroundColor: const Color(0xFF082A2E),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF0A7E8B),
        iconTheme: IconThemeData(color: Color(0xFF0A7E8B)),
        actionsIconTheme: IconThemeData(color: Color(0xFF0A7E8B)),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.disabled)) return _seedColor.withOpacity(0.6);
            return _seedColor;
          }),
          elevation: MaterialStateProperty.resolveWith<double>((states) => states.contains(MaterialState.hovered) ? 8.0 : 2.0),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) => states.contains(MaterialState.pressed) ? const Color(0xFF082A2E).withOpacity(0.12) : null),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          textStyle: MaterialStateProperty.all(const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      cardColor: const Color(0xFF082A2E),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
      );
}
