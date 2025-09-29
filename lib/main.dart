import 'package:flutter/material.dart';
import 'common/theme.dart'; // <-- Impor file theme.dart Anda
import 'screens/PindahDanaScreen.dart'; // <-- Impor file screen yang sudah dibuat

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blu App Clone',
      // Menerapkan tema yang sudah Anda definisikan ke seluruh aplikasi
      theme: appTheme,
      home: const PindahDanaScreen(),
    );
  }
}