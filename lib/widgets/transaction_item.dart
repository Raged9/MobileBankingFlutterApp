import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final String day;
  final String month;
  final String desc;
  final int amount;
  final String category;

  const TransactionItem({
    super.key,
    required this.day,
    required this.month,
    required this.desc,
    required this.amount,
    required this.category,
  });

  String _formatCurrency(int value) {
    final formatter = NumberFormat("#,###", "id_ID");
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final bool isIncome = amount > 0;

    return Card(
      color: const Color.fromARGB(255, 190, 226, 255).withOpacity(0.050),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(month, style: const TextStyle(fontSize: 14)),
          ],
        ),
        title: Text(desc),
        subtitle: Text(category),
        trailing: Text(
          "${isIncome ? "+" : "-"} Rp ${_formatCurrency(amount.abs())}",
          style: TextStyle(
            color: isIncome ? Colors.green.shade700 : Colors.red.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}