import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';
import 'pin_screen.dart';

class QrisScreen extends StatefulWidget {
  const QrisScreen({super.key});

  @override
  State<QrisScreen> createState() => _QrisScreenState();
}

class _QrisScreenState extends State<QrisScreen> {
  final _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handlePayment() {
    final userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    final currentBalance = userDataProvider.userData?.balance ?? 0;
    final amountText = _amountController.text.replaceAll('.', '').replaceAll(',', '');
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      _showErrorSnackbar("Jumlah pembayaran tidak valid.");
      return;
    }

    if (amount > currentBalance) {
      _showErrorSnackbar("Saldo Anda tidak mencukupi.");
      return;
    }

    // Pindah ke layar verifikasi PIN
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinVerificationScreen(
          onPinVerified: (pin) => userDataProvider.verifyPin(pin),
          onVerificationSuccess: () async {
            Navigator.pop(context); // Tutup layar PIN

            setState(() { _isLoading = true; });

            // Panggil fungsi pembayaran QRIS di provider
            final success = await userDataProvider.qrisPayment(amount, "Pembayaran QRIS");

            if (!mounted) return;

            setState(() { _isLoading = false; });

            if (success) {
              _showSuccessSnackbar('Pembayaran QRIS sebesar ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount)} berhasil!');
              Navigator.pop(context); // Kembali dari halaman QRIS
            } else {
              _showErrorSnackbar("Terjadi kesalahan. Gagal melakukan pembayaran.");
            }
          },
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context).userData;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran QRIS'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Placeholder untuk tampilan kamera
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.black,
            child: const Center(
              child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 100),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo Anda: ${formatter.format(userData?.balance ?? 0)}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Pembayaran',
                      prefixText: 'Rp ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handlePayment,
                        child: const Text('Bayar'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}