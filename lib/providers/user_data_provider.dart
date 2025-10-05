import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_data.dart';

class UserDataProvider with ChangeNotifier {
  UserData? _userData;
  bool _isLoggedIn = false;

  UserData? get userData => _userData;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('last_logged_in_user')) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<void> loginUser(UserData userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_logged_in_user', userData.email);
    _userData = userData;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_logged_in_user');
    _userData = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // Fungsi untuk menambah saldo dan menyimpannya
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

          _userData = UserData(
            name: _userData!.name,
            email: _userData!.email,
            cardNumber: _userData!.cardNumber,
            balance: newBalance,
            phoneNumber: _userData!.phoneNumber,
            address: _userData!.address,
            accountNumber: _userData!.accountNumber,
          );
          notifyListeners();
        }
      }
    }
  }
}
