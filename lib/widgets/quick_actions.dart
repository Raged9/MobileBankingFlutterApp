import 'package:flutter/material.dart';
import '../screens/AddBalanceScreen.dart';
import '../screens/PindahDanaScreen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaksi',
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
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddBalanceScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _actionButton(
                context: context,
                icon: Icons.send,
                label: 'Transfer',
              onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PindahDanaScreen()),
                  );
                },
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 0.5,
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Color.fromARGB(255, 34, 85, 155)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}