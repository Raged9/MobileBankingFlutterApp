import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String transactionType = "Semua Transaksi";
  
  List<String> selectedCategories = ["Semua Kategori"];

  final List<String> transactionTypes = [
    "Semua Transaksi",
    "Transaksi Masuk",
    "Transaksi Keluar",
  ];

  final List<String> categories = [
    "Semua Kategori",
    "Bayar/Top-up",
    "Q-RIS",
    "Transfer",
    "Lainnya",
  ];

  Future<void> pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _showTransactionTypePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Pilih Jenis Transaksi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              ListView.builder(
                shrinkWrap: true,
                itemCount: transactionTypes.length,
                itemBuilder: (context, index) {
                  final type = transactionTypes[index];
                  return ListTile(
                    title: Text(type),
                    trailing: transactionType == type ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
                    onTap: () {
                      setState(() {
                        transactionType = type;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Pilih Kategori", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CheckboxListTile(
                          title: Text(category),
                          value: selectedCategories.contains(category),
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                if (category == "Semua Kategori") {
                                  selectedCategories = ["Semua Kategori"];
                                } else {
                                  selectedCategories.remove("Semua Kategori");
                                  if (!selectedCategories.contains(category)) {
                                     selectedCategories.add(category);
                                  }
                                }
                              } else {
                                selectedCategories.remove(category);
                                if (selectedCategories.isEmpty) {
                                  selectedCategories.add("Semua Kategori");
                                }
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: const Text("Pilih"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getSelectedCategoriesText() {
    if (selectedCategories.contains("Semua Kategori") || selectedCategories.isEmpty) {
      return "Semua Kategori";
    }
    if (selectedCategories.length > 2) {
      return "${selectedCategories.length} kategori dipilih";
    }
    return selectedCategories.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filter Transaksi")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rentang Tanggal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.calendar_today), onPressed: () => pickDate(true), label: Text(startDate == null ? "Dari" : "${startDate!.day}/${startDate!.month}/${startDate!.year}"))),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.calendar_today), onPressed: () => pickDate(false), label: Text(endDate == null ? "Sampai" : "${endDate!.day}/${endDate!.month}/${endDate!.year}"))),
              ],
            ),
            const SizedBox(height: 24),
            
            const Text("Jenis Transaksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            InkWell(
              onTap: _showTransactionTypePicker,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(transactionType, style: const TextStyle(fontSize: 16)),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text("Kategori Transaksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            InkWell(
              onTap: _showCategoryPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_getSelectedCategoriesText(), style: const TextStyle(fontSize: 16)),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    "startDate": startDate,
                    "endDate": endDate,
                    "transactionType": transactionType,
                    "categories": selectedCategories,
                  });
                },
                child: const Text("Terapkan Filter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}