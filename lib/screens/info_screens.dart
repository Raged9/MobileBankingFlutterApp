import 'package:flutter/material.dart';
import '../widgets/info_item.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String _selectedCategory = "Semua Kategori";

  final List<String> _categories = [
    "Semua Kategori",
    "Info",
    "Transaksi",
    "Promo"
  ];

  final List<Map<String, dynamic>> _allInfoItems = [
    {
      "category": "Info",
      "icon": Icons.campaign_outlined,
      "title": "myBCA, BCA Mobile dan KlikBCA Service Maintenance",
      "date": "12 Sep 2025",
      "subtitle": "Informasi Maintenance Layanan Transaksi e-Banking BCA.",
      "detailContent": {
        "description":
            "Akan dilakukan pemeliharaan sistem rutin pada layanan e-Banking BCA untuk meningkatkan kualitas layanan. Selama periode ini, beberapa transaksi mungkin akan mengalami keterlambatan. Mohon maaf atas ketidaknyamanannya."
      }
    },
    {
      "category": "Promo",
      "icon": Icons.percent_outlined,
      "title": "Cashback 20% Belanja di Supermarket",
      "date": "09 Sep 2025",
      "subtitle": "Dapatkan cashback maksimal Rp 25.000 untuk transaksi pertama.",
      "detailContent": {
        "description":
            "Promo spesial untuk Anda! Nikmati cashback sebesar 20% untuk setiap transaksi di seluruh supermarket partner kami dengan menggunakan QRIS. Promo berlaku hingga akhir bulan ini. Syarat dan ketentuan berlaku."
      }
    },
    {
      "category": "Promo",
      "icon": Icons.local_offer_outlined,
      "title": "Diskon 50% untuk Kopi Pilihan di Kopi Kenangan",
      "date": "11 Sep 2025",
      "subtitle": "Nikmati promo spesial setiap hari Jumat dengan Kartu Debit BCA.",
      "detailContent": {
        "description":
            "Jumat lebih seru dengan diskon 50% untuk pembelian Americano dan Kopi Susu Gula Aren di seluruh gerai Kopi Kenangan. Cukup tunjukkan kartu Debit BCA Anda saat pembayaran."
      }
    },
    {
      "category": "Transaksi",
      "icon": Icons.receipt_long_outlined,
      "title": "Transfer Masuk",
      "date": "10 Sep 2025",
      "subtitle": "Anda menerima transfer dari Budi Santoso.",
      "detailContent": {
        "amount": "500.000",
        "sender": "Budi Santoso",
        "transactionId": "TRX-20250910-00123"
      }
    },
    {
      "category": "Info",
      "icon": Icons.security_outlined,
      "title": "Pentingnya Menjaga Kerahasiaan Nomor Ponsel Anda",
      "date": "08 Sep 2025",
      "subtitle": "Simak tips untuk menghindari penipuan.",
      "detailContent": {
        "description":
            "Jaga selalu kerahasiaan data pribadi Anda. Jangan pernah memberikan kode OTP, PIN, atau password kepada siapa pun, termasuk pihak yang mengaku dari bank. Keamanan transaksi Anda adalah prioritas kami."
      }
    },
  ];

  List<Map<String, dynamic>> _filteredInfo = [];

  @override
  void initState() {
    super.initState();
    _filteredInfo = _allInfoItems;
  }

  void _filterItems() {
    if (_selectedCategory == "Semua Kategori") {
      _filteredInfo = _allInfoItems;
    } else {
      _filteredInfo = _allInfoItems
          .where((item) => item['category'] == _selectedCategory)
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tombol Kembali ditambahkan di sini
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Info & Transaksi"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (isSelected) {
                        if (isSelected) {
                          setState(() {
                            _selectedCategory = category;
                            _filterItems();
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredInfo.length,
              itemBuilder: (context, index) {
                final item = _filteredInfo[index];
                return InfoItem(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}