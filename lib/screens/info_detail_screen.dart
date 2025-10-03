import 'package:flutter/material.dart';

class InfoDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const InfoDetailScreen({super.key, required this.item});

  Widget _buildInfoLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['title'],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            item['date'],
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const Divider(height: 32),
          Text(
            item['detailContent']['description'],
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionLayout(BuildContext context) {
    final details = item['detailContent'];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
              const SizedBox(height: 16),
              Text(
                "Rp ${details['amount']}",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text("Transaksi Berhasil", style: TextStyle(color: Colors.green)),
              const Divider(height: 40),
              _buildReceiptRow("Jenis Transaksi", item['title']),
              _buildReceiptRow("Dari", details['sender']),
              _buildReceiptRow("ID Transaksi", details['transactionId']),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildReceiptRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    String appBarTitle = "Detail Informasi";
    if (item['category'] == 'Promo') {
      appBarTitle = "Detail Promo";
    } else if (item['category'] == 'Transaksi') {
      appBarTitle = "Detail Transaksi";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: SingleChildScrollView(
        child: item['category'] == 'Transaksi'
            ? _buildTransactionLayout(context)
            : _buildInfoLayout(context),
      ),
    );
  }
}