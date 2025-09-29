import 'package:flutter/material.dart';
import 'common/theme.dart';
import 'screens/login.dart';

void main() {
  runApp(const MobileBankingApp());
}

class MobileBankingApp extends StatelessWidget {
  const MobileBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Banking App',
      theme: appTheme, // Menggunakan tema dari file theme.dart
      home: const LoginPage(), // Halaman awal adalah LoginPage dari login.dart
      debugShowCheckedModeBanner: false,
    );
  }
}

