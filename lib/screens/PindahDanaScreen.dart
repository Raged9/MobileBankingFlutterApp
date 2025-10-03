import 'package:flutter/material.dart';

class PindahDanaScreen extends StatelessWidget {
  const PindahDanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tidak perlu lagi mendefinisikan backgroundColor, akan diambil dari theme
      appBar: AppBar(
        elevation: 0,
        // AppBar akan mengambil warna dari scaffoldBackgroundColor theme
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul "Pindah Dana"
            const Text(
              'Pindah Dana',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            // Card untuk Sumber dan Tujuan Dana
            _buildSourceDestinationCard(),

            const SizedBox(height: 24),

            // Input untuk Jumlah
            // InputDecoration sekarang akan mengikuti appTheme
            const TextField(
              decoration: InputDecoration(
                hintText: 'Rp Jumlah', // Menggunakan hintText agar lebih modern
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Tampilan Saldo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saldo bluAccount',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Text(
                  'Rp 8.293,96',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Input untuk Catatan
            // InputDecoration juga akan mengikuti appTheme
            const TextField(
              decoration: InputDecoration(
                hintText: 'Catatan (Opsional)',
              ),
            ),
            const Spacer(), // Mendorong elemen berikutnya ke bawah

            // Kotak Informasi
            _buildInfoBox(),
            const SizedBox(height: 16),

            // Tombol Lanjut
            SizedBox(
              width: double.infinity,
              // ElevatedButton sekarang akan otomatis menggunakan gaya dari theme
              child: ElevatedButton(
                onPressed: () {
                  // Aksi ketika tombol Lanjut ditekan
                },
                // Tidak perlu lagi mendefinisikan style di sini
                child: const Text('Lanjut'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget untuk Card Sumber & Tujuan (tidak berubah)
  Widget _buildSourceDestinationCard() {
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
              child: const Text('BCA', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            title: const Text('bluAccount'),
            subtitle: const Text(
              'Rp 8.293,96',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.expand_more),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height: 1),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 20),
            ),
            title: Text('Pilih Tujuan', style: TextStyle(color: Colors.grey[600])),
            trailing: const Icon(Icons.expand_more),
          ),
        ],
      ),
    );
  }

  // Widget untuk kotak informasi (tidak berubah)
  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: Colors.blue[400]),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Transaksi ini akan diproses tanpa penggunaan PIN ya',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}