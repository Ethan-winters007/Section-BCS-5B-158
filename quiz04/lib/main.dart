import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quiz04/auth_service.dart';
import 'package:quiz04/screens/login_screen.dart';
import 'package:quiz04/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uvfdcfczycgtfvucnbmu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV2ZmRjZmN6eWNndGZ2dWNuYm11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUxMzQxMDIsImV4cCI6MjA4MDcxMDEwMn0.dHdaKzxfAu0AkM9bTCY1EEyKKIyWbxuCptnubl1B1_U',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz 4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  AuthWrapperState createState() => AuthWrapperState();
}

class AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  Widget? _currentScreen;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
    _authService.authStateChanges.listen((event) {
      _checkAuthState();
    });
  }

  void _checkAuthState() {
    final user = _authService.getCurrentUser();
    setState(() {
      _currentScreen = user != null ? const HomeScreen() : const LoginScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _currentScreen ?? const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
