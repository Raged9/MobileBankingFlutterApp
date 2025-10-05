// lib/screens/transaction_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';
import '../models/transaction_data.dart';
import '../widgets/transaction_item.dart';
import 'filter_transaction_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late int selectedMonth;
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _activeFilters;
  List<TransactionData> currentTransactions = [];
  final PageController _pageController = PageController(
    initialPage: DateTime.now().month - 1,
    viewportFraction: 0.3,
  );

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now().month;
    _searchController.addListener(_runFiltersAndSearch);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runFiltersAndSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _runFiltersAndSearch() {
    final allTransactions =
        Provider.of<UserDataProvider>(context, listen: false).transactions;

    List<TransactionData> monthlyList =
        allTransactions.where((t) => t.date.month == selectedMonth).toList();

    List<TransactionData> filteredList = List.from(monthlyList);

    if (_activeFilters != null) {
      filteredList =
          _applyFiltersToData(_activeFilters!, listToFilter: filteredList);
    }

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filteredList = filteredList.where((transaction) {
        return transaction.description.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      currentTransactions = filteredList;
    });
  }

  List<TransactionData> _applyFiltersToData(Map<String, dynamic> filters,
      {required List<TransactionData> listToFilter}) {
    List<TransactionData> filteredList = List.from(listToFilter);
    final DateTime? startDate = filters['startDate'];
    final DateTime? endDate = filters['endDate'];

    if (startDate != null || endDate != null) {
      filteredList = filteredList.where((t) {
        final isAfter = startDate == null || !t.date.isBefore(startDate);
        final isBefore = endDate == null || !t.date.isAfter(endDate);
        return isAfter && isBefore;
      }).toList();
    }

    final String transactionType = filters['transactionType'];
    if (transactionType == "Transaksi Masuk") {
      filteredList = filteredList.where((t) => t.amount > 0).toList();
    } else if (transactionType == "Transaksi Keluar") {
      filteredList = filteredList.where((t) => t.amount < 0).toList();
    }

    final List<String> categories = filters['categories'];
    if (categories.isNotEmpty && !categories.contains("Semua Kategori")) {
      filteredList =
          filteredList.where((t) => categories.contains(t.category)).toList();
    }
    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserDataProvider>(context);

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

              if (filterResult != null &&
                  filterResult is Map<String, dynamic>) {
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
                final monthNames = [
                  "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
                  "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
                ];
                return Center(
                  child: Text(
                    monthNames[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: (index + 1 == selectedMonth)
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                ? const Center(child: Text("Tidak ada transaksi ditemukan."))
                : ListView.builder(
                    itemCount: currentTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = currentTransactions[index];
                      return TransactionItem(
                        day: DateFormat('d').format(transaction.date),
                        month: DateFormat('MMM').format(transaction.date),
                        desc: transaction.description,
                        amount: transaction.amount.toInt(),
                        category: transaction.category,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}