import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';
import 'pin_screen.dart';

class PindahDanaScreen extends StatefulWidget {
  const PindahDanaScreen({super.key});

  @override
  State<PindahDanaScreen> createState() => _PindahDanaScreenState();
}

class _PindahDanaScreenState extends State<PindahDanaScreen> {
  final Map<String, String> _dummyDestination = {
    "bank": "BCA",
    "name": "Budi Santoso",
    "accountNumber": "8888 1234 5678",
  };
  Map<String, String>? _selectedDestination;

  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDestination = _dummyDestination;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleTransfer() {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final currentBalance = userDataProvider.userData?.balance ?? 0;

    if (_selectedDestination == null) {
      _showErrorSnackbar("Silakan pilih rekening tujuan.");
      return;
    }

    final amountText =
        _amountController.text.replaceAll('.', '').replaceAll(',', '');
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      _showErrorSnackbar("Jumlah transfer tidak valid.");
      return;
    }

    if (amount > currentBalance) {
      _showErrorSnackbar("Saldo Anda tidak mencukupi.");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinVerificationScreen(
          onPinVerified: (pin) => userDataProvider.verifyPin(pin),
          onVerificationSuccess: () async {
            Navigator.pop(context); // Pop PinVerificationScreen

            setState(() {
              _isLoading = true;
            });

            final success = await userDataProvider.transferBalance(
                amount, _selectedDestination?['name'] ?? 'Penerima');

            if (!mounted) return;

            setState(() {
              _isLoading = false;
            });

            if (success) {
              _showSuccessSnackbar(
                  'Transfer sebesar ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount)} berhasil!');
              Navigator.pop(context); // Pop PindahDanaScreen
            } else {
              _showErrorSnackbar("Terjadi kesalahan. Gagal mentransfer dana.");
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
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pindah Dana',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            _buildSourceDestinationCard(
              sourceBalance: formatter.format(userData?.balance ?? 0),
              destination: _selectedDestination,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                hintText: 'Rp Jumlah',
              ),
              keyboardType: TextInputType.number,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saldo Akun',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  formatter.format(userData?.balance ?? 0),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Catatan (Opsional)',
              ),
            ),
            const Spacer(),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleTransfer,
                  child: const Text('Lanjut'),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceDestinationCard({
    required String sourceBalance,
    Map<String, String>? destination,
  }) {
    return Card(
      elevation: 1,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.cyan[700],
              child: const Text('BCA',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
            title: const Text('Akun Saya'),
            subtitle: Text(
              sourceBalance,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height: 1),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(destination?['bank']?.substring(0, 1) ?? '?',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            title: Text(destination?['name'] ?? 'Pilih Tujuan'),
            subtitle: Text(destination?['accountNumber'] ?? ''),
          ),
        ],
      ),
    );
  }
}