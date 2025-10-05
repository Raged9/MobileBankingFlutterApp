// lib/models/transaction_data.dart

import 'dart:convert';

class TransactionData {
  final String id;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final String? recipientName; // Opsional, khusus untuk transfer

  TransactionData({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    this.recipientName,
  });

  // Konversi dari Map (saat decode dari JSON)
  factory TransactionData.fromMap(Map<String, dynamic> map) {
    return TransactionData(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      recipientName: map['recipientName'],
    );
  }

  // Konversi ke Map (saat encode ke JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'recipientName': recipientName,
    };
  }

  // Helper untuk konversi dari/ke JSON String
  static String encode(List<TransactionData> transactions) => json.encode(
        transactions
            .map<Map<String, dynamic>>((t) => t.toMap())
            .toList(),
      );

  static List<TransactionData> decode(String transactions) =>
      (json.decode(transactions) as List<dynamic>)
          .map<TransactionData>((item) => TransactionData.fromMap(item))
          .toList();
}