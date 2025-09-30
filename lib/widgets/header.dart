import 'package:flutter/material.dart';
import '../models/user_data.dart';
import '../screens/placeholder_page.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  void _navigateToNewPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlaceholderPage()),
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
          onPressed: () => _navigateToNewPage(context),
        ),
      ],
    );
  }
}