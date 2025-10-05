import 'package:flutter/material.dart';
import '../widgets/transaction_item.dart';
import 'filter_transaction_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final PageController _pageController = PageController(
    initialPage: DateTime.now().month - 1,
    viewportFraction: 0.3,
  );
  late int selectedMonth;
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic>? _activeFilters;

  final Map<int, List<Map<String, dynamic>>> allTransactions = {
    9: [
      {"day": "29", "month": "Sep", "desc": "Transfer ke Budi", "amount": -50000, "category": "Transfer"},
      {"day": "28", "month": "Sep", "desc": "Gaji Bulanan", "amount": 2500000, "category": "Pemasukan"},
      {"day": "27", "month": "Sep", "desc": "Beli Pulsa", "amount": -25000, "category": "Bayar/Top-up"},
      {"day": "15", "month": "Sep", "desc": "Makan di Kantin", "amount": -22000, "category": "Q-RIS"},
      {"day": "14", "month": "Sep", "desc": "Transfer dari Ibu", "amount": 500000, "category": "Pemasukan"},
    ],
    10: [
      {"day": "15", "month": "Okt", "desc": "Bayar Tagihan Listrik", "amount": -150000, "category": "Bayar/Top-up"},
      {"day": "12", "month": "Okt", "desc": "Makan Siang", "amount": -35000, "category": "Q-RIS"},
      {"day": "05", "month": "Okt", "desc": "Top up E-Money", "amount": -100000, "category": "E-Money"},
    ],
    8: [
      {"day": "20", "month": "Agu", "desc": "Cashback Pembelian", "amount": 15000, "category": "Pemasukan"},
      {"day": "17", "month": "Agu", "desc": "Belanja Online", "amount": -250000, "category": "Lainnya"},
    ],
  };

  List<Map<String, dynamic>> currentTransactions = [];

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now().month;
    _searchController.addListener(_runFiltersAndSearch);
    _resetAndFetchTransactions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _resetAndFetchTransactions() {
    setState(() {
      _activeFilters = null;
      _searchController.clear();
      _runFiltersAndSearch();
    });
  }

  void _runFiltersAndSearch() {
    List<Map<String, dynamic>> baseList = allTransactions[selectedMonth] ?? [];
    List<Map<String, dynamic>> filteredList = List.from(baseList);

    // Apply existing filters
    if (_activeFilters != null) {
      filteredList = _applyFiltersToData(_activeFilters!, listToFilter: baseList);
    }
    
    // Apply search query
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filteredList = filteredList.where((transaction) {
        return transaction['desc'].toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      currentTransactions = filteredList;
    });
  }

  List<Map<String, dynamic>> _applyFiltersToData(Map<String, dynamic> filters, {required List<Map<String, dynamic>> listToFilter}) {
    List<Map<String, dynamic>> filteredList = List.from(listToFilter);

    final DateTime? startDate = filters['startDate'];
    final DateTime? endDate = filters['endDate'];

    if (startDate != null || endDate != null) {
      filteredList = filteredList.where((transaction) {
        final transactionDate = DateTime(2025, selectedMonth, int.parse(transaction['day']));
        
        final bool isAfterStartDate = startDate == null || !transactionDate.isBefore(startDate);
        final bool isBeforeEndDate = endDate == null || !transactionDate.isAfter(endDate);
        
        return isAfterStartDate && isBeforeEndDate;
      }).toList();
    }

    final String transactionType = filters['transactionType'];
    if (transactionType == "Transaksi Masuk") {
      filteredList = filteredList.where((t) => t['amount'] > 0).toList();
    } else if (transactionType == "Transaksi Keluar") {
      filteredList = filteredList.where((t) => t['amount'] < 0).toList();
    }

    final List<String> categories = filters['categories'];
    if (categories.isNotEmpty && !categories.contains("Semua Kategori")) {
      filteredList = filteredList.where((t) => categories.contains(t['category'])).toList();
    }
    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        actions: [
          if (_activeFilters != null)
            IconButton(
              tooltip: "Hapus Filter",
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _activeFilters = null;
                  _runFiltersAndSearch();
                });
              },
            ),
          IconButton(
            tooltip: "Filter Transaksi",
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final filterResult = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilterScreen()),
              );

              if (filterResult != null && filterResult is Map<String, dynamic>) {
                setState(() {
                  _activeFilters = filterResult;
                  _runFiltersAndSearch();
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedMonth = index + 1;
                  _runFiltersAndSearch();
                });
              },
              itemCount: 12,
              itemBuilder: (context, index) {
                final monthNames = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"];
                return Center(
                  child: Text(
                    monthNames[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: (index + 1 == selectedMonth) ? Theme.of(context).colorScheme.primary : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari transaksi...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: currentTransactions.isEmpty
                ? const Center(child: Text("Tidak ada transaksi yang sesuai."))
                : ListView.builder(
                    itemCount: currentTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = currentTransactions[index];
                      return TransactionItem(
                        day: transaction["day"],
                        month: transaction["month"],
                        desc: transaction["desc"],
                        amount: transaction["amount"],
                        category: transaction["category"],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}