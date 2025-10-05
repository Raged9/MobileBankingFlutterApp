import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_data.dart';

class UserDataProvider with ChangeNotifier {
  UserData? _userData;
  bool _isLoggedIn = false;
  bool _isLoading = true; // Tambahkan state loading

  UserData? get userData => _userData;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading; // Getter untuk loading

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

  // Fungsi aman untuk verifikasi PIN
  Future<bool> verifyPin(String enteredPin) async {
    if (_userData == null) return false;

    // Mensimulasikan proses dekripsi dan perbandingan yang aman.
    // Di aplikasi nyata, proses ini mungkin terjadi di backend
    // atau menggunakan metode dekripsi yang sesuai di klien.
    try {
      final storedEncryptedPin = _userData!.pin;
      final decodedPin = utf8.decode(base64.decode(storedEncryptedPin));
      return decodedPin == enteredPin;
    } catch (e) {
      return false; // Gagal decode, berarti PIN tidak cocok
    }
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

          // Perbarui objek _userData saat ini juga
          _userData = UserData(
            name: _userData!.name,
            email: _userData!.email,
            cardNumber: _userData!.cardNumber,
            balance: newBalance,
            phoneNumber: _userData!.phoneNumber,
            address: _userData!.address,
            accountNumber: _userData!.accountNumber,
            pin: _userData!.pin,
          );
          notifyListeners();
        }
      }
    }
  }
}