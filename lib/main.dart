import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_data_provider.dart';
import 'screens/login.dart';
import 'screens/pin_screen.dart'; // Buat file ini jika belum ada

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider()..checkLoginStatus(),
      child: const MobileBankingApp(),
    ),
  );
}

class MobileBankingApp extends StatelessWidget {
  const MobileBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Banking App',
      debugShowCheckedModeBanner: false,
      home: Consumer<UserDataProvider>(
        builder: (context, userDataProvider, child) {
          // Kita perlu menunggu pengecekan login selesai
          if (userDataProvider.isLoggedIn) {
            // Jika sudah pernah login, tampilkan PIN screen
            return const PinScreen();
          } else {
            // Jika belum, tampilkan Login screen
            return const LoginPage();
          }
        },
      ),
    );
  }
}