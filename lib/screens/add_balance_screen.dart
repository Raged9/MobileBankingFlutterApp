// lib/screens/add_balance_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';

class AddBalanceScreen extends StatefulWidget {
  const AddBalanceScreen({super.key});

  @override
  State<AddBalanceScreen> createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {
  final _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _addBalance() async {
    if (_amountController.text.isNotEmpty) {
      final amount =
          double.tryParse(_amountController.text.replaceAll('.', ''));
      if (amount != null && amount > 0) {
        setState(() {
          _isLoading = true;
        });

        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;

        await Provider.of<UserDataProvider>(context, listen: false)
            .addBalance(amount);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Saldo berhasil ditambahkan: Rp ${NumberFormat('#,##0', 'id_ID').format(amount)}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jumlah tidak valid.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context).userData;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Balance',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAccountNumberCard(
            accountNumber: userData?.accountNumber ?? '',
            balance: userData?.balance ?? 0,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    hintText: 'Rp Jumlah Top Up',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              _isLoading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      icon: const Icon(Icons.add_circle,
                          size: 40, color: Colors.blue),
                      onPressed: _addBalance,
                    ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Select Method',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('All Methods'),
          _PaymentMethodTile(
            icon: Icons.account_balance,
            iconColor: Colors.blue.shade800,
            title: 'Virtual Account',
            onTap: () {},
          ),
          _PaymentMethodTile(
            icon: Icons.important_devices,
            iconColor: Colors.orange.shade700,
            title: 'Mobile Banking',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildAccountNumberCard(
      {required String accountNumber, required double balance}) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Account Number',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                accountNumber,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Balance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                formatter.format(balance),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}