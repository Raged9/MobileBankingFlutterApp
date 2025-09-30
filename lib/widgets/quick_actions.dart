import 'package:flutter/material.dart';
import '../screens/placeholder_page.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  void _navigateToNewPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlaceholderPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                context: context,
                icon: Icons.add,
                label: 'Top Up',
                onTap: () => _navigateToNewPage(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _actionButton(
                context: context,
                icon: Icons.send,
                label: 'Transfer',
                onTap: () => _navigateToNewPage(context),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.blue.shade700),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}