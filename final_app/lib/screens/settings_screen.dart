import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Metallic Seaweed (fixed)'),
            trailing: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: theme.seedColor,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF082A2E).withOpacity(0.12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
