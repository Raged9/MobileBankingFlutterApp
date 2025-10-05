import 'package:flutter/material.dart';

class AddBalanceScreen extends StatelessWidget {
  const AddBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Bagian Regular Savings
          _buildSavingsCard(),
          const SizedBox(height: 24),

          // Judul "Select Method"
          const Text(
            'Select Method',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Bagian Recently Used
          _buildSectionTitle('Recently used'),
          _PaymentMethodTile(
            icon: Icons.account_balance,
            iconColor: Colors.blue.shade800,
            title: 'BCA Virtual Account',
            subtitle: '10 remaining free admin quota for top-up above Rp50.000',
            onTap: () => _showPaymentDetailsSheet(context),
          ),
          const SizedBox(height: 24),

          // Bagian All Methods
          _buildSectionTitle('All Methods'),
          _PaymentMethodTile(
            icon: Icons.important_devices,
            iconColor: Colors.orange.shade700,
            title: 'Internet Banking/Mobile Ban...',
            tag: 'Free',
            onTap: () => _showPaymentDetailsSheet(context),
          ),
          _PaymentMethodTile(
            icon: Icons.account_balance,
            iconColor: Colors.blue.shade800,
            title: 'Virtual Account',
            subtitle: '10 remaining free admin quota for top-up above Rp50.000',
            onTap: () => _showPaymentDetailsSheet(context),
          ),
          _PaymentMethodTile(
            icon: Icons.store,
            iconColor: Colors.green.shade600,
            title: 'Minimart Virtual Account',
            subtitle: 'Admin fee Rp5.000 per transaction',
            onTap: () {}, // Tambahkan aksi jika perlu
          ),
          _PaymentMethodTile(
            icon: Icons.account_balance_wallet,
            iconColor: Colors.orange.shade800,
            title: 'My Balance',
            subtitle: 'Free admin fee',
            onTap: () {}, // Tambahkan aksi jika perlu
          ),
        ],
      ),
    );
  }

  // Widget untuk judul setiap seksi (Recently used, All Methods)
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

  // Widget untuk kartu Regular Savings di bagian atas
  Widget _buildSavingsCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Regular Savings (7431)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text('Balance Rp0,28', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Text(
                    '0.0% p.a.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Change >',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan modal bottom sheet
  void _showPaymentDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Internet Banking/Mobile Banking/ATM',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text('Account number', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '5859457136957431',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Logika untuk menyalin nomor
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                    ),
                    child: const Text('Copy'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildStepInstruction('1', 'Go to the nearest bank or login to other bank app.'),
              const SizedBox(height: 16),
              _buildStepInstruction('2', 'Enter the upper account number as beneficiary account.'),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Don't know how it works?",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Got It'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget untuk instruksi langkah demi langkah di bottom sheet
  Widget _buildStepInstruction(String step, String instruction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.grey[300],
          child: Text(step, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 16),
        Expanded(child: Text(instruction, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}

// Widget kustom untuk setiap item metode pembayaran agar lebih rapi
class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String? tag;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.tag,
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
      title: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          if (tag != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                tag!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: Colors.grey[600]))
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}