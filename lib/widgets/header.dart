import 'package:flutter/material.dart';
import '../models/user_data.dart';
import '../screens/settings_screen.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Hello, ${userData.name}!',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black54),
          onPressed: () => _navigateToSettings(context),
        ),
      ],
    );
  }
}