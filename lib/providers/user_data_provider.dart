import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_data.dart';
import '../models/transaction_data.dart';

class UserDataProvider with ChangeNotifier {
  UserData? _userData;
  List<TransactionData> _transactions = [];

  bool _isLoggedIn = false;
  bool _isLoading = true;

  UserData? get userData => _userData;
  List<TransactionData> get transactions => _transactions;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('last_logged_in_user')) {
      final email = prefs.getString('last_logged_in_user');
      final usersJson = prefs.getString('registered_users');
      if (email != null && usersJson != null) {
        final Map<String, dynamic> decodedMap = json.decode(usersJson);
        final registeredUsers = decodedMap.map(
          (key, value) => MapEntry(key, Map<String, String>.from(value)),
        );
        if (registeredUsers.containsKey(email)) {
          final userDataMap = registeredUsers[email]!;
          _userData = UserData(
            name: userDataMap['name'] ?? '',
            email: email,
            cardNumber: '**** **** **** 1234',
            balance: double.parse(userDataMap['balance'] ?? '0'),
            phoneNumber: '+62 812 3456 7890',
            address: 'Jakarta, Indonesia',
            accountNumber: userDataMap['accountNumber'] ?? '',
            pin: userDataMap['pin'] ?? '',
          );
          _isLoggedIn = true;
          await loadTransactions();
        } else {
          _isLoggedIn = false;
        }
      } else {
        _isLoggedIn = false;
      }
    } else {
      _isLoggedIn = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    if (_userData == null) return;
    final prefs = await SharedPreferences.getInstance();
    final key = 'transactions_${_userData!.email}';
    final transactionsJson = prefs.getString(key);
    if (transactionsJson != null) {
      _transactions = TransactionData.decode(transactionsJson);
    } else {
      _transactions = [];
    }
    notifyListeners();
  }

  Future<void> addTransaction(TransactionData transaction) async {
    _transactions.insert(0, transaction);

    if (_userData == null) return;
    final prefs = await SharedPreferences.getInstance();
    final key = 'transactions_${_userData!.email}';
    final encodedData = TransactionData.encode(_transactions);
    await prefs.setString(key, encodedData);

    notifyListeners();
  }

  Future<void> loginUser(UserData userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_logged_in_user', userData.email);
    _userData = userData;
    _isLoggedIn = true;
    await loadTransactions();
    notifyListeners();
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_logged_in_user');
    _userData = null;
    _transactions = [];
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<bool> verifyPin(String enteredPin) async {
    if (_userData == null) return false;
    try {
      final storedEncryptedPin = _userData!.pin;
      final decodedPin = utf8.decode(base64.decode(storedEncryptedPin));
      return decodedPin == enteredPin;
    } catch (e) {
      return false;
    }
  }

  Future<void> addBalance(double amount) async {
    if (_userData != null) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('registered_users');
      if (usersJson != null) {
        final Map<String, dynamic> decodedMap = json.decode(usersJson);
        final registeredUsers = decodedMap.map(
          (key, value) => MapEntry(key, Map<String, String>.from(value)),
        );

        if (registeredUsers.containsKey(_userData!.email)) {
          final currentUser = registeredUsers[_userData!.email]!;
          final currentBalance = double.parse(currentUser['balance'] ?? '0');
          final newBalance = currentBalance + amount;
          currentUser['balance'] = newBalance.toString();

          final updatedUsersJson = json.encode(registeredUsers);
          await prefs.setString('registered_users', updatedUsersJson);

          _userData = _userData!.copyWith(balance: newBalance);

          final transaction = TransactionData(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            description: 'Top Up Saldo',
            amount: amount,
            category: 'Pemasukan',
            date: DateTime.now(),
          );
          await addTransaction(transaction);
        }
      }
    }
  }

  Future<bool> transferBalance(double amount, String recipientName) async {
    if (_userData != null && _userData!.balance >= amount) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('registered_users');
      if (usersJson != null) {
        final Map<String, dynamic> decodedMap = json.decode(usersJson);
        final registeredUsers = decodedMap.map(
          (key, value) => MapEntry(key, Map<String, String>.from(value)),
        );

        if (registeredUsers.containsKey(_userData!.email)) {
          final currentUser = registeredUsers[_userData!.email]!;
          final currentBalance = double.parse(currentUser['balance'] ?? '0');
          final newBalance = currentBalance - amount;
          currentUser['balance'] = newBalance.toString();

          final updatedUsersJson = json.encode(registeredUsers);
          await prefs.setString('registered_users', updatedUsersJson);

          _userData = _userData!.copyWith(balance: newBalance);

          final transaction = TransactionData(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            description: 'Transfer ke $recipientName',
            amount: -amount,
            category: 'Transfer',
            date: DateTime.now(),
            recipientName: recipientName,
          );
          await addTransaction(transaction);
          return true;
        }
      }
    }
    return false;
  }

  Future<void> updateUserName(String newName) async {
    if (_userData != null) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('registered_users');
      if (usersJson != null) {
        final Map<String, dynamic> decodedMap = json.decode(usersJson);
        final registeredUsers = decodedMap.map(
          (key, value) => MapEntry(key, Map<String, String>.from(value)),
        );

        if (registeredUsers.containsKey(_userData!.email)) {
          registeredUsers[_userData!.email]!['name'] = newName;
          await prefs.setString('registered_users', json.encode(registeredUsers));
          _userData = _userData!.copyWith(name: newName);
          notifyListeners();
        }
      }
    }
  }

  Future<bool> updatePassword(
      String currentPassword, String newPassword) async {
    if (_userData != null) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('registered_users');
      if (usersJson != null) {
        final Map<String, dynamic> decodedMap = json.decode(usersJson);
        final registeredUsers = decodedMap.map(
          (key, value) => MapEntry(key, Map<String, String>.from(value)),
        );

        if (registeredUsers.containsKey(_userData!.email)) {
          final storedPassword = registeredUsers[_userData!.email]!['password'];
          if (storedPassword == currentPassword) {
            registeredUsers[_userData!.email]!['password'] = newPassword;
            await prefs.setString(
                'registered_users', json.encode(registeredUsers));
            return true;
          }
        }
      }
    }
    return false;
  }
}